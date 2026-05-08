# Firewall (UFW)

UFW = "Uncomplicated Firewall", Ubuntu's frontend over `iptables`/`nftables`. Even on a desktop dev VM, the modern best practice is "deny everything inbound by default, only open what's needed." Same shape as Windows Defender Firewall.

## Initial setup

```fish
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw status verbose
```

After this, **everything outbound works** (Anthropic API, GitHub, package registries, web browsing) but no machine on your LAN — including your Windows host — can reach services running in the VM unless you open a port for them.

## Tailscale carve-out

You almost certainly want Tailscale traffic to flow freely (you control your tailnet, that's the point). The `tailscale0` interface runs WireGuard between your devices.

```fish
sudo ufw allow in on tailscale0
```

Adds an IPv4 + IPv6 rule allowing any incoming traffic on the `tailscale0` device.

## SSH from the LAN (only if you want it)

If you SSH into the VM from your Windows host or another LAN machine:

```fish
sudo ufw allow from 192.168.0.0/16 to any port 22 proto tcp comment 'SSH from LAN'
```

The CIDR `192.168.0.0/16` covers all common home-LAN subnets (`192.168.0.x`, `192.168.1.x`, …, `192.168.254.x`). If you only want a specific machine, use `192.168.1.42` (or whatever).

Skip this rule if you only ever access the VM via Tailscale (which you allowed above).

## Important caveat: Docker bypasses UFW

Docker manipulates `iptables`' FORWARD chain directly. UFW only governs the INPUT chain. So `docker run -p 8080:8080` exposes port 8080 to the world **regardless** of UFW status. UFW won't block it, won't protect it.

If that matters in your threat model, install [`ufw-docker`](https://github.com/chaifeng/ufw-docker) and bind containers to specific interfaces. For most dev workflows, just be aware that "publish a port via Docker = port is exposed" — UFW isn't a backstop.

## Check status

```fish
sudo ufw status verbose
```

Expected output looks like:

```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
Anywhere on tailscale0     ALLOW IN    Anywhere
22/tcp                     ALLOW IN    192.168.0.0/16             # SSH from LAN
Anywhere (v6) on tailscale0 ALLOW IN    Anywhere (v6)
```

## Disable / reset (if needed)

```fish
sudo ufw disable          # turn off, rules retained
sudo ufw reset            # nuke all rules, set defaults back to "allow"
```
