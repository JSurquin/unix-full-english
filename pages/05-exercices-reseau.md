---

# 🎯 Hands-on exercises – Module 5

**Network configuration and troubleshooting**

---

# Exercise 1: Basic network diagnostics 🔍

**Goal:** Diagnose connectivity

**Instructions:**

1. Display your IP address
2. Display the default gateway
3. Test connectivity to `8.8.8.8`
4. Test DNS resolution for `google.com`
5. Trace the route to `cloudflare.com`
6. Show active connections

---

# Solution Exercise 1 💡

```bash
# 1. IP address
ip addr show
# or
hostname -I
# or
ifconfig  # old - apt install net-tools if needed

# 2. Gateway
ip route show default
# or
route -n | grep ^0.0.0.0

# 3. Connectivity test
ping -c 4 8.8.8.8

# 4. DNS test
ping -c 4 google.com
# or
nslookup google.com
# or
dig google.com +short

# 5. Trace route
tracepath cloudflare.com          # default on Ubuntu (iputils-tracepath)
# or: sudo apt install traceroute && traceroute cloudflare.com

# 6. Active connections
ss -tunap
# old (optional): sudo apt install net-tools && sudo netstat -tunap
```

---

# Exercise 2: SSH configuration 🔐

**Goal:** Configure and secure SSH

**Instructions:**

1. Generate an SSH key pair (ed25519)
2. Display your public key
3. Copy your key to `localhost` (test)
4. Connect without a password
5. Change SSH port to 2222 (config)
6. Disable password authentication

---

# Solution Exercise 2 💡

```bash
# 1. Generate keys
ssh-keygen -t ed25519 -C "you@example.com"
# Press Enter to accept defaults

# 2. Display public key
cat ~/.ssh/id_ed25519.pub

# 3. Copy to localhost
ssh-copy-id localhost
# or manually:
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 4. Passwordless login
ssh localhost

# 5 & 6. SSH server config (on remote server / lab VM)
sudo nano /etc/ssh/sshd_config

# Change:
# Port 2222
# PasswordAuthentication no
# PubkeyAuthentication yes
# PermitRootLogin no

# Test config
sudo sshd -t

# Restart (Ubuntu)
sudo systemctl restart ssh

# Connect on new port
ssh -p 2222 user@server
```

---

# Exercise 3: Firewall with UFW 🔥

**Goal:** Configure a simple firewall

**Instructions:**

1. Install UFW
2. Allow SSH (port 22) - **before** enabling!
3. Allow HTTP and HTTPS
4. Enable UFW
5. Show rules and test

**Optional (advanced):** block ping - needs editing `/etc/ufw/before.rules` (skip in class if short on time)

---

# Solution Exercise 3 💡

```bash
# 1. Install
sudo apt install ufw

# 2. Allow SSH (IMPORTANT: before enabling!)
sudo ufw allow 22/tcp
# or
sudo ufw allow ssh

# 3. HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
# or
sudo ufw allow 'Nginx Full'

# 4. Enable
sudo ufw enable

# 5. Show rules and test
sudo ufw status verbose
sudo ufw status numbered

# From another machine:
curl http://your_ip   # Should work

# --- Optional: block ping (advanced) ---
# sudo sed -i 's/-A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT/# &/' /etc/ufw/before.rules
# sudo ufw reload
# ping your_ip   # Would be blocked

# Delete a rule (by number)
sudo ufw delete 3

# Disable temporarily
sudo ufw disable
```

---

# Exercise 4: Secure file transfer 📤

**Goal:** Transfer files securely

**Instructions:**

1. Create a 10 MB test file
2. Transfer it to `/tmp` on localhost with `scp`
3. Transfer a full directory with `scp -r`
4. Sync a directory with `rsync`
5. Compare transfer times

---

# Solution Exercise 4 💡

```bash
# 1. Create test file
dd if=/dev/zero of=/tmp/test_10mb.bin bs=1M count=10

# 2. Transfer with scp
time scp /tmp/test_10mb.bin localhost:/tmp/test_copy.bin

# 3. Full directory
mkdir -p /tmp/source/{dir1,dir2,dir3}
touch /tmp/source/dir{1,2,3}/file{1..5}.txt
time scp -r /tmp/source localhost:/tmp/dest

# 4. Rsync (more efficient)
time rsync -avz /tmp/source/ localhost:/tmp/dest_rsync/

# Modify a file
echo "changed" >> /tmp/source/dir1/file1.txt

# Re-sync (only changes)
time rsync -avz /tmp/source/ localhost:/tmp/dest_rsync/

# 5. Compare — rsync is faster for updates!

# Rsync with progress
rsync -avz --progress /tmp/source/ localhost:/tmp/dest2/
```

---

# Exercise 5: Simple web server 🌐

**Goal:** Set up a basic web server

**Instructions:**

1. Install nginx
2. Create a simple HTML page
3. Configure a virtual host
4. Test with curl (and browser if available)
5. Add a `/etc/hosts` entry
6. Check access logs

---

# Solution Exercise 5 💡

```bash
# 1. Install nginx
sudo apt update
sudo apt install nginx

# 2. HTML page
sudo mkdir -p /var/www/mysite
sudo tee /var/www/mysite/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>My Site</title></head>
<body>
  <h1>Welcome to my site!</h1>
  <p>This is a test page.</p>
</body>
</html>
EOF

# 3. Virtual host
sudo tee /etc/nginx/sites-available/mysite << 'EOF'
server {
    listen 80;
    server_name mysite.local;
    root /var/www/mysite;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

# Enable
sudo ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# 5. /etc/hosts
echo "127.0.0.1 mysite.local" | sudo tee -a /etc/hosts

# 4. Test
curl http://mysite.local

# 6. Logs
sudo tail -f /var/log/nginx/access.log
```

---

# Exercise 6: Static IP with Netplan 🔧

**Goal:** Configure a fixed IP on your Ubuntu VM

**Instructions:**

1. Identify your network interface name
2. Back up the current Netplan configuration
3. Note your current network settings (IP, gateway, DNS)
4. Create a static IP configuration
5. Test with `netplan try` (auto undo if network breaks)
6. Verify everything works

---

# Solution Exercise 6 (1/3) 💡

```bash
# 1. Identify network interface
ip -br link
# Typical VM result:
# lo        UNKNOWN   00:00:00:00:00:00
# enp0s1    UP        4e:bc:9c:xx:xx:xx   ← QEMU/KVM (lab VMs)
# enp0s3    UP        08:00:27:xx:xx:xx   ← VirtualBox
# ens33     UP        00:0c:29:xx:xx:xx   ← VMware

# Note the name: enp0s1, enp0s3, ens33, or other

# 2. Back up current config
sudo cp /etc/netplan/*.yaml ~/netplan-backup.yaml
cat ~/netplan-backup.yaml
```

---

# Solution Exercise 6 (2/3) 💡

```bash
# 3. Note current configuration
ip addr show          # Your current IP
ip route show default # Your gateway
cat /etc/resolv.conf  # Your DNS

# 4. Create new configuration
sudo nano /etc/netplan/01-static.yaml
```

```yaml
# File contents
# IMPORTANT: Replace "enp0s1" with YOUR interface name!
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s1:
      dhcp4: false
      addresses:
        - 192.168.1.150/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
```

---

# Solution Exercise 6 (3/3) 💡

```bash
# 5. Test BEFORE applying permanently
sudo netplan try
# You have 120 seconds to test
# If it works: press Enter
# If not: wait; it rolls back automatically!

# 6. Verify
ip addr show enp0s1      # New IP? (your interface name)
ip route show default    # Correct gateway?
ping -c 2 8.8.8.8        # Internet OK?
ping -c 2 google.com     # DNS OK?

# If all OK, apply permanently
sudo netplan apply

# To go back to DHCP:
# Set dhcp4: true and remove addresses/routes/nameservers
```

---

# Exercise 7: Local DNS configuration 🌐

**Goal:** Master name resolution with `/etc/hosts`

**Instructions:**

1. Display your current DNS servers
2. Create an alias "myvm" for your own IP (127.0.0.1)
3. Create an alias "gateway" for your default gateway
4. Test these aliases with `ping`
5. Block a site (redirect to localhost)
6. Compare `ping` vs `dig` behavior
7. Clean up your changes

---

# Solution Exercise 7 (1/3) 💡

```bash
# 1. View current DNS
cat /etc/resolv.conf
# or with systemd-resolved (modern Ubuntu)
resolvectl status

# 2. Create alias for localhost
echo "127.0.0.1    myvm myvm.local" | sudo tee -a /etc/hosts

# Test
ping -c 2 myvm
# PING myvm (127.0.0.1) → works!

# 3. Create alias for gateway
# First find gateway IP
ip route show default
# default via 192.168.1.1 dev enp0s1

echo "192.168.1.1    gateway router box" | sudo tee -a /etc/hosts

# Test
ping -c 2 gateway
ping -c 2 router
```

---

# Solution Exercise 7 (2/3) 💡

```bash
# 5. Block a site (example: twitter.com)
echo "127.0.0.1    twitter.com www.twitter.com" | sudo tee -a /etc/hosts

# Test
ping -c 2 twitter.com
# PING twitter.com (127.0.0.1) → redirected to localhost!

# In a browser, twitter.com will no longer work!

# ping uses /etc/hosts first, then DNS
ping -c 1 twitter.com
# → 127.0.0.1 (from /etc/hosts)

# dig asks DNS only - ignores /etc/hosts
dig twitter.com +short
# → Twitter's real IP
```

---

# Solution Exercise 7 (3/3) 💡

```bash
# 7. Clean up changes
# See what was added
tail -5 /etc/hosts

# Remove added lines
sudo sed -i '/myvm/d' /etc/hosts
sudo sed -i '/gateway/d' /etc/hosts
sudo sed -i '/twitter/d' /etc/hosts

# Verify
cat /etc/hosts

# Twitter works again!
ping -c 1 twitter.com
# → Real IP now
```

---

**💡 Real-world uses of `/etc/hosts`:**

- 🧪 Test a site in dev before changing DNS
- 🚫 Block ads or unwanted sites
- 🏠 Give friendly names to local machines
- 🔧 Temporarily work around DNS issues

---

# Bonus exercise: Network monitoring script 📊

**Goal:** Monitor connectivity

**Create a script that:**
- Tests connectivity to several servers
- Measures latency
- Logs results
- Alerts on failure

---

# Bonus exercise - solution 💡

```bash
#!/bin/bash
# Network monitoring script

SERVERS=("8.8.8.8" "1.1.1.1" "google.com" "github.com")
LOG_FILE="/var/log/network_monitor.log"
ALERT_THRESHOLD=200  # ms

echo "===== Monitoring $(date) =====" | tee -a $LOG_FILE

for server in "${SERVERS[@]}"; do
    echo -n "Testing $server... " | tee -a $LOG_FILE

    result=$(ping -c 3 -W 2 $server 2>/dev/null | grep "avg" | \
             awk -F'/' '{print $5}')

    if [ -z "$result" ]; then
        echo "❌ FAILED" | tee -a $LOG_FILE
        logger -t NET_MONITOR "ALERT: $server unreachable"
    else
        latency=${result%.*}
        echo "✅ OK (${latency}ms)" | tee -a $LOG_FILE

        if [ $latency -gt $ALERT_THRESHOLD ]; then
            echo "  ⚠️  High latency!" | tee -a $LOG_FILE
            logger -t NET_MONITOR "WARNING: $server latency ${latency}ms"
        fi
    fi

    sleep 1
done

echo "============================" | tee -a $LOG_FILE
```

---

**Automate with cron:**

```bash
# Every 5 minutes
*/5 * * * * /usr/local/bin/network_monitor.sh
```

---

### Key takeaways 📌

<div class="text-xs">

**Diagnostics:**
- `ping`: connectivity
- `tracepath` / `traceroute`: path
- `dig`: DNS
- `ss` (best) / `netstat` (old): connections

**Firewall:**
- UFW for simplicity
- `allow`/`deny` for rules
- Always allow SSH before enabling!

**SSH:**
- Public/private key pairs
- `ssh-keygen`, `ssh-copy-id`
- Config in `/etc/ssh/sshd_config`

</div>

---

### Key takeaways (continued) 📌

<div class="text-xs">

**Netplan (Ubuntu):**
- YAML files in `/etc/netplan/`
- `netplan try` = test with auto undo
- `netplan apply` = apply permanently
- Watch YAML indentation!

**Local DNS:**
- `/etc/hosts` = names on **this machine first**
- `/etc/resolv.conf` = which DNS servers to ask
- `dig` = DNS only ; `ping` = hosts file + DNS

**Netplan tip:**
- `/24` after the IP = normal lab network (e.g. `192.168.1.100/24`)

</div>
