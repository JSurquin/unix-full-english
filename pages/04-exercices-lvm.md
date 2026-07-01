---
layout: new-section
routeAlias: 'exercices-lvm'
---

<a name="exercices-lvm" id="exercices-lvm"></a>

# 🎯 Student exercises - LVM
## Module 3 - after the live demo

**Alone on the VM** - no copy-paste from the trainer screen.

Lab password: your usual sudo password (e.g. `johndoe`).

---

# Your VM may not look like the trainer's ⚠️

**Trainer lab VM** (Ubuntu Server, course image): `/` is on **LVM** — `ubuntu-vg` → `ubuntu-lv`. One extra empty disk **`/dev/vdb`** for the live demo.

**Your VM** (typical **Ubuntu 22.x** desktop install): often **no LVM at all** — root on a plain ext4 partition, plus many **snap loop** devices in `lsblk`. That is normal.

**Same LVM logic everywhere:** from an **empty second disk**, the workflow is always PV → VG → LV → filesystem → mount. Only the starting point changes.

---

# Pick your path 🛤️

| | **Track A** | **Track B** |
|---|-------------|-------------|
| **When** | `sudo pvs` shows **`ubuntu-vg`** | No LVM on `/` (typical 22.x VM) |
| **Goal** | Repeat the **live demo** — extend the pool, grow `/` | **Build LVM from scratch** on a new disk, then optionally extend |
| **Disk** | Whole **`/dev/vdb`** (no partition — like the demo) | **`/dev/vdb`** with a **GPT** LVM partition (recommended) |

**Both tracks:** stop the VM → attach a **20 GB** empty disk in UTM / VirtualBox / VMware → boot → `lsblk` shows **`vdb`** or **`sdb`**. LVM itself needs **no OS reboot** after that.

---

# Track A — Exercise 1: Extend `ubuntu-vg` with `/dev/vdb` 💾

**Goal:** Repeat the **same scenario as the live demo** - add a second disk to the pool and grow `/` without reboot.

**Prerequisite:** you saw the in-class LVM live demo (`pvcreate`, `vgextend`, `lvextend -r`).

**Before you start:** **stop the VM**, attach a **20 GB** empty disk in UTM / VirtualBox / VMware, **boot again** → it appears as **`/dev/vdb`** (no partitions). That hypervisor step is normal - LVM work itself needs **no OS reboot**.

**Tasks:**

1. Record **BEFORE**: `lsblk`, `sudo pvs`, `sudo vgs`, `df -h /`
2. If needed: `sudo pvcreate /dev/vdb` and `sudo vgextend ubuntu-vg /dev/vdb`
3. Grow root: `sudo lvextend -r -L +2G /dev/ubuntu-vg/ubuntu-lv` (use a smaller `+` if `vgs` shows little free space)
4. Record **AFTER**: same commands - prove `/` grew
5. Write one sentence: where did the new space come from?

---

# Track A - step 1: baseline

```bash
lsblk
sudo pvs
sudo vgs
df -h /
```

**Check:** `/` is on `ubuntu-vg/ubuntu-lv` (installed that way on the trainer lab image).

---

# Track A - step 2: add disk to pool

Skip this slide if `sudo pvs` already lists `/dev/vdb` in `ubuntu-vg`.

```bash
lsblk /dev/vdb          # empty disk, no partitions
sudo pvcreate /dev/vdb
sudo vgextend ubuntu-vg /dev/vdb
sudo pvs                # two PVs: vda3 + vdb
sudo vgs                # more free space in the pool
```

---

# Track A - step 3: grow `/` live

```bash
df -h /                 # BEFORE

sudo lvextend -r -L +2G /dev/ubuntu-vg/ubuntu-lv
# -L +2G  = add 2 GB to the LV (lab-friendly size)
# -r      = resize ext4 automatically - same as the trainer demo

df -h /                 # AFTER - root should be larger
```

---

# Track B — Exercise 1: LVM from an empty disk (GPT) 💾

**Goal:** On a VM **without** existing LVM, build the full stack on a second disk and mount **`/data`**.

**Why GPT?** Default on modern Ubuntu (UEFI, disks > 2 TB, robust partition table). LVM does not care — it only needs a block device like **`/dev/vdb1`**.

**Replace `vdb` with your disk name** if `lsblk` shows `sdb`, etc.

---

# Track B - step 1: check the disk

```bash
lsblk
```

**Example** (ignore snap `loop` devices — focus on real disks):

```
sda
├─sda1   /boot/efi
├─sda2   /
sdb      ← empty disk you attached
```

---

# Track B - step 2: GPT partition for LVM

Use **`gdisk`** (not MBR/`fdisk` — GPT is the 2026 default):

```bash
sudo gdisk /dev/vdb
```

---

# Track B - step 2: gdisk keys

Inside **`gdisk /dev/vdb`**:

```
o        # new empty GPT table (only if disk is blank)
n        # new partition — Enter for defaults (whole disk)
Enter
Enter
Enter
t        # change type
8e00     # Linux LVM  (MBR would be 8e — same idea, different code)
w        # write and quit
```

**Result:** `/dev/vdb1`. You *can* use the whole disk without a partition, but a GPT LVM partition is cleaner.

---

# Track B - step 3: Physical Volume

```bash
sudo pvcreate /dev/vdb1
sudo pvs
# or: sudo pvdisplay
```

---

# Track B - step 4: Volume Group

```bash
sudo vgcreate vg_data /dev/vdb1
sudo vgs
# or: sudo vgdisplay
```

---

# Track B - step 5: Logical Volume

**20 GB example:**

```bash
sudo lvcreate -L 20G -n lv_data vg_data
```

**Or use all free space in the VG:**

```bash
sudo lvcreate -l 100%FREE -n lv_data vg_data
```

---

# Track B - step 5: verify LV

```bash
sudo lvs
# or: sudo lvdisplay
```

---

# Track B - step 6: format ext4

```bash
sudo mkfs.ext4 /dev/vg_data/lv_data
```

**XFS alternative:** `sudo mkfs.xfs /dev/vg_data/lv_data`

---

# Track B - step 7: mount point

```bash
sudo mkdir /data
sudo mount /dev/vg_data/lv_data /data
df -h /data
```

---

# Track B - step 8: persistent mount (fstab)

```bash
sudo blkid /dev/vg_data/lv_data
```

Add one line to **`/etc/fstab`** (use the UUID from `blkid`):

```
UUID=xxxxxxxx-xxxx  /data  ext4  defaults  0  2
```

---

# Track B - step 8: test fstab

```bash
sudo umount /data
sudo mount -a
df -h /data
```

**No errors from `mount -a`** → fstab is correct.

---

# Track B - final check: lsblk

```bash
lsblk
```

**Expected shape:**

```
vdb
└─vdb1
  └─vg_data-lv_data   →  /data
```

---

# Track B - mental model 🧠

```
Disk (/dev/vdb)
    │
    ▼
GPT partition (type 8e00)   ← optional but recommended
    │
    ▼
PV  (pvcreate)
    │
    ▼
VG  (vgcreate vg_data)
    │
    ▼
LV  (lvcreate lv_data)
    │
    ▼
ext4  (mkfs.ext4)
    │
    ▼
/data  (mount + fstab)
```

---

# Track B - commands to remember 📋

**Create:** `pvcreate` → `vgcreate` → `lvcreate`  
**Check:** `pvs` · `vgs` · `lvs`  
**Use:** `mkfs.ext4` → `mkdir` → `mount` → `blkid` → `/etc/fstab` → `mount -a`

**Short chain:** `gdisk` → `pvcreate` → `vgcreate` → `lvcreate` → `mkfs` → `mount` → `fstab`

---

# Track B — Exercise 2: extend the pool (optional) 📈

**Same idea as Track A / the live demo** — add a **third** disk and grow **`lv_data`**.

Attach **`/dev/vdc`** (20 GB), partition with **`gdisk`** → **`/dev/vdc1`**, then:

```bash
sudo pvcreate /dev/vdc1
sudo vgextend vg_data /dev/vdc1
sudo vgs                  # VG bigger, LV still old size
```

---

# Track B — Exercise 2: grow LV + filesystem

The **VG grows** when you `vgextend`. The **LV and ext4 do not** — you must extend both:

```bash
sudo lvextend -r -l +100%FREE /dev/vg_data/lv_data
# -r = lvextend + resize2fs in one step
df -h /data
```

---

# Track B — three sizes to remember ⚠️

**Three separate sizes:** PVs (disks) → VG (pool) → LV (slice) → filesystem (ext4).

Growing the pool with `vgextend` is **not** enough — you still need `lvextend` and a filesystem resize (`-r` or `resize2fs`).

---

# LVM exercises - recap ✅

**Track A (trainer lab / `ubuntu-vg`):**

- [ ] `sudo pvs` shows `/dev/vdb` in `ubuntu-vg` (or it was already there after the demo)
- [ ] `df -h /` increased after `lvextend -r`

**Track B (typical 22.x VM, no LVM on `/`):**

- [ ] GPT partition **`8e00`** on the extra disk · `pvcreate` → `vgcreate vg_data` → `lvcreate`
- [ ] **`/data`** mounted · survives reboot (`fstab` + `mount -a` OK)
- [ ] *(optional)* second disk · `vgextend` · `lvextend -r` · `df -h /data` grew