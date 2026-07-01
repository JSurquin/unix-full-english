---
layout: new-section
routeAlias: 'paquets-maintenance'
---

<a name="paquets-maintenance" id="paquets-maintenance"></a>

# 📦 Module 3
## Package management and maintenance

### Installing, updating, and maintaining software

---

# What is a package? 📦

**Package:** archive containing software and its metadata

**Analogy: IKEA furniture** 🪑

- **Package** = box with parts and instructions
- **Package manager** = tools to assemble
- **Repository** = IKEA store (package catalog)
- **Dependencies** = other items you need (shelves for some items)

**Package contents:**
- Binaries
- Configuration files
- Documentation
- Install/uninstall scripts
- Dependency list

---

# Linux packaging systems 📚

**Two main families:**

**Debian/Ubuntu (.deb)**
- Low-level: `dpkg`
- Frontends: `apt`, `apt-get`, `aptitude`
- Distros: Debian, Ubuntu, Mint, Pop!_OS

**Red Hat/Fedora (.rpm)**
- Low-level: `rpm`
- Frontend: `dnf` (legacy: `yum`)
- Distros: RHEL, CentOS, AlmaLinux, Rocky, Fedora

---

# Why package managers? 🤔

**Without a package manager:**
- Manual downloads
- Resolve dependencies by hand
- No automatic updates
- Conflict risk

**With a package manager:**
- One-command install
- Dependencies resolved automatically
- Centralized updates
- Clean uninstall

---

# APT: Advanced Package Tool 🔧

**apt:** manager for Debian/Ubuntu

**Essential commands:**

```bash
# Refresh package index
sudo apt update

# Upgrade installed packages
sudo apt upgrade

# Search for a package
apt search nginx

# Show package info
apt show nginx
```

---

# Installing packages with apt 📥

```bash
# Install a package
sudo apt install nginx

# Install several packages
sudo apt install nginx mysql-server php

# Install without confirmation
sudo apt install -y nginx

# Install a specific version
sudo apt install nginx=1.18.0-0ubuntu1

# Reinstall a package
sudo apt install --reinstall nginx
```

---

# Removing packages with apt 🗑️

```bash
# Remove package (keep config)
sudo apt remove nginx

# Remove with configuration
sudo apt purge nginx

# Remove unused dependencies
sudo apt autoremove

# Purge + autoremove
sudo apt purge nginx && sudo apt autoremove
```

---

# Updating the system with apt 🔄

```bash
# Refresh package index
sudo apt update

# Upgrade packages (without removing)
sudo apt upgrade

# Full upgrade (may remove packages)
sudo apt full-upgrade

# Distribution upgrade (release upgrade)
sudo apt dist-upgrade

# Classic combo
sudo apt update && sudo apt upgrade -y
```

---

# update vs upgrade 🔀

**apt update:** refreshes the **index** of available packages
- Like checking the store catalog
- Installs nothing
- Run before upgrade

**apt upgrade:** upgrades **installed** packages
- Like downloading new versions
- Actually applies updates
- Requires `update` first

---

**Analogy: Netflix** 📺

- **apt update** = Refresh the Netflix catalog
  - See what’s new
  - Downloads nothing
  - Fast (seconds)

- **apt upgrade** = Download episodes
  - Installs new versions
  - Can take time
  - Uses bandwidth

**Practical example:**

```bash
# Scenario: your web server
sudo apt update          # Check if new nginx is available
# → "nginx 1.20 available (you have 1.18)"

sudo apt upgrade -y      # Install nginx 1.20
# → Download, install, restart if needed
```

---

# Searching packages 🔍

```bash
# Simple search
apt search nginx

# Name-only search
apt search --names-only nginx

# List all available packages
apt list

# List installed packages
apt list --installed

# List upgradable packages
apt list --upgradable

# Detailed information
apt show nginx
```

---

# Dependencies 🔗

**Dependency:** package required for something to run

```bash
# Show package dependencies
apt depends nginx

# Reverse dependencies (who needs this package)
apt rdepends nginx

# Dry-run install (see what would be installed)
apt install --simulate nginx

# Install build dependencies without installing the package
sudo apt build-dep nginx
```

---

# APT repositories 📚

**Repositories:** package sources

**Main file: `/etc/apt/sources.list`**

```bash
cat /etc/apt/sources.list
```

```
deb http://fr.archive.ubuntu.com/ubuntu/ jammy main restricted
deb http://fr.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted
```

---

# APT source format 📝

```
deb http://archive.ubuntu.com/ubuntu/ jammy main
│   │                                  │     │
│   └── URL                            │     └── Components
│                                      └── Release codename
└── Type (deb = binary, deb-src = source)
```

**Ubuntu/Debian components:**
- **main:** supported free software
- **restricted:** supported proprietary software
- **universe:** community free software
- **multiverse:** non-free software

---

# Add a PPA (Ubuntu) ➕

**PPA:** Personal Package Archive

```bash
# Add a PPA
sudo add-apt-repository ppa:ondrej/php
sudo apt update

# Remove a PPA
sudo add-apt-repository --remove ppa:ondrej/php

# Or manually
sudo nano /etc/apt/sources.list.d/ondrej-ubuntu-php-jammy.list
```

**⚠️ Warning:** PPAs are unofficial-verify the source!

---

# Add an external repository 🌐

**Example: Docker**

```bash
# Prerequisites
sudo apt install ca-certificates curl gnupg

# Add GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add repository
echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update and install
sudo apt update
sudo apt install docker-ce
```

---

# Clean the APT system 🧹

```bash
# Remove downloaded packages
sudo apt clean

# Remove old downloaded packages
sudo apt autoclean

# Remove unused dependencies
sudo apt autoremove

# Full cleanup combo
sudo apt autoremove --purge && sudo apt clean
```

---

# dpkg: low-level manager 🔩

**dpkg:** direct management of .deb packages

```bash
# Install a .deb
sudo dpkg -i package.deb

# If dependencies are missing
sudo apt install -f

# List installed packages
dpkg -l

# List files owned by a package
dpkg -L nginx

# Find which package owns a file
dpkg -S /usr/sbin/nginx
```

---

# dpkg: information and maintenance 📊

```bash
# Info on an installed package
dpkg -s nginx

# List files inside a .deb
dpkg -c package.deb

# Extract a .deb without installing
dpkg-deb -x package.deb /tmp/extracted

# Reconfigure a package
sudo dpkg-reconfigure package-name

# Fix broken packages
sudo dpkg --configure -a
```

---

# DNF: Red Hat/Fedora manager 🎩

**dnf:** replaces yum (since Fedora 22, RHEL 8)

```bash
# Refresh index and apply upgrades
sudo dnf upgrade

# Search for a package
dnf search nginx

# Package information
dnf info nginx

# Install a package
sudo dnf install nginx
```

---

# Install with DNF 📥

```bash
# Install a package
sudo dnf install nginx

# Install several packages
sudo dnf install nginx mariadb-server php

# Install without confirmation
sudo dnf install -y nginx

# Install a package group
sudo dnf groupinstall "Development Tools"

# Reinstall
sudo dnf reinstall nginx
```

---

# Remove with DNF 🗑️

```bash
# Remove a package
sudo dnf remove nginx

# Remove with unused dependencies
sudo dnf autoremove nginx

# Remove a group
sudo dnf groupremove "Development Tools"
```

---

# Update with DNF 🔄

```bash
# Check for updates
dnf check-update

# Upgrade all packages
sudo dnf upgrade

# Upgrade one package
sudo dnf upgrade nginx

# Upgrade to a new Fedora release
sudo dnf system-upgrade download --releasever=39
sudo dnf system-upgrade reboot
```

---

# Search with DNF 🔍

```bash
# Simple search
dnf search nginx

# List all packages
dnf list

# List installed packages
dnf list installed

# List available packages
dnf list available

# Detailed information
dnf info nginx

# Transaction history
dnf history

# Undo last transaction
sudo dnf history undo last
```

---

# DNF repositories 📚

**Config files: `/etc/yum.repos.d/`**

```bash
ls /etc/yum.repos.d/
```

**Example repo file:**

```ini
[epel]
name=Extra Packages for Enterprise Linux $releasever - $basearch
baseurl=https://download.fedoraproject.org/pub/epel/$releasever/Everything/$basearch/
enabled=1
gpgcheck=1
gpgkey=https://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-$releasever
```

---

# Managing DNF repositories 🔧

```bash
# List repositories
dnf repolist

# List all repositories (including disabled)
dnf repolist --all

# Enable a repository
sudo dnf config-manager --enable epel

# Disable a repository
sudo dnf config-manager --disable epel

# Add a repository
sudo dnf config-manager --add-repo https://example.com/repo/example.repo
```

---

# EPEL: extra RHEL packages 🎁

**EPEL:** Extra Packages for Enterprise Linux

```bash
# Install EPEL on RHEL/AlmaLinux/Rocky
sudo dnf install epel-release

# Or manually
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

# Verify
dnf repolist | grep epel
```

**EPEL adds thousands of extra packages!**

---

# Clean the DNF system 🧹

```bash
# Clean cache
sudo dnf clean all

# Remove orphan packages
sudo dnf autoremove

# Remove old kernels (keep last 2)
sudo dnf remove $(dnf repoquery --installonly --latest-limit=-2 -q)
```

---

# RPM: low-level manager 🔩

**rpm:** direct management of .rpm packages

```bash
# Install a .rpm
sudo rpm -ivh package.rpm

# Upgrade
sudo rpm -Uvh package.rpm

# Remove
sudo rpm -e package-name

# List installed packages
rpm -qa

# List files from a package
rpm -ql nginx
```

---

# RPM: information 📊

```bash
# Information on an installed package
rpm -qi nginx

# Information on a .rpm file
rpm -qip package.rpm

# Find which package owns a file
rpm -qf /usr/sbin/nginx

# Verify package integrity
rpm -V nginx

# List package scripts
rpm -q --scripts nginx
```

---

# Snap: universal packages 📦

**Snap:** universal package format (Canonical/Ubuntu)

```bash
# Install snapd
sudo apt install snapd        # Ubuntu/Debian
sudo dnf install snapd        # Fedora

# Search for a snap
snap find vlc

# Install a snap
sudo snap install vlc

# List installed snaps
snap list

# Update
sudo snap refresh vlc
sudo snap refresh   # All

# Remove
sudo snap remove vlc
```

---

# Snap: pros and cons ⚖️

**Pros ✅**
- Isolation (containerized)
- Automatic updates
- Same package on all distributions
- Several versions in parallel

**Cons ❌**
- Larger (bundled dependencies)
- Slower startup
- More memory
- Limited system access (sandboxing)

---

# Flatpak: Snap alternative 📦

**Flatpak:** universal format (open project)

```bash
# Install Flatpak
sudo apt install flatpak             # Ubuntu/Debian
sudo dnf install flatpak             # Fedora

# Add Flathub (main repo)
flatpak remote-add --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo

# Search for an app
flatpak search firefox

# Install
flatpak install flathub org.mozilla.firefox

# Run
flatpak run org.mozilla.firefox
```

---

# Flatpak: management 🔧

```bash
# List installed applications
flatpak list

# Update everything
flatpak update

# Uninstall
flatpak uninstall org.mozilla.firefox

# Remove unused runtimes
flatpak uninstall --unused

# Show info
flatpak info org.mozilla.firefox
```

---

# AppImage: portable executables 🎒

**AppImage:** a single executable file

```bash
# Download an AppImage
wget https://example.com/app.AppImage

# Make executable
chmod +x app.AppImage

# Run
./app.AppImage

# That’s it! No install step
```

**Pros:**
- No install
- Portable (USB)
- No admin rights

**Cons:**
- No automatic updates
- No system integration

---

# Build from source 🔨

**When to compile?**
- Package unavailable
- Need a very new version
- Custom build options

```bash
# Install build tools
sudo apt install build-essential    # Debian/Ubuntu
sudo dnf groupinstall "Development Tools"  # RHEL/Fedora

# Download sources
wget https://example.com/software-1.0.tar.gz
tar -xzf software-1.0.tar.gz
cd software-1.0
```

---

# Build from source (continued) 🔨

```bash
# Configure
./configure --prefix=/usr/local

# Compile
make

# Install
sudo make install

# Uninstall (if supported)
sudo make uninstall
```

---

# Security: automatic updates 🔐

**Why automate?**
- Critical security patches
- Nothing forgotten
- System stays current
- Smaller attack surface
- Policy compliance

**Options:**
- **Ubuntu/Debian:** unattended-upgrades
- **RHEL/Fedora:** dnf-automatic

---

# What is unattended-upgrades? 🤖

**unattended-upgrades:** automates updates on Ubuntu/Debian

**How it works:**
- Downloads and installs updates automatically
- No manual steps
- Configurable update types

**Good fits:**
- Production servers
- Machines you don’t touch daily
- High-security environments
- Large fleets

---

# Installing unattended-upgrades 📥

```bash
# Install package
sudo apt install unattended-upgrades
```

---

# Enabling unattended-upgrades ⚙️

```bash
# Enable (interactive)
sudo dpkg-reconfigure unattended-upgrades
```

---

# Enabling unattended-upgrades (continued) ⚙️

You will be asked:
- **Yes:** enable automatic updates
- **No:** disable automatic updates

**Alternative: manual configuration**

```bash
# Edit config
sudo nano /etc/apt/apt.conf.d/20auto-upgrades
```

---

# auto-upgrade configuration 📝

**File: `/etc/apt/apt.conf.d/20auto-upgrades`**

```bash
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
```

---

# auto-upgrade configuration (explained) 📝

**Parameter meaning:**

- **Update-Package-Lists "1":** refresh package index daily
- **Unattended-Upgrade "1":** enable daily unattended upgrades
- **Download-Upgradeable-Packages "1":** download available upgrades
- **AutocleanInterval "7":** clean cache every 7 days

**Possible values:**
- **"0"** = Off
- **"1"** = Daily
- **"7"** = Every 7 days

---

# Advanced configuration: 50unattended-upgrades 🔧

**Main file: `/etc/apt/apt.conf.d/50unattended-upgrades`**

Controls:
- Which updates to install
- Whether to reboot
- Email notifications
- Package handling

```bash
# Edit configuration
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```

---

# Configuration: update origins 📚

```bash
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}:${distro_codename}-updates";
    // "${distro_id}:${distro_codename}-proposed";
    // "${distro_id}:${distro_codename}-backports";
};
```

---

# Configuration: origins (explained) 📚

**Available options:**

- **`-security`:** security fixes only (recommended ✅)
- **`-updates`:** stable updates
- **`-proposed`:** proposed/test packages ⚠️
- **`-backports`:** newer backported versions ⚠️

**Recommendation:** enable only `-security` on critical servers

---

# Configuration: automatic reboot 🔄

```bash
# Allow automatic reboot?
Unattended-Upgrade::Automatic-Reboot "false";

# If yes, at what time?
Unattended-Upgrade::Automatic-Reboot-Time "03:00";

# Reboot even if users are logged in?
Unattended-Upgrade::Automatic-Reboot-WithUsers "false";
```

---

# Configuration: email notifications 📧

```bash
# Email for notifications
Unattended-Upgrade::Mail "admin@example.com";

# When to send email?
// "always"
// "only-on-error"
// "on-change"
Unattended-Upgrade::MailReport "on-change";
```

---

# Configuration: package handling 📦

```bash
# Remove unused dependencies?
Unattended-Upgrade::Remove-Unused-Dependencies "true";

# Remove new unused dependencies?
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";

# Auto-remove unused kernel packages?
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
```

---

# Configuration: blacklist 🚫

```bash
# Packages to NEVER auto-upgrade
Unattended-Upgrade::Package-Blacklist {
    "nginx";
    "mysql-server";
    "postgresql";
};
```

---

# Configuration: blacklist (why?) 🤔

**Use cases:**
- Critical packages needing supervision
- Apps with custom configs
- Services that need testing before upgrade
- Packages that might break dependencies

**Example:** web server with custom config
- nginx upgrade might overwrite config
- Prefer manual handling

---

# Full example (security only) 🔐

```bash
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};

Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Mail "admin@example.com";
Unattended-Upgrade::MailReport "on-change";

Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";
```

---

# Full example (with reboot) 🔄

```bash
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}:${distro_codename}-updates";
};

Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
Unattended-Upgrade::Automatic-Reboot-WithUsers "false";

Unattended-Upgrade::Mail "admin@example.com";
Unattended-Upgrade::MailReport "always";
```

---

# Benefits of unattended-upgrades ✅

**Stronger security 🔐**
- Critical patches applied immediately
- No human delay
- Smaller vulnerability window

**Time saved ⏰**
- No need to run `apt update && apt upgrade` manually
- Automatic handling across many servers
- Focus on important work

---

# Benefits of unattended-upgrades (continued) ✅

**Full control 🎛️**
- Pick update categories precisely
- Blacklist sensitive packages
- Schedule reboots
- Customizable notifications

**Reliability 🛡️**
- Mature, tested process
- Smart dependency handling
- Rollback possible if something goes wrong

---

# Good to know ⚠️

**Reboots may be required:**
- Kernel updates often need a reboot
- Some system libraries too
- Check `/var/run/reboot-required`

```bash
# Check if reboot is needed
test -f /var/run/reboot-required && echo "Reboot required"

# Why?
cat /var/run/reboot-required.pkgs
```

---

# Logs and monitoring 📋

**Log locations:**

```bash
# Main logs
/var/log/unattended-upgrades/

# Detailed log
/var/log/unattended-upgrades/unattended-upgrades.log

# dpkg log
/var/log/unattended-upgrades/unattended-upgrades-dpkg.log
```

---

# Reading logs 🔍

```bash
# Recent updates
sudo tail -f /var/log/unattended-upgrades/unattended-upgrades.log

# Errors
sudo grep -i error /var/log/unattended-upgrades/unattended-upgrades.log

# Today’s updates
sudo grep "$(date +%Y-%m-%d)" \
  /var/log/unattended-upgrades/unattended-upgrades.log
```

---

# Test the configuration ✅

```bash
# Dry-run in debug mode
sudo unattended-upgrade --debug --dry-run

# Run now
sudo unattended-upgrade --debug

# Service status
sudo systemctl status unattended-upgrades
```

---

# Temporarily disable 🛑

```bash
# Stop service
sudo systemctl stop unattended-upgrades

# Disable at boot
sudo systemctl disable unattended-upgrades

# Re-enable
sudo systemctl enable --now unattended-upgrades
```

---

# DNF Automatic (RHEL/Fedora) 🤖

```bash
# Install
sudo dnf install dnf-automatic

# Configuration
sudo nano /etc/dnf/automatic.conf
```

```ini
[commands]
upgrade_type = security
download_updates = yes
apply_updates = yes

[email]
email_to = admin@example.com
```

```bash
# Enable
sudo systemctl enable --now dnf-automatic.timer
```

---

# Check security updates 🔒

**Ubuntu/Debian:**

```bash
# List security upgrades
sudo apt list --upgradable | grep security

# Install only security updates
sudo unattended-upgrade -d
```

**RHEL/Fedora:**

```bash
# List security updates
sudo dnf updateinfo list security

# Install security fixes only
sudo dnf upgrade --security
```

---

# Kernel versions 🧠

```bash
# Current kernel
uname -r

# Installed kernels (Debian/Ubuntu)
dpkg -l | grep linux-image

# Remove an old kernel
sudo apt remove linux-image-5.15.0-25-generic

# Or autoremove
sudo apt autoremove
```

---

# Kernel versions (RHEL/Fedora) 🧠

```bash
# Installed kernels
rpm -q kernel

# Config: how many kernels to keep
sudo nano /etc/dnf/dnf.conf
```

```ini
installonly_limit=3
```

```bash
# Remove old kernels
sudo dnf remove --oldinstallonly --setopt installonly_limit=2 kernel
```

---

# Troubleshooting: broken packages 🔧

**Debian/Ubuntu:**

```bash
# Fix broken installs
sudo apt install -f

# Reconfigure unfinished packages
sudo dpkg --configure -a

# Force-remove a stuck package
sudo dpkg --remove --force-remove-reinstreq package-name
```

---

# Troubleshooting: broken packages (RHEL/Fedora) 🔧

```bash
# Check for problems
sudo dnf check

# Repair
sudo dnf distro-sync

# Reinstall a package
sudo dnf reinstall package-name

# RPM database issues
sudo rpm --rebuilddb
```

---

# Pinning package versions 🔒

**Debian/Ubuntu: apt-mark**

```bash
# Prevent upgrades
sudo apt-mark hold nginx

# Show held packages
apt-mark showhold

# Unhold
sudo apt-mark unhold nginx
```

---

# Pinning package versions (DNF) 🔒

**RHEL/Fedora: versionlock**

```bash
# Install plugin
sudo dnf install python3-dnf-plugin-versionlock

# Hold a package
sudo dnf versionlock add nginx

# List holds
sudo dnf versionlock list

# Remove hold
sudo dnf versionlock delete nginx
```

---

# Alternatives: multiple versions 🔀

**update-alternatives:** manage several versions of a tool

```bash
# List alternatives
update-alternatives --list editor

# Show current choice
update-alternatives --display editor

# Change alternative
sudo update-alternatives --config editor

# Register an alternative
sudo update-alternatives --install /usr/bin/editor editor \
  /usr/bin/vim 100
```

---

# Common alternatives examples 📝

```bash
# Default editor
sudo update-alternatives --config editor

# Java
sudo update-alternatives --config java

# Default browser
sudo update-alternatives --config x-www-browser

# Python
sudo update-alternatives --config python
```

---

# Logs and history 📜

**APT logs:**

```bash
# Install history
cat /var/log/apt/history.log

# Detailed log
cat /var/log/apt/term.log

# Archived history
zcat /var/log/apt/history.log.*.gz | less
```

---

# Logs and history (DNF) 📜

```bash
# DNF history
dnf history

# Transaction details
dnf history info 5

# Undo a transaction
sudo dnf history undo 5

# Redo a transaction
sudo dnf history redo 5

# Logs
cat /var/log/dnf.log
```

---

# Best practices 📋

1. **Always `update` before `upgrade`**
   ```bash
   sudo apt update && sudo apt upgrade
   ```

2. **Read changes before confirming**
   - Check what will be installed/removed

3. **Back up before major upgrades**
   - VM snapshot or backup

4. **Enable automatic security updates**
   - unattended-upgrades or dnf-automatic

---

# Best practices (continued) 📋

5. **Clean regularly**
   ```bash
   sudo apt autoremove && sudo apt clean
   ```

6. **Don’t mix incompatible sources**
   - Avoid mixing Debian and Ubuntu repos
   - Avoid untrusted PPAs

7. **Watch for obsolete packages**
   ```bash
   apt list --upgradable
   ```

8. **Document changes**
   - Note added repositories
   - Note pinned versions

---

# Real-world examples 💼

**Install LAMP (Linux, Apache, MySQL, PHP):**

```bash
# Debian/Ubuntu
sudo apt update
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql

# RHEL/Fedora
sudo dnf install httpd mariadb-server php php-mysqlnd
sudo systemctl enable --now httpd mariadb
```

---

# Real-world examples (continued) 💼

**Install Docker from the official repo:**

```bash
# Debian/Ubuntu
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# RHEL/Fedora
sudo dnf config-manager --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
```

---

# Module 3 recap ✅

**What you learned:**

✅ Packages and dependencies

✅ APT (Debian/Ubuntu): install, remove, update, upgrade

✅ DNF/YUM (RHEL/Fedora): install, remove, upgrade

✅ Managing repositories

✅ Universal formats (Snap, Flatpak, AppImage)

✅ Automatic security updates

✅ Building from source

✅ Fixing broken packages

✅ Maintenance best practices

---

# Next step 🎯

**Module 4: User and permission management**

- Creating and managing user accounts
- Groups and membership
- Advanced permissions (chmod, chown, umask)
- Sudo and sudoers
- Disk quotas
- Logs and journalctl

---
layout: default
---

# Questions? 🤔

Ask your questions now!

Post your questions on <ExternalLink href="https://questions.andromed.fr">questions.andromed.fr</ExternalLink> (access code **29062026**) so I can centralize and answer them.

The next module covers automation with scripts and scheduled tasks.

