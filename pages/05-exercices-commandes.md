---

# 🎯 Hands-on exercises - Module 2

**Mastering basic commands**

---

# Exercise 1: Navigation 🗺️

**Goal:** Move around the system

**Instructions:**

1. Show your current directory
2. List the contents of `/usr/bin`
3. Go to `/tmp`
4. Return to your home directory
5. Show the full path of `/tmp`
6. Go back to the previous directory with `cd -`

---

# Solution Exercise 1 💡

```bash
# 1. Current directory
pwd

# 2. Contents of /usr/bin
ls /usr/bin

# With details
ls -l /usr/bin

# Only the first 20
ls /usr/bin | head -20

# 3. Go to /tmp
cd /tmp

# 4. Back to home
cd
# or
cd ~

# 5. Full path of /tmp
realpath /tmp
# or
readlink -f /tmp

# 6. Previous directory
cd -
```

---

# Exercise 2: File operations 📁

**Goal:** Create, copy, move, rename

**Instructions:**

1. Create a `test` directory in your home
2. In `test`, create 5 files: `file1.txt` through `file5.txt`
3. Copy `file1.txt` to `file1_backup.txt`
4. Rename `file2.txt` to `document.txt`
5. Move `file3.txt` to your home
6. Create a subdirectory `archive`
7. Move all remaining files into `archive`

---

# Solution Exercise 2 💡

```bash
# 1. Create directory
mkdir ~/test
cd ~/test

# 2. Create 5 files
touch file{1..5}.txt
# or
touch file1.txt file2.txt file3.txt file4.txt file5.txt

# Verify
ls -l

# 3. Copy
cp file1.txt file1_backup.txt

# 4. Rename
mv file2.txt document.txt

# 5. Move
mv file3.txt ~/

# 6. Create subdirectory
mkdir archive

# 7. Move remaining files
mv *.txt archive/

# Verify
ls -la
ls -la archive/
```

---

# Exercise 3: Display and search 🔍

**Goal:** View and search content

**Instructions:**

1. Create `numbers.txt` with numbers 1 to 100
2. Display everything
3. Show only the first 10 lines
4. Show only the last 10 lines
5. Search for the number "42"
6. Count lines in the file

---

# Solution Exercise 3 💡

```bash
# 1. Create file with numbers
seq 1 100 > numbers.txt

# Verify
ls -l numbers.txt

# 2. Print all
cat numbers.txt

# 3. First 10 lines
head numbers.txt
# or
head -n 10 numbers.txt

# 4. Last 10 lines
tail numbers.txt
# or
tail -n 10 numbers.txt

# 5. Search for 42
grep "42" numbers.txt
# Result: 42 (and 142 if range extended)

# Exact match
grep "^42$" numbers.txt

# 6. Count lines
wc -l numbers.txt
# or
cat numbers.txt | wc -l
```

---

# Exercise 4: Redirections and pipes 🔄

**Goal:** Master redirections

**Instructions:**

1. List `/etc` and save to `liste_etc.txt`
2. Append the date to that file
3. Create a file with "Hello" then append "World"
4. Count how many `.conf` files are in `/etc`
5. Find the 5 largest files in `/var/log`

---

# Solution Exercise 4 💡

```bash
# 1. List and save
ls /etc > liste_etc.txt

# Verify
wc -l liste_etc.txt

# 2. Append date
date >> liste_etc.txt

# Verify
tail liste_etc.txt

# 3. Progressive content
echo "Hello" > message.txt
echo "World" >> message.txt

# Verify
cat message.txt

# 4. Count .conf files
ls /etc/*.conf 2>/dev/null | wc -l
# or
find /etc -name "*.conf" 2>/dev/null | wc -l

# 5. Largest files in /var/log
sudo du -h /var/log/* 2>/dev/null | sort -hr | head -5
# or
sudo find /var/log -type f -exec du -h {} + 2>/dev/null | \
    sort -hr | head -5
```

---

# Exercise 5: Advanced search 🎯

**Goal:** Use find and grep effectively

**Instructions:**

1. Find all `.txt` files under your home
2. Find files modified in the last 24 hours
3. Find files larger than 1 MB
4. Create `log.txt` with different levels (INFO, ERROR, WARN)
5. Extract only ERROR lines

---

# Solution Exercise 5 💡

```bash
# 1. All .txt under home
find ~ -name "*.txt" 2>/dev/null

# With details
find ~ -name "*.txt" -ls 2>/dev/null

# 2. Modified in last 24h
find ~ -mtime -1 2>/dev/null

# 3. Files > 1 MB
find ~ -size +1M 2>/dev/null

# With sizes
find ~ -size +1M -exec ls -lh {} \; 2>/dev/null

# 4. Create log file
cat > log.txt << EOF
2025-11-24 10:00:00 INFO Application started
2025-11-24 10:05:00 ERROR Connection failed
2025-11-24 10:10:00 WARN Low memory
2025-11-24 10:15:00 INFO Processing
2025-11-24 10:20:00 ERROR Database unreachable
2025-11-24 10:25:00 INFO Processing done
EOF

# 5. Extract ERROR
grep ERROR log.txt

# With color
grep --color ERROR log.txt

# Count errors
grep -c ERROR log.txt

# With line numbers
grep -n ERROR log.txt
```

---

# Exercise 6: Combining commands 🔗

**Goal:** Chain several commands

**Instructions:**

1. List processes, search for "bash", count them
2. Print `/etc/passwd`, sort it, take the first 10
3. Show your disk usage sorted by size
4. List `/bin`, count how many names start with "s"
5. Create a one-liner that shows the time every 5 seconds

---

# Solution Exercise 6 💡

```bash
# 1. bash processes
ps aux | grep bash | wc -l

# 2. Sorted /etc/passwd
cat /etc/passwd | sort | head -10
# or
sort /etc/passwd | head -10

# 3. Disk usage sorted
du -h ~ | sort -hr | head -20

# 4. Commands starting with "s"
ls /bin | grep "^s" | wc -l

# 5. Time every 5s
while true; do clear; date; sleep 5; done
# Ctrl+C to stop

# Alternative with watch
watch -n 5 date
```

---

# Bonus exercise: cleanup script 🧹

**Goal:** Build a useful script

**Create `cleanup.sh` that:**
- Finds temp files (`.tmp`, `.bak`)
- Lists them
- Asks for confirmation
- Deletes them
- Shows a summary

---

# Solution bonus exercise 💡

```bash
#!/bin/bash
# Cleanup script

echo "===== Cleanup script ====="
echo

# Find temp files
echo "Searching for temp files..."
TMP_FILES=$(find ~ -name "*.tmp" -o -name "*.bak" 2>/dev/null)

if [ -z "$TMP_FILES" ]; then
    echo "✅ No temp files found"
    exit 0
fi

# List files
echo "Files found:"
echo "$TMP_FILES"
echo

# Count
COUNT=$(echo "$TMP_FILES" | wc -l)
echo "Total: $COUNT file(s)"

# Confirm
read -p "Delete them? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Delete
    echo "$TMP_FILES" | while read file; do
        rm "$file"
        echo "  ✓ Removed: $file"
    done
    echo
    echo "✅ Done: $COUNT file(s) removed"
else
    echo "❌ Cancelled"
fi
```

**Usage:**

```bash
chmod +x cleanup.sh
./cleanup.sh
```

---

<small>

### Key takeaways 📌

<div class="text-xs">

**Navigation:**
- `pwd`, `cd`, `ls`
- Absolute vs relative paths
- `cd -` to go back

**File ops:**
- `mkdir`, `touch`
- `cp`, `mv`, `rm`
- `-r` for recursive

**Viewing:**
- `cat`, `less`, `more`
- `head`, `tail`
- `grep` to search

**Redirections:**
- `>` overwrites
- `>>` appends
- `|` pipes between commands

</div>

</small>
