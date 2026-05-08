# Tailscale Setup Guide

WireGuard-based mesh VPN. Used on this VM for SSH-from-anywhere (incl. Termius on mobile) without port-forwarding or manual key management.

## Installation

```bash
curl -fsSL https://tailscale.com/install.sh | sh
tailscale version
```

The install script adds the Tailscale apt repo, installs the package, and enables the `tailscaled` systemd unit.

Currently installed: **1.96.4** at `/usr/bin/tailscale`.

## First-time auth

```bash
sudo tailscale up --ssh
```

The `--ssh` flag enables **Tailscale SSH** (auth via your Tailscale account, no SSH keys to manage). The command prints a `https://login.tailscale.com/a/...` URL — open it, sign in (Google / Microsoft / GitHub / email), approve the device. Done.

When the device key expires (180-day default), you'll see `Logged out.` from `tailscale status` and need to re-run `sudo tailscale up --ssh` and re-auth via the same flow. You can disable key expiry per-device in the admin console.

## Verify

```bash
tailscale status              # peers + states
tailscale ip -4               # this device's tailnet IPv4
tailscale ip -6               # IPv6
hostname                      # MagicDNS name uses this
```

## Connect from another device

```bash
# Via Tailscale SSH
ssh adrian@<tailnet-name>     # MagicDNS, e.g. ssh adrian@vm
ssh adrian@<tailscale-ip>     # IP form

# Plain SSH still works too — Tailscale just gives you a routable IP
ssh adrian@<tailscale-ip>
```

## Mobile (Termius / Terminus)

1. Install **Tailscale** on the phone (iOS / Android), sign in with the same account.
2. Install **Termius** (or **Terminus**), add a host:
   - **Hostname**: tailnet name (e.g. `vm`) or tailscale IP
   - **Port**: 22
   - **User**: `adrian`
   - **Auth**: password or key
3. Connect, then `zellij attach -c work` to land in your persistent session. See [../zellij/](../zellij/).

## Useful commands

```bash
sudo tailscale up --ssh                    # connect + enable Tailscale SSH
sudo tailscale down                        # disconnect
sudo tailscale logout                      # remove this device
tailscale status
tailscale ip
tailscale ping <peer>
tailscale file cp ./file.txt <peer>:       # send a file
tailscale file get                         # save received files

# Service control
systemctl status tailscaled
sudo systemctl restart tailscaled
```

## Optional features

```bash
sudo tailscale up --ssh --advertise-exit-node          # offer this VM as exit node
sudo tailscale up --ssh --exit-node=<peer>             # route traffic via a peer
sudo tailscale up --ssh --advertise-routes=192.168.1.0/24   # subnet routing
tailscale funnel 3000                                  # expose a local port to the public internet
```

## Admin console

https://login.tailscale.com/admin

- Devices, ACLs, DNS, sharing, logs, key expiry settings.

## Troubleshooting

```bash
# Are we even authed?
tailscale status        # "Logged out." → need `sudo tailscale up --ssh`

# Service running?
systemctl status tailscaled
sudo systemctl restart tailscaled

# Re-auth from scratch
sudo tailscale logout
sudo tailscale up --ssh

# Network reach
ping login.tailscale.com
```

## Notes about this VM

- Hostname is `vm`, so MagicDNS makes the SSH command `ssh adrian@vm` from any other tailnet device.
- The IP changes if the device is removed and re-added — prefer the MagicDNS name in mobile clients.
- At time of last check, the Tailscale daemon was logged out; run `sudo tailscale up --ssh` to bring it back online.

## Resources

- Docs: https://tailscale.com/kb/
- Admin: https://login.tailscale.com/admin
- Status page: https://status.tailscale.com/
