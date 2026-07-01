---

# 🎯 Hands-on exercises - Module 3

**Package management and maintenance**

---

# Exercise 1: Basic apt usage 📦

**Goal:** Master apt

**Instructions:**

1. Refresh the package list
2. Search for the `htop` package
3. Show detailed info for `htop`
4. Install `htop` and `tree`
5. List installed packages containing "net"
6. Upgrade all packages

---

# Solution Exercise 1 💡

```bash
# 1. Refresh index
sudo apt update

# 2. Search htop
apt search htop

# 3. Details
apt show htop

# 4. Install
sudo apt install htop tree -y

# 5. Installed packages with "net"
apt list --installed | grep net

# 6. Full upgrade
sudo apt upgrade -y
# or full distribution upgrade
sudo apt full-upgrade -y

# Verify
htop
tree /etc
```

---

# Exercise 2: Cleanup and maintenance 🧹

**Goal:** Clean the system

**Instructions:**

1. Show disk used by apt cache
2. Clear the cache
3. Remove orphan packages
4. List packages that are no longer needed
5. Remove them
6. Check freed space

---

# Solution Exercise 2 💡

```bash
# 1. Cache size
du -sh /var/cache/apt/archives/

# 2. Clear cache
sudo apt clean
# Verify
du -sh /var/cache/apt/archives/

# 3 & 4 & 5. Orphans
# Preview
apt autoremove --dry-run

# Remove
sudo apt autoremove -y

# Full cleanup
sudo apt autoclean

# 6. Disk space
df -h /

# Full cleanup combo
sudo apt clean && sudo apt autoremove -y && sudo apt autoclean
```

---

# Exercise 3: Version management 🔢

**Goal:** Install specific versions

**Instructions:**

1. List available versions of `nginx`
2. Install a specific version
3. Hold the package to block upgrades
4. Try to upgrade (should skip held package)
5. Unhold the package
6. Remove without purging configuration

---

# Solution Exercise 3 💡

```bash
# 1. Available versions
apt-cache policy nginx

# 2. Install specific version (example)
sudo apt install nginx=1.18.0-0ubuntu1

# 3. Hold
sudo apt-mark hold nginx

# Verify
apt-mark showhold

# 4. Try upgrade
sudo apt upgrade
# nginx will NOT upgrade

# 5. Unhold
sudo apt-mark unhold nginx

# 6. Remove without purge
sudo apt remove nginx
# Config stays in /etc/nginx

# Full purge
sudo apt purge nginx
```

---

# Exercise 4: Adding PPAs 📚

**Goal:** Add third-party sources

**Instructions:**

1. Add the `git-core` PPA (latest Git)
2. Update and install git from that PPA
3. List all active PPAs
4. Remove the PPA
5. Return to the distro version

⚠️ **Note:** PPAs are Ubuntu/derivatives only

---

# Solution Exercise 4 💡

```bash
# 1. Add PPA
sudo add-apt-repository ppa:git-core/ppa -y

# 2. Update and install
sudo apt update
sudo apt install git -y

# Check version
git --version

# 3. List PPAs
grep -r "ppa.launchpad.net" /etc/apt/sources.list.d/

# 4. Remove PPA
sudo add-apt-repository --remove ppa:git-core/ppa -y

# 5. Back to official package
sudo apt update
sudo apt install --reinstall git -y

# Alternative: build from source
sudo apt install build-essential
wget https://github.com/git/git/archive/refs/tags/v2.43.0.tar.gz
tar -xzf v2.43.0.tar.gz
cd git-2.43.0
make prefix=/usr/local all
sudo make prefix=/usr/local install
```

---

# Exercise 5: Snap packages 📦

**Goal:** Use Snap

**Instructions:**

1. Install `snapd` if needed
2. Browse popular snaps
3. Install a snap (e.g. `hello-world`)
4. List installed snaps
5. Refresh snaps
6. Remove the snap

---

# Solution Exercise 5 💡

```bash
# 1. Install snapd
sudo apt install snapd -y

# 2. Search snaps
snap find "editor"
snap find "browser"

# 3. Install
sudo snap install hello-world

# Test
hello-world

# 4. List installed
snap list

# 5. Update
sudo snap refresh
# or one snap
sudo snap refresh hello-world

# 6. Remove
sudo snap remove hello-world

# Revisions
snap list --all

# Info
snap info firefox
```

---

# Bonus exercise: automatic update script 🤖

**Goal:** Automate updates

**Create a script that:**
- Refreshes the package list
- Applies upgrades
- Cleans automatically
- Sends an email report
- Logs all actions

---

# Bonus solution 💡

```bash
#!/bin/bash
# Automatic update script

LOG_FILE="/var/log/auto_update.log"
ADMIN_EMAIL="admin@example.com"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

log "===== Automatic update start ====="

# Refresh index
log "Updating package list..."
sudo apt update >> $LOG_FILE 2>&1

# Count upgrades
UPDATES=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
log "Upgrades available: $UPDATES"

if [ $UPDATES -gt 0 ]; then
    log "Installing upgrades..."
    sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y >> $LOG_FILE 2>&1
    
    if [ $? -eq 0 ]; then
        log "✅ Upgrades installed successfully"
    else
        log "❌ Upgrade error"
        echo "Update error on $(hostname)" | \
            mail -s "Update Error" $ADMIN_EMAIL
    fi
else
    log "System is up to date"
fi

# Cleanup
log "Cleaning..."
sudo apt autoremove -y >> $LOG_FILE 2>&1
sudo apt autoclean >> $LOG_FILE 2>&1

# Reboot required?
if [ -f /var/run/reboot-required ]; then
    log "⚠️  Reboot required"
    echo "Reboot required on $(hostname)" | \
        mail -s "Reboot Required" $ADMIN_EMAIL
fi

log "===== Automatic update end ====="
```

**Cron (Sundays 3am):**

```bash
0 3 * * 0 /usr/local/bin/auto_update.sh
```

---

### Key takeaways 📌

<div class="text-xs">

**APT:**
- `update`: refresh package index
- `upgrade`: install upgrades
- `install`: install a package
- `remove`/`purge`: uninstall

**Maintenance:**
- `autoremove`: remove orphans
- `clean`: clear cache
- `apt-mark hold`: pin version

**Alternatives:**
- Snap: universal packages
- Flatpak: Snap alternative
- AppImage: portable apps

</div>
