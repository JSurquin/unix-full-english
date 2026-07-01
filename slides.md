---
theme: ./
colorSchema: "auto"
layout: intro
highlighter: shiki
# https://sli.dev/custom/highlighters.html
title: Unix/Linux Training - Initiation 2025
# download: true
#transition: slide-left
# remoteAssets: false
# export:
#   zoom: 1
#   format: pdf
#   timeout: 300000000
#   pdfOptions:
#     format: A4
download: "https://unix-full-english.andromed.fr/slides.pdf"
themeConfig:
  logoHeader: "/avatar.png"
  eventLogo: "https://img2.storyblok.com/352x414/f/84560/2388x414/23d8eb4b8d/vue-amsterdam-with-name.png"
  eventUrl: "https://vuejs.amsterdam/"
#addons:
  #- "@slidev/addon-sharp-long-code"
---

# Unix/Linux - Initiation 2025

🐧 A course presented by Ascent and Andromed.

<div class="pt-12">
  <span @click="next" class="px-2 p-3 rounded cursor-pointer hover:bg-white hover:bg-opacity-10 neon-border">
    Press space for the next slide <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: presenter
eventLogo: 'https://img2.storyblok.com/352x0/f/84560/2388x414/23d8eb4b8d/vue-amsterdam-with-name.png'
eventUrl: 'https://vuejs.amsterdam/'
twitter: '@jimmylansrq'

twitterUrl: 'https://twitter.com/jimmylansrq'
presenterImage: 'https://legacy.andromed.fr/images/fondator.jpg'
---

# Jimmylan Surquin

Founder <a  href="https://www.andromed.fr/"><logos-storyblok-icon  mr-1/>Andromed</a>

- Lille, France 🇫🇷
- Content on <a href="https://www.youtube.com/channel/jimmylansrq"> <logos-youtube-icon mr-1 /> jimmylansrq </a>
- Blog & Portfolio <a href="https://jimmylan.fr"> jimmylan.fr </a>

---
layout: text-image
media: 'https://i.pinimg.com/originals/f5/5e/80/f55e8059ea945abfd6804b887dd4a0af.gif'
caption: 'UNIX/LINUX 2025'
---

# DISCLAIMER 🐧

### In this course we cover the fundamental concepts of Unix/Linux in 2025.

---
layout: two-cols
routeAlias: 'sommaire'
---

<a name="sommaire" id="sommaire"></a>

# UNIX/LINUX INITIATION — TABLE OF CONTENTS 📜

<br>

<div class="flex flex-col gap-2">
<Link to="introduction-unix-linux">🧱 1. Unix/Linux introduction and history</Link>
<Link to="commandes-basiques">🔧 2. Essential base commands</Link>
<Link to="paquets-maintenance">📦 3. Package management and maintenance</Link>
<Link to="gestion-systeme-utilisateurs">👥 4. User and permission management</Link>
<Link to="stockage-systeme-fichiers">💾 5. Storage and filesystems</Link>
</div>

::right::

<div class="flex flex-col gap-2">
<Link to="processus-services">⚙️ 6. Process and service management</Link>
<Link to="reseau">📡 7. Network configuration</Link>
<Link to="automatisation-scripts">🤖 8. Automation and scripts</Link>
<Link to="securite-systeme">🔐 9. System security</Link>
<Link to="services-serveurs">☁️ 10. Server services</Link>
<Link to="supervision-analyse">📊 11. Monitoring & system analysis</Link>
<Link to="supervision-avancee">🚨 12. Advanced monitoring (Zabbix)</Link>
<Link to="optimisation-performances">⚡ 13. Optimization & performance (BONUS)</Link>
<Link to="optimisation-reseau-linux">🌐 14. Linux network optimization (BONUS)</Link>
<Link to="qcm-final">✅ Final validation MCQ</Link>
</div>

**Note:** Each module includes:
- 📖 Theory
- ✅ Validation MCQ
- 🎯 Hands-on exercises

---
layout: two-cols
routeAlias: 'programme-initiation'
---

### UNIX/LINUX INITIATION PROGRAM 📅

<small>

**Module 1 - Introduction**
- Unix, GNU/Linux history
- Unix philosophy
- System architecture
- Kernel, shell

**Module 2 - Base commands** 🆕
- Navigation (cd, ls, pwd)
- File operations (cp, mv, rm)
- Search (find, grep)
- Viewing (cat, less, head, tail)
- Redirections and pipes

</small>

::right::

<small>

**Module 3 - Packages and maintenance**
- apt/dnf: installation
- System updates
- Dependency management

**Module 4 - Users and permissions**
- Accounts and groups
- Permissions (chmod, chown)
- sudo and sudoers
- Disk quotas

**Module 5 - Storage**
- Disks and partitions
- Mounting (mount, fstab)
- Symbolic links
- ACL

</small>

---
layout: two-cols
---

### UNIX/LINUX INITIATION PROGRAM 📅

<small>

**Module 6 - Processes and services**
- PID, signals
- nice, kill
- systemd
- journalctl

**Module 7 - Network**
- IP configuration
- Secure SSH
- Firewall (ufw)
- Diagnostics (ping, traceroute)

</small>

::right::

<small>

**Module 8 - Automation**
- Bash scripts
- Cron and at
- System logs

**Module 9 - Security**
- SSH hardening
- fail2ban
- Audit (auditd)
- Encryption (LUKS)

**Module 10 - Server services**
- Nginx
- MySQL
- SSL/TLS
- Monitoring

</small>

---
layout: two-cols
---

### UNIX/LINUX INITIATION PROGRAM 📅

<small>

**Module 11 - Monitoring & analysis**
- Monitoring (top, htop, iotop)
- Log analysis
- System metrics
- Dashboards

**Module 12 - Advanced monitoring**
- Zabbix server and agent
- Alerts and notifications
- Custom templates
- Advanced dashboards

</small>

::right::

<small>

**Module 13 - Optimization (BONUS)** ⚡
- Kernel tuning (sysctl)
- Memory optimization
- Server tuning
- Service performance

**Module 14 - Network optimization (BONUS)** 🌐
- TCP/IP stack and sysctl
- Network interface (NIC)
- Queues & bufferbloat
- Firewall & containers

**Final MCQ** ✅
- Knowledge validation
- All modules
- Course certification

</small>

---
src: './pages/01-introduction-unix-linux.md'
---

---
src: './pages/01-qcm-introduction.md'
---

---
src: './pages/05-commandes-basiques.md'
---

---
src: './pages/05-qcm-commandes.md'
---

---
src: './pages/05-exercices-commandes.md'
---

---
src: './pages/06-paquets-maintenance.md'
---

---
src: './pages/06-qcm-paquets.md'
---

---
src: './pages/06-exercices-paquets.md'
---

---
src: './pages/02-gestion-systeme-utilisateurs.md'
---

---
src: './pages/02-qcm-utilisateurs.md'
---

---
src: './pages/02-exercices-utilisateurs.md'
---

---
src: './pages/04-stockage-systeme-fichiers.md'
---

---
src: './pages/04-qcm-stockage.md'
---

---
src: './pages/04-exercices-stockage.md'
---

---
src: './pages/03-processus-services.md'
---

---
src: './pages/03-qcm-processus.md'
---

---
src: './pages/03-exercices-processus.md'
---

---
src: './pages/05-reseau.md'
---

---
src: './pages/05-qcm-reseau.md'
---

---
src: './pages/05-exercices-reseau.md'
---

---
src: './pages/07-automatisation-scripts.md'
---

---
src: './pages/07-qcm-automatisation.md'
---

---
src: './pages/07-exercices-automatisation.md'
---

---
src: './pages/08-securite-systeme.md'
---

---
src: './pages/08-qcm-securite.md'
---

---
src: './pages/08-exercices-securite.md'
---

---
src: './pages/09-services-serveurs.md'
---

---
src: './pages/09-qcm-serveurs.md'
---

---
src: './pages/09-exercices-serveurs.md'
---

---
src: './pages/13-supervision-analyse-systeme.md'
---

---
src: './pages/13-qcm-supervision.md'
---

---
src: './pages/13-exercices-supervision.md'
---

---
src: './pages/14-supervision-avancee-alertes.md'
---

---
src: './pages/14-qcm-supervision-avancee.md'
---

---
src: './pages/14-exercices-supervision-avancee.md'
---

---
src: './pages/15-optimisation-performances.md'
---

---
src: './pages/15-qcm-optimisation.md'
---

---
src: './pages/15-exercices-optimisation.md'
---

---
src: './pages/16-optimisation-reseau-linux.md'
---

---
src: './pages/16-qcm-optimisation-reseau.md'
---

---
src: './pages/16-exercices-optimisation-reseau.md'
---

---
src: './pages/10-qcm-final.md'
---
