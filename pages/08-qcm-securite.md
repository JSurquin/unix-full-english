---

# Module 9 quiz: System security ✅

**10 questions on system hardening**

---

# Question 1

What is SELinux?

A) A package manager

B) A mandatory access control (MAC) system

C) A firewall

D) A text editor

---

# Question 2

Which tool blocks IPs after several failed login attempts?

A) `iptables`

B) `fail2ban`

C) `ufw`

D) `firewalld`

---

# Question 3

Where are hashed passwords stored?

A) `/etc/passwd`

B) `/etc/shadow`

C) `/etc/security`

D) `/etc/passwords`

---

# Question 4

Which command temporarily disables SELinux enforcement?

A) `selinux disable`

B) `setenforce 0`

C) `systemctl stop selinux`

D) `disable selinux`

---

# Question 5

Which file configures sudo?

A) `/etc/sudo`

B) `/etc/sudoers`

C) `/etc/sudo.conf`

D) `/etc/security/sudo`

---

# Question 6

What does fail2ban monitor?

A) System performance

B) Logs to detect intrusion attempts

C) Disk space

D) Processes

---

# Question 7

Which command shows failed login attempts?

A) `lastlog`

B) `last`

C) `lastb`

D) `faillog`

---

# Question 8

What is a best practice for SSH?

A) Use strong passwords

B) Use SSH keys

C) Change the port

D) All of the above

---

# Question 9

What does `auditd` do?

A) Optimizes performance

B) Audits system actions

C) Cleans the system

D) Backs up files

---

# Question 10

How do you encrypt a partition on Linux?

A) `encrypt`

B) `LUKS`

C) `cryptfs`

D) `secure`

---

# Module 9 answers 📝

**Answer 1:** B) A mandatory access control (MAC) system
- SELinux adds a security layer beyond Unix permissions

**Answer 2:** B) `fail2ban`
- Protection against brute-force attacks

**Answer 3:** B) `/etc/shadow`
- Accessible only by root

**Answer 4:** B) `setenforce 0`
- 0 = permissive, 1 = enforcing

**Answer 5:** B) `/etc/sudoers`
- Edit ONLY with `visudo`

---

# Module 9 answers (continued) 📝

**Answer 6:** B) Logs to detect intrusion attempts
- Temporarily bans suspicious IPs

**Answer 7:** C) `lastb`
- `last` shows successful logins

**Answer 8:** D) All of the above
- Defense in depth: multiple layers

**Answer 9:** B) Audits system actions
- Records who did what and when

**Answer 10:** B) `LUKS`
- LUKS = Linux Unified Key Setup

---

# Module 9 score 📊

Count your correct answers:

- **9–10:** Excellent! ⭐⭐⭐
- **7–8:** Good! ⭐⭐
- **5–6:** Review needed ⭐
- **< 5:** Reread module 9
