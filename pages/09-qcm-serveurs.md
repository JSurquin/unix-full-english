---

# Module 10 quiz: Server services ✅

**10 questions on services and servers**

---

# Question 1

Which web server is known for performance?

A) Apache

B) Nginx

C) IIS

D) Tomcat

---

# Question 2

Where is Nginx configuration on Ubuntu?

A) `/etc/apache2/`

B) `/etc/nginx/`

C) `/var/www/nginx/`

D) `/usr/local/nginx/`

---

# Question 3

How do you test the Nginx configuration?

A) `nginx test`

B) `nginx -t`

C) `systemctl test nginx`

D) `test nginx`

---

# Question 4

Which command backs up a MySQL database?

A) `mysql-backup`

B) `mysqldump`

C) `mysql-export`

D) `backup-mysql`

---

# Question 5

Which port does MySQL use by default?

A) 3306

B) 5432

C) 27017

D) 1433

---

# Question 6

What is a reverse proxy?

A) A proxy that reverses data

B) A front-end server in front of applications

C) A type of firewall

D) A backup tool

---

# Question 7

How do you obtain a free SSL certificate?

A) Let's Encrypt (Certbot)

B) Buy from a CA

C) Generate with OpenSSL

D) Both A and C are correct

---

# Question 8

Which protocol transfers files securely?

A) FTP

B) HTTP

C) SCP/SFTP

D) Telnet

---

# Question 9

What is Docker?

A) A package manager

B) A container platform

C) A text editor

D) A web server

---

# Question 10

How do you start all services defined in docker-compose?

A) `docker start`

B) `docker-compose up`

C) `compose start`

D) `docker run`

---

# Module 10 answers 📝

**Answer 1:** B) Nginx  
- Async architecture, low memory use

**Answer 2:** B) `/etc/nginx/`  
- `/etc/nginx/nginx.conf` is the main file

**Answer 3:** B) `nginx -t`  
- Always test before reload!

**Answer 4:** B) `mysqldump`  
- `mysqldump -u root -p database > backup.sql`

**Answer 5:** A) 3306  
- 5432 = PostgreSQL, 27017 = MongoDB

---

# Module 10 answers (continued) 📝

**Answer 6:** B) A front-end server in front of applications  
- Nginx is often used as a reverse proxy

**Answer 7:** A) Let's Encrypt (Certbot)  
- Free, automated, auto-renewed

**Answer 8:** C) SCP/SFTP  
- Built on SSH, therefore encrypted

**Answer 9:** B) A container platform  
- Isolates applications in containers

**Answer 10:** B) `docker-compose up`  
- `-d` to run in the background

---

# Module 10 score 📊

Count your correct answers:

- **9–10:** Excellent! ⭐⭐⭐
- **7–8:** Good! ⭐⭐
- **5–6:** Review needed ⭐
- **< 5:** Reread module 10
