---
layout: new-section
routeAlias: 'exercices-firewall'
---

<a name="exercices-firewall" id="exercices-firewall"></a>

# 🎯 Student exercises - ufw
## Module 5 - after the live demo

**Alone on the VM** - configure the firewall yourself.

**Rule #1:** allow **SSH before** `ufw enable` - or you lock yourself out.

---

# Exercise 1: Basic ufw rules 🔥

**Goal:** Install ufw, allow the right services, enable it, read the rules.

**Tasks:**

1. Install `ufw`
2. Allow **SSH** (port 22)
3. Allow **HTTP** (80) and **HTTPS** (443)
4. Enable ufw
5. Show rules with `ufw status verbose` and `ufw status numbered`
6. From another terminal (or VM console): confirm SSH still works

---

# Exercise 1 - solution

```bash
sudo apt install ufw
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
sudo ufw status verbose
sudo ufw status numbered
```

---

# Exercise 2: Lab ports for LDAP & SNMP 📡

**Goal:** Open only what the Day-3 labs need - from your LAN, not from the whole internet.

**Tasks:**

1. Find your VM IP (`ip -br a`)
2. Allow **LDAP** (TCP 389) only from `192.168.64.0/24` (adjust if your LAN differs)
3. Allow **SNMP** (UDP 161) from the same subnet
4. Add a short **comment** on each rule (`comment 'LDAP lab'`)
5. Show final rules - can you explain each line?

---

# Exercise 2 - solution

```bash
ip -br a
sudo ufw allow from 192.168.64.0/24 to any port 389 proto tcp comment 'LDAP lab'
sudo ufw allow from 192.168.64.0/24 to any port 161 proto udp comment 'SNMP lab'
sudo ufw status numbered
```

---

# Exercise 3: Fix a broken rule 🧯

**Goal:** Practice deleting and fixing rules.

**Setup (trainer may do this for you):** a rule blocks SSH by mistake, or HTTP was never allowed.

**Tasks:**

1. List numbered rules
2. Delete the wrong rule by number
3. Re-add SSH if needed
4. Reload status - SSH works, HTTP works

---

# Exercise 3 - solution

```bash
sudo ufw status numbered
sudo ufw delete 2
sudo ufw allow OpenSSH
sudo ufw status verbose
```

---

# ufw exercises - recap ✅

- [ ] SSH allowed **before** enable
- [ ] HTTP/HTTPS allowed (or consciously denied - you can explain why)
- [ ] LDAP/SNMP rules limited to a subnet
- [ ] You can delete a rule by number
