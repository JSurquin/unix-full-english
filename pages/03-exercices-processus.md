---

# 🎯 Hands-on exercises - Module 2

**Process and service management**

---

# Exercise 3: systemd services 🎛️

**Goal:** Manage services with systemd

**Instructions:**

1. List all active services
2. Check the SSH service status
3. Restart the SSH service (if installed)
4. Enable automatic startup at boot
5. List services that have failed
6. Show the last 50 log lines for the SSH service

---

# Exercise 3 solution 💡

```bash
# 1. Active services
systemctl list-units --type=service --state=active

# 2. SSH status (Ubuntu unit: ssh; RHEL/Rocky: sshd)
systemctl status ssh

# 3. Restart
sudo systemctl restart ssh

# 4. Enable at boot
sudo systemctl enable ssh
# Verify
systemctl is-enabled ssh

# 5. Failed services
systemctl --failed

# 6. SSH logs (Ubuntu: use ssh - journalctl -u sshd shows no entries)
journalctl -u ssh -n 50
# or follow
journalctl -u ssh -f
```

---

# Exercise 4: Custom service 🛠️

**Goal:** Create and manage your own service

**Instructions:**

Create a service that:
1. Runs a simple Python script every 10 seconds
2. Restarts automatically on crash
3. Starts automatically at boot
4. Writes logs

**Python script to create: `/opt/hello_service.py`**

---

# Exercise 4 solution - Script 💡

```bash
# 1. Create the script
sudo mkdir -p /opt
sudo tee /opt/hello_service.py << 'EOF'
#!/usr/bin/env python3
import time
import datetime

while True:
    now = datetime.datetime.now()
    print(f"[{now}] Service running...")
    time.sleep(10)
EOF

# Make executable
sudo chmod +x /opt/hello_service.py
```

---

# Exercise 4 solution - Service 💡

```bash
# 2. Create the systemd service
sudo tee /etc/systemd/system/hello.service << 'EOF'
[Unit]
Description=Hello Service
After=network.target

[Service]
Type=simple
User=nobody
ExecStart=/usr/bin/python3 /opt/hello_service.py
Restart=always
RestartSec=5s
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# 3. Reload systemd
sudo systemctl daemon-reload

# 4. Start the service
sudo systemctl start hello.service

# 5. Enable at boot
sudo systemctl enable hello.service

# 6. Verify
systemctl status hello.service
journalctl -u hello.service -f
```

---

# Exercise 5: Boot analysis 🚀

**Goal:** Analyze boot performance

**Instructions:**

1. Show total boot time
2. List the 10 slowest services to start
3. Show the critical boot chain
4. Generate a boot graph (SVG)
5. Disable an unnecessary service to speed up boot

---

# Exercise 5 solution 💡

```bash
# 1. Total time
systemd-analyze

# 2. Top 10 slowest services
systemd-analyze blame | head -10

# 3. Critical chain
systemd-analyze critical-chain

# 4. Graph
systemd-analyze plot > /tmp/boot.svg
# Minimal server VM: no GUI browser - verify and open on your workstation
ls -la /tmp/boot.svg
# scp johndoe@vm:/tmp/boot.svg .

# 5. Disable an unnecessary service
# Minimal Ubuntu server (no bluetooth.service):
sudo systemctl disable ModemManager.service
# See the difference
systemd-analyze
```

---

# Exercise 6: Log management 📜

**Goal:** Master journalctl

**Instructions:**

1. Show logs since the last boot
2. Show only errors
3. Follow logs in real time
4. Show yesterday’s logs
5. Export logs to a file
6. Delete logs older than 7 days

---

# Exercise 6 solution 💡

```bash
# 1. Logs since last boot
journalctl -b

# 2. Errors only
journalctl -p err
# or all priorities <= error for current boot
journalctl -p err -b

# 3. Real time
journalctl -f
# Ctrl+C to stop

# 4. Yesterday’s logs
journalctl --since yesterday --until today

# 5. Export
journalctl > /tmp/all_logs.txt
# or for a specific service
journalctl -u nginx > /tmp/nginx_logs.txt

# 6. Delete logs older than 7 days
sudo journalctl --vacuum-time=7d

# Disk usage
journalctl --disk-usage
```

---

### Key takeaways 📌

<div class="text-xs">

**systemd:**
- `start`, `stop`, `restart`, `reload`
- `enable`, `disable` for boot
- `mask` to block a unit

**Units & boot:**
- Custom units (`daemon-reload`, `Restart=`)
- Targets (runlevels), `systemd-analyze` for boot

**Logs:**
- `journalctl -u` for a service
- `journalctl -b` since last boot

</div>
