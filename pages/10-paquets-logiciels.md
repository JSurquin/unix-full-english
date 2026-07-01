---
layout: intro
routeAlias: 'paquets-logiciels'
---

# Software Packages 📦

### Linux package and software management

<div class="pt-12">
  <span @click="next" class="px-2 p-3 rounded cursor-pointer hover:bg-white hover:bg-opacity-10 neon-border">
    Let's manage packages together <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: default
---

# Core concepts 📚

### What is a package?

**Definition:**
- Archive containing a piece of software
- Metadata (dependencies, version, etc.)
- Install/uninstall scripts
- Managed by a package manager

**Package types:**
- **Binary packages** : Pre-built software
- **Source packages** : Source code to compile
- **Development packages** : Headers and libraries
- **Documentation packages** : Manuals and docs

**Common package managers:**
- **apt** (Debian/Ubuntu)
- **yum/dnf** (Red Hat/CentOS)
- **pacman** (Arch Linux)
- **zypper** (openSUSE)

---
layout: default
---

# APT package manager 🔧

### Package management on Debian/Ubuntu

**Updating package lists:**
```bash
sudo apt update                 # Update the package list
sudo apt upgrade               # Upgrade installed packages
sudo apt full-upgrade          # Full upgrade (may change packages)
sudo apt dist-upgrade          # Distribution upgrade
```

**Install and remove:**
```bash
sudo apt install package_name    # Install a package
sudo apt install pkg1 pkg2  # Install several packages
sudo apt remove package_name     # Remove a package
sudo apt purge package_name      # Remove completely
sudo apt autoremove            # Remove unnecessary dependencies
```

**Search and information:**
```bash
apt search package_name          # Search for a package
apt show package_name            # Package information
apt list --installed           # Installed packages
apt list --upgradable          # Packages to upgrade
```

---
layout: default
---

# Advanced APT commands 🚀

### Advanced features

**Repository management:**
```bash
# Add a repository
sudo add-apt-repository ppa:nom/ppa
sudo apt update

# Remove a repository
sudo add-apt-repository --remove ppa:nom/ppa

# List repositories
cat /etc/apt/sources.list
ls /etc/apt/sources.list.d/
```

**Cleanup and maintenance:**
```bash
sudo apt clean                 # Clean the cache
sudo apt autoclean             # Clean obsolete packages
sudo apt autoremove            # Remove orphaned dependencies
sudo apt autoremove --purge    # Remove with configuration
```

**Troubleshooting:**
```bash
sudo apt --fix-broken install  # Fix broken dependencies
sudo dpkg --configure -a       # Reconfigure packages
sudo apt install -f            # Force install
```

---
layout: default
---

# DNF/YUM package manager 📦

### Package management on Red Hat/CentOS

**Basic commands:**
```bash
sudo dnf update               # Update the system
sudo dnf install package_name   # Install a package
sudo dnf remove package_name    # Remove a package
sudo dnf search package_name    # Search for a package
sudo dnf info package_name      # Package information
```

**Repository management:**
```bash
sudo dnf repolist             # List repositories
sudo dnf repolist enabled     # Enabled repositories
sudo dnf repolist disabled    # Disabled repositories
sudo dnf config-manager --add-repo URL  # Add a repository
```

**Cleanup:**
```bash
sudo dnf clean all            # Clean the cache
sudo dnf autoremove           # Remove unnecessary dependencies
sudo dnf autoremove --duplicates  # Remove duplicates
```

---
layout: default
---

# Pacman package manager 🏗️

### Package management on Arch Linux

**Basic commands:**
```bash
sudo pacman -S package_name     # Install a package
sudo pacman -R package_name     # Remove a package
sudo pacman -Rs package_name    # Remove with dependencies
sudo pacman -Syu              # Update the system
sudo pacman -Ss package_name    # Search for a package
```

**Repository management:**
```bash
sudo pacman -Sy               # Sync repositories
sudo pacman -Syy              # Force sync
sudo pacman -Q                # List installed packages
sudo pacman -Qq               # Simple list
```

**AUR (Arch User Repository):**
```bash
# With yay (AUR helper)
yay -S package_name             # Install from AUR
yay -R package_name             # Remove an AUR package
yay -Ss package_name            # Search in AUR
```

---
layout: default
---

# Dependency management 🔗

### Understanding dependencies

**Dependency types:**
```bash
# Required dependencies
Depends: libc6 (>= 2.17)

# Recommended dependencies
Recommends: python3

# Suggested dependencies
Suggests: python3-pip

# Conflicting dependencies
Conflicts: old-package

# Replacement dependencies
Replaces: old-package
```

**Diagnostic commands:**
```bash
# View a package's dependencies
apt show package_name | grep -E "(Depends|Recommends|Suggests)"

# View packages that depend on a package
apt rdepends package_name

# View broken dependencies
apt check
```

**Conflict resolution:**
```bash
# Force install despite conflicts
sudo apt install package_name --force-yes

# Resolve conflicts automatically
sudo apt install package_name --fix-broken
```

---
layout: default
---

# Development packages 🛠️

### Development tools

**Build packages:**
```bash
# Basic tools
sudo apt install build-essential
sudo apt install gcc g++ make

# Development libraries
sudo apt install libssl-dev
sudo apt install libcurl4-openssl-dev
sudo apt install python3-dev

# Debug tools
sudo apt install gdb
sudo apt install valgrind
sudo apt install strace
```

**Development environments:**
```bash
# Python
sudo apt install python3 python3-pip python3-venv

# Node.js
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs

# Java
sudo apt install openjdk-11-jdk
sudo apt install maven
```

---
layout: default
---

# Source package management 📝

### Building from source

**Download and extract:**
```bash
# Download sources
wget https://example.com/software-1.0.tar.gz
tar -xzf software-1.0.tar.gz
cd software-1.0
```

**Configure and build:**
```bash
# Configuration
./configure --prefix=/usr/local
make
sudo make install

# Or with cmake
mkdir build && cd build
cmake ..
make
sudo make install
```

**Uninstall:**
```bash
# If the package has a Makefile
sudo make uninstall

# Otherwise remove manually
sudo rm -rf /usr/local/bin/software
sudo rm -rf /usr/local/lib/software
```

---
layout: default
---

# Snap and Flatpak packages 📱

### Universal packages

**Snap (Canonical):**
```bash
# Installation
sudo apt install snapd

# Usage
sudo snap install package_name
sudo snap remove package_name
snap list
snap info package_name
snap refresh package_name
```

**Flatpak (Red Hat):**
```bash
# Installation
sudo apt install flatpak

# Add the Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Usage
flatpak install flathub org.gnome.Gedit
flatpak uninstall org.gnome.Gedit
flatpak list
flatpak update
```

**Comparison:**
```bash
# Snap: strict confinement, automatic updates
# Flatpak: more flexible, more open ecosystem
# Both: universal packages, isolation
```

---
layout: default
---

# Python package management 🐍

### pip and virtual environments

**pip (Python Package Installer):**
```bash
# Install packages
pip install package_name
pip install package_name==1.2.3
pip install -r requirements.txt

# Uninstall
pip uninstall package_name

# List packages
pip list
pip freeze > requirements.txt
```

**Virtual environments:**
```bash
# Create a virtual environment
python3 -m venv my_env
source my_env/bin/activate

# Deactivate the environment
deactivate

# With virtualenvwrapper
mkvirtualenv my_project
workon my_project
deactivate
```

**Conda (Anaconda):**
```bash
# Install packages
conda install package_name
conda install package_name=1.2.3

# Create an environment
conda create -n my_env python=3.9
conda activate my_env
conda deactivate
```

---
layout: default
---

# Node.js package management 🟢

### npm and yarn

**npm (Node Package Manager):**
```bash
# Global install
npm install -g package_name

# Local install
npm install package_name
npm install package_name --save-dev

# Uninstall
npm uninstall package_name

# List packages
npm list
npm list -g
```

**yarn (npm alternative):**
```bash
# Installation
npm install -g yarn

# Usage
yarn add package_name
yarn add package_name --dev
yarn remove package_name
yarn list
yarn install
```

**Version management:**
```bash
# With nvm (Node Version Manager)
nvm install 16.14.0
nvm use 16.14.0
nvm list

# With n (alternative)
n 16.14.0
n list
```

---
layout: default
---

# Container packages 🐳

### Managing Docker images

**Basic Docker commands:**
```bash
# Pull an image
docker pull ubuntu:20.04
docker pull nginx:alpine

# List images
docker images
docker image ls

# Remove an image
docker rmi nom_image
docker image rm nom_image

# Clean unused images
docker image prune
docker system prune
```

**Building images:**
```bash
# Build from a Dockerfile
docker build -t mon_image .
docker build -t mon_image:v1.0 .

# Tag an image
docker tag mon_image mon_image:v1.0

# Push to a registry
docker push mon_image:v1.0
```

---
layout: default
---

# Security packages 🔒

### Security and audit packages

**Security tools:**
```bash
# Security audit
sudo apt install lynis
sudo lynis audit system

# Vulnerability scanner
sudo apt install rkhunter
sudo rkhunter --update
sudo rkhunter --check

# Encryption tools
sudo apt install openssl
sudo apt install gpg
```

**Security updates:**
```bash
# Security updates only
sudo apt update
sudo apt upgrade --only-upgrade

# Check for vulnerabilities
sudo apt list --upgradable | grep security
```

**Automatic configuration:**
```bash
# unattended-upgrades
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```

---
layout: default
---

# System package management ⚙️

### Critical system packages

**Linux kernel:**
```bash
# List installed kernels
dpkg -l | grep linux-image

# Install a new kernel
sudo apt install linux-image-generic

# Remove old kernels
sudo apt autoremove --purge
```

**Firmware and drivers:**
```bash
# Proprietary firmware
sudo apt install firmware-linux
sudo apt install firmware-linux-nonfree

# Graphics drivers
sudo apt install nvidia-driver-470
sudo apt install mesa-utils
```

**System services:**
```bash
# Network services
sudo apt install network-manager
sudo apt install ufw

# Core services
sudo apt install systemd
sudo apt install dbus
```

---
layout: default
---

# Package monitoring 📊

### Monitoring package state

**Diagnostic commands:**
```bash
# Check package integrity
dpkg -V

# View broken packages
dpkg --audit

# Check dependencies
apt check

# View disk space used
dpkg-query -W --showformat='${Installed-Size;10}\t${Package}\n' | sort -k1,1n
```

**Monitoring tools:**
```bash
# Apticron (update notifications)
sudo apt install apticron
sudo nano /etc/apticron/apticron.conf

# Debian-goodies
sudo apt install debian-goodies
checkrestart
```

**Package logs:**
```bash
# View install logs
cat /var/log/dpkg.log

# View recent errors
grep -i error /var/log/dpkg.log
```

---
layout: default
---

# Hands-on exercises 🎯

### Putting it into practice

**Exercise 1: Basic APT management**
```bash
# Update the system
sudo apt update
sudo apt upgrade

# Install a package
sudo apt install htop

# Search for a package
apt search "text editor"

# View information
apt show vim
```

**Exercise 2: Dependency management**
```bash
# View a package's dependencies
apt show nginx | grep -E "(Depends|Recommends)"

# View packages that depend on a package
apt rdepends python3

# Clean unnecessary dependencies
sudo apt autoremove
```

**Exercise 3: Python environment**
```bash
# Create a virtual environment
python3 -m venv my_project
source my_project/bin/activate

# Install packages
pip install requests
pip install flask

# Create requirements.txt
pip freeze > requirements.txt
```

---
layout: default
---

# Best practices 💡

### Tips for package management

**Security**
- Update the system regularly
- Use official repositories
- Verify package signatures
- Monitor vulnerabilities
- Use isolated environments

**Performance**
- Clean the cache regularly
- Remove unnecessary packages
- Use local mirrors
- Optimize repositories
- Monitor disk space

**Maintenance**
- Document installations
- Back up configuration
- Test updates
- Keep a list of installed packages
- Use monitoring tools

---
layout: default
---

# Next steps 🎯

### What's ahead

1. Basic **shell scripting**
2. **Virtualization** and containers
3. **Docker** introduction
4. **Final integrative project**

**Preparation:**
- Get comfortable with apt
- Practice installing packages
- Try virtual environments
- Explore different package managers
