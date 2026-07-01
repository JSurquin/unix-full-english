---

# Quiz - Linux network optimization (BONUS) ✅

**BONUS module: Knowledge check**

---

# Question 1 🎯

**What does “optimizing the network” on Linux mean?**

A) Making the Internet faster  
B) Making the machine more efficient at handling network traffic  
C) Increasing your Internet connection speed  
D) Installing more NICs

<v-click>

**Answer: B**

Network tuning doesn’t change Internet speed; it improves how the host processes traffic.

</v-click>

---

# Question 2 ⚙️

**What is the main tool to change TCP/IP parameters?**

A) ifconfig  
B) netstat  
C) sysctl  
D) ping

<v-click>

**Answer: C**

`sysctl` changes Linux kernel parameters, including the TCP/IP stack.

</v-click>

---

# Question 3 🌐

**Which TCP congestion algorithm is recommended in 2025?**

A) Reno  
B) Tahoe  
C) BBR  
D) Vegas

<v-click>

**Answer: C**

BBR (Bottleneck Bandwidth and RTT) is Google’s modern algorithm, well suited to today’s networks.

</v-click>

---

# Question 4 📡

**Which tool tunes network interface settings?**

A) sysctl  
B) ethtool  
C) iptables  
D) netcat

<v-click>

**Answer: B**

`ethtool` configures and inspects network interface (NIC) settings.

</v-click>

---

# Question 5 🐢

**What is bufferbloat?**

A) A network virus  
B) Excessive latency from oversized buffers  
C) A security protocol  
D) A type of firewall

<v-click>

**Answer: B**

Bufferbloat is excess latency caused by oversized network buffers.

</v-click>

---

# Question 6 ⚖️

**Which queueing algorithm is modern and recommended?**

A) pfifo  
B) fq_codel  
C) bfifo  
D) red

<v-click>

**Answer: B**

`fq_codel` (Fair Queue Controlled Delay) is a modern scheduler that fights bufferbloat.

</v-click>

---

# Question 7 🔐

**Which modern firewall framework is recommended in 2025?**

A) ipchains  
B) iptables (classic)  
C) nftables  
D) firewalld only

<v-click>

**Answer: C**

`nftables` is the modern successor to iptables, with better performance and syntax.

</v-click>

---

# Question 8 🐋

**Which Docker network mode usually performs best?**

A) bridge (default)  
B) none  
C) host  
D) overlay

<v-click>

**Answer: C**

`host` mode avoids NAT and typically gives the best performance (less isolation).

</v-click>

---

# Question 9 📊

**Which tool measures throughput between two hosts?**

A) ping  
B) traceroute  
C) iperf3  
D) wget

<v-click>

**Answer: C**

`iperf3` is the standard tool for network throughput (and related) tests.

</v-click>

---

# Question 10 🔍

**Which command replaces netstat on modern systems?**

A) ip  
B) ss  
C) ifconfig  
D) route

<v-click>

**Answer: B**

`ss` (socket statistics) replaces netstat and is faster.

</v-click>

---

# Question 11 🚀

**What does TSO mean in network offloading?**

A) TCP Socket Optimization  
B) TCP Segmentation Offload  
C) Total System Offload  
D) Transport Security Offload

<v-click>

**Answer: B**

TSO (TCP Segmentation Offload) offloads segmentation to the NIC.

</v-click>

---

# Question 12 📈

**What net.core.somaxconn value suits a high-load web server?**

A) 128 (default)  
B) 512  
C) 4096 or higher  
D) 50

<v-click>

**Answer: C**

For high-load web servers, raise somaxconn to 4096 or more.

</v-click>

---

# Question 13 🔌

**What MTU is used for jumbo frames?**

A) 1500 (standard)  
B) 1450  
C) 9000  
D) 65535

<v-click>

**Answer: C**

Jumbo frames typically use MTU 9000 bytes (vs 1500).

</v-click>

---

# Question 14 🚦

**What does the `tc` command do on Linux?**

A) Manage cron jobs  
B) Control traffic and network queues  
C) Test connectivity  
D) Create containers

<v-click>

**Answer: B**

`tc` (Traffic Control) manages queuing and traffic shaping.

</v-click>

---

# Question 15 📏

**What is the first step before optimizing a system?**

A) Apply every tweak found online  
B) Measure current performance  
C) Reboot the server  
D) Install new tools

<v-click>

**Answer: B**

Always measure first - you can only improve what you measure.

</v-click>

---

# Question 16 ⏱️

**Which sysctl parameter allows reusing sockets in TIME_WAIT?**

A) net.ipv4.tcp_reuse  
B) net.ipv4.tcp_tw_reuse  
C) net.ipv4.tcp_recycle  
D) net.ipv4.tcp_socket_reuse

<v-click>

**Answer: B**

`net.ipv4.tcp_tw_reuse` allows reusing sockets in TIME_WAIT in controlled cases.

</v-click>

---

# Question 17 🦭

**Which network backend does Podman use by default in 2025?**

A) CNI  
B) slirp4netns  
C) netavark  
D) bridge

<v-click>

**Answer: C**

Podman now defaults to `netavark`, which is more efficient than slirp4netns.

</v-click>

---

# Question 18 💾

**For an NFS storage server, which point matters most?**

A) Minimum latency only  
B) Large TCP window for maximum throughput  
C) Data compression  
D) Always-on encryption

<v-click>

**Answer: B**

For NFS, a large TCP window helps maximize large file transfer throughput.

</v-click>

---

# Question 19 📡

**Which tool shows bandwidth usage in real time?**

A) ping  
B) iftop  
C) top  
D) htop

<v-click>

**Answer: B**

`iftop` displays per-connection bandwidth in real time.

</v-click>

---

# Question 20 🎯

**What is the right approach to network optimization?**

A) Apply all settings from random guides  
B) Measure, tune, re-measure  
C) Tune without measuring - it always works  
D) Never change defaults

<v-click>

**Answer: B**

Use a scientific loop: measure, change one thing, measure again.

</v-click>

---

# Score 🎯

**Scale:**
- 18–20/20: Expert! ⭐⭐⭐⭐
- 15–17/20: Excellent! ⭐⭐⭐
- 12–14/20: Very good! ⭐⭐
- 10–11/20: Good ⭐
- < 10: Review the module

---
layout: default
---

# End of network optimization quiz ✅

Congratulations! Move on to hands-on exercises on real servers.
