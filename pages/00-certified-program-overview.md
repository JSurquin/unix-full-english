---
layout: new-section
routeAlias: 'certified-program'
---

<a name="certified-program" id="certified-program"></a>

# 📋 Official syllabus

<div class="text-xs">

This **three-day** track goes from **Linux basics** to **network, storage, and monitoring**, then **OpenLDAP and SNMP**. Each day builds on the last - Day 1: the OS, Day 2: connect and watch the machine, Day 3: shared login and SNMP.

**Warm-up (before the syllabus):** short **Unix / GNU / Linux history** and **basic commands** (files, folders, pipes) so everyone starts at the same level.

</div>

---

# Day 1 - Linux system foundation

<div class="text-xs">

**Today (Day 1)**, we focus on what makes a Linux box usable, manageable, and secure at the operating-system level.

**Users & permissions** - UID/GID, `/etc/passwd`, `/etc/group`, `/etc/shadow`, `/dev/*`, create and delete users, **extra groups**.

**Sudo** - with or without password, session timeout, common `sudoers` rules.

**Init & services** - `systemd` units and targets, enable/disable, status, logs; compare with old **`init.d`** when needed.

**Files & directories** - `chmod`, `chown`, `umask`, ACLs, symbolic vs hard links.

**Filesystems & LVM** - ext4, btrfs, overlayfs, mount, `/etc/fstab`, PV / VG / LV, grow volumes, snapshots, `fsck` / `e2fsck` (RAID covered as theory).

**MAC** - **AppArmor** on Ubuntu (enforce/complain profiles, check logs with journal).

</div>

---

# Day 2 - Network, storage & observability

<div class="text-xs">

**On Day 2**, the machine **connects to the network and shows its health** - network and observability (storage & LVM were already covered on Day 1).

**Network** - static IP, DHCP, DNS, routes, **ufw** firewall (Ubuntu).

**Performance** - `top`, `htop`, `vmstat`, `iostat`, `sar` for CPU, RAM, disk, I/O.

**Logs** - syslog, `rsyslog`, `journalctl`, `logrotate`.

</div>

---

# Day 3 - Linux services

<div class="text-xs">

**On Day 3**, we set up **OpenLDAP** (one login for many servers) and **SNMP** (read server stats from afar).

**OpenLDAP** - install server, basic schema (`ou=people`, `ou=groups`, `posixAccount`), **NSS/PAM** on clients, firewall rules, test login end to end.

**SNMP** - install `snmpd`, v2c in the lab (short v3 example), MIBs and OIDs, `snmpwalk` / `snmpget`.

**Troubleshooting workshop (closes the training)** - **hands-on labs** on broken VMs (boot, disk, services, LDAP, SNMP). Placed at the end on purpose: scenarios D & E need the LDAP and SNMP modules.

</div>

---

# How to read this deck

<div class="text-xs">

- Some chapters are **long** on purpose: treat them as **reference** at home; in class, follow the day-by-day bullets above.  
- **Live coding:** the **trainer** demos on the VM (explain + type commands).  
- **Student exercises:** after **LVM**, **AppArmor**, **ufw**, **OpenLDAP**, and **SNMP**, students work **alone** on the 🎯 exercise slides in this deck.  
- **End-of-training troubleshooting:** the trainer breaks things on the lab VM - students diagnose and fix (after LDAP & SNMP).  

Press **space** to follow the technical modules in sequence.

</div>
