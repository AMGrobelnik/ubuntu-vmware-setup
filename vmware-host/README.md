# VMware Host-side Configuration

Settings applied **on the Windows host** (not inside the Ubuntu guest). These have to be done on the VMware Workstation Player side; nothing in the guest can substitute for them.

## What goes in the `.vmx` file

The VM's `.vmx` file lives at `<your VM folder>\<vm-name>.vmx` on Windows (e.g. `D:\Users\Adrian\VM\Adrian Ubuntu VM v2.vmx`). Edit with VM **fully powered off** (not just rebooted from inside Linux — `sudo poweroff`, then verify VMware shows "Powered off").

Lines that should be present:

```
# 3D acceleration
mks.enable3d = "TRUE"
svga.graphicsMemoryKB = "4194304"             # 4 GB graphics memory (sufficient threshold for 3D to engage)
svga.vramSize = "134217728"                   # 128 MB VRAM
mks.gl.allowBlacklistedDrivers = "TRUE"       # let VMware use newer NVIDIA driver versions it doesn't yet trust

# Paravirtualized network — much faster than emulated E1000
ethernet0.virtualDev = "vmxnet3"

# Side-channel mitigations off on the VMM side (we also disable inside guest via mitigations=off)
monitor.disable_mitigations = "TRUE"
```

The first time you set these, take a backup first:

```powershell
Copy-Item "D:\Users\Adrian\VM\Adrian Ubuntu VM v2.vmx" "D:\Users\Adrian\VM\Adrian Ubuntu VM v2.vmx.bak"
```

After editing, **cold boot** the VM (start from "Powered off" → "Play virtual machine"). A `sudo reboot` from inside the guest does NOT reload the `.vmx` — it warm-reboots the same VMM process.

## Hardware-accelerated GPU Scheduling (HAGS) on Windows

VMware's `vmware-vmx.exe` needs HAGS to get a proper DX12/WDDM direct context to the host GPU. Without it, even with a perfect `.vmx`, VMware silently falls back to software rendering on the host (visible in `vmware.log` as `SWBScreen`).

**Enable**: Settings → System → Display → Graphics → "Default graphics settings" → toggle **Hardware-accelerated GPU scheduling: ON**.

Then **reboot Windows** (the WDDM driver only re-loads on Windows boot, not on VM cold boot).

## NVIDIA Control Panel (Quadro / RTX hosts)

Right-click desktop → NVIDIA Control Panel → Manage 3D Settings:

- **Global Settings** → Preferred graphics processor: **High-performance NVIDIA processor** (not Auto)
- **Program Settings** → Add → browse to `C:\Program Files (x86)\VMware\VMware Workstation\vmware-vmx.exe` → set its preferred GPU to **High-performance NVIDIA processor**

If you ever update the NVIDIA Quadro driver, redo this — Program-Settings entries can clear after some driver upgrades.

## Verifying 3D actually works (from inside the guest)

`glxinfo`'s `Accelerated:` and `Video memory:` fields **lie** for the SVGA3D driver. Trust an actual benchmark:

```fish
sudo apt install -y mesa-utils
vblank_mode=0 glxgears -info
# Press Ctrl+C after a couple FPS lines print.
```

- ~1500–2000+ FPS = real GPU-backed rendering through your host card
- ~200–500 FPS = software fallback (SWBScreen on host, .vmx or HAGS misconfigured)

`glxinfo -B` will say `Accelerated: no` and `Video memory: 1MB` even when 3D is fully working — that's a known Mesa SVGA3D-driver bug, not a real status. Do not trust it. If you want a single-line check that's *less* misleading: `dmesg | grep vmwgfx` should show `Capabilities: ... 3D, dx, hp cmd queue` and `Available shader model: SM_5_1X`. That comes from the kernel and is honest.

## Why VMware ≠ GPU passthrough

VMware Workstation does **API translation**, not real PCI passthrough. The pipeline is:

```
Linux app → Mesa SVGA3D driver → vmwgfx kernel module → SVGA device
        → vmware-vmx.exe (host) → DX12/Vulkan calls → Windows NVIDIA driver
        → Quadro / RTX → pixels back up the chain
```

Real passthrough (your Quadro showing up *as* an NVIDIA device inside the guest) requires ESXi with vDGA, or KVM on a Linux host with `vfio-pci`. VMware Workstation never had that feature and won't get it. So no CUDA / NVENC / Quadro-specific features inside the Linux VM. For CUDA on a Windows host, **WSL2 Ubuntu** with NVIDIA's WSL CUDA driver is the painless path — full CUDA, no host swap.
