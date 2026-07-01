---
layout: exercices
---

# Exercises - Linux network optimization (BONUS) 🎯

**BONUS module: Hands-on**

---

# Exercise 1: Tune TCP with sysctl 🧠

**Goal:** Set TCP parameters for high performance

**Instructions:**

1. Show current TCP parameters
2. Edit /etc/sysctl.conf
3. Increase TCP buffers (rmem/wmem)
4. Set somaxconn to 4096
5. Enable BBR if available
6. Apply changes
7. Verify

**Duration:** 15 minutes

---

# Exercise 1: Solution 💡

```bash
# 1. Current parameters
sysctl -a | grep -E "net.core.rmem_max|net.ipv4.tcp_congestion"

# 2. Edit
sudo nano /etc/sysctl.conf

# 3–5. Add:
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.core.somaxconn = 4096
net.ipv4.tcp_max_syn_backlog = 8192
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# 6. Apply
sudo sysctl -p
```

---

# Exercise 1: Solution (continued) 💡

```bash
# 7. Verify
sysctl net.ipv4.tcp_congestion_control
sysctl net.core.somaxconn

# Available algorithms
cat /proc/sys/net/ipv4/tcp_available_congestion_control
```

---

# Exercise 2: Tune the network card 📡

**Goal:** Enable hardware offloads with ethtool

**Instructions:**

1. Identify your interface (`ip a`)
2. Show current settings with ethtool
3. Enable TSO (TCP Segmentation Offload)
4. Enable GRO (Generic Receive Offload)
5. Enable GSO (Generic Segmentation Offload)
6. Verify
7. Make persistent via /etc/network/interfaces or systemd

**Duration:** 15 minutes

---

# Exercise 2: Solution 💡

```bash
# 1. Identify interface
ip addr show
# e.g. eth0, ens33, enp0s3...

# 2. Current config
sudo ethtool -k eth0 | grep -E "tcp-segmentation|generic-receive"

# 3–5. Enable offloads
sudo ethtool -K eth0 tso on
sudo ethtool -K eth0 gro on
sudo ethtool -K eth0 gso on
```

---

# Exercise 2: Solution (continued) 💡

```bash
# 6. Verify
sudo ethtool -k eth0 | grep -E "tcp-segmentation|generic-receive|generic-segmentation"

# 7. Persist (systemd)
sudo nano /etc/systemd/network/10-eth0.link
```

---

# Exercise 2: systemd configuration 💡

Contents of `/etc/systemd/network/10-eth0.link`:

```ini
[Match]
MACAddress=XX:XX:XX:XX:XX:XX

[Link]
TCPSegmentationOffload=yes
GenericReceiveOffload=yes
GenericSegmentationOffload=yes
```

---

# Exercise 3: Configure fq_codel ⚖️

**Goal:** Reduce bufferbloat with fq_codel

**Instructions:**

1. Show current qdisc
2. Set fq_codel on the main interface
3. Verify
4. Test latency with ping under load (before/after)
5. Make persistent

**Duration:** 15 minutes

---

# Exercise 3: Solution 💡

```bash
# 1. Current qdisc
tc qdisc show dev eth0

# 2. Set fq_codel
sudo tc qdisc replace dev eth0 root fq_codel

# 3. Verify
tc qdisc show dev eth0
# Should show: qdisc fq_codel ...

# 4. Latency under load
ping -c 10 8.8.8.8
# Start a download at the same time
# wget http://speedtest.tele2.net/100MB.zip
# Check whether latency stays stable
```

---

# Exercise 3: Solution (continued) 💡

```bash
# 5. Persist
sudo nano /etc/rc.local
# Add before exit 0:
# #!/bin/bash
# tc qdisc replace dev eth0 root fq_codel

sudo chmod +x /etc/rc.local
```

---

# Exercise 4: Configure nftables 🔐

**Goal:** Deploy a performant firewall

**Instructions:**

1. Install nftables
2. Create a baseline ruleset
3. Accept loopback without filtering
4. Allow SSH, HTTP, HTTPS
5. Default drop everything else
6. Enable the service
7. Test connectivity

**Duration:** 20 minutes

---

# Exercise 4: Solution 💡

```bash
# 1. Install
sudo apt install nftables -y

# 2. Edit config
sudo nano /etc/nftables.conf
```

---

# Exercise 4: Solution (config) 💡

```bash
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        
        # Loopback
        iif lo accept
        
        # Connection tracking
        ct state established,related accept
        ct state invalid drop
        
        # SSH
        tcp dport 22 accept
        
        # HTTP/HTTPS
        tcp dport { 80, 443 } accept
        
        # ICMP (ping)
        icmp type echo-request accept
    }
    
    chain forward {
        type filter hook forward priority 0; policy drop;
    }
    
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

---

# Exercise 4: Solution (enable) 💡

```bash
# 6. Enable
sudo systemctl enable --now nftables

# Reload config
sudo nft -f /etc/nftables.conf

# Verify
sudo nft list ruleset

# 7. Test
# SSH should work
ssh user@localhost

# HTTP should work
curl http://localhost

# Other ports blocked
telnet localhost 3306
# Connection refused or timeout
```

---

# Exercise 5: Test with iperf3 📊

**Goal:** Measure throughput before/after tuning

**Instructions:**

1. Install iperf3 on 2 machines (or 2 VMs)
2. Measure throughput BEFORE tuning
3. Apply TCP tuning (exercise 1)
4. Apply NIC tuning (exercise 2)
5. Measure throughput AFTER tuning
6. Compare results
7. Document the gain

**Duration:** 20 minutes

---

# Exercise 5: Solution 💡

```bash
# 1. Install on both hosts
sudo apt install iperf3 -y

# 2. Machine A (server)
iperf3 -s

# Machine B (client) - BEFORE test
iperf3 -c 192.168.1.100 -t 30
# Note: [ ID] Interval   Transfer  Bitrate

# 3–4. Apply tuning (ex 1 and 2)
# On BOTH machines!

# 5. Machine A (server)
iperf3 -s
```

---

# Exercise 5: Solution (continued) 💡

```bash
# Machine B (client) - AFTER test
iperf3 -c 192.168.1.100 -t 30
# Note: [ ID] Interval   Transfer  Bitrate

# Parallel streams
iperf3 -c 192.168.1.100 -P 10 -t 30

# 6–7. Compare
# Example:
# BEFORE: 800 Mbits/sec
# AFTER: 940 Mbits/sec
# GAIN: +17.5%
```

---

# Exercise 6: Tune Docker networking 🐋

**Goal:** Improve container network performance

**Instructions:**

1. Run Nginx container in bridge mode (default)
2. Benchmark with ab (Apache Bench)
3. Run again in host mode
4. Benchmark again
5. Compare results
6. Adjust Docker MTU if needed

**Duration:** 20 minutes

---

# Exercise 6: Solution 💡

```bash
# 1. Bridge mode (default)
docker run -d -p 8080:80 --name nginx-bridge nginx

# 2. Test
sudo apt install apache2-utils -y
ab -n 10000 -c 100 http://localhost:8080/
# Note: Requests per second

# Stop
docker stop nginx-bridge && docker rm nginx-bridge

# 3. Host mode
docker run -d --network host --name nginx-host nginx
```

---

# Exercise 6: Solution (continued) 💡

```bash
# 4. Test again
ab -n 10000 -c 100 http://localhost/
# Note: Requests per second

# 5. Compare
# Bridge: ~5000 req/sec (example)
# Host: ~8000 req/sec (example)
# Gain: +60%

# 6. MTU
sudo nano /etc/docker/daemon.json
# Add: { "mtu": 1450 }

sudo systemctl restart docker
```

---

# Exercise 7: Real-time network monitoring 📡

**Goal:** Watch network traffic

**Instructions:**

1. Install iftop
2. Monitor eth0 in real time
3. Use ss to list connections
4. Use tcpdump to capture HTTP traffic
5. Optional: analyze capture in Wireshark

**Duration:** 15 minutes

---

# Exercise 7: Solution 💡

```bash
# 1–2. Install and run iftop
sudo apt install iftop -y
sudo iftop -i eth0 -P -n
# -P: show ports
# -n: no DNS resolution
# Press 'q' to quit

# 3. ss
# All TCP connections
ss -tan

# Listening processes
sudo ss -tlnp

# Summary stats
ss -s
```

---

# Exercise 7: Solution (continued) 💡

```bash
# 4. tcpdump
# Capture HTTP traffic (1000 packets)
sudo tcpdump -i eth0 port 80 -w capture.pcap -c 1000

# ASCII content
sudo tcpdump -i eth0 port 80 -A

# Filter by IP
sudo tcpdump -i eth0 host 192.168.1.100

# 5. Wireshark on your workstation
# Copy capture.pcap locally
# Open: wireshark capture.pcap
```

---

# BONUS project: High-performance web server 🚀

**Goal:** Configure Nginx for high load

**Full steps:**

1. Install Nginx
2. Apply ALL system tuning (TCP, NIC, fq_codel)
3. Tune Nginx (workers, keepalive, buffers)
4. Configure nftables
5. Benchmark with ab: 100,000 requests, 500 concurrent connections
6. Target: > 10,000 req/sec

**Duration:** 45 minutes

---

# BONUS project: Solution (1/4) 💡

```bash
# 1. Install Nginx
sudo apt update
sudo apt install nginx -y

# 2. System tuning
sudo nano /etc/sysctl.conf
# Add TCP parameters below
```

---

# BONUS project: sysctl configuration 💡

Add to `/etc/sysctl.conf`:

```ini
# TCP
net.core.rmem_max = 268435456
net.core.wmem_max = 268435456
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 20480
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
```

---

# BONUS project: Solution (2/4) 💡

Also add to `/etc/sysctl.conf`:

```ini
# Congestion
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
```

---

# BONUS project: Apply tuning 💡

```bash
sudo sysctl -p

# NIC
sudo ethtool -K eth0 tso on gro on gso on

# fq_codel
sudo tc qdisc replace dev eth0 root fq_codel
```

---

# BONUS project: Solution (3/4) 💡

```bash
# 3. Tune Nginx
sudo nano /etc/nginx/nginx.conf
# Use the slide configuration below
```

---

# BONUS project: Nginx config (part 1) 💡

```nginx
user www-data;
worker_processes auto;
worker_rlimit_nofile 100000;
pid /run/nginx.pid;

events {
    worker_connections 10000;
    use epoll;
    multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    keepalive_requests 10000;
    types_hash_max_size 2048;
```

---

# BONUS project: Nginx config (part 2) 💡

```nginx
    # Gzip
    gzip on;
    gzip_vary on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
    
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    access_log off;
    error_log /var/log/nginx/error.log crit;
    
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

---

# BONUS project: Test and reload 💡

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

# BONUS project: Final benchmark 💡

```bash
# 4. nftables (see exercise 4)

# 5. Final benchmark
ab -n 100000 -c 500 http://localhost/

# Expected:
# Requests per second: > 10000 [#/sec]
# Time per request: < 50 [ms] (mean)
# Failed requests: 0

# If it fails, check:
ulimit -n  # Should be >= 65535
sudo systemctl status nginx
dmesg | tail  # System errors
```

---

# Full network optimization checklist ✅

<div class="text-sm">

**System is tuned when:**

□ **TCP/IP:** Wider buffers, BBR enabled, higher backlog  
□ **NIC:** TSO/GRO/GSO on  
□ **Queue:** fq_codel or cake applied  
□ **Firewall:** nftables tuned  
□ **Containers:** MTU set, right network mode  
□ **Monitoring:** iperf3, ss, iftop under control  
□ **Benchmarks:** before/after documented

</div>

---

# Exercise recap ✅

**Skills practiced:**

✅ TCP/IP tuning with sysctl  
✅ NIC tuning (ethtool)  
✅ Queue management (tc, fq_codel)  
✅ Modern firewall (nftables)  
✅ Performance tests (iperf3, ab)  
✅ Docker networking  
✅ Network monitoring (iftop, ss, tcpdump)

---

# Exercise recap ✅

**Typical gains:**

- 🚀 +15–20% network throughput (TCP tuned)
- 🎯 −40% latency under load (fq_codel)
- 💪 +60% container perf (host mode)
- ⚡ +30% web server req/sec

**Important:** always measure before and after!

---
layout: default
---

# Congratulations! 🎉

You now master advanced Linux network optimization!

**Go further:**
- eBPF and XDP (eXpress Data Path)
- DPDK (Data Plane Development Kit)
- Advanced load balancing (HAProxy, Traefik)
- Advanced kernel tuning (IRQ affinity, NUMA)
- 10G/40G/100G networking

**Resources:**
- kernel.org/doc/Documentation/networking/
- brendangregg.com/blog/ (performance)
- netdevconf.org (conferences)
