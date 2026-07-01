---
layout: intro
routeAlias: 'processus-services-legacy'
---

# Processes and Services ⚡

### Managing processes and system services

<div class="pt-12">
  <span @click="next" class="px-2 p-3 rounded cursor-pointer hover:bg-white hover:bg-opacity-10 neon-border">
    Let's manage processes together <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: default
---

# Core concepts 🔄

### What is a process?

**Definition:**
- A running program
- An instance of a program in memory
- Has a unique PID (Process ID)
- Consumes system resources

**Process types:**
- **Parent processes**: Create other processes
- **Child processes**: Created by parent processes
- **Orphan processes**: Parent has terminated
- **Zombie processes**: Terminated but not yet reaped

**Process states:**
- **Running**: Executing
- **Sleeping**: Waiting
- **Stopped**: Stopped
- **Zombie**: Terminated but not reaped

---
layout: default
---

# Basic process commands 📊

### Viewing and managing processes

**ps (Process Status)**
```bash
ps                           # My processes
ps aux                       # All processes
ps -ef                       # Extended format
ps -p PID                    # Specific process
ps -u user                   # A user's processes
ps -o pid,ppid,cmd           # Specific columns
```

**top (interactive)**
```bash
top                          # Real-time processes
top -p PID                   # Specific process
top -u user                  # A user's processes
top -n 1                     # Single refresh
```

**htop (improved)**
```bash
htop                         # Improved interface
htop -p PID                  # Specific process
htop -u user                 # A user's processes
```

---
layout: default
---

# Process management ⚙️

### Controlling processes

**kill (terminate a process)**
```bash
kill PID                     # Graceful termination
kill -9 PID                  # Force kill
kill -15 PID                 # SIGTERM signal (default)
kill -1 PID                  # SIGHUP signal (reload)
kill -2 PID                  # SIGINT signal (Ctrl+C)
```

**pkill and killall**
```bash
pkill process_name           # Kill by name
pkill -f "pattern"           # Kill by pattern
killall process_name         # Kill all processes by name
pkill -u user                # Kill all of a user's processes
```

**nice and renice**
```bash
nice -n 10 command           # Run with priority 10
renice 10 PID                # Change a process's priority
renice -n 10 -p PID          # Alternative
```

---
layout: default
---

# System signals 📡

### Communicating with processes

**Common signals:**
```bash
SIGHUP (1)   # Hangup - reload configuration
SIGINT (2)   # Interrupt - Ctrl+C
SIGQUIT (3)  # Quit - Ctrl+\
SIGKILL (9)  # Kill - forced termination
SIGTERM (15) # Terminate - graceful shutdown
SIGSTOP (19) # Stop - pause the process
SIGCONT (18) # Continue - resume the process
```

**Sending signals:**
```bash
kill -SIGTERM PID            # Send SIGTERM
kill -TERM PID               # Alternative
kill -1 PID                  # Send SIGHUP
kill -9 PID                  # Send SIGKILL
```

**Signal handling in scripts:**
```bash
#!/bin/bash
trap 'echo "Signal received"; exit' SIGTERM SIGINT
while true; do
    echo "Running..."
    sleep 1
done
```

---
layout: default
---

# systemd services 🔧

### Managing modern services

**systemctl commands:**
```bash
systemctl start service       # Start a service
systemctl stop service        # Stop a service
systemctl restart service     # Restart a service
systemctl reload service      # Reload configuration
systemctl status service      # Service status
systemctl enable service      # Enable at boot
systemctl disable service     # Disable at boot
```

**Service information:**
```bash
systemctl list-units --type=service  # List all services
systemctl list-units --failed         # Failed services
systemctl show service                # Detailed information
systemctl cat service                 # Show unit file
```

**Dependency management:**
```bash
systemctl list-dependencies service   # Service dependencies
systemctl list-dependencies --reverse service  # Dependent units
```

---
layout: default
---

# systemd unit files 📄

### Configuring services

**Structure of a .service file:**
```ini
[Unit]
Description=My Service
After=network.target
Requires=network.target

[Service]
Type=simple
User=service_user
Group=service_group
ExecStart=/path/to/service
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

**Service types:**
```bash
Type=simple                  # Simple service
Type=forking                 # Forking service
Type=oneshot                 # One-shot service
Type=notify                  # Notifying service
Type=dbus                    # D-Bus service
```

**File locations:**
```bash
/etc/systemd/system/         # System units
/usr/lib/systemd/system/     # Package units
~/.config/systemd/user/      # User units
```

---
layout: default
---

# Process monitoring 📈

### Real-time monitoring

**Monitoring commands:**
```bash
# CPU and memory usage
top -p PID                   # Specific process
htop -p PID                  # Improved interface
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head  # Top memory

# Resource usage
iotop                        # I/O top
iotop -p PID                 # Process I/O
lsof -p PID                  # Open files for a process
```

**Advanced monitoring:**
```bash
# Continuous watch
watch -n 1 'ps aux | grep process'
watch -n 1 'netstat -tuln | grep port'

# Process logs
journalctl -u service -f     # Follow service logs
journalctl -p err            # System errors
```

---
layout: default
---

# Memory management 💾

### Memory monitoring

**Memory commands:**
```bash
free                         # Memory usage
free -h                      # Human-readable
free -s 5                    # Refresh every 5 seconds
cat /proc/meminfo            # Detailed information
vmstat 1                     # Virtual memory stats
```

**Swap management:**
```bash
swapon -s                    # Swap status
swapon /dev/sda2             # Enable swap
swapoff /dev/sda2            # Disable swap
mkswap /dev/sda2             # Prepare partition for swap
```

**Cache cleanup:**
```bash
sync                         # Flush buffers
echo 3 > /proc/sys/vm/drop_caches  # Drop caches
sysctl vm.drop_caches=3      # Alternative
```

---
layout: default
---

# CPU management 🔥

### CPU performance monitoring

**CPU commands:**
```bash
uptime                       # System load
cat /proc/loadavg            # Load averages
cat /proc/cpuinfo            # CPU information
nproc                        # Number of processors
lscpu                        # Detailed CPU information
```

**Load monitoring:**
```bash
# System load
cat /proc/loadavg
# Format: 1min 5min 15min running_processes total_processes last_pid

# Per-process CPU usage
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head
top -p 1                     # Highest CPU process
```

**CPU limiting:**
```bash
# Using cpulimit
cpulimit -p PID -l 50        # Limit to 50% CPU
cpulimit -e process -l 30     # Limit by name
```

---
layout: default
---

# Job management 📋

### Background jobs

**Job commands:**
```bash
command &                    # Run in background
jobs                         # List jobs
fg %1                        # Bring job 1 to foreground
bg %1                        # Resume job 1 in background
kill %1                      # Kill job 1
```

**nohup and screen:**
```bash
nohup command &              # Keep running after logout
screen -S session            # Create screen session
screen -r session            # Attach to session
screen -ls                   # List sessions
```

**tmux (terminal multiplexer):**
```bash
tmux                         # Start tmux
tmux new-session -s name     # New named session
tmux attach -t name          # Attach to session
tmux list-sessions           # List sessions
```

---
layout: default
---

# Logs and debugging 🐛

### Log monitoring

**System logs:**
```bash
journalctl                   # systemd logs
journalctl -u service        # Service logs
journalctl -f                # Follow in real time
journalctl --since "1 hour ago"  # Last hour
journalctl -p err            # Errors only
```

**Traditional logs:**
```bash
tail -f /var/log/syslog      # Follow system log
tail -f /var/log/auth.log    # Follow authentication log
grep "ERROR" /var/log/service.log  # Search for errors
```

**Process debugging:**
```bash
strace -p PID                # Trace system calls
ltrace -p PID                # Trace library calls
gdb -p PID                   # GNU debugger
```

---
layout: default
---

# cgroups v2 management 📦

### Process group control (modern)

**Create a cgroup manually (cgroups v2):**

```bash
# Create a cgroup
sudo mkdir /sys/fs/cgroup/my_group

# Set memory limit (500 MiB)
echo "500M" | sudo tee /sys/fs/cgroup/my_group/memory.max

# Set CPU limit (50% = 50000/100000 µs)
echo "50000 100000" | sudo tee /sys/fs/cgroup/my_group/cpu.max

# Add a process (replace PID with the real PID)
echo PID | sudo tee /sys/fs/cgroup/my_group/cgroup.procs
```

---

# Managing cgroups with systemd 🔧

**Recommended method: systemctl set-property**

```bash
# Limit a service's memory (modern syntax)
sudo systemctl set-property nginx.service MemoryMax=512M

# Limit CPU
sudo systemctl set-property nginx.service CPUQuota=50%

# View current limits
systemctl show nginx.service --property=MemoryMax,CPUQuota,TasksMax
```

**Run a command with limits (quick test):**

```bash
systemd-run --scope -p MemoryMax=256M -p CPUQuota=25% ./script.sh
```

**Monitoring tools:**

```bash
systemd-cgtop                # Cgroup top (real time)
systemd-cgls                 # Cgroup tree
```

---
layout: default
---

# Service automation 🤖

### Service scripts

**Classic init script:**
```bash
#!/bin/bash
# /etc/init.d/my_service

case "$1" in
    start)
        echo "Starting service..."
        /path/to/service &
        ;;
    stop)
        echo "Stopping service..."
        killall service
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
```

**Modern systemd unit:**
```ini
[Unit]
Description=My Automated Service
After=network.target

[Service]
Type=simple
ExecStart=/path/to/service
ExecStop=/bin/kill -TERM $MAINPID
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

---
layout: default
---

# Advanced monitoring 🔍

### Monitoring tools

**Custom htop:**
```bash
# ~/.config/htop/htoprc
# Custom columns
# Colors by process type
# Memory/CPU alerts
```

**Monitoring with Prometheus:**
```bash
# Export system metrics
node_exporter --collector.processes

# Available metrics
# - process_cpu_seconds_total
# - process_memory_bytes
# - process_open_fds
```

**Grafana for visualization:**
```bash
# System dashboard
# - CPU usage per process
# - Memory usage
# - Process count
# - Response time
```

---
layout: default
---

# Hands-on exercises 🎯

### Practice

**Exercise 1: Process management**
```bash
# Create a background process
sleep 100 &
jobs

# Change priority
renice 10 $!

# Kill the process
kill %1
```

**Exercise 2: systemd service**
```bash
# Create a simple service
sudo nano /etc/systemd/system/my_service.service

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable my_service
sudo systemctl start my_service
sudo systemctl status my_service
```

**Exercise 3: Monitoring**
```bash
# Watch a specific process
watch -n 1 'ps aux | grep process'

# Analyze memory usage
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -10
```

---
layout: default
---

# Best practices 💡

### Tips for process management

**Performance**
- Monitor processes regularly
- Identify resource-heavy processes
- Optimize critical services
- Use cgroups to limit resources

**Security**
- Limit service privileges
- Watch for suspicious processes
- Use dedicated users for services
- Log important actions

**Maintenance**
- Clean up zombie processes
- Restart problematic services
- Update configurations
- Document custom services

---
layout: default
---

# Next steps 🎯

### What's ahead

1. **Networking and connectivity**
2. **Software packages** and management
3. **Shell scripting** basics
4. **Virtualization** and containers
5. **Docker** introduction

**Preparation:**
- Get comfortable with systemctl
- Practice process management
- Try monitoring commands
- Build your first services
