---
layout: new-section
routeAlias: 'commandes-basiques'
---

<a name="commandes-basiques" id="commandes-basiques"></a>

# 🗂️ Base commands - files, text & shell

---
layout: default
---

# Navigation commands 🧭

### Moving around the system

**pwd (Print Working Directory)**
```bash
pwd                        # Show current directory
pwd -P                     # Physical path (no symlinks)
```

**cd (Change Directory)**
```bash
cd                         # Go to home
cd /absolute/path          # Absolute path
cd relative/path           # Relative path
cd ..                      # Go up one level
cd -                       # Previous directory
cd ~                       # Home directory
```

**ls (List)**
```bash
ls                         # Simple list
ls -la                     # Detailed, include hidden
ls -lh                     # Human-readable sizes
ls -R                      # Recursive
ls -t                      # Sort by time
ls -S                      # Sort by size
```

---
layout: default
---

# File operations 📁

### Create, copy, move, delete

**mkdir (Make Directory)**
```bash
mkdir name                 # Create a directory
mkdir -p full/path         # Create parents as needed
mkdir dir1 dir2 dir3       # Create several
```

**cp (Copy)**
```bash
cp source dest             # Copy a file
cp -r source dest          # Copy a directory
cp -v source dest          # Verbose
cp -i source dest          # Interactive (confirm)
cp -p source dest          # Preserve attributes
# classic cp = new file with new date + permissions by default, -p keep the original date and permissions
```

**mv (Move)**
```bash
mv oldfile.txt newfile.txt                 # Rename
mv file dest/              # Move
mv -i file dest/           # Interactive
mv -v file dest/           # Verbose
```

---
layout: default
---

# Delete commands 🗑️

### Remove files and directories

**rm (Remove)**
```bash
rm file                    # Remove a file
rm -f file                 # Force (no prompt)
rm -i file                 # Interactive
rm -v file                 # Verbose
rm file1 file2             # Multiple files
```

**rmdir (Remove Directory)**
```bash
rmdir dir                  # Remove empty directory
rmdir -p path/to/dir       # Remove empty parents
```

**rm with advanced options**
```bash
rm -r dir                  # Recursive (directory + contents)
rm -rf dir                 # Force recursive (dangerous!)
rm -I dir                  # Prompt once before bulk delete (GNU rm)
```

---
layout: default
---

# Viewing commands 📄

### Display file contents

**cat (Concatenate)**
```bash
cat file                   # Print entire file
cat file1 file2            # Concatenate files to show the content of the files
cat > newfile              # Create file (Ctrl+D to finish) (overwrite the file if exist)
cat >> file                # Appenda at the end of the file
```

**less and more**
```bash
less file                  # Interactive pager (scroll, search, navigation)
more file                  # Page by page (basic pager, older tool)
# In less: space (next page), b (prev page), q (quit)
```

**head and tail**
```bash
head file                  # First 10 lines of the file
head -n 20 file            # First 20 lines
tail file                  # Last 10 lines of the file
tail -n 20 file            # Last 20 lines of the file
tail -f file               # Follow in real time the file (like tail -f /var/log/*.log), very useful to see the logs in real time
```

---
layout: default
---

# Text editors 📝

### Edit files from the command line

**nano (beginner-friendly)**
```bash
nano file.txt              # Open/create
# Ctrl+O: Save
# Ctrl+X: Quit
# Ctrl+K: Cut line (if you cut the line , you can paste it with Ctrl+U)
# Ctrl+U: Paste
```

**vim/vi (advanced)**
```bash
vim file.txt               # Open in vim
# i: Insert mode
# Esc: Command mode
# :w: Save
# :q: Quit
# :wq: Save and quit
# :q!: Quit without saving
```

**Quick edit with echo**
```bash
echo "content" > file.txt  # Overwrite
echo "more" >> file.txt    # Append
```

---
layout: default
---

# Search commands 🔍

### Find information

**grep (Global Regular Expression Print)**
```bash
grep "pattern" file        # Search lines matching pattern (basic regex search in file)
grep -i "pattern" file     # Case-insensitive search (ignores upper/lower case differences)
grep -v "pattern" file     # Invert match (shows lines that DO NOT match the pattern)
grep -r "pattern" dir      # Recursive search inside directory (search all files inside folders)
grep -n "pattern" file     # Show matching lines with line numbers
grep -l "pattern" *        # Show only filenames that contain matches (no line content)
```

**find**
```bash
find . -name "file.txt"    # By name
find . -type f             # Files only
find . -type d             # Directories only
find . -size +100M         # Larger than 100MB
find . -mtime -7           # Modified in last 7 days
find . -user username      # Owned by user
```

---
layout: default
---

# Text processing 📝

### Manipulate text

**echo**
```bash
echo "text"                # Print text
echo -n "text"             # No newline
echo $VAR                  # Print variable
echo -e "line\nnext"       # Interpret escapes
```

**sed (Stream Editor)**
```bash
sed 's/old/new/g' file     # Replace into the file you choose
sed '1,5d' file              # Delete lines 1 to 5 into the file you choose
sed 's/^/prefix/' file       # Prefix lines into the file you choose
sed 's/$/suffix/' file       # Suffix lines into the file you choose
```

**awk**
```bash
awk '{print $1}' file       # First column into the file you choose
awk '{print $1, $3}' file   # Columns 1 and 3
awk '/pattern/' file         # Lines matching pattern into the file you choose
awk '{sum += $1} END {print sum}' file  # Sum column 1
```

---

exemple with awk : 

you have this file : 

```bash
10 alice
20 bob
30 charlie
```

```bash
awk '{sum += $1} END {print sum}' file
# output : 60
```

> awk = analyze + split + calculate

---
layout: default
---

# Sort and filter 📊

### Organize data

**sort**
```bash
sort file                  # Alphabetical sort
sort -n file               # Numeric sort
sort -r file               # Reverse
sort -k2 file              # Sort by 2nd column
sort -u file               # Unique lines
```

**uniq**
```bash
uniq file                  # Drop adjacent duplicates
uniq -c file               # Count occurrences
uniq -d file               # Only duplicates
sort file | uniq           # Classic combo
```

**wc (Word Count)**
```bash
wc file                    # Lines, words, chars
wc -l file                 # Lines only
wc -w file                 # Words only
wc -c file                 # Characters only
```

---
layout: default
---

# Compression 📦

### Compress and decompress

**gzip/gunzip**
```bash
gzip file                  # Compress (removes original)
gzip -k file               # Keep original
gunzip file.gz             # Decompress
gzip -d file.gz            # Decompress (alt)
```

**tar (Tape Archive)**
```bash
tar -czf archive.tar.gz dir/   # Create compressed archive
tar -xzf archive.tar.gz        # Extract
tar -cJf archive.tar.xz dir/   # xz compress
tar -xJf archive.tar.xz        # Extract xz
tar -tf archive.tar.gz         # List contents
```

**zip/unzip** *(optional - `apt install zip` on minimal server images)*

```bash
zip archive.zip file       # Create zip
zip -r archive.zip dir/    # Recursive
unzip archive.zip          # Extract
unzip -l archive.zip       # List
```

---
layout: default
---

# Network commands 🌐

### Network setup and tests

**ping**
```bash
ping google.com            # Connectivity test
ping -c 4 google.com       # Only 4 pings
ping -i 2 google.com       # 2 second interval
ping -s 1000 google.com    # 1000 byte packets
```

**netstat** *(old tool - not on Ubuntu Server by default; use `ss` below)*

```bash
# apt install net-tools   # if you need netstat
netstat -tuln              # Listening ports
netstat -i                 # Network interfaces
netstat -r                 # Routing table
netstat -s                 # Statistics
```

**ss (Socket Statistics)**
```bash
ss -tuln                   # Listening ports (modern) #  tuln = tcp + udp + listening + numeric
ss -i                      # Detailed info # i = interface
ss -s                      # Summary stats # s = summary
```

---
layout: default
---

# System commands ⚙️

### System information

**uname**
```bash
uname                      # System name
uname -a                   # All info
uname -r                   # Kernel version
uname -m                   # Architecture
```

**who and w**
```bash
who                        # Logged-in users # who = who is logged in and what they are doing
whoami                     # Current username
w                          # Users and their processes , example of output : 
# user     tty      login@   idle   what      where
# root     pts/0    2026-06-28 10:00:00 alice  -
# alice    pts/1    2026-06-28 10:00:00 alice  -
# bob      pts/2    2026-06-28 10:00:00 bob    -
# charlie  pts/3    2026-06-28 10:00:00 charlie  -
```

**date and time**
```bash
date                       # Current date/time
date +%Y-%m-%d             # Custom format
time command               # Time a command
```

---
layout: default
---

# Process commands ⚡

### Manage processes

**ps (Process Status)**
```bash
ps                         # Your processes
ps aux                     # All processes
ps -ef                     # Extended format
ps -p PID                  # Specific PID
ps -u user                 # User’s processes
```

**top and htop**
```bash
top                        # Live processes
htop                       # Improved UI
# top keys: q (quit), k (kill), r (renice), h (help)
```

**kill and pkill**
```bash
kill PID                   # Terminate process
kill -9 PID                # Force kill
killall process_name       # Kill by name
pkill process_name         # Modern alternative
```

---
layout: default
---

# Monitoring commands 📊

### Watch the system

**df (Disk Free)**
```bash
df                         # Disk space
df -h                      # Human-readable
df -i                      # Inode usage
df -T                      # Filesystem type
```

**du (Disk Usage)**
```bash
du                         # Usage of current dir
du -h                      # Human-readable
du -sh *                   # Size of each item
du -d 1                    # Depth 1
```

**free**
```bash
free                       # Memory usage
free -h                    # Human-readable
free -s 5                  # Refresh every 5s
```

---
layout: default
---

# Redirection 🔄

### Control stdin/stdout/stderr

<div class="text-xs">

- Stderr is the standard error output, it is used to display error messages.
- Stdout is the standard output, it is used to display the output of a command.
- Stdin is the standard input, it is used to read the input of a command.

</div>

**Output redirection**
```bash
command > file             # Overwrite
command >> file            # Append
command 2> file            # Stderr to file
command &> file            # Stdout + stderr
```

**Input redirection**
```bash
command < file             # Read from file
cat < file                 # Print content
```

**Pipes**
```bash
command1 | command2        # Pipe stdout to stdin
ls -la | grep "file"       # Filter output
ps aux | grep "process"    # Find process
cat file | sort | uniq     # Chain commands
```

---
layout: default
---

# Variables 🌍

### Define variables

```bash
VAR=value                    # This shell only - child processes do NOT see it
export VAR=value             # Environment var - inherited by child processes
export PATH=$PATH:/new/path  # Same rule: lasts for this shell session
```

---

# Variable lifetime ⏱️

**Both** `VAR=value` and `export VAR=value` die when the **shell session ends** (close terminal, logout, SSH disconnect).

| Scope | Visible in current shell | Passed to `child` commands | Survives logout |
|-------|--------------------------|----------------------------|-----------------|
| `VAR=value` | ✅ | ❌ | ❌ |
| `export VAR=value` | ✅ | ✅ | ❌ |

**Persist across logins:** write to `~/.bashrc`, `~/.profile`, or `/etc/environment`, then re-login (or `source` for the current shell only).

```bash
unset VAR                    # Remove from this session immediately
```

---

# Important system variables

These variables are important for the system and are used by the shell.

```bash
echo $HOME                 # User home
echo $USER                 # Username
echo $PWD                  # Current directory
echo $SHELL                # Current shell
echo $PATH                 # Search path
```

**Positional parameters**
```bash
echo $1 $2 $3              # CLI arguments (like an function arguments, function Name(arg1, arg2, arg3))
echo $#                    # Argument count # # = number of arguments (arg 1 = 1, arg 2 = 2, arg 3 = 3, 3 args total count)
echo $@                    # All arguments show all the arguments (arg1, arg2, arg3)
echo $?                    # Last exit code
```

---

Example : 

```bash
#!/bin/bash
echo "arg1: $1"
echo "arg2: $2"
echo "count: $#"
echo "all: $@"
```

run the script : 

```bash
./script.sh hello world
```

Output : 

```bash
arg1: hello
arg2: world
count: 2
all: hello world
```

---
layout: default
---

# Scripting basics 📝

### Simple automation

**Create a script**
```bash
#!/bin/bash (is the shebang, it is used to tell the system which interpreter to use)
# My first script
echo "Hello World!"
echo "Date: $(date)"
echo "User: $USER"
```

**Run a script**
```bash
chmod +x script.sh         # Make executable
./script.sh                # Run with the interpreter from the shebang (e.g. #!/bin/bash)
bash script.sh             # Run explicitly with bash (Bourne Again Shell - sh-compatible, but its own shell)
source script.sh           # Run in current shell (no fork; variables stay in this shell)
```

**Variables in scripts**
```bash
#!/bin/bash
NAME="John"
echo "Hello $NAME"
echo "Args: $1 $2 $3"
echo "Arg count: $#"
```

---
layout: default
---

### Best practices 💡

<div class="text-xs">

**Safety**
- Always verify before deleting
- Use `-i` for destructive commands
- Back up regularly
- Do not run unknown commands

**Productivity**
- Use tab completion
- Create aliases for frequent commands
- Use history efficiently
- Combine commands with pipes

**Organization**
- Structure directories logically
- Use descriptive filenames
- Document scripts
- Keep the environment tidy

</div>

Go to **users & sudo** next 🎯