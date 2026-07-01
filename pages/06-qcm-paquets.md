---

# Quiz Module 3: Packages and maintenance ✅

**10 questions on package managers**

---

# Question 1

Which package manager is used on Ubuntu?

A) `yum`

B) `dnf`

C) `apt`

D) `pacman`

---

# Question 2

Which command refreshes the package index?

A) `apt upgrade`

B) `apt update`

C) `apt refresh`

D) `apt sync`

---

# Question 3

How do you install a package?

A) `apt install package`

B) `apt get package`

C) `apt add package`

D) `apt download package`

---

# Question 4

Which command searches for a package?

A) `apt find`

B) `apt search`

C) `apt query`

D) `apt locate`

---

# Question 5

How do you remove a package and its configuration?

A) `apt remove`

B) `apt delete`

C) `apt purge`

D) `apt uninstall`

---

# Question 6

Which package manager is used on Fedora/RHEL?

A) `yum`

B) `dnf`

C) `apt`

D) A and B (dnf replaces yum)

---

# Question 7

What does `apt autoremove` do?

A) Removes all packages

B) Removes unused packages

C) Clears the cache

D) Removes old versions

---

# Question 8

What is a PPA?

A) A personal package archive

B) A type of package

C) A package manager

D) A file format

---

# Question 9

How do you clear downloaded package cache?

A) `apt clean`

B) `apt clear`

C) `apt flush`

D) `apt delete-cache`

---

# Question 10

What is Snap?

A) A traditional package manager

B) A universal, containerized package format

C) A backup tool

D) A text editor

---

# Module 3 answers 📝

**Answer 1:** C) `apt`
- apt = Advanced Package Tool (Debian/Ubuntu)

**Answer 2:** B) `apt update`
- Always run `update` before `upgrade`

**Answer 3:** A) `apt install package`
- e.g. `sudo apt install nginx`

**Answer 4:** B) `apt search`
- `apt search nginx` lists packages matching "nginx"

**Answer 5:** C) `apt purge`
- `remove` keeps config, `purge` removes everything

---

# Module 3 answers (continued) 📝

**Answer 6:** D) A and B (dnf replaces yum)
- `dnf` is the modern successor to `yum`

**Answer 7:** B) Removes unused packages
- Cleans orphan dependencies

**Answer 8:** A) A personal package archive
- Ubuntu-specific; adds third-party repositories

**Answer 9:** A) `apt clean`
- Frees disk space by removing downloaded packages

**Answer 10:** B) A universal, containerized package format
- Alternatives: Flatpak and AppImage

---

# Module 3 score 📊

Count your correct answers:

- **9–10**: Excellent! ⭐⭐⭐
- **7–8**: Good! ⭐⭐
- **5–6**: Review ⭐
- **< 5**: Reread module 3
