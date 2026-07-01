---
layout: new-section
routeAlias: 'troubleshooting-labs'
---

<a name="troubleshooting-labs" id="troubleshooting-labs"></a>

# 🧯 Guided troubleshooting labs
## End of training - we break things on purpose

You already did **logs, metrics, network, storage, LDAP and SNMP**.  
The trainer breaks the lab VM - **never on real production** without a backup.

---
layout: new-section
---

# 🧪 Live coding - End of training · Troubleshooting

### Break scenarios A→E - students diagnose and fix on the VM

---

# Lab 0 - safety first

- **Snapshot the VM** before each scenario.  
- Keep **console access** (serial or hypervisor).  
- Work in pairs: **one fixes, one writes notes**.

The trainer breaks the VM **live** - students diagnose and fix.

Scenarios **A→E** map to the slides below.

---

# Scenario A - “Boot stops at initramfs”

**Problem:** typo in `/etc/fstab` or wrong UUID.  
**You see:** emergency shell, mount errors.  
**Check:** `journalctl -xb`, `findmnt`, `blkid` vs fstab.  
**Fix:** fix fstab, `findmnt --verify`, reboot.

**Trainer:** add a fake UUID line to `/etc/fstab` → students run `sudo mount -a`.

---

# Scenario B - “Disk full but du looks OK”

**Problem:** deleted file still open **or** logs fill `/var`.  
**You see:** `No space left on device`.  
**Check:** `df -h`, `du -xhd1`, `lsof +L1`, `journalctl --disk-usage`.  
**Fix:** stop/truncate the process, fix **logrotate**, grow LV if needed.

**Trainer:** create a deleted-but-open file that fills `/var` - students find it with `lsof +L1`.

---

# Scenario C - “Service restart loop”

**Problem:** bad `ExecStart`, missing dependency, socket permissions.  
**You see:** `systemctl status` shows many restarts.  
**Check:** `journalctl -u svc -b`, `systemctl cat svc`, `ss -lntp`.  
**Fix:** fix the unit; check AppArmor (`journalctl -k | grep -i apparmor`).

**Trainer:** set `ExecStart=/usr/bin/false` + `Restart=always` on `my-service` - students check `journalctl -u my-service`.

---

# Scenario D - “LDAP works on console, not SSH”

**Problem:** wrong PAM for `sshd`, or NSS does not use LDAP.  
**You see:** `getent` OK locally, SSH login fails.  
**Check:** `/etc/pam.d/common-account`, `pam-auth-update`, `journalctl -u ssh`.  
**Fix:** `pam_ldap` **before** `pam_deny`; check `UsePAM` in `sshd_config`.

**Trainer:** swap `pam_ldap` and `pam_deny` in `common-account` - classic mis-ordering.

---

# Scenario E - “SNMP timeouts”

**Problem:** wrong community string, firewall, or `agentAddress`.  
**You see:** `snmpwalk` hangs, `ss -lunp` shows nothing on port 161.  
**Check:** `ss -lunp`, `ufw status`, `snmpd.conf`, AppArmor logs.
**Fix:** match firewall + snmp config.

**Trainer:** set `agentAddress 127.0.0.1` + wrong community string - students fix `snmpd.conf`.

---

# Debrief (5 min each)

1. **How did you notice?** - first error or alert?  
2. **Root cause** - real problem, not just the symptom?  
3. **Fix** - smallest safe change?  
4. **Next time** - monitoring, alerts, written steps?

End of the training - debrief and Q&A.

---
layout: new-section
---

# ✅ Live coding done - Troubleshooting

**You practiced on the VM:** scenarios A→E - diagnose, fix, debrief

**Verify at home:** replay each scenario on a snapshot VM - write root cause + smallest fix

**End of the training** - thanks for your attention, replay scenarios at home on a snapshot VM.
