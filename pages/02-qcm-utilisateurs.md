---

# MCQ Module 4: User management ✅

**10 questions on users, groups, and permissions**

---

# Question 1

Which file contains user information?

A) `/etc/users`

B) `/etc/passwd`

C) `/etc/shadow`

D) `/etc/accounts`

---

# Question 2

Which command creates a new user?

A) `adduser` or `useradd`

B) `newuser`

C) `createuser`

D) `mkuser`

---

# Question 3

What does `chmod 644 file.txt` mean?

A) rw-r--r--

B) rwxr--r--

C) rw-rw-r--

D) r--r--r--

---

# Question 4

Which `usermod` option adds a user to a group?

A) `-g`

B) `-G`

C) `-aG`

D) `-a`

---

# Question 5

What does the `sudo` command do?

A) Logs in as root

B) Runs a command with root privileges

C) Creates a new user

D) Changes group

---

# Question 6

Which file configures sudo rights?

A) `/etc/sudo`

B) `/etc/sudoers`

C) `/etc/sudo.conf`

D) `/etc/security/sudo`

---

# Question 7

What does `umask 0022` do?

A) Sets default permissions for new files

B) Hides dotfiles

C) Encrypts files

D) Changes the owner

---

# Question 8

How do you change a file’s group?

A) `chmod`

B) `chown`

C) `chgrp`

D) Both B and C are correct

---

# Question 9

What does the `passwd` command do?

A) Displays passwords

B) Changes the password

C) Encrypts files

D) Lists users

---

# Question 10

Which command lists a user’s groups?

A) `groups username`

B) `id username`

C) `whoami`

D) Both A and B are correct

---

# Module 4 answers 📝

**Answer 1:** B) `/etc/passwd`
- `/etc/passwd` holds user information (passwords are in `/etc/shadow`)

**Answer 2:** A) `adduser` or `useradd`
- `useradd` is low-level, `adduser` is interactive (Debian/Ubuntu)

**Answer 3:** A) rw-r--r--
- 6 = rw- (owner), 4 = r-- (group), 4 = r-- (others)

**Answer 4:** C) `-aG`
- `-aG` (append Group) adds without removing existing groups

**Answer 5:** B) Runs a command with root privileges
- `sudo` lets you elevate privileges temporarily

---

# Module 4 answers (continued) 📝

**Answer 6:** B) `/etc/sudoers`
- Edit ONLY with `visudo`

**Answer 7:** A) Sets default permissions for new files
- umask subtracts from permissions: 666 - 022 = 644 for files

**Answer 8:** D) Both B and C are correct
- `chgrp group file` or `chown :group file`

**Answer 9:** B) Changes the password
- `passwd` changes your password; `sudo passwd user` changes another user’s

**Answer 10:** D) Both A and B are correct
- `groups` and `id` show group membership

---

# Module 4 score 📊

Count your correct answers:

- **9–10**: Excellent! ⭐⭐⭐
- **7–8**: Good! ⭐⭐
- **5–6**: Needs review ⭐
- **< 5**: Reread module 4
