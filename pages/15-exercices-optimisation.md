---
layout: exercices
---

# Exercises - Optimization & performance (BONUS) 🎯

**Module 6: Hands-on**

---

# Exercise 1: Tune memory 💾

**Goal:** Configure swappiness

**Instructions:**

1. Check current swappiness
2. Set it to 10 temporarily
3. Verify the change
4. Make it persistent in /etc/sysctl.conf
5. Reload configuration

**Duration:** 10 minutes

---

# Exercise 1: Solution 💡

```bash
# 1. Current value
sysctl vm.swappiness
# or
cat /proc/sys/vm/swappiness

# 2. Temporary change
sudo sysctl vm.swappiness=10

# 3. Verify
sysctl vm.swappiness

# 4. Persistent
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf

# 5. Reload
sudo sysctl -p

# Final check
sysctl vm.swappiness
```

---

# Exercise 2: Raise open file limits 📂

**Goal:** Set limit to 65535 open files

**Instructions:**

1. Check current limit: `ulimit -n`
2. Edit /etc/security/limits.conf
3. Add lines for * soft/hard nofile
4. Restart session (logout/login)
5. Verify new limit

**Duration:** 10 minutes

---

# Exercise 2: Solution 💡

```bash
# 1. Current limit
ulimit -n

# 2. Edit limits.conf
sudo nano /etc/security/limits.conf

# 3. Add at end:
* soft nofile 65535
* hard nofile 65535

# 4. Save and close

# 5. Logout then login
exit
# Reconnect

# 6. Verify
ulimit -n
# Should show 65535
```

---

# Exercise 3: Tune Nginx 🚀

**Goal:** Enable gzip and adjust workers

**Instructions:**

1. Edit /etc/nginx/nginx.conf
2. Set worker_processes to auto
3. Enable gzip with appropriate types
4. Test configuration
5. Reload Nginx
6. Verify gzip with curl

**Duration:** 15 minutes

---

# Exercise 3: Solution 💡

```bash
# 1. Edit config
sudo nano /etc/nginx/nginx.conf

# 2–3. Change:
user www-data;
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    # Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_min_length 1000;
    
    # ... rest of config
}

# 4. Test
sudo nginx -t

# 5. Reload
sudo systemctl reload nginx

# 6. Verify gzip
curl -H "Accept-Encoding: gzip" -I http://localhost
# Look for: Content-Encoding: gzip
```

---

# Exercise 4: tuned (Red Hat/CentOS only) 🎚️

**Goal:** Apply an optimization profile

**Prerequisites:** RHEL/CentOS/AlmaLinux/Rocky

**Instructions:**

1. Install tuned
2. List available profiles
3. Show active profile
4. Apply throughput-performance
5. Verify

**Duration:** 10 minutes

---

# Exercise 4: Solution 💡

```bash
# 1. Install
sudo dnf install tuned -y

# Start
sudo systemctl enable --now tuned

# 2. List profiles
tuned-adm list

# 3. Active profile
tuned-adm active

# 4. Apply profile
sudo tuned-adm profile throughput-performance

# 5. Verify
tuned-adm active
# Should show: Current active profile: throughput-performance

# See applied changes
tuned-adm profile_info
```

---

# Exercise 5: Optimize MySQL with MySQLTuner 🗄️

**Goal:** Analyze and tune MySQL

**Instructions:**

1. Download MySQLTuner
2. Make it executable
3. Run the script
4. Note main recommendations
5. Apply 2–3 changes in my.cnf
6. Restart MySQL
7. Run MySQLTuner again to see improvement

**Duration:** 20 minutes

---

# Exercise 5: Solution 💡

```bash
# 1–2. Download and chmod
wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl
chmod +x mysqltuner.pl

# 3. Run
sudo ./mysqltuner.pl

# Script asks for MySQL root credentials
# Then prints recommendations

# 4. Example recommendations:
# - Increase innodb_buffer_pool_size
# - Adjust max_connections
# - Enable slow_query_log

# 5. Apply
sudo nano /etc/mysql/my.cnf

# Add/modify:
[mysqld]
innodb_buffer_pool_size = 1G
max_connections = 200
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log

# 6. Restart
sudo systemctl restart mysql

# 7. Re-run
sudo ./mysqltuner.pl
# Warnings should decrease
```

---

# BONUS project: Before/after benchmark ⚡

**Goal:** Measure the impact of tuning

**Tool:** Apache Bench (ab)

**Steps:**

1. Install Apache Bench: `sudo apt install apache2-utils`
2. Test Nginx BEFORE tuning:
   ```bash
   ab -n 1000 -c 10 http://localhost/
   ```
3. Note "Requests per second"
4. Apply Nginx tuning (exercise 3)
5. Test AFTER:
   ```bash
   ab -n 1000 -c 10 http://localhost/
   ```
6. Compare results

**Goal:** +20% requests/sec

---

# BONUS project: Solution 💡

```bash
# 1. Install Apache Bench
sudo apt install apache2-utils -y

# 2. Benchmark BEFORE
ab -n 1000 -c 10 http://localhost/
# Note: Requests per second: XXX [#/sec]

# 3. Tune Nginx (see exercise 3)
# - worker_processes auto
# - gzip on
# - keepalive_timeout 65

# 4. Benchmark AFTER
ab -n 1000 -c 10 http://localhost/
# Note: Requests per second: YYY [#/sec]

# 5. Compute gain
# Gain % = ((YYY - XXX) / XXX) * 100

# Example:
# Before: 500 req/sec
# After: 650 req/sec
# Gain: +30%
```

---

# Full optimization checklist ✅

**System is tuned when:**

□ vm.swappiness = 10  
□ Open file limits = 65535  
□ TCP network params adjusted (somaxconn, syn_backlog)  
□ Nginx: worker_processes auto + gzip  
□ MySQL: buffer pool tuned + slow_query enabled  
□ MySQLTuner run and recommendations applied  
□ Before/after benchmarks documented

---

# BONUS exercise recap ✅

**Skills practiced:**

✅ sysctl configuration (swappiness, network)

✅ Open file limits

✅ Nginx tuning (workers, gzip)

✅ tuned profiles (Red Hat)

✅ MySQL analysis with MySQLTuner

✅ Benchmarking with Apache Bench

**Important:** always measure real-world impact!

---
layout: default
---

# Well done! 🎉

You now know the basics of system optimization.

**Go further:**
- Advanced profiling (perf, flame graphs)
- Distributed cache (Redis, Memcached, Varnish)
- Load balancing and high availability
- APM (Application Performance Monitoring)
