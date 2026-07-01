---

# 🎯 Hands-on exercises – Module 8

**Automation, scripts, and scheduled tasks**

---

# Exercise 1: First Bash script 📝

**Goal:** Create a working script

**Instructions:**

Create a script `sysinfo.sh` that displays:
1. Username
2. Hostname
3. Date and time
4. Current directory
5. Available disk space
6. The 5 processes using the most memory

---

# Solution Exercise 1 💡

```bash
#!/bin/bash
# System information script

echo "======================================"
echo "  System Information"
echo "======================================"
echo

echo "User: $(whoami)"
echo "Hostname: $(hostname)"
echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Directory: $(pwd)"
echo

echo "======================================"
echo "  Disk Space"
echo "======================================"
df -h / | tail -1
echo

echo "======================================"
echo "  Top 5 Processes (Memory)"
echo "======================================"
ps aux --sort=-%mem | head -6 | tail -5
echo

echo "======================================"
```

**Usage:**

```bash
chmod +x sysinfo.sh
./sysinfo.sh
```

---

# Exercise 2: Script with arguments 🎯

**Goal:** Handle arguments

**Create `backup.sh` that:**
- Takes 2 arguments: source and destination
- Verifies arguments are provided
- Verifies the source exists
- Creates a tar.gz archive with a timestamp
- Shows success or failure

---

# Solution Exercise 2 💡

```bash
#!/bin/bash
# Backup script

# Check arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source> <destination>"
    echo "Example: $0 /home/user/documents /backup"
    exit 1
fi

SOURCE="$1"
DEST="$2"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="backup_${TIMESTAMP}.tar.gz"

# Verify source exists
if [ ! -d "$SOURCE" ]; then
    echo "❌ Error: $SOURCE does not exist"
    exit 1
fi

# Create destination directory if needed
mkdir -p "$DEST"

# Create archive
echo "Backing up $SOURCE to $DEST/$ARCHIVE..."
tar -czf "$DEST/$ARCHIVE" "$SOURCE" 2>/dev/null

if [ $? -eq 0 ]; then
    SIZE=$(du -h "$DEST/$ARCHIVE" | cut -f1)
    echo "✅ Backup successful! Size: $SIZE"
    ls -lh "$DEST/$ARCHIVE"
else
    echo "❌ Backup failed"
    exit 1
fi
```

---

# Exercise 3: Loops and conditions 🔄

**Goal:** Use control structures

**Create a script that:**
1. Loops over all .log files in /var/log
2. Prints each file name and size
3. Archives files larger than 10 MB
4. Deletes archives older than 30 days

---

# Solution Exercise 3 💡

```bash
#!/bin/bash
# Log management

LOG_DIR="/var/log"
ARCHIVE_DIR="/backup/logs"
MAX_SIZE=10485760  # 10 MB in bytes

mkdir -p "$ARCHIVE_DIR"

echo "Analyzing log files..."

# Loop over .log files
for logfile in $LOG_DIR/*.log; do
    # Skip if not a file
    [ -f "$logfile" ] || continue
    
    filename=$(basename "$logfile")
    size=$(stat -f%z "$logfile" 2>/dev/null || stat -c%s "$logfile")
    size_mb=$(echo "scale=2; $size / 1048576" | bc)
    
    echo "📄 $filename : ${size_mb}MB"
    
    # If > 10 MB, archive
    if [ $size -gt $MAX_SIZE ]; then
        echo "  ⚠️  Large file, archiving..."
        timestamp=$(date +%Y%m%d)
        gzip -c "$logfile" > "$ARCHIVE_DIR/${filename}_${timestamp}.gz"
        
        if [ $? -eq 0 ]; then
            echo "  ✅ Archived"
            # Truncate file (do not delete)
            > "$logfile"
        fi
    fi
done

# Delete archives older than 30 days
echo
echo "Cleaning old archives..."
find "$ARCHIVE_DIR" -name "*.gz" -mtime +30 -delete
echo "✅ Done"
```

---

# Exercise 4: Bash functions 🎭

**Goal:** Create reusable functions

**Create a script with these functions:**
- `log_info()`: print an info message
- `log_error()`: print an error message
- `check_root()`: verify running as root
- `check_command()`: verify a command exists

---

# Solution Exercise 4 💡

```bash
#!/bin/bash
# Script with functions

# Info log function
log_info() {
    echo "[$(date '+%H:%M:%S')] ℹ️  INFO: $1"
}

# Error log function
log_error() {
    echo "[$(date '+%H:%M:%S')] ❌ ERROR: $1" >&2
}

# Check if root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

# Check if a command exists
check_command() {
    if ! command -v $1 &> /dev/null; then
        log_error "Command '$1' not found"
        return 1
    fi
    log_info "Command '$1' found"
    return 0
}

# Example usage
log_info "Starting script"

check_command "git"
check_command "docker"
check_command "kubectl"  # Fails if not installed

log_info "Script finished"
```

---

# Exercise 5: Scheduled tasks with cron ⏰

**Goal:** Automate with cron

**Instructions:**

1. Create a script that cleans `/tmp`
2. Schedule it daily at 2:00 AM
3. Create a job that backs up `/etc` every Monday at 3:00 AM
4. List your cron jobs
5. Redirect output to a log file

---

# Solution Exercise 5 💡

```bash
# 1. Cleanup script
cat > /usr/local/bin/clean_tmp.sh << 'EOF'
#!/bin/bash
find /tmp -type f -mtime +7 -delete
find /tmp -type d -empty -delete
echo "[$(date)] /tmp cleanup done" >> /var/log/clean_tmp.log
EOF

chmod +x /usr/local/bin/clean_tmp.sh

# 2. Edit crontab
crontab -e

# Add:
# /tmp cleanup daily at 2 AM
0 2 * * * /usr/local/bin/clean_tmp.sh

# 3. Backup /etc every Monday at 3 AM
0 3 * * 1 tar -czf /backup/etc_$(date +\%Y\%m\%d).tar.gz /etc

# 4. List jobs
crontab -l

# 5. With redirection
0 2 * * * /usr/local/bin/clean_tmp.sh >> /var/log/cron_clean.log 2>&1
0 3 * * 1 tar -czf /backup/etc_$(date +\%Y\%m\%d).tar.gz /etc >> /var/log/backup.log 2>&1

# Cron syntax examples:
# */5 * * * *     # Every 5 minutes
# 0 */2 * * *     # Every 2 hours
# 0 9-17 * * 1-5  # 9am-5pm, Mon-Fri
# @reboot         # On boot
# @daily          # Daily (midnight)
# @weekly         # Weekly
```

---

# Exercise 6: Logs with journalctl 📜

**Goal:** Filter and analyze logs

**Instructions:**

1. Create a script that analyzes systemd logs
2. Extract errors from the last 24 hours
3. Count errors per service
4. Send a report
5. Run it daily

---

# Solution Exercise 6 💡

```bash
#!/bin/bash
# System log analysis

REPORT="/tmp/log_report_$(date +%Y%m%d).txt"

echo "===== Log analysis report =====" > $REPORT
echo "Date: $(date)" >> $REPORT
echo >> $REPORT

# 1 & 2. Errors from last 24h
echo "📛 Errors from last 24h:" >> $REPORT
journalctl --since "24 hours ago" -p err --no-pager >> $REPORT
echo >> $REPORT

# 3. Count per service
echo "📊 Errors per service:" >> $REPORT
journalctl --since "24 hours ago" -p err --no-pager | \
    grep -oP '(?<=\w{3} \d+ \d+:\d+:\d+ \w+ )\w+' | \
    sort | uniq -c | sort -rn | head -10 >> $REPORT
echo >> $REPORT

# Warnings too
echo "⚠️  Warnings from last 24h:" >> $REPORT
journalctl --since "24 hours ago" -p warning --no-pager | wc -l >> $REPORT
echo >> $REPORT

# Failed services
echo "❌ Failed services:" >> $REPORT
systemctl --failed >> $REPORT 2>&1
echo >> $REPORT

echo "===== End of report =====" >> $REPORT

# Display report
cat $REPORT

# Email (optional)
# mail -s "Log report $(hostname)" admin@example.com < $REPORT
```

---

**Schedule daily at 7 AM:**

```bash
0 7 * * * /usr/local/bin/log_analysis.sh
```

---

# Bonus exercise: Interactive system dashboard 📊

**Goal:** Advanced monitoring script

**Create a script that continuously shows:**
- System load
- Top processes
- Network connections
- Disk space
- Auto-refresh

---

# Solution Bonus exercise 💡

```bash
#!/bin/bash
# Interactive system dashboard

while true; do
    clear
    
    echo "╔════════════════════════════════════════════╗"
    echo "║      SYSTEM DASHBOARD - $(date +%H:%M:%S)      ║"
    echo "╚════════════════════════════════════════════╝"
    echo
    
    # System load
    echo "📊 SYSTEM LOAD"
    uptime
    echo
    
    # CPU and memory
    echo "💻 USAGE"
    printf "CPU: "
    top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
    printf "MEM: "
    free | grep Mem | awk '{printf "%.1f%%\n", $3/$2 * 100.0}'
    echo
    
    # Top 5 processes
    echo "🔥 TOP 5 PROCESSES (CPU)"
    ps aux --sort=-%cpu | head -6 | tail -5 | \
        awk '{printf "%-10s %5s%%  %s\n", $1, $3, $11}'
    echo
    
    # Disk space
    echo "💾 DISK SPACE"
    df -h / | tail -1 | \
        awk '{printf "Used: %s / %s (%s)\n", $3, $2, $5}'
    echo
    
    # Network connections
    echo "🌐 CONNECTIONS"
    echo "Established: $(ss -tan | grep ESTAB | wc -l)"
    echo "Listening: $(ss -tln | grep LISTEN | wc -l)"
    echo
    
    # Services
    echo "⚙️  CRITICAL SERVICES"
    for svc in sshd nginx mysql; do
        if systemctl is-active --quiet $svc 2>/dev/null; then
            echo "✅ $svc"
        else
            echo "❌ $svc"
        fi
    done
    
    echo
    echo "Refreshing in 5s... (Ctrl+C to quit)"
    sleep 5
done
```

---

### Key takeaways 📌

<div class="text-xs">

**Scripts:**
- Shebang `#!/bin/bash`
- Arguments: `$1`, `$2`, `$@`, `$#`
- Conditions: `if`, `test`, `[ ]`
- Loops: `for`, `while`, `until`

**Cron:**
- Format: minute hour day month weekday
- `crontab -e` to edit
- Redirect output for logs

**Logs:**
- `journalctl` for systemd
- Filters: `-p`, `-u`, `--since`
- `logger` to write to syslog

</div>
