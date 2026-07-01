---
layout: new-section
routeAlias: 'exercices-apparmor'
---

<a name="exercices-apparmor" id="exercices-apparmor"></a>

# 🎯 Student exercises - AppArmor
## Module 4 - after the live demo

**Alone on the VM** — same story as class: nginx + secret file in `/tmp/`.

**Commands:** `aa-status` · `aa-complain` · `aa-enforce` · `apparmor_parser -r`

---

# Exercise 1: `aa-status` 📊

```bash
sudo aa-status
sudo aa-enabled
```

---

# Exercise 1: questions

**Note the 5 count lines:** enforce · complain · prompt · kill · unconfined.

1. **enforce** vs **complain** — what happens on a rule violation?
2. **unconfined** — are rules actually applied?
3. kill and prompt at **0** — is that a problem?

---

# Exercise 2: Block `/tmp/` with AppArmor 🍎

**Goal:** profile → enforce **403** on secret · port **80** still **200** → complain **200** → enforce **403**.

**Two URLs:** `curl localhost:8080/secret.html` (reads `/tmp/`) · `curl localhost` (reads `/var/www/html/` — must stay up).

1. Install `nginx` + `apparmor-utils`
2. `/tmp/secret.html` + nginx site on **8080** serving `/tmp/`
3. Both URLs work **before** the profile
4. Profile — see **theory slides** for line-by-line meaning · **no** `/tmp/**`
5. Load · **`restart`** nginx · test both URLs
6. complain / enforce · find `DENIED` (Exercise 3)

---

# Exercise 2 - setup

```bash
sudo apt install -y nginx apparmor-utils
echo "TOP SECRET DATA" | sudo tee /tmp/secret.html
sudo nano /etc/nginx/sites-enabled/secret.conf
```

---

# Exercise 2 - `secret.conf`

```nginx
server {
    listen 8080;
    root /tmp;
    location / { try_files $uri =404; }
}
```

---

# Exercise 2 - test before profile

```bash
sudo nginx -t && sudo systemctl reload nginx
curl localhost:8080/secret.html    # → TOP SECRET DATA
curl localhost                     # → default site :80 — remember this one!
```

---

# Exercise 2 - write profile

Edit **`/etc/apparmor.d/usr.sbin.nginx`** — full file and line meanings are in the **course theory slides** (header · capabilities · paths).

**Rules:** name **`/usr/sbin/nginx`** · **no** `/tmp/**` · **no** `deny /tmp/**`

---

# Exercise 2 - paste profile

```text
#include <tunables/global>
profile usr.sbin.nginx /usr/sbin/nginx flags=(attach_disconnected) {
  #include <abstractions/base>
  #include <abstractions/nameservice>
  capability net_bind_service,
  capability setgid,
  capability setuid,
  capability dac_override,
  /usr/sbin/nginx mr,
  /usr/lib/nginx/** mr,
  /etc/nginx/** r,
  /var/log/nginx/** w,
  /var/www/html/** r,
  /run/nginx.pid rw,
  /run/nginx/** rw,
}
```

---

# Exercise 2 - enforce · complain · enforce

```bash
sudo apparmor_parser -r /etc/apparmor.d/usr.sbin.nginx
sudo systemctl restart nginx
curl localhost:8080/secret.html          # enforce → 403
curl localhost                           # enforce → 200 (still!)

sudo aa-complain /etc/apparmor.d/usr.sbin.nginx
sudo systemctl reload nginx
curl localhost:8080/secret.html          # complain → 200

sudo aa-enforce /etc/apparmor.d/usr.sbin.nginx
sudo systemctl reload nginx
curl localhost:8080/secret.html          # enforce → 403
sudo journalctl -k | grep -i apparmor | tail -5
```

---

# Exercise 3: Find the denial 🔍

With profile in **enforce**, run `curl localhost:8080/secret.html`, then:

```bash
sudo journalctl -k | grep DENIED
```

---

# Exercise 3: expected answer

**Write one sentence:** which path was blocked?

Expect `/tmp/secret.html` and `apparmor="DENIED"`.

---

# AppArmor exercises - recap ✅

- [ ] You can explain **enforce** vs **complain** vs **unconfined**
- [ ] **:8080/secret** blocked in enforce · **localhost:80** still **200**
- [ ] complain → **200** + log · enforce → **403** again
- [ ] **DENIED** line found in `journalctl -k`
