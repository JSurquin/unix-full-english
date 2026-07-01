---

# Module 5 quiz: Storage and files

**10 questions on disks, partitions, and file systems**

---

# Question 1

Which command shows available disk space?

A) `du`

B) `df`

C) `disk`

D) `free`

---

# Question 2

Where are automatic mount configurations stored?

A) `/etc/mount`

B) `/etc/fstab`

C) `/etc/filesystems`

D) `/boot/mount.conf`

---

# Question 3

Which command mounts a file system?

A) `mount`

B) `attach`

C) `connect`

D) `link`

---

# Question 4

What does LVM stand for?

A) Linux Virtual Memory

B) Logical Volume Manager

C) Linux Volume Management

D) Local Virtual Machine

---

# Question 5

How do you create a symbolic link?

A) `link`

B) `ln`

C) `ln -s`

D) `symlink`

---

# Question 6

What does `fsck` do?

A) Mounts a file system

B) Checks file system integrity

C) Formats a disk

D) Shows disk space

---

# Question 7

What is an ACL?

A) A partition type

B) A file system

C) Extended permission (Access Control List)

D) A disk type

---

# Question 8

Which command shows a file’s ACLs?

A) `acl`

B) `getfacl`

C) `showacl`

D) `chmod`

---

# Question 9

What is swap?

A) A backup partition

B) An extension of RAM on disk

C) A RAID type

D) A file system

---

# Question 10

Which command lists disks and partitions?

A) `disks`

B) `partitions`

C) `lsblk`

D) `listdisk`

---

# Module 5 answers

**Answer 1:** B) `df`
- `df` (disk free) shows space per partition. `du` shows usage per directory.

**Answer 2:** B) `/etc/fstab`
- fstab = file system table.

**Answer 3:** A) `mount`
- `mount /dev/sdb1 /mnt/data` mounts the partition.

**Answer 4:** B) Logical Volume Manager
- LVM provides flexible storage management.

**Answer 5:** C) `ln -s`
- `ln -s target link` creates a symbolic link.

---

# Module 5 answers (continued)

**Answer 6:** B) Checks file system integrity
- Never run fsck on a mounted partition.

**Answer 7:** C) Extended permission (Access Control List)
- ACLs allow finer permissions than rwx alone.

**Answer 8:** B) `getfacl`
- Use `setfacl` to set, `getfacl` to read.

**Answer 9:** B) An extension of RAM on disk
- Used when RAM is full.

**Answer 10:** C) `lsblk`
- lsblk = list block devices.

---

# Module 5 score

Count your correct answers:

- **9–10:** Excellent.
- **7–8:** Good.
- **5–6:** Needs review.
- **< 5:** Reread module 5
