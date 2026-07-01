---

# Quiz Module 7: Networking ✅

**20 questions on network configuration and troubleshooting**

---

# Question 1

Which IP address is localhost?

A) `192.168.1.1`

B) `127.0.0.1`

C) `10.0.0.1`

D) `0.0.0.0`

---

# Question 2

Which port does SSH use by default?

A) 21

B) 22

C) 23

D) 80

---

# Question 3

Which command tests network connectivity?

A) `test`

B) `ping`

C) `connect`

D) `check`

---

# Question 4

Which command shows the IP configuration?

A) `ipconfig`

B) `ifconfig`

C) `ip addr`

D) Both B and C are correct

---

# Question 5

Which command shows active connections?

A) `connections`

B) `netstat` or `ss`

C) `active`

D) `ports`

---

# Question 6

Which tool generates an SSH key pair?

A) `ssh-key`

B) `ssh-keygen`

C) `keygen`

D) `ssh-create`

---

# Question 7

Where are a user's SSH keys stored?

A) `/etc/ssh/`

B) `~/.ssh/`

C) `/var/ssh/`

D) `/root/ssh/`

---

# Question 8

Which firewall is easy to use on Ubuntu?

A) `iptables`

B) `ufw`

C) `firewalld`

D) `firewall`

---

# Question 9

How do you copy a file over SSH?

A) `copy`

B) `scp`

C) `ssh-copy`

D) `transfer`

---

# Question 10

Which command resolves a domain name to an IP address?

A) `resolve`

B) `nslookup` or `dig`

C) `dns`

D) `lookup`

---

# Question 11

What does the CIDR /24 notation mean?

A) 24 machines on the network

B) Mask 255.255.255.0 (256 addresses)

C) 24 open ports

D) 24 subnets

---

# Question 12

Which SSH option creates a local tunnel (local forwarding)?

A) `-R`

B) `-L`

C) `-D`

D) `-T`

---

# Question 13

Which file contains DNS servers on Linux?

A) `/etc/dns.conf`

B) `/etc/resolv.conf`

C) `/etc/network/dns`

D) `/etc/dns/servers`

---

# Question 14

Which command synchronizes files over SSH with resume support?

A) `scp`

B) `sftp`

C) `rsync`

D) `ssh-sync`

---

# Question 15

Which SSH key algorithm is recommended in 2026?

A) RSA 1024

B) DSA

C) Ed25519

D) ECDSA 256

---

# Question 16

What does the `traceroute` command do?

A) Tests connection speed

B) Shows the network path to a host

C) Lists network interfaces

D) Scans open ports

---

# Question 17

Which tool configures networking on modern Ubuntu (22.04+)?

A) ifconfig

B) network-scripts

C) Netplan

D) wicked

---

# Question 18

Which file lets you define local DNS aliases?

A) `/etc/hosts`

B) `/etc/aliases`

C) `/etc/dns/local`

D) `/etc/hostname`

---

# Question 19

What is the range of well-known ports?

A) 1-100

B) 0-1023

C) 1024-49151

D) 49152-65535

---

# Question 20

Which service automatically assigns IP addresses to clients?

A) DNS

B) NAT

C) DHCP

D) ARP

---

# Module 7 answers 📝 (1/4)

**Answer 1:** B) `127.0.0.1`
- The entire 127.0.0.0/8 range is reserved for loopback

**Answer 2:** B) 22
- Port 22 = SSH, Port 21 = FTP, Port 23 = Telnet, Port 80 = HTTP

**Answer 3:** B) `ping`
- `ping google.com` tests whether the server is reachable

**Answer 4:** D) Both B and C are correct
- `ip addr` is modern; `ifconfig` is legacy but still used

**Answer 5:** B) `netstat` or `ss`
- `ss` is the modern replacement for `netstat`

---

# Module 7 answers 📝 (2/4)

**Answer 6:** B) `ssh-keygen`
- `ssh-keygen -t ed25519` is recommended in 2026

**Answer 7:** B) `~/.ssh/`
- Each user's home directory

**Answer 8:** B) `ufw`
- ufw = Uncomplicated Firewall (simple interface for iptables)

**Answer 9:** B) `scp`
- `scp file user@server:/path/`

**Answer 10:** B) `nslookup` or `dig`
- `dig` is more modern and detailed

---

# Module 7 answers 📝 (3/4)

**Answer 11:** B) Mask 255.255.255.0 (256 addresses)
- /24 means 24 bits for the network, 8 bits for hosts (2^8 = 256)

**Answer 12:** B) `-L`
- `-L` = local forwarding (bring a remote port to local)
- `-R` = remote forwarding, `-D` = dynamic (SOCKS proxy)

**Answer 13:** B) `/etc/resolv.conf`
- Contains DNS servers with `nameserver 8.8.8.8`

**Answer 14:** C) `rsync`
- `rsync -avz` synchronizes with compression and resume on interruption

**Answer 15:** C) Ed25519
- Ed25519 is the most modern, secure, and performant. RSA 4096 remains acceptable.

---

# Module 7 answers 📝 (4/4)

**Answer 16:** B) Shows the network path to a host
- Shows each router hop between you and the destination

**Answer 17:** C) Netplan
- Netplan is the standard tool on Ubuntu 18.04+ for network configuration

**Answer 18:** A) `/etc/hosts`
- Lets you define local name → IP mappings

**Answer 19:** B) 0-1023
- Well-known ports (reserved for system services), require root

**Answer 20:** C) DHCP
- Dynamic Host Configuration Protocol: automatic assignment of IP, mask, gateway, DNS

---

# Module 7 score 📊

Count your correct answers:

- **18-20**: Networking expert! ⭐⭐⭐
- **14-17**: Very good! ⭐⭐
- **10-13**: Good, needs consolidation ⭐
- **< 10**: Reread module 7
