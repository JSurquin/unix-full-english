---
layout: new-section
routeAlias: 'exercices-openldap'
---

<a name="exercices-openldap" id="exercices-openldap"></a>

# 🎯 Student exercises - OpenLDAP
## Day 3 - after the live demo

**Alone on the VM** - the trainer already showed slapd + LDIF + NSS/PAM.

Lab constants: base **`dc=nodomain`**, admin **`cn=admin,dc=nodomain`**, password **`johndoe`**.

---

# Exercise 1: Read the tree with ldapsearch 🔍

**Goal:** Use flags you learned in class - no guessing.

**Tasks:**

1. Bind as admin and show the root DN only (`-s base`)
2. List direct children of `dc=nodomain` (`-s one`)
3. Find `ldapuser1` under `ou=people` with filter `(uid=ldapuser1)` - show `uid`, `cn`, `uidNumber`
4. Write one line: what does **`-x`** mean? what does **`-W`** mean?

---

# Exercise 1 - commands

```bash
ldapsearch -x -D "cn=admin,dc=nodomain" -W -b dc=nodomain -s base dn
ldapsearch -x -D "cn=admin,dc=nodomain" -W -b dc=nodomain -s one dn
ldapsearch -x -LLL -b ou=people,dc=nodomain '(uid=ldapuser1)' uid cn uidNumber
```

---

# Exercise 1 - expected

- Line `dn: dc=nodomain`
- Lines `dn: ou=people,...` and `dn: ou=groups,...`
- `uid: ldapuser1`, `cn: LDAP User`, `uidNumber: 5001`

---

# Exercise 2: Add a second user via LDIF 📄

**Goal:** Write LDIF, import with `ldapadd`, verify with `ldapsearch`.

**Tasks:**

1. Create `/tmp/user2.ldif` with user **`ldapuser2`** (uidNumber **5002**, same group **5000** / devops)
2. Use objectClasses: `inetOrgPerson`, `posixAccount`, `shadowAccount`
3. Password: **`johndoe`**
4. Import with `ldapadd -f`
5. Search `(uid=ldapuser2)` - must return one entry

---

# Exercise 2 - LDIF content

```bash
sudo nano /tmp/user2.ldif
```

```text
dn: uid=ldapuser2,ou=people,dc=nodomain
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: ldapuser2
sn: Two
givenName: LDAP
cn: LDAP User Two
uidNumber: 5002
gidNumber: 5000
homeDirectory: /home/ldapuser2
loginShell: /bin/bash
userPassword: johndoe
```

---

# Exercise 2 - import and verify

```bash
sudo ldapadd -x -D "cn=admin,dc=nodomain" -W -f /tmp/user2.ldif
ldapsearch -x -LLL -b ou=people,dc=nodomain '(uid=ldapuser2)' uid cn uidNumber
```

---

# Exercise 3: NSS + PAM login 🔐

**Goal:** Prove Linux sees the user and accepts the password.

**Prerequisite:** `nslcd` + `nsswitch.conf` + PAM already wired (live demo).

**Tasks:**

1. `getent passwd ldapuser2` - must return a line (uid 5002)
2. Confirm user is **not** in `/etc/passwd`
3. `ssh ldapuser2@127.0.0.1` - password `johndoe` - must login
4. Check home was created (`ls /home/ldapuser2`) if `pam_mkhomedir` is enabled

---

# Exercise 3 - commands

```bash
getent passwd ldapuser2
grep ldapuser2 /etc/passwd
ssh ldapuser2@127.0.0.1
ls -la /home/ldapuser2
```

---

# Exercise 4: Debug NSS vs PAM 🧯

**Goal:** Know which layer fails - same idea as troubleshooting scenario D.

**Tasks (trainer may break PAM order for you):**

1. `ldapsearch` finds `ldapuser2` but `getent` is empty → fix **NSS** (`nslcd`, `nsswitch.conf`, `uri ldap://127.0.0.1`)
2. `getent` OK but SSH refused → fix **PAM** (`pam_ldap` before `pam_deny` in `common-account`)
3. Write 2 bullets: what **NSS** checks vs what **PAM** checks

---

# Exercise 4 - hints

```bash
sudo systemctl status nslcd
grep ldap /etc/nsswitch.conf
sudo journalctl -u nslcd -n 20
grep pam_ldap /etc/pam.d/common-account
sudo journalctl -u ssh -n 20
```

---

# OpenLDAP exercises - recap ✅

- [ ] Three ldapsearch queries work (base / one / filter)
- [ ] `ldapuser2` imported from your LDIF
- [ ] `getent` + SSH login work
- [ ] You can tell NSS vs PAM failures apart
