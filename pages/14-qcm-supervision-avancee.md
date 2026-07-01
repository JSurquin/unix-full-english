---

# Quiz - Advanced monitoring with Zabbix ✅

**Module 5: Knowledge check**

---

# Question 1 🏗️

**What is Zabbix’s architecture?**

A) A standalone agent on each server  
B) Central server + agents on monitored machines  
C) Web UI only  
D) A cron script that collects data

<v-click>

**Answer: B**

Zabbix uses a client/server model: a central server collects data from agents on each machine.

</v-click>

---

# Question 2 🔌

**Which port does the Zabbix agent listen on by default?**

A) 10050  
B) 10051  
C) 3306  
D) 8080

<v-click>

**Answer: A**

The Zabbix agent listens on port 10050. The Zabbix server listens on 10051.

</v-click>

---

# Question 3 🗄️

**Which database can be used with Zabbix?**

A) MySQL only  
B) PostgreSQL only  
C) MySQL/MariaDB or PostgreSQL  
D) SQLite only

<v-click>

**Answer: C**

Zabbix supports MySQL/MariaDB and PostgreSQL. PostgreSQL is often recommended for large setups.

</v-click>

---

# Question 4 🔑

**What are Zabbix’s default login credentials?**

A) admin / admin  
B) Admin / zabbix  
C) root / password  
D) zabbix / zabbix

<v-click>

**Answer: B**

User: `Admin` (capital A) / Password: `zabbix`  
⚠️ Change immediately after install!

</v-click>

---

# Question 5 🚨

**What is a “trigger” in Zabbix?**

A) A button to start monitoring  
B) A rule that fires an alert based on conditions  
C) A graph type  
D) A system service

<v-click>

**Answer: B**

A trigger is a logical condition (e.g. CPU > 80%) that, when true, raises an alert.

</v-click>

---

# Question 6 📦

**What is a template in Zabbix?**

A) An email layout  
B) A graphical theme  
C) A pre-built set of items, triggers, and graphs  
D) A configuration file

<v-click>

**Answer: C**

A template is reusable configuration (items, triggers, graphs) you apply to multiple hosts.

</v-click>

---

# Question 7 ⚙️

**In zabbix_agentd.conf, what is the "Server" parameter for?**

A) Name of the server to monitor  
B) IP of the Zabbix server allowed to connect  
C) Server type (web, db, etc.)  
D) Server port

<v-click>

**Answer: B**

`Server=` is the IP of the Zabbix server allowed to query this agent (security).

</v-click>

---

# Question 8 🟢

**In Zabbix, what does green "ZBX" in Availability mean?**

A) The agent has an error  
B) The agent is reachable and responding  
C) The agent is in maintenance  
D) The agent is disabled

<v-click>

**Answer: B**

Green ZBX = the Zabbix agent is reachable and answers the server.

</v-click>

---

# Question 9 📊

**Where do you see the latest data collected for a host?**

A) Configuration → Hosts  
B) Monitoring → Latest data  
C) Reports → Data  
D) Administration → Queue

<v-click>

**Answer: B**

**Monitoring → Latest data** shows the latest values for all host items.

</v-click>

---

# Question 10 📧

**To receive alerts by email, what must you configure?**

A) SMTP server only  
B) Trigger only  
C) Email media type + assign to user + create an action  
D) Nothing - it’s automatic

<v-click>

**Answer: C**

You need: 1) Email media type (SMTP), 2) Assign it to the user, 3) Create an action to send the alert.

</v-click>

---

# Score 🎯

**Scale:**
- 9–10: Excellent! ⭐⭐⭐
- 7–8: Very good! ⭐⭐
- 5–6: Good - consolidate ⭐
- < 5: Review the module

**Next step:** Hands-on Zabbix exercises

---
layout: default
---

# End of quiz ✅

Move on to the hands-on exercises!

