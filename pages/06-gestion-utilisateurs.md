---
layout: intro
routeAlias: 'gestion-utilisateurs'
---

# User management 👥

### Administering user accounts and groups

<div class="pt-12">
  <span @click="next" class="px-2 p-3 rounded cursor-pointer hover:bg-white hover:bg-opacity-10 neon-border">
    Let's manage users together <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: default
---

# Core concepts 🔐

### Users and groups in Unix/Linux

**User:**
- Account that accesses the system
- Identified by a username
- Has a unique UID (User ID)
- Has a personal home directory

**Group:**
- Collection of users
- Identified by a group name
- Has a unique GID (Group ID)
- Allows sharing resources

**User types:**
- **root**: Superuser (UID 0)
- **System users**: Services and daemons
- **Regular users**: End users

---
layout: default
---

# Configuration files 📄

### Where user information is stored

**/etc/passwd**
```bash
# Format: username:password:UID:GID:comment:home:shell
root:x:0:0:root:/root:/bin/bash
user1:x:1000:1000:User One:/home/user1:/bin/bash
```

**/etc/shadow**
```bash
# Encrypted passwords
root:$6$...:18000:0:99999:7:::
user1:$6$...:18000:0:99999:7:::
```

**/etc/group**
```bash
# Format: groupname:password:GID:members
root:x:0:
user1:x:1000:user1
sudo:x:27:user1
```

**/etc/gshadow**
```bash
# Group security information
root:!::
user1:!::
sudo:!:user1
```

---
layout: default
---

# User management commands 👤

### Creating and managing users

**useradd (add a user)**
```bash
useradd username              # Create a user
useradd -m username           # Create with home directory
useradd -s /bin/bash username # Specify shell
useradd -u 1001 username      # Specify UID
useradd -g group username     # Primary group
useradd -G group1,group2 username # Supplementary groups
```

**usermod (modify a user)**
```bash
usermod -s /bin/zsh username  # Change shell
usermod -d /new/home username # Change home
usermod -L username           # Lock account
usermod -U username           # Unlock account
```

---
layout: default
---

# User management commands 👤

### Removing users and managing passwords

**userdel (delete a user)**
```bash
userdel username              # Delete user
userdel -r username           # Delete with home
userdel -f username           # Force deletion
```

**passwd (manage passwords)**
```bash
passwd                        # Change your password
passwd username               # Change a user's password
passwd -l username            # Lock account
passwd -u username          # Unlock account
passwd -e username          # Force change at next login
```

**chage (password aging)**
```bash
chage -l username             # List aging information
chage -M 90 username          # Expire in 90 days
chage -W 7 username           # Warn 7 days before
```

---
layout: default
---

# Group management commands 👥

### Creating and managing groups

**groupadd (add a group)**
```bash
groupadd group_name           # Create a group
groupadd -g 1001 group_name   # Specify GID
groupadd -r group_name        # System group
```

**groupmod (modify a group)**
```bash
groupmod -n new_name old_name # Rename a group
groupmod -g 1002 group_name   # Change GID
```

**groupdel (delete a group)**
```bash
groupdel group_name           # Delete a group
```

**gpasswd (manage group membership)**
```bash
gpasswd -a user group         # Add a member
gpasswd -d user group         # Remove a member
gpasswd -M user1,user2,user3 group # Set member list
```

---
layout: default
---

# Information commands 📊

### Getting information about users

**id (user identity)**
```bash
id                            # My identity
id username                   # A user's identity
id -u username                # UID only
id -g username                # Primary GID only
id -G username                # All groups
id -n username                # Names instead of IDs
```

**who and w**
```bash
who                           # Logged-in users
who am i                      # Current user
w                             # Users and their processes
w -h                          # No header
```

**last and lastlog**
```bash
last                          # Login history
last username                 # A user's logins
lastlog                       # Last login for all users
lastlog -u username           # Last login for one user
```

---
layout: default
---

# Advanced permissions management 🔐

### sudo and su

**sudo (Substitute User DO)**
```bash
sudo command                  # Run as root
sudo -u user command          # Run as another user
sudo -i                       # Interactive root shell
sudo -s                       # Non-interactive root shell
sudo -l                       # List sudo permissions
```

**su (Switch User)**
```bash
su                            # Switch to root
su -                          # Root with full environment
su user                       # Switch to user
su - user                     # Switch with login environment
```

**sudo configuration (/etc/sudoers)**
```bash
# Syntax: user host=(runas_user) commands
user1 ALL=(ALL) ALL              # All commands
user1 ALL=(ALL) NOPASSWD: ALL    # No password
user1 ALL=(ALL) /usr/bin/apt     # apt only
%sudo ALL=(ALL) ALL              # sudo group
```

---
layout: default
---

# User security 🛡️

### Security best practices

**Password policy**
```bash
# Configuration in /etc/login.defs
PASS_MAX_DAYS 90                 # Expire after 90 days
PASS_MIN_DAYS 1                  # Min 1 day between changes
PASS_WARN_AGE 7                  # Warn 7 days before
PASS_MIN_LEN 8                   # Minimum length 8 characters
```

**Account lockout**
```bash
passwd -l user             # Lock an account
usermod -L user            # Alternative
usermod -e 1 user          # Immediate expiration
```

**Login monitoring**
```bash
last                              # Login history
lastb                             # Failed login attempts
faillog -a                        # Login failures
```

---
layout: default
---

# Quota management 📊

### Limiting disk usage

**Quota configuration**
```bash
# Enable quotas on the filesystem
mount -o usrquota,grpquota /dev/sda1 /home

# Initialize quotas
quotacheck -cugm /home
quotaon -av

# Edit quotas for a user
edquota -u user
```

**Quota commands**
```bash
quota -u user              # User quotas
quota -g group             # Group quotas
repquota -a                # Global report
warnquota                  # Send warnings
```

**Configurable limits**
```bash
# In edquota
Filesystem  blocks  soft  hard  inodes  soft  hard
/dev/sda1   1000    2000  3000    100    200   300
# blocks = current usage
# soft = soft limit
# hard = hard limit
```

---
layout: default
---

# User profiles 👤

### Customizing environments

**Profile files**
```bash
~/.bashrc                        # Bash config for each shell
~/.bash_profile                   # Bash config for login
~/.profile                        # General configuration
~/.bash_logout                    # Actions on logout
```

**Environment variables**
```bash
export PATH=$PATH:/added/path   # Add to PATH
export EDITOR=vim                 # Default editor
export LANG=en_US.UTF-8          # Locale
export HISTSIZE=1000              # History size
```

**Aliases and functions**
```bash
# In ~/.bashrc
alias ll='ls -la'
alias la='ls -A'
alias ..='cd ..'
alias h='history'

# Custom functions
backup() {
    tar -czf backup_$(date +%Y%m%d).tar.gz "$1"
}
```

---
layout: default
---

# SSH key management 🔑

### Key-based authentication

**Generate a key pair**
```bash
ssh-keygen -t rsa -b 4096         # 4096-bit RSA
ssh-keygen -t ed25519              # Ed25519 (recommended)
ssh-keygen -f ~/.ssh/id_rsa        # Specify file
```

**Copy the public key**
```bash
ssh-copy-id user@server    # Copy automatically
cat ~/.ssh/id_rsa.pub | ssh user@server "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

**SSH configuration**
```bash
# In ~/.ssh/config
Host server
    HostName 192.168.1.100
    User user
    Port 22
    IdentityFile ~/.ssh/id_rsa
```

**Secure permissions**
```bash
chmod 700 ~/.ssh                   # SSH directory
chmod 600 ~/.ssh/id_rsa            # Private key
chmod 644 ~/.ssh/id_rsa.pub        # Public key
chmod 600 ~/.ssh/authorized_keys   # Authorized keys
```

---
layout: default
---

# System users 🔧

### Users for services

**Create a system user**
```bash
useradd -r -s /bin/false service_user  # System user, no shell
useradd -r -d /var/lib/service service_user  # Specific home
```

**Common users**
```bash
# Typical system users
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
mysql:x:127:127:MySQL Server:/var/lib/mysql:/bin/false
postgres:x:128:128:PostgreSQL:/var/lib/postgresql:/bin/bash
```

**Service permissions**
```bash
# Grant service access
usermod -aG service_group user
chown -R service_user:service_group /path/service
chmod 755 /path/service
```

---
layout: default
---

# User monitoring 📈

### Monitoring user activity

**Monitoring commands**
```bash
who                           # Logged-in users
w                             # Users and processes
ps aux | grep user            # A user's processes
lsof -u user                  # Open files for a user
```

**Login logs**
```bash
tail -f /var/log/auth.log         # Follow logins
grep "session opened" /var/log/auth.log  # Opened sessions
grep "session closed" /var/log/auth.log  # Closed sessions
```

**Resource monitoring**
```bash
du -sh /home/*                    # Disk per user home
quota -u user              # User quotas
ps -eo user,pid,ppid,cmd --sort=-%mem | head  # Top memory by user
```

---
layout: default
---

# Hands-on exercises 🎯

### User management practice

**Exercise 1: Create users**
```bash
# Create user with home directory
sudo useradd -m -s /bin/bash john
sudo passwd john

# Create a group
sudo groupadd developers

# Add user to group
sudo usermod -aG developers john
```

**Exercise 2: Permission management**
```bash
# Create shared directory
sudo mkdir /shared
sudo chown root:developers /shared
sudo chmod 775 /shared

# Test access
su - john
cd /shared
touch test.txt
```

**Exercise 3: sudo configuration**
```bash
# Add user to sudo group
sudo usermod -aG sudo john

# Test sudo
su - john
sudo apt update
```

---
layout: default
---

# Best practices 💡

### Tips for user management

**Security**
- Use strong passwords
- Limit sudo privileges
- Monitor logins
- Lock inactive accounts
- Use SSH key authentication

**Organization**
- Create logical groups
- Use naming conventions
- Document permissions
- Back up configuration files

**Maintenance**
- Review permissions regularly
- Clean up inactive accounts
- Rotate passwords
- Monitor resource usage

---
layout: default
---

# Next steps 🎯

### What's ahead

1. **Permissions and security** (advanced)
2. **Processes and services**
3. **Networking and connectivity**
4. **Software packages** and management
5. **Shell scripting** basics

**Preparation:**
- Practice creating users
- Get comfortable with sudo
- Test group permissions
