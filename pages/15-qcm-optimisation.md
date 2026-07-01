---

# Quiz - Optimization & performance (BONUS) ✅

**Module 6: Knowledge check**

---

# Question 1 🎯

**When should you tune a system?**

A) Right after installation  
B) Every month on a schedule  
C) Only when a performance problem is identified  
D) Never - the system tunes itself

<v-click>

**Answer: C**

Avoid premature optimization. Tune only when a real, measured problem exists.

</v-click>

---

# Question 2 💾

**What does vm.swappiness=10 mean?**

A) Use 10% swap  
B) Aggressive swap  
C) Minimal swap, prefer RAM  
D) Disable swap completely

<v-click>

**Answer: C**

swappiness=10 minimizes swap use and prefers RAM. Recommended for servers with enough RAM.

</v-click>

---

# Question 3 🔧

**How do you apply changes from /etc/sysctl.conf?**

A) `sudo sysctl -a`  
B) `sudo sysctl -p`  
C) `sudo systemctl reload sysctl`  
D) Reboot the server

<v-click>

**Answer: B**

`sudo sysctl -p` reloads and applies /etc/sysctl.conf without reboot.

</v-click>

---

# Question 4 🚀

**What is the recommended value for worker_processes in Nginx?**

A) 1  
B) 2  
C) 4  
D) auto

<v-click>

**Answer: D**

`worker_processes auto` scales to the number of CPUs.

</v-click>

---

# Question 5 🗄️

**What is the recommended innodb_buffer_pool_size for MySQL?**

A) 128 MB  
B) 10–20% of RAM  
C) 70–80% of available RAM  
D) 100% of RAM

<v-click>

**Answer: C**

70–80% of available RAM for MySQL is typical (leave room for the OS).

</v-click>

---

# Score 🎯

**Scale:**
- 5/5: Excellent! ⭐⭐⭐
- 4/5: Very good! ⭐⭐
- 3/5: Good ⭐
- < 3: Review the module

---
layout: default
---

# End of BONUS quiz ✅

Move on to hands-on exercises to experiment!
