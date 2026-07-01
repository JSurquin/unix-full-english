---

# 🎯 Hands-on exercises - Module 1

**Put Unix/Linux fundamentals into practice**

---

# Exercise 1: Navigating the system 🗺️

**Goal:** Master navigation and basic commands

**Instructions:**

1. Show your current directory
2. List all files (including hidden) in `/etc`
3. Go to your home directory
4. Create the following directory tree:

```
training/
├── documents/
├── scripts/
└── backup/
```

5. Create an empty file `test.txt` in `documents/`
6. Show the absolute path to that file

---

# Exercise 1 solution 💡

```bash
# 1. Current directory
pwd

# 2. List /etc including hidden files
ls -la /etc

# 3. Go to home directory
cd ~
# or
cd

# 4. Create the directory tree
mkdir -p training/{documents,scripts,backup}

# 5. Create the file
touch training/documents/test.txt

# 6. Absolute path
realpath training/documents/test.txt
# or
readlink -f training/documents/test.txt
```

---

# Exercise 2: File operations 📄

**Goal:** Create, copy, move, and delete files

**Instructions:**

1. Create a file `infos.txt` containing your name and the date
2. Copy it into the `backup/` folder
3. Rename the copy to `infos_backup.txt`
4. Create five files: `file1.txt` through `file5.txt`
5. Delete `file3.txt`
6. Move all remaining files into `documents/`

---

# Exercise 2 solution 💡

```bash
# 1. Create the file with content
echo "Name: $(whoami)" > training/infos.txt
echo "Date: $(date)" >> training/infos.txt

# 2. Copy to backup
cp training/infos.txt training/backup/

# 3. Rename
mv training/backup/infos.txt training/backup/infos_backup.txt

# 4. Create five files
touch training/file{1..5}.txt

# 5. Delete file3
rm training/file3.txt

# 6. Move remaining files
mv training/file*.txt training/documents/
```

---

# Exercise 3: Search and filtering 🔍

**Goal:** Use grep, find, and pipes

**Instructions:**

1. Create a file `users.txt` with this content:

```
alice:admin:alice@example.com
bob:user:bob@example.com
charlie:admin:charlie@example.com
david:user:david@example.com
```

2. Show only lines containing "admin"
3. Count the total number of lines
4. Show only the email addresses
5. Find all `.txt` files under `training/`

---

# Exercise 3 solution 💡

```bash
# 1. Create the file
cat > training/users.txt << EOF
alice:admin:alice@example.com
bob:user:bob@example.com
charlie:admin:charlie@example.com
david:user:david@example.com
EOF

# 2. Lines with "admin"
grep "admin" training/users.txt

# 3. Count lines
wc -l training/users.txt
# or
cat training/users.txt | wc -l

# 4. Show only emails (3rd field)
cut -d':' -f3 training/users.txt
# or
awk -F':' '{print $3}' training/users.txt

# 5. Find all .txt files
find training/ -name "*.txt"
```

---

# Exercise 4: Redirections and pipes 🔄

**Goal:** Master redirections and command chaining

**Instructions:**

1. List all files in `/etc` and save the list to `etc_files.txt`
2. Count how many filenames contain "conf"
3. Show only the first 10 files
4. Create an `errors.log` file that captures errors from a command
5. Build a pipeline that:
   - Lists processes
   - Keeps those containing "bash"
   - Counts how many there are

---

# Exercise 4 solution 💡

```bash
# 1. Save the list
ls /etc > training/etc_files.txt

# 2. Count files with "conf" in the name
ls /etc | grep "conf" | wc -l

# 3. First 10 files
ls /etc | head -10

# 4. Capture errors
ls /root 2> training/errors.log
# The command normally fails; errors go to the file

# 5. Command pipeline
ps aux | grep bash | wc -l
```

---

# Exercise 5: Advanced text manipulation 📝

**Goal:** Use sed, awk, and related tools

**Instructions:**

1. Create a file `log.txt` with simulated log lines
2. Replace every "ERROR" with "CRITICAL" using sed
3. Show only the 2nd column with awk
4. Sort the file alphabetically
5. Remove duplicate lines

**Sample content:**

```
2025-11-24 INFO Startup
2025-11-24 ERROR Connection failed
2025-11-24 INFO Retry attempt 2
2025-11-24 ERROR Timeout
2025-11-24 INFO Success
```

---

# Exercise 5 solution 💡

```bash
# 1. Create the file
cat > training/log.txt << EOF
2025-11-24 INFO Startup
2025-11-24 ERROR Connection failed
2025-11-24 INFO Retry attempt 2
2025-11-24 ERROR Timeout
2025-11-24 INFO Success
EOF

# 2. Replace ERROR with CRITICAL
sed 's/ERROR/CRITICAL/g' training/log.txt > training/log_critical.txt

# 3. Show the 2nd column
awk '{print $2}' training/log.txt

# 4. Sort
sort training/log.txt

# 5. Remove duplicates
sort training/log.txt | uniq
# or directly
sort -u training/log.txt
```

---

# Bonus exercise: System information script 🖥️

**Goal:** Write a useful first script

**Create a script `sysinfo.sh` that displays:**
- Username
- Current directory
- Date and time
- Available disk space
- Number of running processes

---

# Bonus exercise solution 💡

```bash
#!/bin/bash
# System information script

echo "===== System information ====="
echo
echo "User: $(whoami)"
echo "Directory: $(pwd)"
echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo
echo "===== Disk space ====="
df -h /
echo
echo "===== Processes ====="
echo "Process count: $(ps aux | wc -l)"
echo
echo "===== System load ====="
uptime
```

**Usage:**

```bash
chmod +x training/scripts/sysinfo.sh
./training/scripts/sysinfo.sh
```

---

# Tips for practice 💡

**How to improve:**

1. **Type the commands yourself**
   - Do not copy-paste only
   - Muscle memory matters

2. **Experiment**
   - Try variants
   - See what happens on errors

3. **Read the manual pages**
   - `man ls`, `man grep`, etc.
   - `-h` or `--help` as well

4. **Use Tab for completion**
   - Saves time
   - Reduces typos

---

# Next step 🎯

**Module 2: Essential basic commands**

Now that you know the concepts, we will cover:
- Essential navigation commands
- Advanced file operations
- Search and filtering tools

---

