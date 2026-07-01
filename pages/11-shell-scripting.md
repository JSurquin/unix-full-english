---
layout: intro
routeAlias: 'shell-scripting'
---

# Shell Scripting 📝

### Automation with shell scripts

<div class="pt-12">
  <span @click="next" class="px-2 p-3 rounded cursor-pointer hover:bg-white hover:bg-opacity-10 neon-border">
    Let's automate with scripts <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: default
---

# Core concepts 🔧

### What is a shell script?

**Definition:**
- Text file containing commands
- Executed by a shell interpreter
- Automates repetitive tasks
- Can be run like any command

**Benefits:**
- Task automation
- Reusability
- Documents operational procedures
- Saves time

**Script categories:**
- **Maintenance scripts**: Cleanup, backups
- **Installation scripts**: Automated setup
- **Monitoring scripts**: System observation
- **Deployment scripts**: Release and rollout

---
layout: default
---

# Script structure 📋

### Essential elements

**Shebang (first line):**
```bash
#!/bin/bash
# or
#!/bin/sh
# or
#!/usr/bin/env bash
```

**Comments:**
```bash
# This is a single-line comment

: '
This is a
multi-line comment
'
```

**Basic layout:**
```bash
#!/bin/bash
# Script name: my_script.sh
# Author: Your name
# Date: 2026-01-01
# Description: What the script does

# Variables
NAME="My Script"

# Functions
my_function() {
    echo "Function called"
}

# Main body
echo "Start of script"
my_function
echo "End of script"
```

---
layout: default
---

# Variables and parameters 📊

### Working with variables

**Declaring variables:**
```bash
# Simple variables
NOM="John"
AGE=25
PI=3.14159

# Environment variables
export PATH=$PATH:/usr/local/bin
export EDITOR=vim

# Read-only variables
readonly VERSION="1.0"
```

**Command-line parameters:**
```bash
# $0 = script name
# $1, $2, $3... = arguments
# $# = argument count
# $@ = all arguments
# $* = all arguments as one string

echo "Script name: $0"
echo "First argument: $1"
echo "Argument count: $#"
echo "All arguments: $@"
```

**Special variables:**
```bash
$?          # Exit status of last command
$$          # PID of this shell
$!          # PID of last background process
$RANDOM     # Random number
```

---
layout: default
---

# Control structures 🔄

### Conditions and loops

**if/else:**
```bash
if [ condition ]; then
    commands
elif [ other_condition ]; then
    commands
else
    commands
fi

# Example
if [ -f file.txt ]; then
    echo "File exists"
else
    echo "File does not exist"
fi
```

**for loops:**
```bash
# Loop over a list
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# Loop over files
for file in *.txt; do
    echo "Processing $file"
done

# Numeric sequence
for i in {1..10}; do
    echo "Iteration $i"
done
```

---
layout: default
---

# Control structures 🔄

### Advanced loops and conditions

**while loop:**
```bash
# while loop
counter=1
while [ $counter -le 5 ]; do
    echo "Counter: $counter"
    counter=$((counter + 1))
done

# Infinite loop with break
while true; do
    echo "Press Ctrl+C to stop"
    sleep 1
done
```

**until loop:**
```bash
# until (runs until condition is true)
counter=1
until [ $counter -gt 5 ]; do
    echo "Counter: $counter"
    counter=$((counter + 1))
done
```

**case statement:**
```bash
case $1 in
    "start")
        echo "Starting..."
        ;;
    "stop")
        echo "Stopping..."
        ;;
    "restart")
        echo "Restarting..."
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        ;;
esac
```

---
layout: default
---

# Tests and comparisons 🧪

### Test operators

**File tests:**
```bash
[ -f file ]     # Exists and is a regular file
[ -d dir ]       # Exists and is a directory
[ -r file ]     # Readable
[ -w file ]     # Writable
[ -x file ]     # Executable
[ -s file ]     # Non-empty
[ -e file ]     # Exists
```

**String comparisons:**
```bash
[ "$a" = "$b" ]    # Equal
[ "$a" != "$b" ]   # Not equal
[ -z "$a" ]        # Empty
[ -n "$a" ]        # Non-empty
[ "$a" < "$b" ]    # Lexicographic order
```

**Numeric comparisons:**
```bash
[ $a -eq $b ]      # Equal
[ $a -ne $b ]      # Not equal
[ $a -lt $b ]      # Less than
[ $a -le $b ]      # Less or equal
[ $a -gt $b ]      # Greater than
[ $a -ge $b ]      # Greater or equal
```

---
layout: default
---

# Functions 📦

### Defining and calling functions

**Function definitions:**
```bash
# Simple function
my_function() {
    echo "Function called"
}

# Function with parameters
salutation() {
    local name=$1
    echo "Hello $name"
}

# Function returning an exit code (0–255)
addition() {
    local a=$1
    local b=$2
    local sum=$((a + b))
    return $sum
}
```

**Calling functions:**
```bash
# Call function
my_function

# Call with arguments
salutation "John"

# Read exit status as return
addition 5 3
result=$?
echo "Result: $result"
```

---
layout: default
---

# Error handling ⚠️

### Working with errors

**Strict mode options:**
```bash
#!/bin/bash
set -e          # Exit on first failure
set -u          # Error on unset variables
set -o pipefail # Pipeline fails if any command fails
```

**Manual error checks:**
```bash
# Check exit status
cmd
if [ $? -ne 0 ]; then
    echo "Error running command"
    exit 1
fi

# Short form
cmd || { echo "Error"; exit 1; }
```

**trap for cleanup:**
```bash
# Cleanup function
cleanup() {
    echo "Cleaning up..."
    rm -f temp_file
}

# Signal handlers
trap cleanup EXIT
trap 'echo "Interrupt received"; exit 1' INT TERM
```

---
layout: default
---

# Input and output 🔄

### stdin, stdout, stderr

**Reading user input:**
```bash
# Simple read
read name
echo "Hello $name"

# Prompt
read -p "Enter your name: " name

# Silent (e.g. password)
read -s -p "Password: " password

# Timeout
read -t 10 -p "Answer quickly: " answer
```

**Output redirection:**
```bash
# Redirect to file
echo "Content" > outfile.txt
echo "Append" >> outfile.txt

# Redirect stderr
cmd 2> errors.log

# Redirect both stdout and stderr
cmd &> all.log

# Redirect stdin
cmd < infile.txt
```

---
layout: default
---

# Practical scripts 🛠️

### Useful examples

**Backup script:**
```bash
#!/bin/bash
# Backup script

# Variables
SOURCE="/home/user"
DESTINATION="/backup"
DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE="backup_$DATE.tar.gz"

# Checks
if [ ! -d "$SOURCE" ]; then
    echo "Error: source directory does not exist"
    exit 1
fi

# Create backup
echo "Creating backup..."
tar -czf "$DESTINATION/$ARCHIVE" -C "$SOURCE" .

if [ $? -eq 0 ]; then
    echo "Backup created: $ARCHIVE"
else
    echo "Backup failed"
    exit 1
fi
```

---
layout: default
---

# Practical scripts 🛠️

### Useful examples

**System monitoring script:**
```bash
#!/bin/bash
# Monitoring script

# Variables
LOG_FILE="/var/log/system_monitor.log"
THRESHOLD=80

# Logging helper
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Disk usage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    log_message "ALERT: disk usage at ${DISK_USAGE}%"
fi

# Memory usage
MEM_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ "$MEM_USAGE" -gt "$THRESHOLD" ]; then
    log_message "ALERT: memory usage at ${MEM_USAGE}%"
fi
```

---
layout: default
---

# Practical scripts 🛠️

### Useful examples

**Automated setup script:**
```bash
#!/bin/bash
# Setup script

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Status helper
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ $2${NC}"
    else
        echo -e "${RED}✗ $2${NC}"
        exit 1
    fi
}

# System update
echo "Updating system..."
sudo apt update && sudo apt upgrade -y
print_status $? "System update done"

# Install packages
echo "Installing packages..."
sudo apt install -y htop vim git curl wget
print_status $? "Package install done"

# Configuration
echo "Configuration..."
mkdir -p ~/projects
print_status $? "Configuration done"

echo "Setup completed successfully!"
```

---
layout: default
---

# Debugging 🐛

### Debugging techniques

**Debug options:**
```bash
#!/bin/bash
set -x          # Trace commands as they run
set -v          # Echo input lines as read
set -n          # Syntax check only (no execution)

# Or enable for a section
set -x
# Code to debug
set +x
```

**Debug output:**
```bash
# Print variables
echo "DEBUG: NAME=$NAME"
echo "DEBUG: AGE=$AGE"

# printf for formatting
printf "DEBUG: NAME='%s', AGE='%d'\n" "$NAME" "$AGE"
```

**Structured logging:**
```bash
# Log with level
log() {
    local level=$1
    shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" >> /var/log/script.log
}

log "INFO" "Script start"
log "ERROR" "An error occurred"
```

---
layout: default
---

# Best practices 💡

### Writing maintainable scripts

**Structure and layout:**
```bash
#!/bin/bash
# =============================================================================
# Script: my_script.sh
# Author: Your name
# Date : 2026-01-01
# Version : 1.0
# Description: Detailed script purpose
# =============================================================================

# Configuration
set -euo pipefail

# Globals
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/var/log/script.log"

# Functions
main() {
    echo "Start of script"
    # Main logic here
    echo "End of script"
}

# Entry point
main "$@"
```

---
layout: default
---

# Best practices 💡

### Writing maintainable scripts

**Security:**
- Always validate user input
- Use absolute paths when it matters
- Avoid unnecessary `eval`
- Check file permissions

**Readability:**
- Use descriptive variable names
- Comment non-obvious logic
- Keep structure linear and clear
- Use functions for reuse

**Robustness:**
- Handle errors explicitly
- Clean up temporary files
- Use timeouts for long-running commands
- Test before production use

---
layout: default
---

# Hands-on exercises 🎯

### Practice

**Exercise 1: Basic script**
```bash
#!/bin/bash
# Build a script that:
# 1. Prints a welcome message
# 2. Asks for the user's name
# 3. Prints "Hello [name]"
# 4. Prints the current date

echo "Welcome!"
read -p "Enter your name: " name
echo "Hello $name"
echo "Current date: $(date)"
```

**Exercise 2: Conditional script**
```bash
#!/bin/bash
# Build a script that:
# 1. Checks whether a file exists
# 2. If yes, prints its size
# 3. If no, creates the file

file="test.txt"
if [ -f "$file" ]; then
    size=$(wc -c < "$file")
    echo "File $file exists, size: $size bytes"
else
    echo "Creating file $file"
    touch "$file"
fi
```

---
layout: default
---

# Next steps 🎯

### What comes next

1. **Virtualization** and containers
2. **Docker** introduction
3. Integrating **final project**
4. **Quiz** for validation

**Preparation:**
- Practice short scripts
- Get comfortable with control flow
- Experiment with error handling
- Build small utility scripts
