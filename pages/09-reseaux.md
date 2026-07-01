---
layout: intro
routeAlias: 'reseaux'
---

# Networks and connectivity 🌐

### Configuring and managing Linux networks

<div class="pt-12">
  <span @click="next" class="px-2 p-3 rounded cursor-pointer hover:bg-white hover:bg-opacity-10 neon-border">
    Let's configure networks together <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: default
---

# Core concepts 🌍

### Linux network architecture

**Network interfaces:**
- **eth0, enp0s3** : Ethernet interface
- **wlan0, wlp2s0** : WiFi interface
- **lo** : Loopback interface (127.0.0.1)
- **docker0, veth*** : Virtual Docker interfaces

**IP addressing:**
- **IPv4** : 192.168.1.100/24
- **IPv6** : 2001:db8::1/64
- **Subnet mask** : 255.255.255.0
- **Gateway** : 192.168.1.1

**Network configuration:**
- **DHCP** : Automatic assignment
- **Static** : Manual configuration
- **Bonding** : Interface aggregation
- **Bridging** : Network bridge

---
layout: default
---

# Basic network commands 🔧

### Network diagnostic tools

**ip (replaces ifconfig)**
```bash
ip addr show                   # Show IP addresses
ip link show                   # Show interfaces
ip route show                  # Show routing table
ip addr add 192.168.1.100/24 dev eth0  # Add an IP
ip link set eth0 up            # Bring interface up
ip link set eth0 down          # Bring interface down
```

**ifconfig (legacy but still used)**
```bash
ifconfig                       # Show all interfaces
ifconfig eth0                  # Specific interface
ifconfig eth0 192.168.1.100 netmask 255.255.255.0  # Configure
ifconfig eth0 up               # Enable
ifconfig eth0 down             # Disable
```

**nmcli (NetworkManager CLI)**
```bash
nmcli device status            # Interface status
nmcli connection show          # Configured connections
nmcli device wifi list         # Available WiFi networks
```

---
layout: default
---

# Static network configuration ⚙️

### Manual interface configuration

**Configuration with ip:**
```bash
# Configure an interface
ip addr add 192.168.1.100/24 dev eth0
ip route add default via 192.168.1.1 dev eth0

# Configure DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
```

**Configuration with netplan (Ubuntu):**
```yaml
# /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

**Applying configuration:**
```bash
sudo netplan apply             # Apply configuration
sudo netplan try               # Test configuration
```

---
layout: default
---

# DHCP configuration 🌐

### Automatic address assignment

**DHCP client configuration:**
```bash
# Request a DHCP address
dhclient eth0                  # Classic DHCP client
dhcpcd eth0                    # Alternative DHCP client

# Automatic configuration
systemctl enable systemd-networkd
systemctl enable systemd-resolved
```

**Configuration with NetworkManager:**
```bash
# Enable DHCP on an interface
nmcli connection modify "Wired connection 1" ipv4.method auto

# View DHCP configuration
nmcli connection show "Wired connection 1"
```

**DHCP server (dnsmasq):**
```bash
# Installation
sudo apt install dnsmasq

# Configuration /etc/dnsmasq.conf
interface=eth0
dhcp-range=192.168.1.50,192.168.1.150,12h
dhcp-option=3,192.168.1.1
dhcp-option=6,8.8.8.8,8.8.4.4
```

---
layout: default
---

# Network diagnostics 🔍

### Testing and diagnostic tools

**ping (connectivity test)**
```bash
ping google.com                # Connectivity test
ping -c 4 google.com          # Only 4 pings
ping -i 2 google.com          # 2-second interval
ping -s 1000 google.com       # Packet size 1000 bytes
ping -t 64 google.com         # TTL 64
```

**traceroute (trace the path)**
```bash
traceroute google.com          # Trace the path
traceroute -n google.com       # No DNS resolution
traceroute -I google.com       # Use ICMP
mtr google.com                 # Real-time traceroute
```

**nslookup and dig (DNS)**
```bash
nslookup google.com            # DNS resolution
nslookup 8.8.8.8              # Reverse lookup
dig google.com                 # Detailed DNS query
dig +short google.com          # Short answer
```

---
layout: default
---

# Network monitoring 📊

### Network traffic monitoring

**netstat (network statistics)**
```bash
netstat -tuln                  # Listening ports
netstat -i                     # Network interfaces
netstat -r                     # Routing table
netstat -s                     # Statistics
netstat -an | grep ESTABLISHED # Established connections
```

**ss (Socket Statistics)**
```bash
ss -tuln                       # Listening ports (modern)
ss -i                          # Detailed information
ss -s                          # Statistics
ss -t state established        # Established connections
```

**iftop (real-time monitoring)**
```bash
iftop                          # Real-time network traffic
iftop -i eth0                  # Specific interface
iftop -P                       # Show ports
```

---
layout: default
---

# Firewall and network security 🛡️

### Firewall configuration

**ufw (Uncomplicated Firewall)**
```bash
sudo ufw enable                # Enable firewall
sudo ufw status                # Firewall status
sudo ufw allow ssh             # Allow SSH
sudo ufw allow 80/tcp          # Allow HTTP
sudo ufw deny 22               # Deny SSH
sudo ufw allow from 192.168.1.0/24  # Allow a network
```

**iptables (advanced firewall)**
```bash
# List rules
sudo iptables -L
sudo iptables -L -n -v

# Add rules
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j DROP
sudo iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT

# Save rules
sudo iptables-save > /etc/iptables/rules.v4
```

**nftables (modern firewall)**
```bash
# Create a table
sudo nft add table inet filter

# Create a chain
sudo nft add chain inet filter input { type filter hook input priority 0 \; }

# Add a rule
sudo nft add rule inet filter input tcp dport 80 accept
```

---
layout: default
---

# VPN and tunnels 🔐

### Secure tunnel configuration

**OpenVPN**
```bash
# Installation
sudo apt install openvpn

# Client configuration
sudo openvpn --config client.ovpn

# Server configuration
sudo openvpn --config server.conf
```

**WireGuard (modern VPN)**
```bash
# Installation
sudo apt install wireguard

# Generate keys
wg genkey | tee privatekey | wg pubkey > publickey

# Interface configuration
sudo ip link add wg0 type wireguard
sudo ip addr add 10.0.0.1/24 dev wg0
sudo wg set wg0 private-key < privatekey
sudo ip link set wg0 up
```

**SSH tunnel**
```bash
# Local tunnel
ssh -L 8080:localhost:80 user@remote

# Remote tunnel
ssh -R 8080:localhost:80 user@remote

# SOCKS tunnel
ssh -D 1080 user@remote
```

---
layout: default
---

# Network services 🌐

### Network service configuration

**SSH (Secure Shell)**
```bash
# Installation
sudo apt install openssh-server

# Configuration /etc/ssh/sshd_config
Port 2222                      # Change port
PermitRootLogin no             # Disallow root
PasswordAuthentication no       # Disable passwords
PubkeyAuthentication yes       # Enable keys
AllowUsers user1 user2         # Allowed users

# Restart SSH
sudo systemctl restart ssh
```

**Nginx (web server)**
```bash
# Installation
sudo apt install nginx

# Configuration /etc/nginx/sites-available/default
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    index index.html;
}

# Enable the site
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
sudo nginx -t                  # Test configuration
sudo systemctl restart nginx
```

---
layout: default
---

# DNS and name resolution 📝

### DNS configuration

**DNS client configuration:**
```bash
# File /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
search example.com

# systemd-resolved configuration
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

**Local DNS server (dnsmasq):**
```bash
# Configuration /etc/dnsmasq.conf
interface=eth0
bind-interfaces
domain=example.com
dhcp-range=192.168.1.50,192.168.1.150,12h
server=8.8.8.8
server=8.8.4.4
```

**DNS resolution tests:**
```bash
# Test with dig
dig @8.8.8.8 google.com
dig +short google.com
dig MX google.com

# Test with nslookup
nslookup google.com 8.8.8.8
```

---
layout: default
---

# Aggregation and bonding 🔗

### Network interface aggregation

**Bonding (interface aggregation)**
```bash
# Configuration /etc/modules-load.d/bonding.conf
bonding

# Configuration /etc/sysconfig/network-scripts/ifcfg-bond0
DEVICE=bond0
TYPE=Bond
NAME=bond0
BONDING_OPTS="mode=1 miimon=100"
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.1.100
NETMASK=255.255.255.0
```

**Slave interface configuration:**
```bash
# /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes
USERCTL=no

# /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes
USERCTL=no
```

---
layout: default
---

# Advanced monitoring 📈

### Network monitoring tools

**tcpdump (packet capture)**
```bash
# Capture traffic
sudo tcpdump -i eth0
sudo tcpdump -i eth0 port 80
sudo tcpdump -i eth0 host 192.168.1.100
sudo tcpdump -i eth0 -w capture.pcap

# Advanced filters
sudo tcpdump -i eth0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
```

**Wireshark (packet analyzer)**
```bash
# Installation
sudo apt install wireshark

# Command-line capture
sudo tshark -i eth0 -w capture.pcap
sudo tshark -i eth0 -f "port 80" -w http.pcap
```

**nethogs (per-process usage)**
```bash
# Installation
sudo apt install nethogs

# Usage
sudo nethogs eth0
sudo nethogs -t eth0
```

---
layout: default
---

# IPv6 configuration 🌐

### IPv6 support

**Automatic IPv6 configuration:**
```bash
# Enable IPv6
echo 'net.ipv6.conf.all.disable_ipv6 = 0' >> /etc/sysctl.conf
sysctl -p

# Configuration with netplan
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp6: true
      addresses:
        - 2001:db8::1/64
```

**IPv6 testing:**
```bash
# IPv6 connectivity test
ping6 google.com
ping6 -c 4 google.com

# IPv6 DNS resolution
dig AAAA google.com
nslookup -type=AAAA google.com
```

**Disable IPv6 (if needed):**
```bash
# Disable IPv6
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf
sysctl -p
```

---
layout: default
---

# Hands-on exercises 🎯

### Putting it into practice

**Exercise 1: Basic network configuration**
```bash
# Configure a static interface
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip link set eth0 up
sudo ip route add default via 192.168.1.1 dev eth0

# Test connectivity
ping -c 4 192.168.1.1
ping -c 4 google.com
```

**Exercise 2: Network diagnostics**
```bash
# Analyze network configuration
ip addr show
ip route show
cat /etc/resolv.conf

# Test connectivity
traceroute google.com
nslookup google.com
```

**Exercise 3: ufw configuration**
```bash
# Configure a basic firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw enable
sudo ufw status
```

---
layout: default
---

# Best practices 💡

### Tips for network management

**Security**
- Use appropriate firewalls
- Disable unnecessary services
- Monitor network traffic
- Use VPNs for remote connections
- Keep systems up to date

**Performance**
- Tune network interfaces
- Use interface aggregation
- Monitor bandwidth
- Configure fast DNS
- Use local DNS caches

**Maintenance**
- Document configurations
- Back up configurations
- Monitor network logs
- Test connectivity regularly
- Keep network documentation current

---
layout: default
---

# Next steps 🎯

### What comes next

1. **Software packages** and management
2. Basic **shell scripting**
3. **Virtualization** and containers
4. **Docker** introduction

**Preparation:**
- Try basic network commands
- Configure a simple firewall
- Get comfortable with diagnostic tools
- Practice interface configuration
