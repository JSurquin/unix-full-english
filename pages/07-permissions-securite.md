---
layout: intro
routeAlias: 'permissions-securite'
---

# Permissions and Security 🔒

### Advanced permission and system security management

<div class="pt-12">
  <span @click="next" class="px-2 p-3 rounded cursor-pointer hover:bg-white hover:bg-opacity-10 neon-border">
    Let's secure the system together <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: default
---

# Unix permission system 🔐

### Understanding basic permissions

**Permission structure:**
```bash
-rw-r--r-- 1 user group 1234 Jan 1 12:00 file
# Type | Owner | Group | Others
```

**Permission types:**
- **r** (read): read (4)
- **w** (write): write (2)
- **x** (execute): execute (1)

**For files:**
- **r**: read content
- **w**: modify content
- **x**: execute the file

**For directories:**
- **r**: list contents
- **w**: create/delete files
- **x**: enter the directory

---
layout: default
---

# Special permissions 🎯

### Advanced system permissions

**SUID (Set User ID)**
```bash
chmod u+s file              # SUID on owner
chmod 4755 file             # SUID with mode 755
# File runs with the owner's privileges
```

**SGID (Set Group ID)**
```bash
chmod g+s directory           # SGID on group
chmod 2755 directory          # SGID with mode 755
# New files inherit the directory's group
```

**Sticky Bit**
```bash
chmod +t directory            # Sticky bit
chmod 1755 directory          # Sticky bit with mode 755
# Only the owner can delete their files
```

---
layout: default
---

# Permission management commands 🔧

### Changing permissions

**chmod (change mode)**
```bash
chmod 755 file              # Numeric permissions
chmod u+x,g-w,o=r file      # Symbolic permissions
chmod +x script.sh             # Add execute
chmod -w file.txt           # Remove write
chmod -R 755 directory/       # Recursive
```

**chown (change owner)**
```bash
chown user file             # Change owner
chown user:group file       # Owner and group
chown -R user directory/      # Recursive
chown --reference=source dest  # Copy from reference file
```

**chgrp (change group)**
```bash
chgrp group file           # Change group
chgrp -R group directory/    # Recursive
```

---
layout: default
---

# ACL (Access Control Lists) 📋

### Fine-grained advanced permissions

**Installing ACL**
```bash
sudo apt install acl           # Install ACL support
sudo mount -o acl /dev/sda1 /  # Mount with ACL
```

**ACL commands**
```bash
setfacl -m u:user:rwx file  # Grant user permissions
setfacl -m g:group:r-x file # Grant group permissions
setfacl -x u:user file      # Remove ACL for user
setfacl -b file             # Remove all ACLs
getfacl file                 # Display ACLs
```

**Usage examples**
```bash
# Grant read to a specific user
setfacl -m u:john:r file.txt

# Grant write to a group
setfacl -m g:developers:rw directory/

# Default ACL for new files
setfacl -m d:u:john:rwx directory/
```

---
layout: default
---

# Password security 🔑

### Security policies

**Configuration in /etc/login.defs**
```bash
# Password policy
PASS_MAX_DAYS 90              # Expire after 90 days
PASS_MIN_DAYS 1               # Min 1 day between changes
PASS_WARN_AGE 7               # Warn 7 days before
PASS_MIN_LEN 8                # Minimum length 8 characters
PASS_CHANGE_TRIES 3           # Change attempts
```

**PAM configuration**
```bash
# /etc/pam.d/common-password
password requisite pam_pwquality.so retry=3 minlen=8 difok=3
password requisite pam_unix.so sha512 shadow nullok
```

**Verification tools**
```bash
pwscore password           # Password quality score
cracklib-check password    # cracklib check
```

---
layout: default
---

# Firewall and network security 🛡️

### Firewall configuration

**ufw (Uncomplicated Firewall)**
```bash
sudo ufw enable                 # Enable firewall
sudo ufw disable                # Disable firewall
sudo ufw status                 # Firewall status
sudo ufw default deny incoming  # Deny incoming by default
sudo ufw default allow outgoing # Allow outgoing by default
```

**ufw rules**
```bash
sudo ufw allow ssh              # Allow SSH
sudo ufw allow 80/tcp           # Allow HTTP
sudo ufw allow 443/tcp          # Allow HTTPS
sudo ufw deny 22                # Deny SSH
sudo ufw allow from 192.168.1.0/24  # Allow a network
```

**iptables (advanced firewall)**
```bash
sudo iptables -L               # List rules
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT  # Allow HTTP
sudo iptables -A INPUT -p tcp --dport 22 -j DROP    # Deny SSH
```

---
layout: default
---

# Service security 🔧

### Hardening system services

**systemctl and security**
```bash
systemctl mask service          # Mask service (prevent start)
systemctl unmask service        # Unmask service
systemctl disable service       # Disable at boot
systemctl enable service        # Enable at boot
```

**Service configuration**
```bash
# /etc/systemd/system/service.service
[Unit]
Description=My Service
After=network.target

[Service]
Type=simple
User=service_user
Group=service_group
ExecStart=/path/to/service
Restart=always

[Install]
WantedBy=multi-user.target
```

**SSH hardening**
```bash
# /etc/ssh/sshd_config
Port 2222                       # Change port
PermitRootLogin no              # Disable root login
PasswordAuthentication no        # Disable passwords
PubkeyAuthentication yes        # Enable keys
AllowUsers user1 user2          # Allowed users
```

---
layout: default
---

# Audit and monitoring 📊

### Monitoring system security

**auditd (audit subsystem)**
```bash
sudo apt install auditd        # Install auditd
sudo systemctl enable auditd   # Enable at boot
sudo systemctl start auditd    # Start service
```

**Audit rules**
```bash
# Monitor access to sensitive files
auditctl -w /etc/passwd -p wa -k passwd_changes
auditctl -w /etc/shadow -p wa -k shadow_changes
auditctl -w /etc/sudoers -p wa -k sudoers_changes

# Monitor connections
auditctl -w /var/log/auth.log -p wa -k auth_changes
```

**Reviewing audit logs**
```bash
ausearch -k passwd_changes      # Search by key
ausearch -f /etc/passwd         # Search by file
aureport --summary              # Summary report
```

---
layout: default
---

# Encryption and integrity 🔐

### Protecting data

**Disk encryption**
```bash
# LUKS encryption
sudo cryptsetup luksFormat /dev/sda1
sudo cryptsetup luksOpen /dev/sda1 encrypted_disk
sudo mkfs.ext4 /dev/mapper/encrypted_disk
sudo mount /dev/mapper/encrypted_disk /mnt
```

**File encryption**
```bash
# GPG for files
gpg -c file.txt              # Encrypt with passphrase
gpg -e -r recipient file.txt  # Encrypt for recipient
gpg -d file.txt.gpg          # Decrypt
```

**Integrity verification**
```bash
# Compute checksums
md5sum file                  # MD5 (legacy)
sha256sum file               # SHA256 (recommended)
sha512sum file               # SHA512 (strong)

# Verify integrity
echo "checksum file" | sha256sum -c
```

---
layout: default
---

# Container security 🐳

### Hardening Docker

**Docker with security**
```bash
# Run container non-privileged
docker run --user 1000:1000 image

# Drop capabilities
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE image

# Read-only mount
docker run -v /host/path:/container/path:ro image
```

**Secure Dockerfile**
```dockerfile
# Use non-root user
FROM ubuntu:20.04
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser
WORKDIR /app
COPY --chown=appuser:appuser . .
```

**Security scanning**
```bash
# Scan image for vulnerabilities
docker scan image_name
trivy image image_name
```

---
layout: default
---

# Web application security 🌐

### Hardening web services

**Apache with security**
```apache
# /etc/apache2/sites-available/secure-site.conf
<VirtualHost *:80>
    ServerName example.com
    DocumentRoot /var/www/html
    
    # Hide server information
    ServerTokens Prod
    ServerSignature Off
    
    # Security headers
    Header always set X-Content-Type-Options nosniff
    Header always set X-Frame-Options DENY
    Header always set X-XSS-Protection "1; mode=block"
    
    # Limit HTTP methods
    <LimitExcept GET POST>
        Deny from all
    </LimitExcept>
</VirtualHost>
```

**Nginx with security**
```nginx
# /etc/nginx/sites-available/secure-site
server {
    listen 80;
    server_name example.com;
    
    # Security headers
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";
    
    # Limit request body size
    client_max_body_size 10M;
}
```

---
layout: default
---

# Security monitoring 📈

### Real-time monitoring

**Security logs**
```bash
# Follow authentication log
tail -f /var/log/auth.log

# Monitor failed SSH logins
grep "Failed password" /var/log/auth.log

# Monitor sudo usage
grep "sudo:" /var/log/auth.log
```

**Monitoring tools**
```bash
# fail2ban to block attacks
sudo apt install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# fail2ban configuration
sudo nano /etc/fail2ban/jail.local
```

**Security alerts**
```bash
# Monitoring script
#!/bin/bash
# Check for suspicious SSH connections
grep "Failed password" /var/log/auth.log | \
  awk '{print $1,$2,$3}' | \
  sort | uniq -c | \
  awk '$1 > 5 {print "ALERT: Too many failed attempts for " $2 " " $3 " " $4}'
```

---
layout: default
---

# Secure backups 💾

### Secure backup strategies

**Encrypted backup**
```bash
# Backup with encryption
tar -czf - /path/to/backup | \
  gpg -e -r backup@example.com > backup_$(date +%Y%m%d).tar.gz.gpg

# Secure incremental backup
rsync -av --delete --chmod=600 \
  --exclude='*.tmp' \
  /source/ /destination/
```

**Backup rotation**
```bash
# Rotation script
#!/bin/bash
# Keep 7 daily, 4 weekly, 12 monthly backups
find /backup/daily -name "*.tar.gz" -mtime +7 -delete
find /backup/weekly -name "*.tar.gz" -mtime +28 -delete
find /backup/monthly -name "*.tar.gz" -mtime +365 -delete
```

**Verify backups**
```bash
# Test restore
tar -tzf backup.tar.gz | head -10
gpg -d backup.tar.gz.gpg | tar -tz | head -10
```

---
layout: default
---

# Hands-on exercises 🎯

### Security practice

**Exercise 1: Advanced permissions**
```bash
# Create secure shared directory
sudo mkdir /shared
sudo chown root:developers /shared
sudo chmod 775 /shared
sudo chmod g+s /shared

# Test permissions
touch /shared/test.txt
ls -la /shared/
```

**Exercise 2: ufw configuration**
```bash
# Basic firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw enable
sudo ufw status
```

**Exercise 3: Security audit**
```bash
# Check sensitive permissions
find /etc -perm -4000 -ls
find /etc -perm -2000 -ls
find /etc -perm -1000 -ls

# Files with no owner/group
find / -nouser -ls
find / -nogroup -ls
```

---
layout: default
---

# Best practices 💡

### Security tips

**Core principles**
- Least privilege
- Defense in depth
- Continuous monitoring
- Regular updates
- Secure backups

**Network security**
- Use firewalls
- Encrypt communications
- Limit exposed services
- Monitor network traffic
- Use VPNs

**System security**
- Disable unnecessary services
- Use strong passwords
- Restrict root access
- Monitor logs
- Keep systems patched

---
layout: default
---

# Next steps 🎯

### What's ahead

1. **Processes and services**
2. **Networking and connectivity**
3. **Software packages** and management
4. **Shell scripting** basics
5. **Virtualization** and containers

**Preparation:**
- Try advanced permissions
- Configure a basic firewall
- Get comfortable with ACLs
- Practice security monitoring
