---
layout: new-section
routeAlias: 'exercices-pratiques'
---

<a name="exercices-pratiques" id="exercices-pratiques"></a>

# 🎯 Practical exercises
## Applying what you learned

### Practice with realistic scenarios

---

# How to approach the exercises? 📝

**Tips:**

1. **Read** the instructions carefully
2. **Break down** the problem
3. **Test** commands in a safe environment
4. **Document** your approach
5. **Use `man` and `--help`** when unsure

**Recommended environment:**
- Virtual machine (VirtualBox, VMware)
- Docker container
- WSL on Windows
- Raspberry Pi

---

# Exercise 1: Navigation and files 📁

**Goal:** Master basic commands

**Tasks:**

1. Create the following layout:

```
projet/
├── src/
│   ├── main.sh
│   └── utils.sh
├── docs/
│   └── README.md
└── tests/
    └── test_main.sh
```

2. Create three text files with content
3. Find all `.sh` files
4. Show the last 10 lines of `main.sh`
5. Count lines across all files

---

# Exercise 1: Solution 💡

```bash
# 1. Create layout
mkdir -p projet/{src,docs,tests}
touch projet/src/{main,utils}.sh
touch projet/docs/README.md
touch projet/tests/test_main.sh

# 2. Add content
echo 'echo "Hello"' > projet/src/main.sh
echo 'helper() { :; }' > projet/src/utils.sh
echo "# Documentation" > projet/docs/README.md

# 3. Find .sh files
find projet -name "*.sh"

# 4. Last lines
tail projet/src/main.sh

# 5. Line count
find projet -type f -exec wc -l {} + | tail -1
```

---

# Exercise 2: Users and permissions 👥

**Goal:** Manage users and permissions

**Tasks:**

1. Create three users: `dev1`, `dev2`, `admin`
2. Create a group `developers`
3. Add `dev1` and `dev2` to the group
4. Create `/shared` with group access for `developers`
5. Set permissions: `rwxrwx---`
6. Test access as each user

---

# Exercise 2: Solution 💡

```bash
# 1. Create users
sudo useradd -m -s /bin/bash dev1
sudo useradd -m -s /bin/bash dev2
sudo useradd -m -s /bin/bash admin
echo "dev1:password1" | sudo chpasswd
echo "dev2:password2" | sudo chpasswd
echo "admin:password3" | sudo chpasswd

# 2. Create group
sudo groupadd developers

# 3. Add to group
sudo usermod -aG developers dev1
sudo usermod -aG developers dev2
```

---

# Exercise 2: Solution (continued) 💡

```bash
# 4. Shared directory
sudo mkdir /shared
sudo chown root:developers /shared

# 5. Permissions
sudo chmod 770 /shared

# 6. Test
su - dev1
touch /shared/test1.txt    # Should succeed
exit

su - admin
touch /shared/test2.txt    # Should fail (not in group)
exit
```

---

# Exercise 3: Process management ⚙️

**Goal:** Understand and manage processes

**Tasks:**

1. Start a long-running process in the background
2. Find its PID
3. Change its priority (nice)
4. Watch its CPU/memory usage
5. Stop and resume the process
6. Terminate it cleanly

**Suggested process:**

```bash
sleep 300 &
```

---

# Exercise 3: Solution 💡

```bash
# 1. Background
sleep 300 &

# 2. Find PID
jobs
pgrep sleep
ps aux | grep sleep

# 3. Change priority
PID=$(pgrep sleep)
sudo renice 10 -p $PID

# 4. Monitor
top -p $PID
# or
htop  # then locate the process
```

---

# Exercise 3: Solution (continued) 💡

```bash
# 5. Stop and resume
kill -STOP $PID
ps aux | grep sleep  # State T
kill -CONT $PID
ps aux | grep sleep  # State S or R

# 6. Clean termination
kill $PID
# Verify
ps aux | grep sleep

# If still running, force
kill -9 $PID
```

---

# Exercise 4: Disks and partitions 💾

**Goal:** Manage storage

**Tasks:**

1. Create a 100 MB disk image file
2. Create a partition on it (optional; may use whole file)
3. Format as ext4
4. Mount at `/mnt/test`
5. Create files on it
6. Check usage
7. Unmount cleanly

**⚠️ Do this in a VM!**

---

# Exercise 4: Solution 💡

```bash
# 1. Create image file
dd if=/dev/zero of=disk.img bs=1M count=100

# 2. Partition (or use file directly for this lab)

# 3. Format
sudo mkfs.ext4 disk.img

# 4. Mount point and mount
sudo mkdir -p /mnt/test
sudo mount -o loop disk.img /mnt/test
```

---

# Exercise 4: Solution (continued) 💡

```bash
# 5. Create files
sudo touch /mnt/test/file{1..5}.txt
echo "Test content" | sudo tee /mnt/test/file1.txt

# 6. Check usage
df -h /mnt/test
du -sh /mnt/test/*

# 7. Unmount
sudo umount /mnt/test

# Cleanup
rm disk.img
```

---

# Exercise 5: Network configuration 🌐

**Goal:** Configure and troubleshoot networking

**Tasks:**

1. Show current IP configuration
2. Identify the default gateway
3. Test connectivity to `8.8.8.8`
4. Resolve `google.com` to an address
5. Trace the route to `cloudflare.com`
6. List listening ports
7. Add an entry to `/etc/hosts`

---

# Exercise 5: Solution 💡

```bash
# 1. IP configuration
ip addr show
# or
ifconfig

# 2. Default gateway
ip route show default
# or
route -n

# 3. Connectivity
ping -c 4 8.8.8.8

# 4. DNS resolution
dig google.com +short
# or
nslookup google.com
```

---

# Exercise 5: Solution (continued) 💡

```bash
# 5. Traceroute
traceroute cloudflare.com
# or
traceroute -I cloudflare.com  # ICMP

# 6. Listening ports
sudo ss -tulnp
# or
sudo netstat -tulnp

# 7. hosts entry
echo "192.168.1.100  monserveur.local" | sudo tee -a /etc/hosts
ping monserveur.local
```

---

# Exercise 6: Backup script 💾

**Goal:** Write an automated backup script

**Requirements:**

1. Back up `/home/user/documents`
2. Name: `backup_YYYYMMDD_HHMMSS.tar.gz`
3. Destination: `/backup`
4. Delete backups older than 7 days
5. Log actions to a file
6. Send email on error

---

# Exercise 6: Solution 💡

```bash
#!/bin/bash
set -euo pipefail

# Configuration
SOURCE="/home/$USER/documents"
DESTINATION="/backup"
DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE="backup_${DATE}.tar.gz"
LOGFILE="/var/log/backup.log"

# Logging helper
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

# Preconditions
if [ ! -d "$SOURCE" ]; then
    log "ERROR: $SOURCE does not exist"
    exit 1
fi
```

---

# Exercise 6: Solution (continued) 💡

```bash
# Destination directory
mkdir -p "$DESTINATION"

# Backup
log "Starting backup of $SOURCE"
if tar -czf "${DESTINATION}/${ARCHIVE}" "$SOURCE" 2>&1 | tee -a "$LOGFILE"; then
    log "Backup successful: ${ARCHIVE}"
    SIZE=$(du -h "${DESTINATION}/${ARCHIVE}" | cut -f1)
    log "Size: $SIZE"
else
    log "ERROR during backup"
    echo "Backup error" | mail -s "Backup Failed" admin@example.com
    exit 1
fi

# Retention (> 7 days)
log "Removing old backups"
find "$DESTINATION" -name "backup_*.tar.gz" -mtime +7 -delete
log "Backup run finished"
```

---

# Exercise 6: Scheduling 📅

**Add to crontab for daily run at 2:00:**

```bash
# Edit crontab
crontab -e

# Add line
0 2 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1
```

**Or with a systemd timer:**

```bash
# /etc/systemd/system/backup.service
[Unit]
Description=Daily backup

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

```bash
# /etc/systemd/system/backup.timer
[Unit]
Description=Backup timer

[Timer]
OnCalendar=daily
OnCalendar=02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

---

# Exercise 7: Hardening SSH 🔒

**Goal:** Secure SSH access

**Tasks:**

1. Generate an SSH key pair
2. Copy the public key to the server
3. Disable password authentication
4. Change SSH port (2222)
5. Configure fail2ban for SSH
6. Test the connection

**⚠️ Do not lock yourself out!**

---

# Exercise 7: Solution 💡

```bash
# 1. Generate keys (on client)
ssh-keygen -t ed25519 -C "admin@example.com"

# 2. Copy public key
ssh-copy-id user@serveur
# or
ssh-copy-id -p 2222 user@serveur  # if port changed

# 3–4. SSH server config
sudo nano /etc/ssh/sshd_config
```

```
Port 2222
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

```bash
# Validate config
sudo sshd -t

# Restart SSH
sudo systemctl restart sshd
```

---

# Exercise 7: Solution (continued) 💡

```bash
# 5. fail2ban
sudo apt install fail2ban
sudo nano /etc/fail2ban/jail.local
```

```ini
[sshd]
enabled = true
port = 2222
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
```

```bash
sudo systemctl restart fail2ban

# 6. Test connection
ssh -p 2222 user@serveur
```

---

# Exercise 8: LEMP web server 🌐

**Goal:** Install a LEMP stack

**LEMP**: Linux + Nginx + MySQL + PHP

**Tasks:**

1. Install Nginx
2. Install MySQL/MariaDB
3. Install PHP-FPM
4. Create a virtual host
5. Create a database
6. Test with a PHP script

---

# Exercise 8: Solution 💡

```bash
# 1. Nginx
sudo apt update
sudo apt install nginx
sudo systemctl enable --now nginx

# 2. MariaDB
sudo apt install mariadb-server
sudo mysql_secure_installation

# 3. PHP-FPM
sudo apt install php-fpm php-mysql php-cli php-curl php-gd

# 4. Virtual host
sudo nano /etc/nginx/sites-available/mywebsite
```

---

# Exercise 8: Solution (continued) 💡

```nginx
server {
    listen 80;
    server_name mywebsite.local;
    root /var/www/mywebsite;
    index index.php index.html;

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/mywebsite /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

# Exercise 8: Solution (continued) 💡

```bash
# Create web root
sudo mkdir -p /var/www/mywebsite
sudo chown -R www-data:www-data /var/www/mywebsite

# 5. Database
sudo mysql
```

```sql
CREATE DATABASE mywebsite_db;
CREATE USER 'mywebsite_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON mywebsite_db.* TO 'mywebsite_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

---

# Exercise 8: Solution (continued) 💡

```bash
# 6. Test PHP script
sudo nano /var/www/mywebsite/test.php
```

```php
<?php
$conn = new mysqli('localhost', 'mywebsite_user', 'password', 'mywebsite_db');

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "Database connection OK!<br>";
echo "PHP version: " . phpversion();
?>
```

```bash
# Add to /etc/hosts
echo "127.0.0.1 mywebsite.local" | sudo tee -a /etc/hosts

# Test
curl http://mywebsite.local/test.php
```

---

# Exercise 9: System monitoring 📊

**Goal:** Write a monitoring script

**The script should check:**

1. CPU usage > 80%
2. Memory usage > 80%
3. Disk usage on `/` > 80%
4. Critical services running (nginx, mysql)
5. Send an alert if something fails

---

# Exercise 9: Solution 💡

```bash
#!/bin/bash
set -euo pipefail

ALERT_EMAIL="admin@example.com"
ALERT=false

# CPU
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "ALERT: CPU at ${CPU_USAGE}%"
    ALERT=true
fi

# Memory
MEM_USAGE=$(free | grep Mem | awk '{print ($3/$2) * 100.0}')
if (( $(echo "$MEM_USAGE > 80" | bc -l) )); then
    echo "ALERT: Memory at ${MEM_USAGE}%"
    ALERT=true
fi
```

---

# Exercise 9: Solution (continued) 💡

```bash
# Disk
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "ALERT: Disk at ${DISK_USAGE}%"
    ALERT=true
fi

# Services
for service in nginx mysql; do
    if ! systemctl is-active --quiet $service; then
        echo "ALERT: $service is stopped"
        ALERT=true
    fi
done

# Send alert
if [ "$ALERT" = true ]; then
    echo "Issue detected on $(hostname)" | \
        mail -s "Monitoring alert" $ALERT_EMAIL
fi
```

---

# Exercise 10: Full project 🎯

**Goal:** Deploy a complete application

**Scenario:**

Deploy a WordPress blog with:
- Nginx as web server
- MySQL for the database
- PHP-FPM
- SSL with Let's Encrypt
- Daily automated backups
- Monitoring
- Fail2ban

**Estimated time:** 2–3 hours

---

# Exercise 10: Steps 📋

1. **System prep**
   - Updates
   - Firewall
   - Dedicated user

2. **Install LEMP stack**
   - Nginx
   - MySQL
   - PHP-FPM

3. **WordPress**
   - Latest release
   - Database setup
   - File permissions

---

# Exercise 10: Steps (continued) 📋

4. **Nginx**
   - Virtual host
   - Let's Encrypt SSL
   - HTTP → HTTPS redirect

5. **Hardening**
   - fail2ban
   - SSH hardening
   - File permissions

6. **Automation**
   - Backup script
   - Daily cron
   - Monitoring script

---

# Exercise 10: Guided solution 💡

**Too long for one slide!**

**Resources:**
- WordPress documentation
- Nginx documentation
- DigitalOcean tutorials
- Linode guides

**Tips:**
- Document each step
- Test after every change
- Back up before major changes
- Use a VM for experiments

---

# Extra resources 📚

**Websites:**
- [Linux Journey](https://linuxjourney.com/)
- [OverTheWire](https://overthewire.org/wargames/) - practice games
- [Explain Shell](https://explainshell.com/) - command breakdown

**Books:**
- "The Linux Command Line" - William Shotts
- "UNIX and Linux System Administration Handbook"
- "Linux Bible"

**YouTube:**
- NetworkChuck
- LearnLinuxTV
- TechWorld with Nana

---

# Tips for practicing 💪

1. **Install Linux in a VM**
   - VirtualBox is free
   - Experiment safely

2. **Use WSL on Windows**
   - Daily practice

3. **Raspberry Pi**
   - Home server projects
   - Home automation

4. **Contribute to open source**
   - GitHub
   - Learn from others

---

# Certification and assessment 📜

**Next step:**
- Validation quiz
- Review acquired skills
- Identify areas to improve

**Certifications to consider:**
- LPIC-1 (Linux Professional Institute)
- CompTIA Linux+
- RHCSA (Red Hat)

**Keep learning:**
- Linux is a journey
- There is always more to explore
- The community is a great resource

---
layout: default
---

# Good luck with the exercises! 💪

Take your time, test, experiment!

You learn by doing.
