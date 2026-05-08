# Disk + Filesystem

How to grow the VM's disk, set up snapshots, and keep TRIM running.

## Growing the disk after a host-side `.vmdk` resize

When you expand the VM's `.vmdk` from VMware Workstation (Settings → Hard Disk → Expand), the *partition* and *filesystem* inside the guest are still at the old size. Two steps:

```fish
# 1. Grow the partition to fill the new disk size
sudo growpart /dev/sda 2

# 2. Grow the ext4 filesystem to fill the resized partition
sudo resize2fs /dev/sda2

# Verify
lsblk /dev/sda
df -h /
```

`growpart` is in the `cloud-guest-utils` package (preinstalled on Ubuntu Server, may need install on Desktop):

```fish
sudo apt install -y cloud-guest-utils
```

This is **online** — no unmount, no reboot. ext4's online-grow capability is mature.

About defrag: ext4 has an extent-based allocator that largely avoids fragmentation. Don't run `e4defrag` inside the guest. Defragging in VMware (host-side, against the `.vmdk` file on NTFS) **does** help — it consolidates the VMDK's blocks on the host SSD, improving sequential I/O. Run that occasionally from the host, not the guest.

## TRIM (already on by default)

Ubuntu enables `fstrim.timer` out of the box. It runs `fstrim` weekly across all mounted filesystems, reclaiming SSD blocks that are no longer in use.

```fish
systemctl is-enabled fstrim.timer    # → enabled
systemctl list-timers fstrim.timer   # → next-run date
```

If for some reason it's off:

```fish
sudo systemctl enable --now fstrim.timer
```

## Timeshift snapshots

Linux's equivalent of Windows System Restore. Writes the system files (`/`, `/usr`, `/etc`, `/boot`) into hard-link-deduplicated snapshot directories. First snapshot ~25 GB; subsequent ones add only changed files (often <500 MB).

Install once:

```fish
sudo apt install -y timeshift
```

Take a snapshot before any risky change:

```fish
sudo timeshift --create --comments "before mitigations=off" --tags D
```

List, restore, delete:

```fish
sudo timeshift --list
sudo timeshift --restore --snapshot '<name-from-list>'
sudo timeshift --delete --snapshot '<name>'
```

Or use the GUI: `sudo timeshift-gtk`.

**What gets backed up by default**: system files. **NOT** `/home` (Timeshift is for OS recovery, not user-data backup). For `/home`, use a different tool — rsync to external, restic, BackBlaze, etc.

If a kernel update or grub change bricks your boot, you can boot the VM from an Ubuntu live ISO, mount `/dev/sda2`, and run `timeshift --restore` from the live environment to roll back.

## Mount options

`/` is mounted with `rw,relatime` by default. `relatime` is the modern compromise — only updates atime when needed, very cheap. Don't bother switching to `noatime`; the gain is tiny on ext4 in 2024+.

```fish
findmnt / -o TARGET,FSTYPE,OPTIONS
```

## Ext4 over what's underneath

Your ext4 sits inside `/dev/sda2`, which is a paravirtualized SCSI device backed by a `.vmdk` file on the Windows host's NTFS, on an SSD. The guest scheduler is set to `none` (see `kernel/`) because the host already schedules the real I/O against the SSD.
