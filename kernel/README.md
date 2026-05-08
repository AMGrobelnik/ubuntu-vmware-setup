# Kernel + System-level Tuning

Settings applied to the running guest kernel and to systemd. All persistent across reboots.

## 1. Disable CPU vulnerability mitigations (`mitigations=off`)

Spectre / Meltdown / MDS / GDS mitigations cost 10–25% CPU throughput, especially on older Intel server CPUs (Xeon E-2176M class). On a single-tenant dev VM where you're not running untrusted code, this is a reasonable trade.

```fish
sudo sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash mitigations=off"|' /etc/default/grub
sudo update-grub
sudo reboot
```

After reboot, verify:

```fish
cat /sys/devices/system/cpu/vulnerabilities/spectre_v2
# Should say: "Vulnerable; IBPB: disabled; STIBP: disabled; ..."
cat /proc/cmdline
# Should include: "mitigations=off"
```

## 2. Lower swappiness (`vm.swappiness=10`)

Default is 60 (server-style "swap aggressively to keep page cache full"). On a desktop dev VM with 40+ GiB RAM, that wastefully swaps idle pages to disk. 10 keeps RAM full of your active working set; only swap under real memory pressure.

```fish
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf
sudo sysctl --system
sysctl vm.swappiness   # → vm.swappiness = 10
```

## 3. zram — compressed RAM swap

Replaces (or supplements) disk swap with a virtual block device backed by compressed RAM. ~3:1 compression ratio with lz4/zstd, far faster than disk swap. Critical in a VM where "disk" is virtualized through the host.

```fish
sudo apt install -y zram-config
sudo systemctl enable --now zram-config.service
cat /proc/swaps     # → should now show /dev/zram0 alongside /swap.img, with higher priority
zramctl             # → /dev/zram0  lzo-rle  22G  ...
```

The package auto-sizes zram to ~50% of RAM. With swappiness=10, the kernel only reaches for swap under genuine pressure, and when it does, zram (priority 5) gets used before the disk-backed `/swap.img` (priority -2).

## 4. I/O scheduler — switch to `none` for paravirt VMs

On bare metal, `mq-deadline` is the right default (it merges/reorders requests to minimize disk-head seeks). Inside a paravirt VM, the *host* already runs its own scheduler against the real SSD; running another one in the guest is wasted work against fake geometry.

```fish
echo 'ACTION=="add|change", KERNEL=="sda", ATTR{queue/scheduler}="none"' | sudo tee /etc/udev/rules.d/60-io-scheduler.rules
echo none | sudo tee /sys/block/sda/queue/scheduler
cat /sys/block/sda/queue/scheduler   # → [none] mq-deadline
```

The udev rule re-applies on every boot (and after disk hotplug events).

## 5. Disable Plymouth (the boot splash) — saves ~20s on every boot

Plymouth's `plymouth-quit-wait.service` waits up to 30 seconds for a "graphical session is ready" signal that often never arrives properly inside a VM. Just mask it.

```fish
sudo systemctl mask plymouth-quit-wait.service plymouth-start.service plymouth.service
sudo systemctl daemon-reload
```

After next reboot:

```fish
systemd-analyze        # → typically ~13s instead of ~34s
systemd-analyze blame  # → plymouth-quit-wait should NOT be the top item anymore
```

This loses the Ubuntu boot logo animation (you see kernel/systemd text scroll briefly instead). On a VM you barely see the boot screen anyway — the VMware window is black until GDM appears.

## 6. Auto-suspend (don't)

VMs and ACPI suspend don't mix well. Verify auto-suspend is off:

```fish
gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type    # → 'nothing'
```

If it's anything else:

```fish
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
```

## 7. Verify everything is active after a fresh boot

```fish
cat /proc/cmdline                                          # mitigations=off present
sysctl vm.swappiness                                       # = 10
cat /sys/block/sda/queue/scheduler                         # [none]
cat /proc/swaps                                            # /dev/zram0 priority 5
cat /sys/devices/system/cpu/vulnerabilities/spectre_v2     # Vulnerable; IBPB: disabled; ...
systemctl is-active zram-config.service                    # active
systemctl is-enabled plymouth-quit-wait.service 2>&1       # masked
```
