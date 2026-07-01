---

# Quiz - Monitoring & System Analysis ✅

**Module 4: Knowledge check**

---

# Question 1 📊

**What does a load average of 4.0 mean on a machine with 2 CPUs?**

A) The system is underutilized  
B) The system is at 50% load  
C) The system is overloaded (twice as much work as CPUs)  
D) The system is behaving normally

<v-click>

**Answer: C**

Load average > number of CPUs = overloaded. Here 4.0 for 2 CPUs = 2× too much work.

</v-click>

---

# Question 2 🎨

**What is the main advantage of htop over top?**

A) htop is faster  
B) htop uses fewer resources  
C) htop has a colorful, more intuitive interface  
D) htop runs on more systems

<v-click>

**Answer: C**

htop provides a colorful UI with bar graphs, keyboard navigation, and easier actions.

</v-click>

---

# Question 3 💽

**Which command shows which process uses the most disk I/O?**

A) top  
B) htop  
C) iostat  
D) iotop

<v-click>

**Answer: D**

iotop shows per-process disk I/O usage in real time.

</v-click>

---

# Question 4 📜

**How do you view nginx error logs with journalctl?**

A) `journalctl nginx`  
B) `journalctl -u nginx -p err`  
C) `journalctl --error nginx`  
D) `journalctl -e nginx`

<v-click>

**Answer: B**

`journalctl -u nginx -p err` filters the service logs to error priority.

</v-click>

---

# Question 5 📈

**Which tool automatically collects system statistics every 10 minutes?**

A) top  
B) sar (sysstat)  
C) htop  
D) vmstat

<v-click>

**Answer: B**

sar (System Activity Reporter) collects system stats automatically for historical analysis.

</v-click>

---

# Question 6 🔄

**Which file configures automatic log rotation for nginx?**

A) /etc/nginx/logrotate.conf  
B) /etc/logrotate.d/nginx  
C) /var/log/nginx/rotate.conf  
D) /etc/log/rotate/nginx

<v-click>

**Answer: B**

Per-service logrotate configs live in /etc/logrotate.d/

</v-click>

---

# Question 7 💾

**Which disk usage threshold is generally considered critical?**

A) > 50%  
B) > 70%  
C) > 85%  
D) > 95%

<v-click>

**Answer: C**

Beyond ~85% disk usage there is risk of crashes or severe slowdown.

</v-click>

---

# Question 8 🔍

**In vmstat, what does si/so > 0 mean?**

A) CPU is overloaded  
B) The system is using swap (memory pressure)  
C) The disk is slow  
D) The network is saturated

<v-click>

**Answer: B**

si (swap in) and so (swap out) > 0 mean the system is short on RAM and using swap.

</v-click>

---

# Question 9 🧹

**How do you trim journald logs to keep only 7 days?**

A) `journalctl --clean 7d`  
B) `journalctl --vacuum-time=7d`  
C) `journalctl --delete-old 7`  
D) `journalctl -r 7d`

<v-click>

**Answer: B**

`journalctl --vacuum-time=7d` removes logs older than 7 days.

</v-click>

---

# Question 10 ⏰

**Which cron expression runs a script every 5 minutes?**

A) `5 * * * * /script.sh`  
B) `*/5 * * * * /script.sh`  
C) `* 5 * * * /script.sh`  
D) `0/5 * * * * /script.sh`

<v-click>

**Answer: B**

`*/5` means “every 5 units” in the minutes field.

</v-click>

---

# Score 🎯

**Scale:**
- 9–10: Excellent! ⭐⭐⭐
- 7–8: Very good! ⭐⭐
- 5–6: Good - consolidate ⭐
- < 5: Review the module

**Next step:** Hands-on exercises

---
layout: default
---

# End of quiz ✅

Move on to the hands-on exercises to apply what you learned!

