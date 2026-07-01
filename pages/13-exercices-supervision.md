---
layout: exercices
---

# Exercises - Monitoring & System Analysis 🎯

**Module 6: Hands-on**

---

# Exercise 1: Real-time monitoring 📊

**Goal:** Use top and htop

**Instructions:**

1. Run `top` and identify:
   - Current load average
   - The 3 processes using the most CPU
   - The 3 processes using the most RAM

2. Install and run `htop`
   - Sort by memory usage
   - Show the process tree (F5)
   - Search for the "sshd" process (F3)

**Duration:** 10 minutes

---

# Exercise 1: Solution 💡

```bash
# 1. Top
top
# Watch the "load average: ..." line
# Press 'P' to sort by CPU
# Press 'M' to sort by RAM
# Note the top 3 processes

# 2. Htop
sudo apt install htop -y    # if not installed
htop
# F6 then select PERCENT_MEM
# F5 for tree view
# F3 then type "sshd"
# F10 to quit
```

---

# Exercise 2: Disk I/O analysis 💽

**Goal:** Identify disk activity

**Instructions:**

1. Install `iotop`
2. Run it and observe for 30 seconds
3. Create a 100 MB file to generate I/O:
   ```bash
   dd if=/dev/zero of=/tmp/test.img bs=1M count=100
   ```
4. Watch iotop during the operation
5. Delete the test file

**Question:** Which process generated the most disk writes?

**Duration:** 10 minutes

---

# Exercise 2: Solution 💡

```bash
# 1. Install
sudo apt install iotop -y

# 2. Run
sudo iotop
# Observe for 30s

# 3. Terminal 2: generate I/O
dd if=/dev/zero of=/tmp/test.img bs=1M count=100

# 4. In iotop: the 'dd' process appears
# with high DISK WRITE

# 5. Cleanup
rm /tmp/test.img
```

**Answer:** The `dd` process generates the most writes

---

# Exercise 3: Log analysis with journalctl 📜

**Goal:** Filter and analyze logs

**Instructions:**

1. Show logs since the last boot
2. Show only errors from the last 24 hours
3. Follow SSH service logs in real time
4. Show the last 20 lines of system logs
5. Check total journald disk usage

**Duration:** 15 minutes

---

# Exercise 3: Solution 💡

```bash
# 1. Logs since last boot
journalctl -b

# 2. Errors from the last 24 hours
journalctl -p err --since "24 hours ago"

# 3. Follow SSH in real time
journalctl -u ssh -f
# or journalctl -u sshd -f (depends on distro)
# Ctrl+C to stop

# 4. Last 20 lines
journalctl -n 20

# 5. Log size
journalctl --disk-usage
```

---

# Exercise 4: Monitoring with vmstat and iostat 📈

**Goal:** Understand system statistics

**Instructions:**

1. Install sysstat: `sudo apt install sysstat -y`
2. Run `vmstat 2 5` (5 times, 2 seconds apart)
3. Note average values for:
   - `r` (runnable processes)
   - `si` and `so` (swap)
   - `wa` (I/O wait)
4. Run `iostat -x 2 3`
5. Note `%util` for your main disk

**Duration:** 10 minutes

---

# Exercise 4: Solution 💡

```bash
# 1. Install
sudo apt install sysstat -y

# 2. vmstat
vmstat 2 5

# Example output:
# r  b  swpd   free   si  so  wa
# 1  0     0  524288   0   0   2

# Interpretation:
# r=1: OK (< nb CPUs)
# si=so=0: no swap (good)
# wa=2: little I/O wait (good)

# 4. iostat
iostat -x 2 3

# Watch %util:
# < 50% = OK
# 50–80% = busy
# > 80% = bottleneck
```

---

# Exercise 5: Monitoring script ⚙️

**Goal:** Create a simple alert script

**Instructions:**

Create `/usr/local/bin/check_disk.sh` that:

1. Checks disk space on `/`
2. Prints an alert if > 80%
3. Makes the script executable
4. Run it manually

**Bonus:** Add it to crontab to run every hour

**Duration:** 20 minutes

---

# Exercise 5: Solution 💡

```bash
# 1. Create the script
sudo nano /usr/local/bin/check_disk.sh
```

```bash
#!/bin/bash
# Disk monitoring script

THRESHOLD=80
USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ $USAGE -gt $THRESHOLD ]; then
    echo "ALERT: Disk / at ${USAGE}%"
    # echo "ALERT: Disk at ${USAGE}%" | mail -s "Disk Alert" admin@example.com
else
    echo "OK: Disk / at ${USAGE}%"
fi
```

---

# Exercise 5: Solution (continued) 💡

```bash
# 2. Make executable
sudo chmod +x /usr/local/bin/check_disk.sh

# 3. Test
/usr/local/bin/check_disk.sh

# Bonus: add to crontab
sudo crontab -e
# Add line:
0 * * * * /usr/local/bin/check_disk.sh >> /var/log/disk_check.log
```

---

# Exercise 6: Analysis with sar 📊

**Goal:** Enable and use sar

**Instructions:**

1. Verify sysstat is installed
2. Enable collection:
   - Edit `/etc/default/sysstat`
   - Set `ENABLED="true"`
3. Restart sysstat
4. Show current CPU stats: `sar`
5. Show memory stats: `sar -r`

**Note:** sar only has historical data after a few hours

**Duration:** 10 minutes

---

# Exercise 6: Solution 💡

```bash
# 1. Install (if needed)
sudo apt install sysstat -y

# 2. Enable collection
sudo nano /etc/default/sysstat
# Change ENABLED="false" to ENABLED="true"

# 3. Restart
sudo systemctl enable sysstat
sudo systemctl start sysstat

# 4. CPU stats
sar
# If "Cannot open /var/log/sysstat/..." = normal,
# wait 10 minutes for collection to start

# 5. Memory stats
sar -r

# 6. Network stats
sar -n DEV
```

---

# Exercise 7: Find why the system is slow 🔍

**Goal:** Find why a system is slow (simulation)

**Instructions:**

A user says “the server is slow.”  
Run these steps in order:

1. Check load average (top or uptime)
2. Check CPU usage (top)
3. Check RAM and swap (free -h)
4. Check disk space (df -h)
5. Check I/O activity (sudo iotop for 10s)
6. Check recent errors (journalctl -p err --since "10 min ago")

Document your observations.

**Duration:** 15 minutes

---

# Exercise 7: Solution 💡

```bash
# 1. Load average
uptime
top
# load < nb_cpus = OK

# 2. CPU
top
# Any process > 80% CPU?

# 3. RAM and swap
free -h
# Swap used > 0 = memory issue

# 4. Disk
df -h
# / > 85% = space issue

# 5. I/O
sudo iotop -o
# Process with high DISK READ/WRITE?

# 6. Errors
journalctl -p err --since "10 min ago"
# System errors?
```

---

# Exercise 7: Slow system checklist 📋

**Build your personal checklist:**

```
SLOW SYSTEM CHECKLIST
=====================
Date: __________  Time: __________

□ Load average: _____ (< nb_cpus ?)
□ Max CPU used by: __________ (___%)
□ RAM used: _____% (< 80% ?)
□ Swap used: _____MB (= 0 ?)
□ Disk / used: _____% (< 85% ?)
□ Disk I/O: Process __________ (high?)
□ Log errors: Yes / No
  └─> If yes: ____________________

Conclusion: ______________________
```

---

# Running project: Automated monitoring 🤖

**End goal:** Full monitoring script

**Features:**
- Check CPU, RAM, disk
- Log to /var/log/monitoring.log
- Send alert if threshold exceeded
- Run every 5 minutes

**Steps:**
1. Create the script
2. Test
3. Add to crontab
4. Watch logs for 1 hour

**See exercise 5 as a starting point**

---

# Exercise recap ✅

**Skills practiced:**

✅ Using top/htop for real-time monitoring

✅ Analyzing I/O with iotop

✅ Filtering logs with journalctl

✅ Interpreting vmstat and iostat

✅ Writing monitoring scripts

✅ Enabling and using sar

✅ Step-by-step check for a slow system

---
layout: default
---

# Well done! 🎉

You now have the basics of system monitoring.

**Next step:** Troubleshooting labs - use metrics and logs on broken VMs.

