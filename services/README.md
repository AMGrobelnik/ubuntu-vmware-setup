# Services to Disable

Default Ubuntu desktop ships with services aimed at laptops and printer-equipped desktops. Inside a VM most of them are dead weight — they consume RAM, slow boot, and provide zero value.

## System-level (need sudo)

```fish
sudo systemctl disable --now \
  cups cups-browsed \
  bluetooth \
  ModemManager
```

| Service | Why disable in a VM |
|---|---|
| `cups`, `cups-browsed` | CUPS print server — no printer to drive in a VM |
| `bluetooth` | No real Bluetooth radio in the VM |
| `ModemManager` | Cellular modem management — no modem |

These also have triggering units (`cups.socket`, `cups.path`) that may stay active. Harmless.

## User-level — Tracker3 file indexer

Tracker3 walks `/home` to build a search index for GNOME's Activities overview. On a dev VM with thousands of node_modules / git objects / Python `.venv` directories, it pegs CPU and disk for hours. Most users never use the search feature.

```fish
systemctl --user mask \
  tracker-miner-fs-3.service \
  tracker-miner-rss-3.service \
  tracker-extract-3.service \
  tracker-xdg-portal-3.service \
  tracker-miner-fs-control-3.service \
  localsearch-3.service

tracker3 reset -s -r   # Stop daemons + wipe the existing index DB
```

(Some unit names may not exist on your version — `systemctl --user mask` will say "Unit X.service does not exist, proceeding anyway" and continue. That's fine.)

## User-level — Evolution mail/calendar daemons

GNOME pre-loads Evolution's data server + alarm-notify on every login, ~100 MB combined RAM, even if you never open Evolution Mail / Calendar. If you use Thunderbird / a web mailer / nothing — disable them.

```fish
mkdir -p ~/.config/autostart
for f in evolution-alarm-notify.desktop org.gnome.Evolution-alarm-notify.desktop
    printf '[Desktop Entry]\nType=Application\nHidden=true\nName=evo-disabled\n' > ~/.config/autostart/$f
end

systemctl --user mask \
  evolution-source-registry.service \
  evolution-calendar-factory.service \
  evolution-addressbook-factory.service
```

Takes effect on next login (Evolution daemons are session-scoped).

## What to **keep** running

- `dockerd` + `containerd` — needed for Docker. ~130 MB combined when idle. If you don't use Docker at all, you can stop and disable both, but most dev workflows want them.
- `NetworkManager` — needed (manages your virtual NICs)
- `snapd` — required if you use snap apps (Ghostty, Firefox, etc.)
- `systemd-resolved` — DNS resolver, leave it
- `gdm3` — display manager, leave it
- `unattended-upgrades` (the `--wait-for-signal` daemon) — sits idle waiting for shutdown to apply security updates. Harmless.

## Verify after applying

```fish
systemctl is-enabled cups cups-browsed bluetooth ModemManager 2>&1
# All four should print "disabled" or "masked"

systemctl --user is-enabled \
  tracker-miner-fs-3 evolution-source-registry 2>&1
# All should print "masked"

pgrep -af tracker | grep -v grep    # → empty
pgrep -af evolution | grep -v grep  # → empty (after re-login)
```
