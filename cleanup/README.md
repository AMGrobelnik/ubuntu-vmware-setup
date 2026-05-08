# Cleanup — reclaiming disk and removing dead weight

Periodic + one-time cleanups to keep a long-running dev VM lean.

## One-shot full cleanup

```fish
sudo apt update && \
sudo apt full-upgrade -y && \
sudo apt autoremove --purge -y && \
sudo journalctl --vacuum-size=200M && \
sudo snap set system refresh.retain=2 && \
snap list --all | awk '/disabled/{print "--revision="$3, $1}' | xargs -r -L 1 sudo snap remove
```

This:

1. Updates the package index
2. Upgrades everything (including phased updates as they roll to you)
3. Purges autoremovable dependencies (especially old kernel modules)
4. Trims journal logs to 200 MB (default keeps 4 GB+ — overkill on a dev VM)
5. Sets snap retention to 2 revisions (default 3) → less disk eaten by old snap versions
6. Purges the old "disabled" snap revisions sitting around for rollback

Typical reclaim from a long-uptime VM: 1–5 GB.

## Purge NVIDIA driver packages (if accidentally installed)

VMware Workstation does NOT do GPU passthrough — your guest sees only `VMware SVGA II`. There's no NVIDIA hardware to drive. But Ubuntu's `ubuntu-drivers` autoinstall sometimes pulls in the NVIDIA kernel + userspace stack anyway, which then rebuilds DKMS modules on every kernel upgrade for nothing.

Check if you have any:

```fish
dpkg -l | grep -E "^ii.*nvidia"
```

If anything shows up, purge:

```fish
sudo apt purge -y '~nnvidia-' '~nlibnvidia-' && \
sudo apt autoremove --purge -y && \
sudo update-initramfs -u
```

`~n` is apt's regex match on package name. Frees ~500 MB-2 GB depending on how many revisions accumulated.

## Old kernel cleanup

Ubuntu keeps the previous one or two kernels for fallback. After a few major upgrades you can have many old kernel module trees taking gigabytes. Clean stale ones (keep current + `-1` previous):

```fish
# Inspect what's still around
ls /lib/modules
dpkg -l | awk '/^ii.*linux-(image|modules|headers)-[0-9]/{print $2}'

# Example: purge the 6.14.x line entirely + any 6.17.0-{14,19} stragglers
sudo apt purge -y \
  '~nlinux-image-6\.14\.' \
  '~nlinux-modules-6\.14\.' \
  '~nlinux-headers-6\.14\.' \
  '~nlinux-image-6\.17\.0-1[49]' \
  '~nlinux-modules-6\.17\.0-1[49]' \
  '~nlinux-headers-6\.17\.0-1[49]'

sudo apt autoremove --purge -y
```

Adjust the version regex to match what you actually have. **Never** purge the kernel you're currently booted from (`uname -r`).

Note: apt's pattern parser uses `(...)` for grouping, not regex alternation — so use a character class like `1[49]` instead of `(14|19)`.

## Stale `/lib/modules/<version>` directories

If purges leave behind module dirs (because DKMS modules left files in them), check `dpkg`'s warnings. Most of the time `update-initramfs` cleans them up automatically. If a dir lingers and the matching kernel is uninstalled:

```fish
sudo rm -rf /lib/modules/<version>
```

(Only do this if the version isn't in `dpkg -l | grep linux-image-`.)

## Stale Claude Code MCP servers

When Claude Code spawns MCP servers (chrome-devtools-mcp, playwright-mcp, context7-mcp, etc.), they sometimes stay around after the session ends. Each holds 80–200 MB. After hours of use, you can have several stacked up.

The `vmclean` fish function (see `fish/functions/vmclean.fish`) handles this — kills all MCP processes, then prints top RAM consumers + memory state. Just run:

```fish
vmclean
```

Whenever the VM feels sluggish.
