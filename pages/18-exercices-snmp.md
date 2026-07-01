---
layout: new-section
routeAlias: 'exercices-snmp'
---

<a name="exercices-snmp" id="exercices-snmp"></a>

# 🎯 Student exercises - SNMP
## Day 3 - after the live demo

**Alone on the VM** - you are the **manager** (`snmpget` / `snmpwalk`), the VM runs the **agent** (`snmpd`).

Lab community (v2c): **`training`** · poll target: **`127.0.0.1`**

---

# Exercise 1: Configure and poll the agent 📡

**Goal:** Install `snmpd`, set your own strings, prove polling works with **numeric OIDs**.

**Tasks:**

1. Install `snmpd`, `snmp`, `snmp-mibs-downloader`
2. Backup and edit `/etc/snmp/snmpd.conf`:
   - `agentAddress udp:161`
   - `rocommunity training 127.0.0.1`
   - `sysLocation` = **your name + city** (e.g. `Alice - Lille`)
   - `sysContact` = **your email** (e.g. `alice@lab.local`)
3. Enable and restart `snmpd`
4. Check UDP 161: `sudo ss -lunp | grep 161`
5. Poll with numeric OIDs (no MIB names needed)

---

# Exercise 1 - snmpd.conf

```bash
sudo apt install -y snmpd snmp snmp-mibs-downloader
sudo cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak
sudo nano /etc/snmp/snmpd.conf
```

---

# Exercise 1 - start and numeric poll

```bash
sudo systemctl enable --now snmpd
sudo systemctl restart snmpd
sudo ss -lunp | grep 161
snmpget -v2c -c training 127.0.0.1 1.3.6.1.2.1.1.5.0
snmpwalk -v2c -c training 127.0.0.1 1.3.6.1.2.1.1
```

---

# Exercise 1 - what you must see

- Hostname (OID `.1.5.0`)
- **sysContact** and **sysLocation** = the strings **you** wrote in config
- Uptime counter

You did **not** use `cat /etc/snmp/snmpd.conf` to answer - SNMP served the data.

---

# Exercise 2: Readable MIB names 🪤

**Goal:** Fix the Ubuntu client trap - agent OK, names fail.

**Tasks:**

1. Run `snmpwalk -v2c -c training 127.0.0.1 system` - note if it fails (*Unknown Object Identifier*)
2. Edit **`/etc/snmp/snmp.conf`** (client file) - comment out line `mibs :`
3. Retry with readable names:
   - `SNMPv2-MIB::sysName.0`
   - `SNMPv2-MIB::sysContact.0`
   - `SNMPv2-MIB::sysLocation.0`

---

# Exercise 2 - fix client MIB

```bash
snmpwalk -v2c -c training 127.0.0.1 system
sudo nano /etc/snmp/snmp.conf
snmpget -v2c -c training 127.0.0.1 SNMPv2-MIB::sysContact.0
snmpget -v2c -c training 127.0.0.1 SNMPv2-MIB::sysLocation.0
```

---

# Exercise 3: Break and fix (manager view) 🧯

**Goal:** Same skills as troubleshooting scenario E.

**Tasks:**

1. Break: wrong community in config **or** `agentAddress 127.0.0.1` only while you poll another IP
2. Symptom: `snmpget` timeout or *Authentication failure*
3. Fix: match community, listen on `udp:161`, check `ufw` allows UDP 161 from your subnet if polling remotely
4. Document: 3 checks you ran (`ss`, config, firewall)

---

# Exercise 3 - diagnostic commands

```bash
snmpget -v2c -c WRONG 127.0.0.1 1.3.6.1.2.1.1.5.0
sudo ss -lunp | grep 161
sudo ufw status | grep 161
sudo journalctl -u snmpd -n 15
grep -E 'agentAddress|rocommunity' /etc/snmp/snmpd.conf
```

---

# Exercise 4: Agent vs manager (written) 📝

**Goal:** No commands - explain in **3 short sentences**:

1. What runs on the **monitored server**? (process + port)
2. What runs on the **monitoring station**? (example tools)
3. Why is SNMP useful when you have 500 servers?

---

# SNMP exercises - recap ✅

- [ ] `snmpd` listens on UDP 161
- [ ] Numeric `snmpwalk` returns your sysContact/sysLocation
- [ ] Readable MIB names work after `snmp.conf` fix
- [ ] You fixed a deliberate break (community / listen / firewall)
- [ ] You can explain agent vs manager
