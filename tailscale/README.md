# Tailscale Setup Guide

Secure VPN mesh network for easy remote access to your Ubuntu machine.

## Overview

Tailscale creates a private network between your devices using WireGuard. Perfect for:
- SSH access from anywhere
- Secure remote connections
- Mobile access (Terminus app)
- No port forwarding needed
- Zero-configuration networking

## Installation

### Install via Script (Recommended)

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

This script:
- Adds Tailscale repository
- Installs Tailscale package
- Sets up systemd service

### Manual Installation

```bash
# Add Tailscale repository
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# Install
sudo apt update
sudo apt install tailscale
```

## Initial Setup

### Start Tailscale with SSH Support

```bash
sudo tailscale up --ssh
```

**Important**: The `--ssh` flag enables Tailscale SSH, which:
- Manages SSH authentication automatically
- Uses your Tailscale account for auth
- No need to manage SSH keys manually
- Secure by default

### Authenticate

1. The command will output a URL like:
   ```
   https://login.tailscale.com/a/XXXXXXXXXX
   ```

2. Open this URL in your browser

3. Log in with:
   - Google account
   - Microsoft account
   - GitHub account
   - Email (magic link)

4. Approve the device

5. Your machine is now on your Tailscale network!

## Verify Connection

### Check Status

```bash
tailscale status
```

Output shows:
- Connected devices
- IP addresses
- Online/offline status
- Your machine name

### Get Your Tailscale IP

```bash
# IPv4 address
tailscale ip -4

# IPv6 address
tailscale ip -6

# Both
tailscale ip
```

Example output:
```
100.73.161.111
fd7a:115c:a1e0::1234:5678
```

### Test Connection

```bash
# Ping another device on Tailscale
ping $(tailscale ip -4)

# SSH to another device
ssh user@TAILSCALE_IP
```

## SSH Configuration

### Tailscale SSH (Recommended)

Already enabled with `--ssh` flag.

**Advantages:**
- Automatic authentication via Tailscale
- No SSH keys to manage
- Audit logging
- Access control via Tailscale admin

**To connect:**
```bash
# From another device on Tailscale
ssh username@machine-name

# Or use Tailscale IP
ssh username@100.73.161.111
```

### Traditional SSH (Also Works)

Regular SSH server is also available:

```bash
# Check SSH service
systemctl status ssh

# Ensure it's enabled
sudo systemctl enable --now ssh
```

Connect via Tailscale IP:
```bash
ssh adrian@100.73.161.111
```

## Mobile Access with Terminus

### Setup on Phone

1. **Install Tailscale app on phone**
   - Android: Google Play Store
   - iOS: App Store

2. **Log in with same account** used on Ubuntu

3. **Install Terminus app**
   - Terminal emulator with SSH support

4. **Add SSH host in Terminus:**
   - **Hostname**: Your Tailscale IP (e.g., `100.73.161.111`)
     - Or machine name: `adrian-vmware-virtual-platform`
   - **Port**: `22`
   - **Username**: `adrian` (your Ubuntu username)
   - **Authentication**:
     - Password (Ubuntu password)
     - Or SSH key

5. **Connect!**

### Current Configuration

Based on your setup:
- **Tailscale IP**: `100.73.161.111`
- **Machine Name**: `adrian-vmware-virtual-platform`
- **Username**: `adrian`

**Terminus Connection:**
```
Host: 100.73.161.111
Port: 22
User: adrian
Auth: Your Ubuntu password
```

## Features

### 1. MagicDNS

Automatically enabled - use machine names instead of IPs:

```bash
# Instead of:
ssh adrian@100.73.161.111

# Use:
ssh adrian@adrian-vmware-virtual-platform
```

### 2. Exit Nodes

Use another device as VPN gateway:

```bash
# Enable device as exit node
sudo tailscale up --advertise-exit-node

# Use another device as exit node
sudo tailscale up --exit-node=DEVICE_NAME
```

### 3. Subnet Routing

Share local network via Tailscale:

```bash
sudo tailscale up --advertise-routes=192.168.1.0/24
```

### 4. File Sharing (Taildrop)

Send files between devices:

```bash
# Send file
tailscale file cp myfile.txt DEVICE_NAME:

# Receive files (automatic to ~/Downloads)
tailscale file get
```

## Management

### Tailscale Admin Console

Web interface: https://login.tailscale.com/admin

Features:
- View all devices
- Manage access controls
- DNS settings
- Sharing settings
- Audit logs
- ACL configuration

### Common Commands

```bash
# Show status
tailscale status

# Show current IP
tailscale ip

# Disconnect
sudo tailscale down

# Reconnect
sudo tailscale up

# Logout (remove device)
sudo tailscale logout

# Update Tailscale
sudo apt update && sudo apt upgrade tailscale

# Check version
tailscale version
```

### Service Management

```bash
# Check service status
systemctl status tailscaled

# Restart service
sudo systemctl restart tailscaled

# Enable at boot (already enabled)
sudo systemctl enable tailscaled
```

## Security

### Access Control Lists (ACLs)

Configure in admin console:

```json
{
  "acls": [
    {
      "action": "accept",
      "src": ["*"],
      "dst": ["*:22"]
    }
  ]
}
```

This allows SSH from any device on your network.

### Key Expiry

By default, device keys expire after 180 days.

**Disable expiry:**
1. Go to https://login.tailscale.com/admin
2. Find your device
3. Click device → Settings → Disable key expiry

### Taildrop Security

Files sent via Taildrop require approval before saving (configurable).

## Firewall Configuration

Tailscale automatically configures firewall rules. No manual iptables needed!

To verify:
```bash
sudo iptables -L -n | grep tailscale
```

## Integration with Zellij

Perfect combination for remote work:

```bash
# SSH from phone via Terminus
ssh adrian@100.73.161.111

# Immediately attach to zellij session
zj

# Your entire work environment loads!
# Tabs, panes, processes - all there

# Close Terminus app
# Session keeps running

# Reconnect later
ssh adrian@100.73.161.111
zj
# Everything exactly as you left it!
```

## Troubleshooting

### Can't Connect

```bash
# Check Tailscale status
tailscale status

# Check if service is running
systemctl status tailscaled

# Restart service
sudo systemctl restart tailscaled

# Reauth
sudo tailscale up --ssh
```

### SSH Not Working

```bash
# Verify SSH server is running
systemctl status ssh

# Test local SSH
ssh localhost

# Check Tailscale SSH
tailscale ssh adrian@100.73.161.111

# Fall back to regular SSH
ssh adrian@100.73.161.111
```

### IP Not Showing

```bash
# Ensure you're authenticated
sudo tailscale up --ssh

# Check network connectivity
tailscale status

# Ping Tailscale control server
ping login.tailscale.com
```

### Device Offline in Admin Console

```bash
# Reconnect
sudo tailscale up --ssh

# Check internet connection
ping 8.8.8.8

# Check firewall
sudo ufw status
```

## Performance

Tailscale uses WireGuard protocol:
- Very fast (near line speed)
- Low latency
- Efficient encryption
- Battery-friendly on mobile

Typical performance:
- LAN-like speeds when on same network
- Direct peer-to-peer connections when possible
- DERP relay when P2P not possible

## Privacy

- **Zero-knowledge**: Tailscale can't see your traffic
- **End-to-end encrypted**: Only your devices can decrypt
- **No data retention**: Traffic doesn't go through Tailscale servers (except DERP relay when needed)
- **Open source client**: Verifiable security

## Use Cases

### Remote Development

```bash
# SSH to work machine
ssh work-machine

# Start/attach zellij
zj

# Code, test, commit - full development environment
```

### File Transfer

```bash
# Send files
tailscale file cp project.zip laptop:

# Access files from phone via Terminus
ssh ubuntu-machine
cd ~/Downloads/Taildrop
```

### Multiple Machines

Connect all your devices:
- Desktop at home
- Laptop
- Phone
- Tablet
- Raspberry Pi
- VPS

All on one private network!

## Cost

- **Free tier**: Up to 100 devices, 3 users
- **Personal use**: Free tier is usually sufficient
- **Paid tiers**: Available for teams/businesses

## Additional Features

### Funnel (Expose to Internet)

Share services publicly (optional):
```bash
tailscale funnel 3000
```

### DNS

Custom DNS resolution for your network.

### Tags

Organize and manage devices:
```bash
sudo tailscale up --advertise-tags=tag:server
```

## Comparison with Alternatives

| Feature | Tailscale | OpenVPN | WireGuard | ZeroTier |
|---------|-----------|---------|-----------|----------|
| Setup | Easy | Complex | Medium | Easy |
| Performance | Excellent | Good | Excellent | Good |
| NAT traversal | Excellent | Poor | Poor | Good |
| Mobile support | Excellent | Good | Good | Good |
| Zero-config | Yes | No | No | Mostly |
| Free tier | Yes | Yes | Free | Yes |

## Resources

- Official Docs: https://tailscale.com/kb/
- Admin Console: https://login.tailscale.com/admin
- GitHub: https://github.com/tailscale/tailscale
- Status: https://status.tailscale.com/

## Quick Reference

```bash
# Install
curl -fsSL https://tailscale.com/install.sh | sh

# Start with SSH
sudo tailscale up --ssh

# Get IP
tailscale ip -4

# Check status
tailscale status

# From phone (Terminus)
ssh adrian@100.73.161.111
zj  # Instant work environment!
```

---

**Perfect for remote work, especially combined with Zellij for persistent sessions!**
