# Create, Mount, Unmount, and Use VFAT, ext4, and XFS File Systems

## RHCSA Exam Objective
> Create, mount, unmount, and use vfat, ext4, and xfs file systems

---

## Introduction

The RHCSA exam tests your ability to create and manage different filesystem types. You must know how to format partitions with VFAT (FAT32), ext4, and XFS, then mount and unmount them properly.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `mkfs.vfat` | Create VFAT (FAT32) filesystem |
| `mkfs.ext4` | Create ext4 filesystem |
| `mkfs.xfs` | Create XFS filesystem |
| `mount` | Mount a filesystem |
| `umount` | Unmount a filesystem |
| `df -h` | Show mounted filesystems |
| `lsblk -f` | Show filesystem types |

---

## Filesystem Comparison

| Feature | VFAT | ext4 | XFS |
|---------|------|------|-----|
| Max file size | 4GB | 16TB | 8EB |
| Journaling | No | Yes | Yes |
| Can shrink | N/A | Yes | No |
| Linux permissions | No | Yes | Yes |
| Use case | USB drives, Windows | General purpose | Large files, RHEL default |

---

## Practice Questions

### Question 1: Create XFS Filesystem
**Task:** Create an XFS filesystem on /dev/sdb1.

<details>
<summary>Show Solution</summary>

```bash
sudo mkfs.xfs /dev/sdb1
```

**Force overwrite existing filesystem:**
```bash
sudo mkfs.xfs -f /dev/sdb1
```

**Verify:**
```bash
lsblk -f /dev/sdb1
```
</details>

---

### Question 2: Create ext4 Filesystem
**Task:** Create an ext4 filesystem on /dev/sdc1.

<details>
<summary>Show Solution</summary>

```bash
sudo mkfs.ext4 /dev/sdc1
```

**Verify:**
```bash
lsblk -f /dev/sdc1
```
</details>

---

### Question 3: Create VFAT Filesystem
**Task:** Create a VFAT (FAT32) filesystem on /dev/sdd1.

<details>
<summary>Show Solution</summary>

```bash
sudo mkfs.vfat /dev/sdd1
```

**Or explicitly FAT32:**
```bash
sudo mkfs.vfat -F 32 /dev/sdd1
```

**Note:** VFAT is used for USB drives and Windows compatibility.
</details>

---

### Question 4: Mount Filesystem Manually
**Task:** Mount /dev/sdb1 to /mnt/data.

<details>
<summary>Show Solution</summary>

```bash
# Create mount point
sudo mkdir -p /mnt/data

# Mount
sudo mount /dev/sdb1 /mnt/data

# Verify
df -h /mnt/data
```
</details>

---

### Question 5: Mount with Specific Filesystem Type
**Task:** Mount /dev/sdc1 specifying ext4 type.

<details>
<summary>Show Solution</summary>

```bash
sudo mount -t ext4 /dev/sdc1 /mnt/backup
```

**Common types:**
- `-t xfs`
- `-t ext4`
- `-t vfat`
</details>

---

### Question 6: Mount with Options
**Task:** Mount a filesystem as read-only.

<details>
<summary>Show Solution</summary>

```bash
sudo mount -o ro /dev/sdb1 /mnt/readonly
```

**Common mount options:**
| Option | Description |
|--------|-------------|
| `ro` | Read-only |
| `rw` | Read-write (default) |
| `noexec` | No execution of binaries |
| `nosuid` | Ignore SUID bits |
| `nodev` | Ignore device files |
| `defaults` | rw, suid, dev, exec, auto, nouser, async |
</details>

---

### Question 7: Unmount Filesystem
**Task:** Unmount /mnt/data.

<details>
<summary>Show Solution</summary>

```bash
sudo umount /mnt/data
```

**Or by device:**
```bash
sudo umount /dev/sdb1
```

**Force unmount (if busy):**
```bash
sudo umount -f /mnt/data
```

**Lazy unmount (detach now, cleanup later):**
```bash
sudo umount -l /mnt/data
```
</details>

---

### Question 8: Find What's Using a Mount
**Task:** Determine why unmount fails (device busy).

<details>
<summary>Show Solution</summary>

```bash
# Find processes using the mount
sudo lsof /mnt/data

# Or using fuser
sudo fuser -vm /mnt/data

# Kill processes using the mount
sudo fuser -km /mnt/data
```
</details>

---

### Question 9: View Mounted Filesystems
**Task:** Display all currently mounted filesystems.

<details>
<summary>Show Solution</summary>

```bash
# Human readable
df -h

# Show filesystem types
df -Th

# Using mount command
mount | grep "^/dev"

# Using findmnt
findmnt
```
</details>

---

### Question 10: Check Filesystem Type
**Task:** Determine the filesystem type of /dev/sdb1.

<details>
<summary>Show Solution</summary>

```bash
# Using lsblk
lsblk -f /dev/sdb1

# Using blkid
sudo blkid /dev/sdb1

# Using file command
sudo file -s /dev/sdb1
```
</details>

---

### Question 11: Create XFS with Label
**Task:** Create XFS filesystem with label "DATA".

<details>
<summary>Show Solution</summary>

```bash
sudo mkfs.xfs -L DATA /dev/sdb1
```

**Verify:**
```bash
sudo blkid /dev/sdb1
```
</details>

---

### Question 12: Create ext4 with Label
**Task:** Create ext4 filesystem with label "BACKUP".

<details>
<summary>Show Solution</summary>

```bash
sudo mkfs.ext4 -L BACKUP /dev/sdc1
```

**Verify:**
```bash
sudo blkid /dev/sdc1
```
</details>

---

### Question 13: Create VFAT with Label
**Task:** Create VFAT filesystem with label "USBDRIVE".

<details>
<summary>Show Solution</summary>

```bash
sudo mkfs.vfat -n USBDRIVE /dev/sdd1
```

**Note:** VFAT uses `-n` for label, not `-L`.
</details>

---

### Question 14: Remount Filesystem
**Task:** Remount /mnt/data as read-only without unmounting.

<details>
<summary>Show Solution</summary>

```bash
sudo mount -o remount,ro /mnt/data
```

**Remount as read-write:**
```bash
sudo mount -o remount,rw /mnt/data
```
</details>

---

### Question 15: Exam Scenario - Complete Setup
**Task:** Create a 2GB partition on /dev/sdb, format with XFS, and mount to /data.

<details>
<summary>Show Solution</summary>

**Step 1: Create partition**
```bash
sudo fdisk /dev/sdb
# n, 1, Enter, +2G, w
```

```bash
sudo partprobe /dev/sdb
```

**Step 2: Create XFS filesystem**
```bash
sudo mkfs.xfs /dev/sdb1
```

**Step 3: Create mount point and mount**
```bash
sudo mkdir /data
sudo mount /dev/sdb1 /data
```

**Step 4: Verify**
```bash
df -h /data
```
</details>

---

### Question 16: Exam Scenario - ext4 for Logs
**Task:** Create ext4 filesystem on /dev/sdc1 and mount to /var/log/app.

<details>
<summary>Show Solution</summary>

```bash
# Create filesystem
sudo mkfs.ext4 /dev/sdc1

# Create mount point
sudo mkdir -p /var/log/app

# Mount
sudo mount /dev/sdc1 /var/log/app

# Verify
df -Th /var/log/app
```
</details>

---

### Question 17: Exam Scenario - VFAT USB
**Task:** Format /dev/sdd1 as VFAT and mount to /mnt/usb with label "USB".

<details>
<summary>Show Solution</summary>

```bash
# Create VFAT with label
sudo mkfs.vfat -n USB /dev/sdd1

# Create mount point
sudo mkdir -p /mnt/usb

# Mount
sudo mount /dev/sdd1 /mnt/usb

# Verify
df -Th /mnt/usb
```
</details>

---

### Question 18: Check and Repair XFS
**Task:** Check XFS filesystem for errors.

<details>
<summary>Show Solution</summary>

```bash
# Unmount first
sudo umount /dev/sdb1

# Check XFS (dry run)
sudo xfs_repair -n /dev/sdb1

# Repair XFS
sudo xfs_repair /dev/sdb1
```

**Note:** XFS must be unmounted for repair.
</details>

---

### Question 19: Check and Repair ext4
**Task:** Check ext4 filesystem for errors.

<details>
<summary>Show Solution</summary>

```bash
# Unmount first
sudo umount /dev/sdc1

# Check (dry run)
sudo e2fsck -n /dev/sdc1

# Check and repair automatically
sudo e2fsck -y /dev/sdc1

# Force check even if clean
sudo e2fsck -f /dev/sdc1
```
</details>

---

### Question 20: Get Filesystem Information
**Task:** Display detailed information about an XFS filesystem.

<details>
<summary>Show Solution</summary>

**For XFS:**
```bash
sudo xfs_info /dev/sdb1
# Or if mounted:
sudo xfs_info /mnt/data
```

**For ext4:**
```bash
sudo tune2fs -l /dev/sdc1
```
</details>

---

## Quick Reference

### Create Filesystems
```bash
# XFS
mkfs.xfs /dev/sdb1
mkfs.xfs -L LABEL /dev/sdb1
mkfs.xfs -f /dev/sdb1          # Force

# ext4
mkfs.ext4 /dev/sdb1
mkfs.ext4 -L LABEL /dev/sdb1

# VFAT
mkfs.vfat /dev/sdb1
mkfs.vfat -n LABEL /dev/sdb1   # Note: -n not -L
mkfs.vfat -F 32 /dev/sdb1      # Force FAT32
```

### Mount/Unmount
```bash
# Mount
mount /dev/sdb1 /mnt/data
mount -t xfs /dev/sdb1 /mnt/data
mount -o ro /dev/sdb1 /mnt/data

# Unmount
umount /mnt/data
umount /dev/sdb1
umount -f /mnt/data            # Force
umount -l /mnt/data            # Lazy

# Remount
mount -o remount,ro /mnt/data
```

### View Information
```bash
# Mounted filesystems
df -h
df -Th
mount | grep "^/dev"
findmnt

# Filesystem type
lsblk -f
blkid /dev/sdb1
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Create XFS filesystems** using `mkfs.xfs`
2. **Create ext4 filesystems** using `mkfs.ext4`
3. **Create VFAT filesystems** using `mkfs.vfat`
4. **Mount filesystems** using `mount`
5. **Unmount filesystems** using `umount`
6. **Add labels** during filesystem creation
7. **Use mount options** like `ro`, `noexec`
8. **Verify mounts** using `df -h` and `lsblk -f`
