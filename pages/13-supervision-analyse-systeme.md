---
layout: new-section
routeAlias: 'supervision-analyse'
---

<a name="supervision-analyse" id="supervision-analyse"></a>

# 📊 Module 6 - Monitoring & logs

---

# Why monitor a server? 🤔

**Monitoring**: tracking a system’s state and performance

**Analogy: a car dashboard** 🚗
- **Speed** = CPU load
- **Engine temperature** = system temperature
- **Fuel gauge** = disk space
- **Warning lights** = error logs

**Without monitoring:**
- Surprises and crashes
- No early warning
- Hard to find the problem
- Longer downtime

---

#### The 4 key resources to watch 🎯

<div class="text-xs">

**1. CPU**: processor load
- Too high = slow system
- Target: < 70% on average

**2. RAM**: memory
- Full RAM = swap = slow
- Target: < 80%

**3. Disk**: storage space
- Full = crashes
- Target: < 85%

**4. Network**: traffic
- Too much traffic = timeouts

</div>

---

# top: the essential classic 📊

```bash
top
```

**First line: load average**
```
load average: 1.23, 0.87, 0.65
```
- 3 values: 1 min, 5 min, 15 min
- If > number of CPUs: overloaded

**Important columns:**
- `PID`: process ID
- `USER`: owner
- `%CPU`: CPU usage
- `%MEM`: memory usage
- `COMMAND`: program name

---

# top: useful hotkeys ⌨️

**Interactive shortcuts:**

```
M    : sort by memory
P    : sort by CPU (default)
k    : kill a process (asks for PID)
u    : filter by user
1    : show all CPUs separately
q    : quit
```

**Practical example:** find who uses the most RAM

```bash
top
# Press M
# The biggest RAM consumers appear at the top
```

---

# htop: top, improved 🎨

```bash
# Install
sudo apt install htop

# Run
htop
```

**Advantages over top:**
- Colorful, intuitive UI
- CPU/RAM bar graphs
- Arrow-key navigation
- Process tree (F5)
- Search (F3)
- Easy kill (F9)

---

# htop: quick navigation 🎮

**Function keys:**

```
F1  : Help
F2  : Setup
F3  : Search for a process
F4  : Filter
F5  : Tree view
F6  : Sort by column
F9  : Kill process
F10 : Quit
```

**Direct keys:**
- `Space`: tag a process
- `u`: filter by user
- `t`: tree view
- `/`: search

---

# iotop: monitor disk I/O 💽

```bash
# Install
sudo apt install iotop

# Run (root required)
sudo iotop
```

**Key columns:**
- `DISK READ`: disk read per second
- `DISK WRITE`: disk write per second
- `COMMAND`: responsible process

**Use cases:**
- Slow system: is it the disk?
- Who is writing heavily to disk?
- Find a process doing intensive I/O

---
layout: new-section
---

# 🧪 Live coding - Module 6

### Monitoring tools - vmstat, journalctl, sar on the VM

---

# vmstat: memory statistics 📈

```bash
# Snapshot
vmstat

# Refresh every 2 seconds
vmstat 2

# 5 runs, every 2 seconds
vmstat 2 5
```

**Important columns:**
- `r`: runnable processes (running or waiting for CPU)
- `b`: processes blocked waiting for I/O
- `si`: swap in (KB/s)
- `so`: swap out (KB/s)
- `bi`: KiB read from block devices/s
- `bo`: KiB written to block devices/s
- `us`: user CPU time
- `sy`: system CPU time
- `wa`: CPU time waiting for I/O

---

# Interpreting vmstat 🔍

```bash
vmstat 2
```

```
r  b   swpd   free   buff  cache   si   so    bi    bo
2  0      0  524288  89600 1048576   0    0    10    50
```

**Warning signs:**
- `r > number of CPUs`: CPU overloaded
- `b > 0`: lots of disk I/O wait
- `si/so > 0`: system is using swap (bad!)
- `wa > 20`: CPU waiting on disk

**Healthy state:**
- `r ≈ number of CPUs`
- `si/so = 0` (no swap)
- `wa < 10`

---

# iostat: I/O per device 💾

```bash
# Install
sudo apt install sysstat

# I/O statistics
iostat

# Refresh every 2 seconds
iostat -x 2
```

**Key columns (-x for details):**
- `r/s`: reads per second
- `w/s`: writes per second
- `rkB/s`: KB read per second
- `wkB/s`: KB written per second
- `%util`: disk utilization

**Note:** `%util > 80%` = disk bottleneck

---

# journalctl: system logs 📜

**systemd journal**: journalctl queries structured logs (alongside classic files in `/var/log/` on Ubuntu)

```bash
# All logs
journalctl

# Logs since last boot
journalctl -b

# Logs for a service
journalctl -u nginx

# Follow in real time
journalctl -f

# Follow a service
journalctl -u nginx -f
```

---

# journalctl: useful filters 🔎

```bash
# Last hour
journalctl --since "1 hour ago"

# Since today
journalctl --since today

# Exact range
journalctl --since "2025-11-01" --until "2025-11-02"

# Errors and above (err, crit, alert, emerg)
journalctl -p err

# Critical and above (crit, alert, emerg)
journalctl -p crit

# Last 50 lines
journalctl -n 50
```

---

# journalctl: export and cleanup 🧹

```bash
# Export to file
journalctl -u nginx > nginx.log

# Journal size
journalctl --disk-usage

# Cleanup: keep 7 days
sudo journalctl --vacuum-time=7d

# Cleanup: keep 500 MB
sudo journalctl --vacuum-size=500M

# Check log files are OK
journalctl --verify
```

---

# sar: System Activity Reporter 📊

**sar**: collects and reports system activity

```bash
# Install sysstat
sudo apt install sysstat

# Enable collection (edit /etc/default/sysstat)
sudo nano /etc/default/sysstat
# ENABLED="true"

sudo systemctl enable sysstat
sudo systemctl start sysstat
```

**Automatic collection**: every 10 minutes by default

---

# sar: read the stats 📈

```bash
# Today’s CPU stats
sar

# Memory stats
sar -r

# Swap stats
sar -S

# I/O stats
sar -b

# Network stats
sar -n DEV

# Yesterday’s stats
sar -f /var/log/sysstat/sa$(date -d yesterday +%d)
```

**Example:** CPU usage between 2pm and 3pm

```bash
sar -s 14:00:00 -e 15:00:00
```

---
layout: new-section
---

# ✅ Live coding done - Module 6

**You ran on the VM:** `vmstat` · `journalctl` · `sar` (+ `free -h` / `df -h` from the recap)

**Verify at home:** sysstat enabled · `sar 1 3` prints CPU lines · errors in `journalctl -b -p err`

**Next:** traditional logs, logrotate & monitoring best practices

---

# Traditional logs: /var/log/ 📂

**Important log files:**

```bash
# General system logs
tail -f /var/log/syslog
# or: journalctl -f

# Login attempts
tail -f /var/log/auth.log
# or: journalctl -t sshd -f

# Kernel
dmesg
tail -f /var/log/kern.log

# Specific services
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
tail -f /var/log/mysql/error.log
```

---

# logrotate: automatic rotation 🔄

**logrotate**: compresses and archives old logs

**Configuration:** `/etc/logrotate.conf` and `/etc/logrotate.d/*`

**Example: /etc/logrotate.d/nginx**

```
/var/log/nginx/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        systemctl reload nginx > /dev/null
    endscript
}
```

---

# rsyslog & classic syslog 📨

**syslog** = the log format. **rsyslog** = the program that writes `/var/log/syslog` on Ubuntu.

```bash
systemctl status rsyslog
logger -p local0.notice "lab-marker"
sudo tail -f /var/log/syslog
```

**Both work:** `journald` can also send logs to rsyslog (`ForwardToSyslog=yes`).

---

# Monitor disk space 💾

```bash
# Overall disk space
df -h

# Usage by directory
du -sh /var/*
du -sh /home/*

# Top 10 largest files in /var
sudo find /var -type f -exec du -h {} + | sort -rh | head -10

# Watch in real time
watch -n 5 df -h
```

**Alert:** disk > 85% = risk of failure

---

# Simple monitoring script example 🤖

**Script: /usr/local/bin/monitor.sh**

```bash
#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80

# Read values
CPU=$(vmstat 1 2 | tail -1 | awk '{print 100-$15}')
MEM=$(free | grep Mem | awk '{print ($3/$2) * 100}')

# Alerts
if (( $(echo "$CPU > $CPU_THRESHOLD" | bc -l) )); then
    echo "ALERT: CPU at ${CPU}%" | mail -s "CPU Alert" admin@example.com
fi

if (( $(echo "$MEM > $MEM_THRESHOLD" | bc -l) )); then
    echo "ALERT: RAM at ${MEM}%" | mail -s "RAM Alert" admin@example.com
fi
```

---

#### Best practices 📋

<div class="text-xs">

**1. Monitor regularly**
- Check htop daily
- Review error logs

**2. Define thresholds**
- CPU < 70%
- RAM < 80%
- Disk < 85%
- Load average < nb_cpus

**3. Automate**
- Monitoring scripts
- Email/SMS alerts
- Historical collection (sar)

</div>

---

# Best practices (continued) ✅

<div class="text-xs">

**4. Keep history**
- sar automatic collection
- Rotated logs kept 14–30 days
- Trend graphs

**5. Write down problems**
- When?
- What did you see?
- Cause?
- Fix?

**6. Plan ahead**
- Watch disk usage over time
- Upgrade before disk is full

</div>

---

#### Module 6 recap ✅

<div class="text-xs">

**What you learned:**

✅ Real-time monitoring tools (top, htop, iotop)

✅ System statistics (vmstat, iostat)

✅ System logs (journalctl, /var/log/*)

✅ Historical collection (sar)

✅ Log rotation (logrotate)

✅ Custom monitoring scripts

✅ Find slow parts (CPU, RAM, disk, I/O)

✅ **rsyslog + journald** - both can work together

**Live demo on VM:** `vmstat 1 3` · `free -h` · `journalctl -b -p err -n 10` · `sar 1 3`

</div>

# Next step 🎯

**Day 3** - **OpenLDAP + PAM**, then **SNMP**. The **troubleshooting workshop** closes the training (boot, disk, services, LDAP, SNMP).

---
layout: default
---

# Questions? 🤔

Feel free to ask your questions now!

Post your questions on <ExternalLink href="https://questions.andromed.fr">questions.andromed.fr</ExternalLink> (access code **29062026**) so I can centralize and answer them.

We stay on the **main path**: **LDAP + SNMP on Day 3**, then the **troubleshooting workshop** closes the training.
