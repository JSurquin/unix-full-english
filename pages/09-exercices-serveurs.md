---

# 🎯 Hands-on exercises - Module 10

**Server services**

---

# Exercise 1: Nginx web server 🌐

**Goal:** Install and configure Nginx

**Instructions:**

1. Install Nginx
2. Create two sites: `site1.local` and `site2.local`
3. Configure two virtual hosts
4. Add HTML content
5. Test both sites
6. Read access logs

---

# Exercise 1 solution 💡

```bash
# 1. Install
sudo apt update
sudo apt install nginx -y

# 2 & 3. Site 1
sudo mkdir -p /var/www/site1
sudo tee /var/www/site1/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Site 1</title></head>
<body style="background: #4CAF50; color: white;">
  <h1>Welcome to Site 1 🎯</h1>
</body>
</html>
EOF

sudo tee /etc/nginx/sites-available/site1 << 'EOF'
server {
    listen 80;
    server_name site1.local;
    root /var/www/site1;
    index index.html;
}
EOF

# Site 2
sudo mkdir -p /var/www/site2
sudo tee /var/www/site2/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Site 2</title></head>
<body style="background: #2196F3; color: white;">
  <h1>Welcome to Site 2 🚀</h1>
</body>
</html>
EOF

sudo tee /etc/nginx/sites-available/site2 << 'EOF'
server {
    listen 80;
    server_name site2.local;
    root /var/www/site2;
    index index.html;
}
EOF

# Enable
sudo ln -s /etc/nginx/sites-available/site1 /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/site2 /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Add to hosts
echo "127.0.0.1 site1.local site2.local" | sudo tee -a /etc/hosts

# 5. Test
curl http://site1.local
curl http://site2.local

# 6. Logs
sudo tail -f /var/log/nginx/access.log
```

---

# Exercise 2: Reverse proxy 🔄

**Goal:** Configure Nginx as a reverse proxy

**Instructions:**

1. Run two simple HTTP backends on ports 8001 and 8002 (see solution: PHP built-in server)
2. Configure Nginx to proxy requests to them
3. Test load balancing
4. Add custom headers
5. Configure caching

---

# Exercise 2 solution 💡

```bash
# 1. HTTP backends using PHP built-in server (install if needed)
sudo apt install -y php-cli
sudo mkdir -p /tmp/s1 /tmp/s2
echo "Response from Server 1" | sudo tee /tmp/s1/index.html
echo "Response from Server 2" | sudo tee /tmp/s2/index.html

php -S 0.0.0.0:8001 -t /tmp/s1 >/tmp/php8001.log 2>&1 &
php -S 0.0.0.0:8002 -t /tmp/s2 >/tmp/php8002.log 2>&1 &

# 2 & 3. Nginx configuration
sudo tee /etc/nginx/sites-available/proxy << 'EOF'
upstream backend {
    server localhost:8001;
    server localhost:8002;
}

server {
    listen 80;
    server_name proxy.local;
    
    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        
        # Cache
        proxy_cache_valid 200 10m;
        proxy_cache_bypass $http_pragma $http_authorization;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/proxy /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

echo "127.0.0.1 proxy.local" | sudo tee -a /etc/hosts

# Test (round-robin load balancing)
for i in {1..10}; do
    curl -s http://proxy.local/
    echo
done

# Cleanup PHP built-in servers
pkill -f 'php -S 0.0.0.0:8001' || true
pkill -f 'php -S 0.0.0.0:8002' || true
```

---

# Exercise 3: MySQL database 🗄️

**Goal:** Install and secure MySQL

**Instructions:**

1. Install MySQL
2. Run initial hardening
3. Create database `webapp`
4. Create a user with limited privileges
5. Test the connection
6. Create a backup

---

# Exercise 3 solution 💡

```bash
# 1. Install
sudo apt install mysql-server -y

# 2. Hardening
sudo mysql_secure_installation
# - Root password
# - Remove anonymous users: Yes
# - Disallow remote root: Yes
# - Remove test database: Yes
# - Reload privileges: Yes

# 3 & 4. Create database and user
sudo mysql << 'EOF'
CREATE DATABASE webapp;
CREATE USER 'webapp_user'@'localhost' IDENTIFIED BY 'SecurePass123!';
GRANT SELECT, INSERT, UPDATE, DELETE ON webapp.* TO 'webapp_user'@'localhost';
FLUSH PRIVILEGES;

-- Test table
USE webapp;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO users (username, email) VALUES
('alice', 'alice@example.com'),
('bob', 'bob@example.com');
EOF

# 5. Test
mysql -u webapp_user -p'SecurePass123!' -e "SELECT * FROM webapp.users;"

# 6. Backup
sudo mysqldump -u root webapp > /tmp/webapp_backup.sql

# Restore (if needed)
# mysql -u root webapp < /tmp/webapp_backup.sql

# Automatic backup script
cat > /usr/local/bin/mysql_backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backup/mysql"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR
mysqldump --all-databases | gzip > $BACKUP_DIR/all_dbs_${DATE}.sql.gz

# Keep only last 7 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
EOF

chmod +x /usr/local/bin/mysql_backup.sh
```

---

# Exercise 4: SSL with Let's Encrypt 🔒

**Goal:** Secure a site with HTTPS

**Instructions:**

1. Install Certbot
2. Obtain a certificate (real domain required, or local self-signed test)
3. Configure Nginx for HTTPS
4. Force HTTP → HTTPS redirect
5. Test the certificate
6. Configure automatic renewal

---

# Exercise 4 solution 💡

```bash
# 1. Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# 2. Obtain certificate (real domain)
sudo certbot --nginx -d example.com -d www.example.com

# Local test (self-signed)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=FR/ST=France/L=Paris/O=Test/CN=site1.local"

# 3 & 4. HTTPS config
sudo tee /etc/nginx/sites-available/site1-ssl << 'EOF'
server {
    listen 80;
    server_name site1.local;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name site1.local;
    
    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    root /var/www/site1;
    index index.html;
}
EOF

sudo ln -sf /etc/nginx/sites-available/site1-ssl /etc/nginx/sites-enabled/site1
sudo nginx -t
sudo systemctl reload nginx

# 5. Test
curl -k https://site1.local

# 6. Automatic renewal (Let's Encrypt)
sudo certbot renew --dry-run

# Cron
echo "0 3 * * * certbot renew --quiet" | sudo crontab -
```

---

# Exercise 5: Monitoring with Prometheus & Node Exporter 📊

**Goal:** Set up monitoring

**Instructions:**

1. Install Node Exporter
2. Configure it as a service
3. Test metrics
4. Write a custom monitoring script
5. Export custom metrics

---

# Exercise 5 solution 💡

```bash
# 1. Download Node Exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.7.0.linux-amd64.tar.gz
sudo mv node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
sudo useradd -rs /bin/false node_exporter

# 2. systemd service
sudo tee /etc/systemd/system/node_exporter.service << 'EOF'
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# 3. Test
curl http://localhost:9100/metrics

# Sample metrics
curl http://localhost:9100/metrics | grep node_cpu
curl http://localhost:9100/metrics | grep node_memory

# 4 & 5. Custom metrics
cat > /var/lib/node_exporter/textfile_collector/custom.prom << 'EOF'
# HELP custom_disk_usage Custom disk usage metric
# TYPE custom_disk_usage gauge
custom_disk_usage{path="/"} 75.5

# HELP custom_service_status Custom service status
# TYPE custom_service_status gauge
custom_service_status{service="nginx"} 1
custom_service_status{service="mysql"} 1
EOF

# Update script
cat > /usr/local/bin/update_custom_metrics.sh << 'EOF'
#!/bin/bash
METRICS_FILE="/var/lib/node_exporter/textfile_collector/custom.prom"

# Disk usage
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

# Service status
NGINX_STATUS=$(systemctl is-active nginx && echo 1 || echo 0)
MYSQL_STATUS=$(systemctl is-active mysql && echo 1 || echo 0)

cat > $METRICS_FILE << ENDOFMETRICS
# HELP custom_disk_usage Custom disk usage metric
# TYPE custom_disk_usage gauge
custom_disk_usage{path="/"} $DISK_USAGE

# HELP custom_service_status Custom service status
# TYPE custom_service_status gauge
custom_service_status{service="nginx"} $NGINX_STATUS
custom_service_status{service="mysql"} $MYSQL_STATUS
ENDOFMETRICS
EOF

chmod +x /usr/local/bin/update_custom_metrics.sh

# Every minute
echo "* * * * * /usr/local/bin/update_custom_metrics.sh" | crontab -
```

---

# Bonus exercise: Full Docker stack 🐳

**Goal:** Deploy a stack with Docker Compose

**Create a `docker-compose.yml` with:**
- Nginx
- PHP-FPM
- MySQL
- Redis
- phpMyAdmin

---

# Bonus exercise solution 💡

```yaml
# docker-compose.yml
version: '3.8'

services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./html:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - php

  php:
    image: php:8.2-fpm
    volumes:
      - ./html:/var/www/html
    environment:
      - MYSQL_HOST=mysql
      - REDIS_HOST=redis

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: webapp
      MYSQL_USER: user
      MYSQL_PASSWORD: userpass
    volumes:
      - mysql_data:/var/lib/mysql

  redis:
    image: redis:latest

  phpmyadmin:
    image: phpmyadmin:latest
    ports:
      - "8080:80"
    environment:
      PMA_HOST: mysql
      PMA_USER: root
      PMA_PASSWORD: rootpass

volumes:
  mysql_data:
```

**Start:**

```bash
docker-compose up -d
docker-compose ps
docker-compose logs -f
```

---

### Key takeaways 📌

<div class="text-xs">

**Nginx:**
- Virtual hosts for multi-site
- Reverse proxy for applications
- SSL/TLS required in production

**Databases:**
- Regular backups
- Users with minimal privileges
- Post-install hardening

**Monitoring:**
- Essential metrics
- Automated alerts
- Centralized logs

</div>
