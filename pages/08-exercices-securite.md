---

# 🎯 Hands-on exercises - Module 4

**System security**

---

# Exercise 1: Permission audit 🔍

**Goal:** Find risky files

**Instructions:**

1. Find all world-writable files
2. Find all SUID files
3. Find all SGID files
4. Find files with no owner
5. Generate a report
6. Fix critical issues

---

# Exercise 1 solution 💡

```bash
#!/bin/bash
# Security audit of file permissions

REPORT="/tmp/security_audit_$(date +%Y%m%d).txt"

echo "===== SECURITY AUDIT =====" > $REPORT
echo "Date: $(date)" >> $REPORT
echo >> $REPORT

# 1. World-writable files
echo "🔓 WORLD-WRITABLE FILES:" >> $REPORT
find / -type f -perm -002 ! -path "/proc/*" ! -path "/sys/*" \
    2>/dev/null | tee -a $REPORT
echo >> $REPORT

# 2. SUID files
echo "⚠️  SUID FILES:" >> $REPORT
find / -type f -perm -4000 2>/dev/null | tee -a $REPORT
echo >> $REPORT

# 3. SGID files
echo "⚠️  SGID FILES:" >> $REPORT
find / -type f -perm -2000 2>/dev/null | tee -a $REPORT
echo >> $REPORT

# 4. Files with no owner
echo "❓ ORPHAN FILES:" >> $REPORT
find / \( -nouser -o -nogroup \) ! -path "/proc/*" ! -path "/sys/*" \
    2>/dev/null | tee -a $REPORT
echo >> $REPORT

# Check /etc/passwd
echo "👤 SYSTEM ACCOUNTS:" >> $REPORT
awk -F: '$3 == 0 {print $1}' /etc/passwd | tee -a $REPORT
echo >> $REPORT

cat $REPORT

# 6. Fixes
echo "Recommended fixes..."

# Remove world-writable (example)
# find / -type f -perm -002 -exec chmod o-w {} \; 2>/dev/null
```

---

# Exercise 2: Audit with auditd 📝

**Prerequisite:** `auditd` is **not** installed by default on Ubuntu Server - install it in step 1.

**Goal:** Monitor system actions

**Instructions:**

1. Install auditd
2. Watch changes to `/etc/passwd`
3. Watch sudo commands
4. Generate events
5. Review reports
6. Search for specific events

---

# Exercise 2 solution 💡

```bash
# 1. Install
sudo apt install auditd audispd-plugins -y

# 2. Rule for /etc/passwd
sudo auditctl -w /etc/passwd -p wa -k passwd_changes

# 3. Rule for sudo command execution
sudo auditctl -a always,exit -F arch=b64 -S execve -F path=/usr/bin/sudo -k sudo_commands

# Also watch sudoers config changes
sudo auditctl -w /etc/sudoers -p wa -k sudoers_changes
sudo auditctl -w /etc/sudoers.d -p wa -k sudoers_changes

# View rules
sudo auditctl -l

# Make permanent
sudo tee /etc/audit/rules.d/custom.rules << 'EOF'
-w /etc/passwd -p wa -k passwd_changes
-w /etc/shadow -p wa -k shadow_changes
-a always,exit -F arch=b64 -S execve -F path=/usr/bin/sudo -k sudo_commands
-w /etc/sudoers -p wa -k sudoers_changes
-w /etc/sudoers.d -p wa -k sudoers_changes
EOF

# Load rules into the running audit daemon
sudo augenrules --load

# 4. Generate events
sudo useradd testuser
sudo userdel testuser
sudo cat /etc/shadow > /dev/null
sudo true

# 5. Review reports
sudo ausearch -k passwd_changes
sudo ausearch -k sudo_commands
sudo ausearch -k sudoers_changes

# By date
sudo ausearch -ts today

# 6. Specific search
sudo ausearch -ua $(whoami)
sudo ausearch -x /usr/bin/sudo

# Detailed report
sudo aureport --summary
sudo aureport --auth
sudo aureport --file
```

---

# Exercise 3: AppArmor (MAC) 🍎

**Prerequisite:** `aa-complain` / `aa-enforce` need `apparmor-utils` (step 3 installs it).

**Goal:** Same story as the in-class nginx lab - write a custom profile, block mode, log-only mode, logs.

**Instructions:**

1. Check AppArmor status (`aa-status`, `aa-enabled`)
2. Install nginx, create `/tmp/secret.html`, configure nginx to serve `/tmp/` on port 8080
3. Write a custom AppArmor profile for nginx that blocks `/tmp/`
4. Load the profile → `curl localhost:8080/secret.html` → **403** (enforce)
5. Switch to **log-only mode** (`aa-complain`) → `curl` → **200** (allowed but logged)
6. Switch back to **block mode** (`aa-enforce`) → `curl` → **403** again
7. **Bonus:** note how `aa-genprof` builds profiles for custom apps

---

# Exercise 3 solution 💡

```bash
# 1. Status
sudo aa-status
sudo aa-enabled

# 2. Install + setup
sudo apt install -y nginx apparmor-utils
echo "TOP SECRET DATA" | sudo tee /tmp/secret.html
# Create /etc/nginx/sites-enabled/secret.conf:
# server { listen 8080; root /tmp; location / { try_files $uri =404; } }
sudo nginx -t && sudo systemctl reload nginx
curl localhost:8080/secret.html    # → TOP SECRET DATA

# 3. Write profile (/etc/apparmor.d/usr.sbin.nginx) then load it
sudo apparmor_parser -r /etc/apparmor.d/usr.sbin.nginx

# 4. Enforce → blocked (restart — not reload — after first profile load)
sudo systemctl restart nginx
curl localhost:8080/secret.html    # → 403 Forbidden
sudo journalctl -k | grep DENIED

# 5. Complain → allowed but logged
sudo aa-complain /etc/apparmor.d/usr.sbin.nginx
sudo systemctl reload nginx
curl localhost:8080/secret.html    # → TOP SECRET DATA
sudo journalctl -k | grep ALLOWED

# 6. Back to enforce
sudo aa-enforce /etc/apparmor.d/usr.sbin.nginx
sudo systemctl reload nginx
curl localhost:8080/secret.html    # → 403 again
```

---

# Exercise 3 - bonus: read the profile

Look for path rules (`/var/www/html/** r,`), `capability`, and `deny` lines.

```bash
sudo less /etc/apparmor.d/usr.sbin.nginx
```

---

# Exercise 3 - bonus: custom apps

For your own binary, Ubuntu can **build a profile from logs**:

```bash
sudo aa-genprof /usr/bin/my-program
sudo aa-logprof
sudo systemctl reload apparmor
```

Not required for the exam - useful when you ship custom software.

---

# Exercise 3 - bonus: disable / re-enable a profile

```bash
# Disable
sudo ln -s /etc/apparmor.d/usr.sbin.nginx /etc/apparmor.d/disable/
sudo apparmor_parser -R /etc/apparmor.d/usr.sbin.nginx

# Re-enable
sudo rm /etc/apparmor.d/disable/usr.sbin.nginx
sudo apparmor_parser -r /etc/apparmor.d/usr.sbin.nginx
```

---

# Key takeaways 📌

**MAC (the module’s core):**
- AppArmor (Ubuntu): `aa-status`, enforce/complain, profiles
- MAC adds a layer on top of Unix permissions

**Audit:**
- Watch SUID/SGID and world-writable files
- `auditd` for traceability
