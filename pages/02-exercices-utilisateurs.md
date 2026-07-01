---

# 🎯 Hands-on exercises - Module 1

**User, group, and permission management**

---

# Exercise 1: Creating users 👥

**Goal:** Create and manage users

**Instructions:**

1. Create three users: `dev1`, `dev2`, `admin1`
2. Set passwords for each
3. Confirm they appear in `/etc/passwd`
4. Show `dev1`’s information with `id`
5. List recent logins with `last`

---

# Exercise 1 solution 💡

```bash
# 1. Create users
sudo useradd -m -s /bin/bash dev1
sudo useradd -m -s /bin/bash dev2
sudo useradd -m -s /bin/bash admin1

# 2. Set passwords
sudo passwd dev1
sudo passwd dev2
sudo passwd admin1

# Or one line (automated)
echo "dev1:password123" | sudo chpasswd
echo "dev2:password123" | sudo chpasswd
echo "admin1:admin123" | sudo chpasswd

# 3. Check passwd
grep -E "dev1|dev2|admin1" /etc/passwd

# 4. dev1 information
id dev1

# 5. Recent logins
sudo last | head -20
```

---

# Exercise 2: Managing groups 👨‍👩‍👧‍👦

**Goal:** Create and manage groups

**Instructions:**

1. Create two groups: `developers` and `admins`
2. Add `dev1` and `dev2` to `developers`
3. Add `admin1` to `admins`
4. Verify membership with `groups`
5. Display `/etc/group`

---

# Exercise 2 solution 💡

```bash
# 1. Create groups
sudo groupadd developers
sudo groupadd admins

# 2. Add dev1 and dev2 to developers
sudo usermod -aG developers dev1
sudo usermod -aG developers dev2

# 3. Add admin1 to admins
sudo usermod -aG admins admin1

# 4. Verify membership
groups dev1
groups dev2
groups admin1

# Or with id
id dev1

# 5. View /etc/group
grep -E "developers|admins" /etc/group
```

---

# Exercise 3: Basic permissions 🔐

**Goal:** Master Unix permissions

**Instructions:**

1. Create a file `project.txt` owned by `dev1`
2. Set permissions to `rw-r--r--` (644)
3. Create `secret.txt` with permissions `rw-------` (600)
4. Create a script `hello.sh` and make it executable
5. Create a directory `shared/` with permissions `rwxrwxr-x` (775)

---

# Exercise 3 solution 💡

```bash
# 1. Create file
sudo -u dev1 touch /home/dev1/project.txt

# 2. Permissions 644
sudo chmod 644 /home/dev1/project.txt
# Verify
ls -l /home/dev1/project.txt

# 3. Secret file
sudo -u dev1 touch /home/dev1/secret.txt
sudo chmod 600 /home/dev1/secret.txt

# 4. Executable script
echo '#!/bin/bash' | sudo -u dev1 tee /home/dev1/hello.sh
echo 'echo "Hello World!"' | sudo -u dev1 tee -a /home/dev1/hello.sh
sudo chmod +x /home/dev1/hello.sh
# or
sudo chmod 755 /home/dev1/hello.sh

# 5. Shared directory
sudo mkdir /home/dev1/shared
sudo chown dev1:dev1 /home/dev1/shared
sudo chmod 775 /home/dev1/shared
```

---

# Exercise 4: Collaborative project 🤝

**Goal:** Set up a shared workspace

**Scenario:** Create a space where `dev1` and `dev2` can collaborate

**Instructions:**

1. Create `/shared/project`
2. Set owner to `root` and group to `developers`
3. Permissions: rwxrwx--- (770) and **SetGID** so new files inherit `developers`
4. Create a file inside as `dev1`
5. Verify `dev2` can modify it
6. Verify `admin1` cannot access it

---

# Exercise 4 solution 💡

```bash
# 1. Create directory
sudo mkdir -p /shared/project

# 2. Change owner and group
sudo chown root:developers /shared/project

# 3. Permissions 770 + SetGID (new files inherit group 'developers')
sudo chmod 770 /shared/project
sudo chmod g+s /shared/project

# Verify
ls -ld /shared/project
# → drwxrws--- root developers

# 4. Create file as dev1
sudo -u dev1 touch /shared/project/code.txt
sudo -u dev1 bash -c 'echo "Hello from dev1" > /shared/project/code.txt'

# 5. Modify as dev2
sudo -u dev2 bash -c 'echo "Modified by dev2" >> /shared/project/code.txt'
cat /shared/project/code.txt

# 6. Test admin1 access (should fail)
sudo -u admin1 ls /shared/project/
# → Permission denied
```

---

# Exercise 5: Using sudo 🔑

**Goal:** Configure sudo securely

**Instructions:**

1. Give `admin1` full sudo rights
2. Give `dev1` permission to restart nginx only
3. Create a `sysadmin` group with full sudo
4. Test commands as each user
5. Check sudo logs with `journalctl -t sudo`

---

# Exercise 5 solution 💡

```bash
# 1. Full rights for admin1
echo "admin1 ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/admin1
sudo chmod 440 /etc/sudoers.d/admin1
sudo visudo -c

# 2. Limited rights for dev1
echo "dev1 ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx" | \
    sudo tee /etc/sudoers.d/dev1
sudo chmod 440 /etc/sudoers.d/dev1
sudo visudo -c

# 3. sysadmin group
sudo groupadd sysadmin
echo "%sysadmin ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/sysadmin
sudo chmod 440 /etc/sudoers.d/sysadmin
sudo visudo -c

# 4. Test
# As admin1
sudo -u admin1 sudo apt update

# As dev1 (should fail)
sudo -u dev1 sudo apt update  # → Should fail

# 5. View logs
sudo journalctl -t sudo -f
```

---

# Exercise 6: Advanced permission management 🎯

**Goal:** Use chown, chmod, and umask

**Instructions:**

1. Create `/project` owned by `dev1:developers`
2. Set umask to `0027` for `dev1`
3. Create a file as `dev1` and check its permissions
4. Recursively change owner of `/project` to `dev2`
5. Set permissions on `/project` to `rwxr-x---`

---

# Exercise 6 solution 💡

```bash
# 1. Create /project
sudo mkdir /project
sudo chown dev1:developers /project

# 2. Change umask for dev1
sudo -u dev1 bash -c 'echo "umask 0027" >> /home/dev1/.bashrc'

# 3. Create file with new umask
sudo -u dev1 bash -c 'umask 0027; touch /project/test.txt'
ls -l /project/test.txt
# → -rw-r----- (permissions 640)

# 4. Recursive owner change
sudo chown -R dev2:developers /project

# 5. Permissions on /project
sudo chmod 750 /project
ls -ld /project
```

---

# Bonus exercise: User management script 🤖

**Goal:** Automate user creation

**Write a script `create_users.sh` that:**
- Reads a CSV with: name,group,shell
- Creates users automatically
- Generates random passwords
- Produces a report

**Sample CSV:**

```
alice,developers,/bin/bash
bob,admins,/bin/bash
charlie,developers,/bin/zsh
```

---

#### Bonus exercise solution 💡

```bash
#!/bin/bash
# User creation script

CSV_FILE="users.csv"
REPORT="users_report.txt"

echo "===== Creation report =====" > $REPORT
echo "Date: $(date)" >> $REPORT
echo >> $REPORT

while IFS=',' read -r username group shell; do
    # Skip header
    [[ "$username" == "name" ]] && continue
    
    echo "Creating $username..."
    
    # Create user
    sudo useradd -m -s "$shell" "$username" 2>/dev/null
    
    # Create group if needed
    sudo groupadd "$group" 2>/dev/null
    
    # Add to group
    sudo usermod -aG "$group" "$username"
    
    # Generate password
    PASSWORD=$(openssl rand -base64 12)
    echo "$username:$PASSWORD" | sudo chpasswd
    
    # Report
    echo "User: $username" >> $REPORT
    echo "Group: $group" >> $REPORT
    echo "Shell: $shell" >> $REPORT
    echo "Password: $PASSWORD" >> $REPORT
    echo "---" >> $REPORT
    
done < "$CSV_FILE"

echo "Done! See $REPORT"
```

---

### Key takeaways 📌

<div class="text-xs">

**Security:**
- Never work as root
- Use sudo only when needed
- Minimum rights

**Good practices:**
- Use groups to organize
- Use umask for secure defaults
- Document sudo configuration

**Essential commands:**
- `useradd`, `usermod`, `userdel`
- `groupadd`, `groupmod`, `gpasswd`
- `chmod`, `chown`, `chgrp`
- `sudo`, `visudo`

</div>
