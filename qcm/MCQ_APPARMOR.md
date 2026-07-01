================================================================================
MCQ - Security & AppArmor
Slide module (routeAlias): securite-systeme · Scope: in_scope
MAC, AppArmor, hardening
Instructions: For each question, enter your answer (A, B, C, or D)
================================================================================

Question 1: What is AppArmor?

A) A package manager for security updates
B) A firewall that blocks network ports
C) A disk encryption tool
D) A mandatory access control (MAC) system that restricts what each program may do

Your answer: ___

================================================================================

Question 2: Which tool blocks IP addresses after several failed login attempts?

A) iptables
B) fail2ban
C) ufw
D) firewalld

Your answer: ___

================================================================================

Question 3: Where are encrypted user passwords stored on Linux?

A) /etc/passwords
B) /etc/passwd
C) /etc/security
D) /etc/shadow

Your answer: ___

================================================================================

Question 4: Which command puts an AppArmor profile in complain (log-only) mode?

A) aa-enforce
B) aa-disable
C) apparmor off
D) aa-complain

Your answer: ___

================================================================================

Question 5: Which file configures sudo permissions?

A) /etc/sudo.conf
B) /etc/sudoers
C) /etc/security/sudo
D) /etc/sudo

Your answer: ___

================================================================================

Question 6: In AppArmor enforce mode, what happens when a program tries an action not allowed by its profile?

A) The profile is automatically deleted
B) The action is blocked and logged as DENIED
C) Only root can see the block in /var/log/auth.log
D) The action is allowed but logged as ALLOWED

Your answer: ___

================================================================================

Question 7: Which command shows failed login attempts?

A) lastlog
B) faillog
C) lastb
D) last

Your answer: ___

================================================================================

Question 8: What is a best practice for SSH?

A) Use strong passwords
B) Use SSH keys
C) Change the default port
D) All of the above

Your answer: ___

================================================================================

Question 9: How do you inspect AppArmor DENIED events in the kernel log?

A) journalctl -k | grep DENIED
B) dmesg --apparmor
C) grep DENIED /var/log/syslog only
D) aa-status --denied

Your answer: ___

================================================================================

Question 10: Where are AppArmor profile files stored?

A) /etc/selinux/
B) /usr/share/apparmor/profiles/
C) /var/lib/apparmor/
D) /etc/apparmor.d/

Your answer: ___

================================================================================
END OF MCQ MODULE 4 - SECURITY & APPARMOR
================================================================================
