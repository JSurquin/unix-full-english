---
layout: exercices
---

# Exercises - Advanced Zabbix monitoring 🎯

**Module 5: Hands-on**

---

# Exercise 1: Install Zabbix Server 🖥️

**Goal:** Install a full Zabbix server

**Prerequisites:** Ubuntu 24.04 machine (VM or cloud)

**Instructions:**

1. Add the Zabbix 7.0 repository
2. Install server + frontend + agent + Apache
3. Install MariaDB
4. Create the zabbix database
5. Import the initial schema
6. Configure zabbix_server.conf
7. Start all services
8. Open the web UI

**Duration:** 30 minutes

---

# Exercise 1: Solution 💡

```bash
# 1–2. Repo and install
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
sudo apt update
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mariadb-server -y

# 3–5. Database
sudo mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
sudo mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'MyPassword';"
sudo mysql -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 1;"
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix

# 6. Configuration
sudo nano /etc/zabbix/zabbix_server.conf
# DBPassword=MyPassword

# 7. Start
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 0;"
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

# 8. UI
firefox http://localhost/zabbix
```

---

# Exercise 2: Initial setup 🔧

**Goal:** Configure the web UI

**Instructions:**

1. Open http://server-ip/zabbix
2. Run the installation wizard
3. Log in with Admin / zabbix
4. Change the Admin password
5. Set language to French
6. Verify host "Zabbix server" is active (green)

**Duration:** 10 minutes

---

# Exercise 2: Solution 💡

```bash
# 1. Browser
http://<SERVER_IP>/zabbix

# 2. Wizard
# - Welcome → Next
# - Prerequisites → Next
# - Database: MySQL, localhost, zabbix, zabbix, Password → Next
# - Server details → Next
# - Finish

# 3. Login
User: Admin
Password: zabbix

# 4. Change password
Administration → Users → Admin → Change password
New password (twice) → Update

# 5. Language
User icon (top right) → Language: French → Update

# 6. Verify
Configuration → Hosts
# Row "Zabbix server" → Availability column = green ZBX ✅
```

---

# Exercise 3: Add an agent 📡

**Goal:** Install and configure an agent on a second server

**Prerequisites:** A second server (VM or cloud)

**Instructions:**

1. On the monitored server, install zabbix-agent
2. Configure zabbix_agentd.conf:
   - Server = Zabbix server IP
   - Hostname = test-server
3. Restart the agent
4. Open port 10050 in the firewall
5. Verify the agent is listening

**Duration:** 15 minutes

---

# Exercise 3: Solution 💡

```bash
# On the monitored server

# 1. Install
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
sudo apt update
sudo apt install zabbix-agent -y

# 2. Configuration
sudo nano /etc/zabbix/zabbix_agentd.conf

# Change:
Server=192.168.1.10        # Zabbix server IP
ServerActive=192.168.1.10
Hostname=test-server

# 3. Restart
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent

# 4. Firewall
sudo ufw allow 10050/tcp

# 5. Verify
sudo systemctl status zabbix-agent
sudo ss -tlnp | grep 10050
```

---

# Exercise 4: Add the host in Zabbix 🖥️

**Goal:** Register the new server in Zabbix

**Instructions:**

1. In Zabbix UI: Configuration → Hosts → Create host
2. Name: `test-server`
3. Groups: `Linux servers`
4. Interface: Agent, server IP, port 10050
5. Templates: add `Linux by Zabbix agent`
6. Add the host
7. Wait until ZBX turns green
8. Browse collected data

**Duration:** 10 minutes

---

# Exercise 4: Solution 💡

```
1. Configuration → Hosts → Create host

2–3. Host tab:
   - Host name: test-server
   - Groups: Linux servers

4. Interfaces → Add:
   - Type: Agent
   - IP address: 192.168.1.20 (test server IP)
   - Port: 10050

5. Templates → Select:
   - Search "Linux by Zabbix agent"
   - Click the name
   - Add

6. Add (bottom button)

7. Wait 30–60 seconds
   Configuration → Hosts
   Availability column → ZBX should be green ✅

8. Monitoring → Latest data
   Filter by host: test-server
   See CPU, RAM, disk, etc.
```

---

# Exercise 5: Create a CPU alert 🚨

**Goal:** Alert if CPU > 80% for 5 minutes

**Instructions:**

1. Create a trigger on test-server:
   - Name: `High CPU on {HOST.NAME}`
   - Severity: High
   - Expression: CPU avg(5m) > 80
2. The alert appears under Monitoring → Problems

**Duration:** 10 minutes

---

# Exercise 5: Solution 💡

```
1. Configuration → Hosts → test-server
2. Triggers → Create trigger

3. Fill in:
   Name: High CPU on {HOST.NAME}
   Severity: High

4. Expression → Add:
   - Item: CPU utilization
   - Function: avg
   - Last of (T): 5m
   - Result: > 80
   
5. Add (expression)
6. Add (trigger)

Test:
# On test-server, stress CPU
sudo apt install stress -y
stress --cpu 4 --timeout 300s

# In Zabbix
Monitoring → Problems
# Alert appears after 5 minutes
```

---

# Exercise 6: Email configuration 📧

**Goal:** Configure email delivery (simulation)

**Note:** For Gmail, create an “app password”  
(Google Account → Security → 2-Step Verification → App passwords)

**Instructions:**

1. Administration → Media types → Email
2. Configure Gmail SMTP:
   - Server: smtp.gmail.com:587
   - STARTTLS
   - Credentials
3. Test sending
4. Assign email to Admin user
5. Create a "CPU alert" action

**Duration:** 20 minutes

---

# Exercise 6: Solution 💡

```
1. Administration → Media types → Email

2. Settings:
   SMTP server: smtp.gmail.com
   Port: 587
   SMTP helo: gmail.com
   SMTP email: your-email@gmail.com
   Connection security: STARTTLS
   Authentication: Username and password
   Username: your-email@gmail.com
   Password: [app password]
   
3. Test → Send to: your-email@gmail.com → Test
   Check inbox

4. Administration → Users → Admin → Media → Add:
   Type: Email
   Send to: your-email@gmail.com
   Active: 1–7, 00:00–24:00
   Severity: all
   Add → Update

5. Configuration → Actions → Create action:
   Name: CPU alert
   Conditions: Severity >= High
   Operations: Send to Admin via Email
   Add
```

---

# Exercise 7: Custom dashboard 📊

**Goal:** Build a dashboard

**Instructions:**

1. Monitoring → Dashboards → Create dashboard
2. Name: `My test server`
3. Add Graph widget: CPU
4. Add Graph widget: RAM
5. Add Graph widget: Disk
6. Save

**Duration:** 15 minutes

---

# Exercise 7: Solution 💡

```
1. Monitoring → Dashboards → Create dashboard

2. Name: My test server

3. Add widget:
   Type: Graph
   Name: CPU
   Host: test-server
   Item: CPU utilization
   Add

4. Add widget:
   Type: Graph
   Name: Memory
   Host: test-server
   Item: Memory utilization
   Add

5. Add widget:
   Type: Graph
   Name: Disk
   Host: test-server
   Item: Disk space usage /
   Add

6. Apply
7. Rearrange widgets with drag & drop
8. Save

# Result: graphical overview of your server!
```

---

#### Running project: Full monitoring 🎯

<div class="text-xs">

**Goal:** Production-style end-to-end monitoring

**Scenario:** You manage 3 servers:
- 1 web server (Nginx)
- 1 database server (MySQL)
- 1 application server

**Tasks:**

1. Install agents on all 3 servers
2. Add them in Zabbix with appropriate templates
3. Create triggers for:
   - CPU > 80%
   - RAM > 90%
   - Disk > 85%
4. Configure email alerts
5. Build a global dashboard

**Duration:** 1–2 hours

</div>

---

# Validation checklist ✅

**Your Zabbix setup is ready when:**

□ Zabbix server installed and running  
□ Web UI reachable  
□ At least one agent installed and green (ZBX)  
□ Collected data visible (Latest data)  
□ One trigger created and working  
□ Email configuration tested  
□ One custom dashboard created

**If all boxes checked: well done! 🎉**

---

# Exercise recap ✅

**Skills practiced:**

✅ Full Zabbix installation

✅ Server and agent configuration

✅ Adding monitored hosts

✅ Creating alert triggers

✅ Email notifications

✅ Dashboards

✅ Using templates

**You can now deploy professional monitoring!**

---
layout: default
---

# Well done! 🎉

You now master Zabbix for advanced monitoring.

**Next step (BONUS):** Module 6 - Optimization & performance

