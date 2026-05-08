# Ubuntu VMware Setup Guide

Complete setup + tuning documentation for an Ubuntu 24.04 LTS workstation running inside VMware Workstation Player on a Windows host. Captures **both** the live desktop configuration (GNOME, Fish, Ghostty, etc.) and the system-level performance tuning that makes the VM feel native.

## Overview

Each subdirectory contains a focused README and the actual config files / commands needed to reproduce the live state on a fresh install. The split is:

- **`vmware-host/`** — settings on the Windows host (`.vmx` file, HAGS, NVIDIA Control Panel)
- **`kernel/`** — guest kernel + sysctl + udev tuning (mitigations off, swappiness, scheduler, zram, plymouth)
- **`services/`** — what to disable in a VM (cups, bluetooth, tracker3, evolution, etc.)
- **`firewall/`** — UFW with Tailscale + LAN-SSH rules
- **`disk/`** — growpart/resize2fs, fstrim, timeshift snapshots
- **`cleanup/`** — APT/snap/journal/nvidia/old-kernel cleanups
- **`gnome/`** — desktop, extensions, dconf dump
- **`fish/`** — shell config, aliases, vmclean helper
- **`ghostty/`** — terminal config (Windows-style copy/paste)
- **`cli-tools/`** — bat/eza/ripgrep/fzf/fdfind
- **`tailscale/`** — mesh VPN
- **`zellij/`** — terminal multiplexer (note: tmux is also fine — see below)

## Bootstrap order

Apply in this order on a fresh VM. Each step is idempotent; rerunning is safe.

1. **VMware host-side first** — see [`vmware-host/`](./vmware-host/). With the VM **off**: edit `.vmx` for `mks.enable3d`, `svga.graphicsMemoryKB=4194304`, `mks.gl.allowBlacklistedDrivers`, `monitor.disable_mitigations`, `ethernet0.virtualDev=vmxnet3`. On Windows: enable Hardware-accelerated GPU Scheduling, NVIDIA Control Panel → vmware-vmx.exe → High-performance NVIDIA. Reboot Windows. Cold-boot the VM.
2. **Disk** — see [`disk/`](./disk/). If you grew the `.vmdk` host-side, run `growpart` + `resize2fs` inside the guest. Install `timeshift` and take a baseline snapshot.
3. **Kernel + system** — see [`kernel/`](./kernel/). Add `mitigations=off` to GRUB, set `vm.swappiness=10`, install `zram-config`, write the I/O scheduler udev rule, mask Plymouth. Reboot once.
4. **Services** — see [`services/`](./services/). Disable cups, bluetooth, ModemManager. Mask Tracker3 + Evolution at user level.
5. **Firewall** — see [`firewall/`](./firewall/). UFW with deny-in/allow-out + Tailscale carve-out + LAN SSH if needed.
6. **Cleanup** — see [`cleanup/`](./cleanup/). One-shot full upgrade, snap retention, journal trim, optional nvidia-package purge.
7. **GNOME desktop** — see [`gnome/`](./gnome/). Restore extension list, dconf dump.
8. **Fish + CLI tools** — see [`fish/`](./fish/) and [`cli-tools/`](./cli-tools/).
9. **Ghostty** — see [`ghostty/`](./ghostty/).
10. **Tailscale** — see [`tailscale/`](./tailscale/) (last, optional).

After step 3 you should already see substantial speedup. Steps 1–6 are where most of the perf wins live.

## Verification (post-bootstrap)

Inside the guest:

```fish
# CPU mitigations off
cat /sys/devices/system/cpu/vulnerabilities/spectre_v2     # Vulnerable; IBPB: disabled; ...

# zram active
cat /proc/swaps                                            # /dev/zram0 ... priority 5

# Swappiness
sysctl vm.swappiness                                       # = 10

# I/O scheduler
cat /sys/block/sda/queue/scheduler                         # [none] mq-deadline

# Network adapter (paravirt)
lspci | grep -i ether                                      # VMware VMXNET3 ...

# 3D: don't trust glxinfo's "Accelerated:" bit. Run a real benchmark instead.
vblank_mode=0 glxgears -info                               # 1500-2500+ FPS = hardware

# Boot time after Plymouth mask
systemd-analyze                                            # ~12-15s userspace

# Firewall
sudo ufw status verbose
```

## A note on tmux vs zellij

The `zellij/` directory captures the live state because the snap package is installed. If you prefer tmux (broader ecosystem, more battle-tested config patterns), uninstall zellij:

```fish
sudo snap remove zellij
sudo apt install -y tmux
```

The `gnome/`, `fish/`, `ghostty/` configs don't depend on either.

## On VMware ≠ GPU passthrough

VMware Workstation never had real PCI/PCIe passthrough. What it offers as "3D acceleration" is API translation: the guest's Mesa SVGA3D driver translates GL/Vulkan calls into VMware's SVGA3D protocol, the host's `vmware-vmx.exe` translates those into DirectX/Vulkan calls against the host GPU driver, and you get pixels back. So:

- ✅ OpenGL up to 4.3 / DX11.1 in the guest
- ❌ No CUDA, no NVENC, no `nvidia-smi`
- ❌ The Quadro/RTX never appears as a GPU device inside the Linux guest

For CUDA on a Windows host, **WSL2 Ubuntu** with NVIDIA's WSL CUDA driver is the painless path — full CUDA without rearchitecting. For real GPU passthrough on Linux: ESXi (free) or KVM with `vfio-pci`, both of which require wiping the host OS.

`glxinfo`'s `Accelerated: no` and `Video memory: 1MB` are **misreports** for SVGA3D specifically — known Mesa bug. Trust `glxgears` FPS instead.

## System Information (snapshot)

- **OS**: Ubuntu 24.04 LTS (Noble)
- **Kernel**: 6.17.x
- **Desktop**: GNOME 46 (Wayland by default; Xorg available)
- **Shell**: Fish 4.x
- **Terminal**: Ghostty (snap, edge)
- **VM host**: VMware Workstation Player on Windows
- **Host GPU example**: NVIDIA Quadro P2000 (any CUDA-capable card works the same way)

---

Last updated: May 2026
