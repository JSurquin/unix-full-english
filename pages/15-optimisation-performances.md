---
layout: new-section
routeAlias: 'optimisation-performances'
---

<a name="optimisation-performances" id="optimisation-performances"></a>

# ⚡ Module 6 (BONUS)
## Optimization & performance

### Going further with system tuning

---

#### When to optimize? 🤔

<div class="text-xs">

**Don’t optimize prematurely!**

Famous quote:
> "Premature optimization is the root of all evil" - Donald Knuth

**Optimize ONLY if:**
- A performance problem is identified
- The bottleneck is located
- There is real business impact
- Monitoring data is available

**Process:**
1. **Measure** (monitoring)
2. **Identify** the issue
3. **Optimize** the hot spot
4. **Re-measure** the impact

</div>

---

# sysctl: kernel tuning ⚙️

**sysctl**: change Linux kernel parameters at runtime

```bash
# List all parameters
sysctl -a

# Show one parameter
sysctl vm.swappiness

# Change temporarily
sudo sysctl vm.swappiness=10

# Apply from /etc/sysctl.conf
sudo sysctl -p
```

**Temporary changes** = lost on reboot  
**Persistent changes** = in `/etc/sysctl.conf`

---

# Memory tuning: swappiness 💾

**vm.swappiness**: tendency to use swap (0–100)

- **100**: aggressive swap (old defaults)
- **60**: common modern default
- **10**: minimal swap (servers with plenty of RAM)
- **0**: almost no swap except in emergencies

**For a server with 8 GB+ RAM:**

```bash
# Temporary
sudo sysctl vm.swappiness=10

# Persistent
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

---

# Network tuning: TCP parameters 🌐

**For a high-load web server:**

```bash
sudo nano /etc/sysctl.conf
```

```ini
# Increase connection backlog
net.core.somaxconn = 4096

# Increase SYN backlog
net.ipv4.tcp_max_syn_backlog = 8096

# Reduce FIN_WAIT timeout
net.ipv4.tcp_fin_timeout = 30

# Reuse TIME_WAIT sockets
net.ipv4.tcp_tw_reuse = 1

# Larger network buffers
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
```

```bash
sudo sysctl -p
```

---

# Open file limits 📂

**Common issue**: "Too many open files"

```bash
# Current limit
ulimit -n

# Increase temporarily
ulimit -n 65535
```

**Persistent: `/etc/security/limits.conf`**

```
* soft nofile 65535
* hard nofile 65535
```

**For systemd services:** in the `.service` file

```ini
[Service]
LimitNOFILE=65535
```

---

# tuned: automatic optimization profiles 🎚️

**tuned**: daemon that applies optimization profiles (Red Hat ecosystem)

```bash
# Install
sudo dnf install tuned

# Start
sudo systemctl enable --now tuned

# List profiles
tuned-adm list

# Common profiles:
# - throughput-performance: high-throughput servers
# - latency-performance: low latency
# - network-latency: network tuned
# - virtual-guest: VM guest
```

---

# Using tuned 🔧

```bash
# Active profile
tuned-adm active

# Apply a profile
sudo tuned-adm profile throughput-performance

# Automatic recommendation
sudo tuned-adm recommend

# Disable
sudo tuned-adm off
```

**Benefit:** automatic tuning without hand-editing sysctl!

---

# Nginx: basic optimizations 🚀

**File: `/etc/nginx/nginx.conf`**

```nginx
# Processes = number of CPUs
worker_processes auto;

# Connections per worker
events {
    worker_connections 1024;
    use epoll;
}

http {
    # Keepalive
    keepalive_timeout 65;
    keepalive_requests 100;
    
    # Compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;
    gzip_min_length 1000;
}
```

---

# Nginx: FastCGI cache (PHP) 💨

**Speed up PHP with FastCGI cache:**

```nginx
# In http
fastcgi_cache_path /var/cache/nginx levels=1:2 keys_zone=APPCACHE:100m inactive=60m;
fastcgi_cache_key "$scheme$request_method$host$request_uri";

# In location ~ \.php$
fastcgi_cache APPCACHE;
fastcgi_cache_valid 200 60m;
fastcgi_cache_bypass $http_pragma $http_authorization;
add_header X-Cache-Status $upstream_cache_status;
```

**Result:** PHP runs once, then served from cache for 60 min

---

# MySQL: essential tuning 🗄️

**File: `/etc/mysql/my.cnf` or `/etc/mysql/mysql.conf.d/mysqld.cnf`**

```ini
[mysqld]
# Buffer pool = 70–80% of available RAM
innodb_buffer_pool_size = 2G

# Logs
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2

# Connections
max_connections = 200

# Query cache (MySQL < 8.0)
query_cache_size = 64M
query_cache_type = 1
```

```bash
sudo systemctl restart mysql
```

---

# MySQL: find slow queries 🐌

**Enable the slow query log:**

```bash
sudo nano /etc/mysql/my.cnf
```

```ini
[mysqld]
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2
log_queries_not_using_indexes = 1
```

```bash
sudo systemctl restart mysql

# Analyze slow queries
sudo mysqldumpslow /var/log/mysql/slow.log
```

---

# MySQLTuner: analysis script 📊

**MySQLTuner**: analyzes MySQL and suggests tuning

```bash
# Download
wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl
chmod +x mysqltuner.pl

# Run
sudo ./mysqltuner.pl

# The script shows:
# - Current statistics
# - Tuning recommendations
# - Parameters to adjust
```

**Apply recommendations** by editing my.cnf

---

# Application cache: Redis ⚡

**Redis**: in-memory key-value cache

```bash
# Install
sudo apt install redis-server

# Memory-only policy
sudo nano /etc/redis/redis.conf
# maxmemory 256mb
# maxmemory-policy allkeys-lru

# Restart
sudo systemctl restart redis-server
```

**Uses:** session cache, DB query cache, HTML fragments…

**PHP example:** replace file sessions with Redis

---

#### Web server optimization checklist ✅

<div class="text-xs">

**Typical stack (Nginx + PHP + MySQL):**

□ **System**
- vm.swappiness = 10
- Open file limits = 65535
- tuned profile: throughput-performance

□ **Nginx**
- worker_processes auto
- gzip enabled
- keepalive configured
- FastCGI cache for PHP

□ **MySQL**
- innodb_buffer_pool_size tuned (~70% RAM)
- Slow query log enabled
- MySQLTuner run

</div>

---

#### Module 6 (BONUS) recap ✅

<div class="text-xs">

**What you learned:**

- ✅ Memory tuning (swappiness)
- ✅ Network tuning (TCP)
- ✅ Open file limits
- ✅ Automatic tuned profiles
- ✅ Nginx tuning (workers, gzip, cache)
- ✅ MySQL tuning (buffer pool, slow queries)
- ✅ MySQLTuner for analysis
- ✅ Redis cache

**Important:** always measure before and after!

</div>

---

# Congratulations! 🎉

You completed the **Linux Server Administration** course!

**Skills gained:**
- System monitoring (top, htop, iotop, sar)
- Advanced monitoring (Zabbix)
- Performance tuning (sysctl, tuned)
- NTP/DHCP configuration

**Next steps:**
- Practice on real servers
- Explore other tools (Prometheus, Ansible)
- Learn containers (Docker, Kubernetes)

