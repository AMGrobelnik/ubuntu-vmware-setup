# Ubuntu VMware Setup Guide

Complete setup documentation for an Ubuntu 24.04 LTS workstation running in VMware (developer environment).

## Overview

This repository captures the live configuration of a working Ubuntu 24.04 LTS dev VM. Each subdirectory contains a README and the actual config files copied from the running system, so a fresh VM can be brought up to the same state without guesswork.

## Components

### 1. [GNOME Desktop](./gnome/)
- GNOME 46 extensions and dconf backups
- Yaru-blue-dark theme (prefer-dark)
- Dash-to-Panel + ArcMenu + Vitals + Clipboard Indicator
- Restore script for fresh installs

### 2. [Fish Shell](./fish/)
- Fish 4.x with `~/.config/fish/config.fish`
- Aliases for `claude` (with env flags) and `zellij`
- Abbreviations: `cat`→`batcat`, `ls`→`eza`, `ll`, `za`, `zda`
- Custom functions: `fcd`, `fe`, `fenv`, `fgb`, `fkill`, `vmclean`
- Bun PATH wiring

### 3. [Ghostty Terminal](./ghostty/)
- Ghostty (snap, edge channel) with Catppuccin Mocha
- Windows-style copy/paste (Ctrl+C / Ctrl+V) with SIGINT fallthrough
- 1 GB scrollback, focus-follows-mouse, copy-on-select to clipboard

### 4. [Zellij](./zellij/)
- Zellij 0.44.1 (snap) with Catppuccin Mocha
- Default shell: fish
- Session serialization enabled

### 5. [CLI Tools](./cli-tools/)
- `fzf`, `bat` (`batcat`), `eza`, `ripgrep`, `fd-find` (`fdfind`)
- All wired into the Fish config via abbreviations

### 6. [Tailscale](./tailscale/)
- Mesh VPN for SSH-from-anywhere (incl. mobile via Termius)
- Tailscale SSH (`--ssh`) instead of manual key management

## Quick Start

Each directory contains:
- `README.md` — what is installed, why, and how to set it up
- The actual config files copied from the live machine
- Install / restore scripts where useful

## System Information

- **OS**: Ubuntu 24.04 LTS (Noble)
- **Kernel**: 6.17.x
- **Desktop**: GNOME 46
- **Shell**: Fish 4.x
- **Terminal**: Ghostty (snap)
- **Multiplexer**: Zellij 0.44.1 (snap)
- **VM host**: VMware

## Setup Order

1. GNOME desktop tweaks + extensions
2. Fish shell (and `chsh`)
3. CLI tools (`fzf`, `bat`, `eza`, `rg`, `fd`)
4. Ghostty terminal
5. Zellij multiplexer
6. Tailscale (for remote / mobile access)

---

Last updated: May 2026
