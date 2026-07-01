---

# Hands-on exercises - Module 3

**Storage and file system management**

---

# Exercise 1: Disk space analysis

**Goal:** Identify disk usage.

**Instructions:**

1. Show disk space for all partitions.
2. Find which directory under `/var` uses the most space.
3. List all files larger than 100 MB.
4. Show inode usage.
5. Find the 10 largest files on the system.

---

# Exercise 1 - solution

```bash
# 1. Disk space
df -h

# 2. Largest directories under /var
sudo du -h --max-depth=1 /var | sort -hr | head -10

# 3. Files > 100 MB
sudo find / -type f -size +100M 2>/dev/null
# With details
sudo find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null

# 4. Inode usage
df -i

# 5. Top 10 largest files
sudo find / -type f -exec du -h {} + 2>/dev/null | sort -hr | head -10
```

---

# Exercise 2: Image files

**Goal:** Create and use disk image files.

**Instructions:**

1. Create a 100 MB image file.
2. Format it as ext4.
3. Mount it under `/mnt/test`.
4. Create files inside it.
5. Unmount cleanly.
6. Remount and verify the files are still there.

---

# Exercise 2 - solution

```bash
# 1. Create image file
dd if=/dev/zero of=~/disk.img bs=1M count=100

# 2. Format as ext4
sudo mkfs.ext4 ~/disk.img

# 3. Mount
sudo mkdir -p /mnt/test
sudo mount -o loop ~/disk.img /mnt/test

# Verify
df -h /mnt/test
mount | grep test

# 4. Create files
sudo touch /mnt/test/file{1..5}.txt
echo "Test" | sudo tee /mnt/test/file1.txt
ls -l /mnt/test/

# 5. Unmount
sudo umount /mnt/test

# 6. Remount and verify
sudo mount -o loop ~/disk.img /mnt/test
ls -l /mnt/test/
# Files are still there.

# Clean up
sudo umount /mnt/test
rm ~/disk.img
```

---

# Exercise 3: Symbolic and hard links

**Goal:** Understand links.

**Instructions:**

1. Create `original.txt` with some content.
2. Create a hard link `hard_link.txt`.
3. Create a symbolic link `soft_link.txt`.
4. Compare inodes.
5. Delete `original.txt` and observe what happens.
6. Create a symbolic link to a directory.

---

# Exercise 3 - solution

```bash
# 1. Original file
echo "Original content" > /tmp/original.txt

# 2. Hard link
ln /tmp/original.txt /tmp/hard_link.txt

# 3. Symbolic link
ln -s /tmp/original.txt /tmp/soft_link.txt

# 4. Compare inodes
ls -li /tmp/*.txt
# original and hard_link share the SAME inode
# soft_link has a different inode

# Check content
cat /tmp/hard_link.txt
cat /tmp/soft_link.txt

# 5. Delete original
rm /tmp/original.txt

# hard_link still works
cat /tmp/hard_link.txt  # OK

# soft_link is broken
cat /tmp/soft_link.txt  # No such file

# 6. Link to directory
ln -s /var/log /tmp/logs_link
ls -l /tmp/logs_link

# Clean up
rm /tmp/hard_link.txt /tmp/soft_link.txt /tmp/logs_link
```

---

# Exercise 4: ACLs - extended permissions

**Goal:** Use ACLs for fine-grained permissions.

**Instructions:**

1. Create a file `project.txt`.
2. Grant user `alice` read permission (in addition to Unix permissions).
3. Grant user `bob` write permission.
4. Display the ACLs.
5. Remove `bob`’s ACL.
6. Remove all ACLs.

---

# Exercise 4 - solution

```bash
# 1. Create file
touch /tmp/project.txt
echo "Secret project" > /tmp/project.txt

# 2. ACL for alice (read)
setfacl -m u:alice:r /tmp/project.txt

# 3. ACL for bob (write)
setfacl -m u:bob:rw /tmp/project.txt

# 4. Show ACLs
getfacl /tmp/project.txt

# ls with ACL
ls -l /tmp/project.txt
# A '+' appears: -rw-rw-r--+

# 5. Remove bob's ACL
setfacl -x u:bob /tmp/project.txt
getfacl /tmp/project.txt

# 6. Remove all ACLs
setfacl -b /tmp/project.txt
getfacl /tmp/project.txt
```

---

# Exercise 5: Automatic mounting with fstab

**Goal:** Configure automatic mounts.

**Instructions:**

1. Create an image file and format it.
2. Create a mount point `/data`.
3. Add an entry in `/etc/fstab` for automatic mounting.
4. Test with `mount -a`.
5. Reboot and verify it mounts automatically.

**Warning:** A bad fstab can prevent the system from booting.

---

# Exercise 5 - solution

```bash
# 1. Create and format
dd if=/dev/zero of=/opt/data.img bs=1M count=200
sudo mkfs.ext4 /opt/data.img

# 2. Mount point
sudo mkdir /data

# 3. Back up fstab before editing
sudo cp /etc/fstab /etc/fstab.backup

# Add entry
echo "/opt/data.img /data ext4 loop,defaults 0 2" | \
    sudo tee -a /etc/fstab

# 4. Test
sudo mount -a
df -h /data

# If error, restore:
# sudo cp /etc/fstab.backup /etc/fstab

# 5. Reboot
sudo reboot

# After reboot, verify
df -h /data
mount | grep data
```

---

# Exercise 6: LVM - see dedicated slides

**Two paths** in the 🎯 **LVM exercise deck** (`exercices-lvm`) — pick the one that matches your VM:

| Track | Your VM | Goal |
|-------|---------|------|
| **A** | `sudo pvs` shows **`ubuntu-vg`** (trainer lab) | Extend the pool with `/dev/vdb`, grow `/` — **same as the live demo** |
| **B** | **No LVM** on `/` (typical Ubuntu **22.x** + snap loops) | Build LVM from scratch on an empty disk (**GPT**), mount `/data`, optionally extend |

Open **`exercices-lvm`** and work through **Track A or Track B** alone on the VM.

See **`pages/04-exercices-lvm.md`** for full steps.

---

# Bonus: grow when /home is full

No reinstall. No reboot. Data stays in place.

```bash
sudo pvcreate /dev/sdb
sudo vgextend lab_vg /dev/sdb
sudo lvextend -L +500G /dev/lab_vg/home
sudo resize2fs /dev/lab_vg/home
```

---

# Bonus exercise: Disk cleanup script

**Goal:** Automate cleanup.

**Build a script that:**
- Deletes temp files older than 7 days.
- Empties trash folders.
- Cleans apt caches.
- Cleans old logs.
- Prints a report.

---

# Bonus exercise - solution

```bash
#!/bin/bash
# Disk cleanup script

echo "===== Disk cleanup $(date) ====="

# Space before
BEFORE=$(df -h / | awk 'NR==2 {print $4}')
echo "Free space before: $BEFORE"

# 1. Temp files > 7 days
echo -e "\nCleaning /tmp..."
FILES_DELETED=$(sudo find /tmp -type f -atime +7 2>/dev/null | wc -l)
sudo find /tmp -type f -atime +7 -delete 2>/dev/null
echo "Files removed: $FILES_DELETED"

# 2. apt caches
echo -e "\nCleaning apt..."
sudo apt clean
sudo apt autoclean
sudo apt autoremove -y

# 3. Old logs
echo -e "\nCleaning logs..."
sudo journalctl --vacuum-time=7d
sudo find /var/log -name "*.log.*" -mtime +30 -delete

# 4. Thumbnails
echo -e "\nCleaning thumbnails..."
rm -rf ~/.cache/thumbnails/*

# Space after
AFTER=$(df -h / | awk 'NR==2 {print $4}')
echo -e "\nFree space after: $AFTER"
echo "============================="
```

---

### Key takeaways

<div class="text-xs">

**Disk management:**
- `df` for partitions, `du` for directories
- `lsblk` for the block-device tree
- `mount`/`umount` to mount/unmount

**LVM:**
- Storage pool (VG) + flexible partition (LV)
- Grow with `lvextend -r` (same as the live demo on `/dev/vdb`)
- Snapshots before risky changes (theory - see module slides)

**Links:**
- Hard link: same inode, same content
- Symbolic link: pointer; can break

**ACLs:**
- Finer than rwx alone
- `setfacl` to set, `getfacl` to read

</div>
