---
layout: new-section
routeAlias: 'optimisation-reseau-linux'
---

<a name="optimisation-reseau-linux" id="optimisation-reseau-linux"></a>

# 🌐 BONUS module
## Network optimization on Linux

### Understanding and tuning the network stack

---

# "Optimizing the network" on Linux 🤔

## What does that mean in practice?

**It is the set of techniques that aim to:**

- 🔻 **Reduce latency**
- 🔺 **Increase throughput**
- 🧠 **Reduce CPU load**
- 🛡 **Improve stability**

---

# "Optimizing the network" on Linux 🤔

## What does that mean in practice? (continued)

**It is the set of techniques that aim to:**

- 📦 **Avoid packet loss**
- ⚙️ **Adapt kernel behavior to the workload**

---

# In short 💡

<div class="text-center text-xl mt-10">

**You don't "make the Internet faster"**

**You make the machine more efficient at sending, receiving, and processing traffic.**

</div>

---

# The six pillars 🏛️

## Network optimization on Linux

1. 🧠 TCP/IP stack tuning
2. 📡 Network interface card (NIC) tuning
3. ⚖️ Queues & congestion
4. 🔐 Firewall & filtering
5. 🧱 Virtualization & containers
6. 📊 Monitoring and diagnostics

---

# 1️⃣ TCP/IP stack 🧠

**Based on the TCP protocol**

**Goals:**
- Avoid congestion
- Manage queues better
- Speed up exchanges

**Tools:**
- `sysctl`
- `/proc/sys/net/*`

---

# 1️⃣ TCP/IP stack - examples 🧠

**Example tunables:**

- Send/receive buffer sizes
- Number of concurrent connections
- Congestion algorithm (BBR, CUBIC…)

```bash
# Show current network parameters
sysctl -a | grep net.ipv4
```

---

# 1️⃣ TCP tuning - configuration

```bash
# Edit configuration
sudo nano /etc/sysctl.conf
```

```ini
# Increase TCP buffers
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# Increase backlog
net.core.somaxconn = 4096
net.ipv4.tcp_max_syn_backlog = 8192
```

---

# 1️⃣ TCP tuning - configuration (continued)

```ini
# Reduce timeouts
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15

# Reuse TIME_WAIT sockets
net.ipv4.tcp_tw_reuse = 1

# BBR congestion control (2025)
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
```

---

# 1️⃣ Apply changes

```bash
# Apply immediately
sudo sysctl -p

# Check active algorithm
sysctl net.ipv4.tcp_congestion_control

# List available algorithms
cat /proc/sys/net/ipv4/tcp_available_congestion_control
```

---

# 2️⃣ Network card (NIC) 📡

**Hardware: Network Interface Card**

**Goals:**
- Reduce CPU overhead
- Improve interrupt handling

**Techniques:**
- **Offloading** (TSO, GRO, LRO)
- **Multiqueue**
- **IRQ affinity**

**Main tool:**
- `ethtool`

---

# 2️⃣ Offloading with ethtool

```bash
# Show current settings
sudo ethtool -k eth0

# Enable TSO (TCP Segmentation Offload)
sudo ethtool -K eth0 tso on

# Enable GRO (Generic Receive Offload)
sudo ethtool -K eth0 gro on

# Enable GSO (Generic Segmentation Offload)
sudo ethtool -K eth0 gso on
```

---

# 2️⃣ Network statistics

```bash
# NIC statistics
sudo ethtool -S eth0

# Link speed and duplex
sudo ethtool eth0

# Set ring buffer size
sudo ethtool -G eth0 rx 4096 tx 4096
```

---

# 2️⃣ Multiqueue and IRQ affinity

**Multiqueue**: spread traffic across CPUs

```bash
# Number of queues
ls /sys/class/net/eth0/queues/

# IRQ assignment
cat /proc/interrupts | grep eth0

# Pin an IRQ to a specific CPU
echo "2" > /proc/irq/125/smp_affinity_list
```

---

# 3️⃣ Queues & congestion ⚖️

**Goals:**
- Avoid **bufferbloat**
- Prioritize important traffic

**Recommended algorithms (2025):**
- `fq` (Fair Queue)
- `fq_codel` (Fair Queue Controlled Delay)
- `cake` (Common Applications Kept Enhanced)

**Main tool:**
- `tc` (Traffic Control)

---

# 3️⃣ What is bufferbloat? 🤔

**Bufferbloat** = excessive latency from oversized buffers

**Symptoms:**
- High latency under load
- Online games lag during downloads
- Choppy video calls

**Fix:**
Use a modern scheduler like `fq_codel` or `cake`

---

# 3️⃣ Configure fq_codel

```bash
# Current qdisc
tc qdisc show dev eth0

# Set fq_codel (modern; default on recent kernels)
sudo tc qdisc replace dev eth0 root fq_codel
```

---

# 3️⃣ Configure cake (more advanced)

```bash
# cake (may need kernel modules)
sudo tc qdisc replace dev eth0 root cake bandwidth 100Mbit

# Interactive traffic priority
sudo tc qdisc replace dev eth0 root cake bandwidth 100Mbit besteffort

# cake statistics
tc -s qdisc show dev eth0
```

---

# 4️⃣ Firewall & filtering 🔐

**Goal:**
Security without killing performance

**Technologies (2025):**
- `iptables` (classic)
- **`nftables`** (modern, recommended)

---

# 4️⃣ Firewall optimizations

**Best practices:**

- ✅ Drop useless rules
- ✅ Optimal rule order (most frequent first)
- ✅ Fast path for internal traffic (localhost)
- ✅ Use sets (ipset) for IP lists
- ✅ Enable connection tracking selectively

---

# 4️⃣ Optimized nftables example

```bash
# Install nftables
sudo apt install nftables

# Edit configuration
sudo nano /etc/nftables.conf
```

---

# 4️⃣ Optimized nftables configuration

```bash
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        
        # Accept loopback without filtering
        iif lo accept
        
        # Connection tracking
        ct state established,related accept
        ct state invalid drop
        
        # SSH
        tcp dport 22 accept
        
        # HTTP/HTTPS
        tcp dport { 80, 443 } accept
    }
}
```

---

# 4️⃣ Apply nftables

```bash
# Enable nftables
sudo systemctl enable --now nftables

# Reload configuration
sudo nft -f /etc/nftables.conf

# Show active rules
sudo nft list ruleset
```

---

# 5️⃣ Virtualization & containers 🧱

**With Docker / Podman**

**Common issues:**
- NAT (Network Address Translation)
- Virtual bridges
- Network overhead

**Possible optimizations:**
- `host` network
- `macvlan`
- Bridge bypass

---

# 5️⃣ Docker: host network mode

```bash
# Run container in host mode
docker run --network host nginx

# No NAT, maximum performance
# WARNING: container shares the host network stack
```

---

# 5️⃣ Docker: adjust MTU

```bash
# Edit Docker daemon
sudo nano /etc/docker/daemon.json
```

```json
{
  "mtu": 1450,
  "default-address-pools": [
    {
      "base": "172.80.0.0/16",
      "size": 24
    }
  ]
}
```

---

# 5️⃣ Restart Docker

```bash
# Restart daemon
sudo systemctl restart docker

# Check MTU
docker network inspect bridge | grep Mtu
```

---

# 5️⃣ Podman: slirp4netns vs netavark

**Podman 2025 uses `netavark` by default (better performance)**

```bash
# Check network backend
podman info | grep -i network

# Host mode with Podman
podman run --network host nginx

# Create macvlan network
podman network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=eth0 macvlan-net
```

---

# 6️⃣ Monitoring and diagnostics 📊

**Core principle:**

<div class="text-center text-2xl mt-10">

**Never optimize without measuring!**

</div>

---

# 6️⃣ Essential tools

**Basic commands:**

- `ip`: modern network configuration
- `ss`: socket statistics (replaces netstat)
- `iftop`: real-time bandwidth monitoring
- `iperf3`: throughput tests
- `tcpdump`: packet capture

---

# 6️⃣ Using ip

```bash
# Show all interfaces
ip addr show

# Show statistics
ip -s link show eth0

# Routing table
ip route show

# Neighbors (ARP)
ip neigh show
```

---

# 6️⃣ Using ss

```bash
# All TCP connections
ss -tan

# Summary statistics
ss -s

# Established connections with details
ss -tiep

# Processes listening on ports
sudo ss -tlnp
```

---

# 6️⃣ Using iftop

```bash
# Install iftop
sudo apt install iftop

# Run iftop
sudo iftop -i eth0

# Useful options:
# -P : show ports
# -n : do not resolve names
sudo iftop -i eth0 -P -n
```

---

# 6️⃣ Using iperf3

```bash
# Install iperf3
sudo apt install iperf3

# Server (machine A)
iperf3 -s

# Client (machine B) - TCP test
iperf3 -c 192.168.1.100

# UDP test at 1 Gbps
iperf3 -c 192.168.1.100 -u -b 1G

# Parallel test (10 flows)
iperf3 -c 192.168.1.100 -P 10
```

---

# 6️⃣ Using tcpdump

```bash
# Capture on eth0
sudo tcpdump -i eth0

# Capture to file
sudo tcpdump -i eth0 -w capture.pcap

# Filter by port
sudo tcpdump -i eth0 port 80

# Filter by IP
sudo tcpdump -i eth0 host 192.168.1.100

# Packet contents (ASCII)
sudo tcpdump -i eth0 -A port 80
```

---

# Use case: Web server 🖥

## Typical optimizations

**For high-performance Nginx:**

- Higher TCP backlog
- Tuned keepalive
- Wider TCP buffers
- Multi-core network queues

---

# Use case: Web server (sysctl)

```bash
# System tuning
sudo nano /etc/sysctl.conf
```

```ini
# High backlog
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 20480

# Buffers
net.core.rmem_max = 268435456
net.core.wmem_max = 268435456
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
```

---

# Use case: Web server (nginx)

```nginx
# /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
worker_rlimit_nofile 65535;

events {
    worker_connections 4096;
    use epoll;
    multi_accept on;
}

http {
    keepalive_timeout 65;
    keepalive_requests 1000;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
}
```

---

# Use case: Containers 📦

## Common issues

- Extra latency from the Docker bridge
- Slow NAT under heavy load
- Wrong MTU

---

# Use case: Containers (fixes)

**Approaches:**

1. **Host network** for maximum performance
2. **MTU tuning** for your network
3. **Disable Docker’s iptables** if not needed
4. **Use macvlan** for direct attachment

```bash
# Disable Docker iptables
sudo nano /etc/docker/daemon.json
```

```json
{
  "iptables": false,
  "ip-forward": false
}
```

---

# Use case: Online gaming 🎮

## Goals

- ⬇️ **Minimal latency**
- ⬇️ **Lower jitter**

**Recommended actions:**

- Use `fq_codel` or `cake`
- Prioritize UDP traffic
- Eliminate bufferbloat

---

# Use case: Gaming (configuration)

```bash
# cake with gaming-oriented prioritization
sudo tc qdisc replace dev eth0 root cake bandwidth 100Mbit diffserv3

# UDP priority (gaming)
sudo iptables -t mangle -A POSTROUTING -p udp -j DSCP --set-dscp-class EF
```

---

# Use case: Network storage ☁️

## NFS / Samba

**Goals:**
- Maximum throughput
- Large TCP window
- Jumbo frames (if supported)

---

# Use case: Network storage (config)

```bash
# Enable jumbo frames (MTU 9000)
sudo ip link set eth0 mtu 9000

# TCP tuning for large transfers
sudo sysctl -w net.ipv4.tcp_window_scaling=1
sudo sysctl -w net.core.rmem_max=536870912
sudo sysctl -w net.core.wmem_max=536870912

# Tuned NFS exports
# /etc/exports
/data 192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)
```

---

# Use case: Network storage (mount)

```bash
# Optimized NFS mount
sudo mount -t nfs -o \
  rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,tcp \
  192.168.1.100:/data /mnt/nfs
```

---

# Full course outline 🎓

## Chapter 1: What we optimize

- Throughput
- Latency
- CPU
- Stability
- Security

---

# Full course outline 🎓

## Chapter 2: Linux network architecture

- TCP/IP stack
- NIC
- Queues
- Routing
- Firewall

---

# Full course outline 🎓

## Chapter 3: Core tools

- `ip`
- `ss`
- `ethtool`
- `iperf3`
- `tc`

---

# Full course outline 🎓

## Chapter 4: TCP tuning with sysctl

- Buffers
- Connections
- Congestion

---

# Full course outline 🎓

## Chapter 5: NIC tuning

- Offload
- Interrupts
- Multiqueue

---

# Full course outline 🎓

## Chapter 6: Containers

- Bridge vs host
- NAT vs direct
- MTU

---

# Full course outline 🎓

## Chapter 7: Measurement & validation

- Before/after tests
- Graphs
- Interpretation

---

# Full optimization checklist ✅

<div class="text-sm">

**□ TCP/IP stack**
- Wider buffers (rmem/wmem)
- BBR enabled
- Higher backlog
- TIME_WAIT reuse

**□ NIC**
- Offloading enabled (TSO, GRO)
- Ring buffers tuned
- Multiqueue configured

</div>

---

# Full optimization checklist ✅

<div class="text-sm">

**□ Queues**
- fq_codel or cake installed
- Bufferbloat addressed

**□ Firewall**
- nftables or iptables tuned
- Efficient rule ordering
- Connection tracking tuned

</div>

---

# Full optimization checklist ✅

<div class="text-sm">

**□ Containers**
- MTU adjusted
- Network mode suited to workload
- NAT optimized or bypassed

**□ Monitoring**
- iperf3 runs regularly
- ss and ip for diagnostics
- tcpdump for troubleshooting

</div>

---

# Module recap 🎯

**What you learned:**

- ✅ The six pillars of network optimization
- ✅ TCP/IP tuning with sysctl
- ✅ NIC tuning (ethtool)
- ✅ Queue management (tc, fq_codel, cake)
- ✅ Firewall tuning (nftables)

---

# Module recap 🎯

**What you learned (continued):**

- ✅ Container networking (Docker/Podman)
- ✅ Diagnostic tools (ip, ss, iftop, iperf3, tcpdump)
- ✅ Practical cases (web server, gaming, storage)

---

# Key takeaways 💡

<div class="text-center mt-10">

1. **Always measure before optimizing**
2. **Tune for your workload**
3. **Test after each change**
4. **Document changes**
5. **Don’t optimize prematurely**

</div>

---

# Further reading 📚

**Official docs:**
- `man sysctl`
- `man tc`
- `man ethtool`
- `man iperf3`

**Online:**
- kernel.org/doc/Documentation/networking/
- nftables.org
- netfilter.org

---

# Congratulations! 🎉

You now master network optimization on Linux!

**Skills gained:**
- Advanced TCP/IP stack tuning
- Hardware-oriented tuning
- Network performance management
- Diagnostics and troubleshooting

**Next steps:**
- Practice on real servers
- Explore eBPF for advanced tuning
- Learn XDP (eXpress Data Path)
