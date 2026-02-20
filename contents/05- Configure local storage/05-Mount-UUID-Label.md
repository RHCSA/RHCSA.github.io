# Configure Systems to Mount File Systems at Boot by UUID or Label

## RHCSA Exam Objective
> Configure systems to mount file systems at boot by universally unique ID (UUID) or label

---

## Introduction

The `/etc/fstab` file configures persistent mounts. Using UUID or LABEL instead of device names (like /dev/sdb1) ensures reliable mounting even if device names change after reboot. The RHCSA exam tests your ability to configure persistent mounts using UUID and LABEL.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `blkid` | Display UUID and LABEL of block devices |
| `lsblk -f` | List filesystems with UUID |
| `e2label` | Set label on ext2/3/4 filesystem |
| `xfs_admin -L` | Set label on XFS filesystem |
| `tune2fs -L` | Set label on ext2/3/4 filesystem |

---

## Practice Questions

### Question 1: Find UUID of a Device
**Task:** Display the UUID of /dev/sdb1.

<details>
<summary>Show Solution</summary>

```bash
sudo blkid /dev/sdb1
```

**Output example:**
```
/dev/sdb1: UUID="a1b2c3d4-e5f6-7890-abcd-ef1234567890" TYPE="xfs"
```

**List all devices:**
```bash
sudo blkid
```

**Alternative:**
```bash
lsblk -f /dev/sdb1
```
</details>

---

### Question 2: Find UUID of Logical Volume
**Task:** Get the UUID of logical volume `/dev/vg_data/lv_data`.

<details>
<summary>Show Solution</summary>

```bash
sudo blkid /dev/vg_data/lv_data
```

**Or:**
```bash
sudo blkid /dev/mapper/vg_data-lv_data
```
</details>

---

### Question 3: Mount by UUID in fstab
**Task:** Configure /dev/sdb1 to mount at /mnt/data at boot using UUID.

<details>
<summary>Show Solution</summary>

**Step 1: Get UUID**
```bash
sudo blkid /dev/sdb1
```
Note the UUID value.

**Step 2: Create mount point**
```bash
sudo mkdir -p /mnt/data
```

**Step 3: Edit /etc/fstab**
```bash
sudo vim /etc/fstab
```

**Add line:**
```
UUID=a1b2c3d4-e5f6-7890-abcd-ef1234567890  /mnt/data  xfs  defaults  0 0
```

**Step 4: Test mount**
```bash
sudo mount -a
```

**Step 5: Verify**
```bash
df -h /mnt/data
```
</details>

---

### Question 4: Set Label on XFS Filesystem
**Task:** Set label "DATA" on XFS filesystem /dev/sdb1.

<details>
<summary>Show Solution</summary>

```bash
sudo xfs_admin -L DATA /dev/sdb1
```

**Verify:**
```bash
sudo blkid /dev/sdb1
```

**Note:** XFS must be unmounted to set label.
</details>

---

### Question 5: Set Label on ext4 Filesystem
**Task:** Set label "BACKUP" on ext4 filesystem /dev/sdc1.

<details>
<summary>Show Solution</summary>

```bash
sudo e2label /dev/sdc1 BACKUP
```

**Alternative:**
```bash
sudo tune2fs -L BACKUP /dev/sdc1
```

**Verify:**
```bash
sudo blkid /dev/sdc1
```
</details>

---

### Question 6: Mount by LABEL in fstab
**Task:** Configure filesystem with label "DATA" to mount at /data at boot.

<details>
<summary>Show Solution</summary>

**Step 1: Verify label exists**
```bash
sudo blkid | grep DATA
```

**Step 2: Create mount point**
```bash
sudo mkdir -p /data
```

**Step 3: Edit /etc/fstab**
```bash
sudo vim /etc/fstab
```

**Add line:**
```
LABEL=DATA  /data  xfs  defaults  0 0
```

**Step 4: Test**
```bash
sudo mount -a
df -h /data
```
</details>

---

### Question 7: Understand fstab Fields
**Task:** Explain each field in an fstab entry.

<details>
<summary>Show Solution</summary>

```
UUID=xxx  /mount/point  fstype  options  dump  fsck
```

| Field | Description |
|-------|-------------|
| 1 | Device (UUID=, LABEL=, or /dev/xxx) |
| 2 | Mount point |
| 3 | Filesystem type (xfs, ext4, swap) |
| 4 | Mount options (defaults, ro, rw, noexec) |
| 5 | Dump (0 = no backup, 1 = backup) |
| 6 | Fsck order (0 = skip, 1 = first, 2 = after) |

**Common options:**
- `defaults` = rw, suid, dev, exec, auto, nouser, async
- `noexec` = prevent execution of binaries
- `ro` = read-only
- `nofail` = don't fail boot if mount fails
</details>

---

### Question 8: Test fstab Configuration
**Task:** Verify fstab entries are correct without rebooting.

<details>
<summary>Show Solution</summary>

```bash
sudo mount -a
```

**If no errors, all fstab entries are valid.**

**Check for syntax errors:**
```bash
sudo findmnt --verify
```

**See what would be mounted:**
```bash
sudo findmnt --fstab
```
</details>

---

### Question 9: Mount LV by UUID in fstab
**Task:** Configure logical volume `lv_data` to mount at /data using UUID.

<details>
<summary>Show Solution</summary>

**Step 1: Get UUID**
```bash
sudo blkid /dev/vg_data/lv_data
```

**Step 2: Create mount point**
```bash
sudo mkdir -p /data
```

**Step 3: Add to /etc/fstab**
```
UUID=xxxx-xxxx-xxxx  /data  xfs  defaults  0 0
```

**Step 4: Test**
```bash
sudo mount -a
df -h /data
```
</details>

---

### Question 10: Set Label During Filesystem Creation
**Task:** Create XFS filesystem with label "PROJECTS" on /dev/sdb1.

<details>
<summary>Show Solution</summary>

```bash
sudo mkfs.xfs -L PROJECTS /dev/sdb1
```

**For ext4:**
```bash
sudo mkfs.ext4 -L PROJECTS /dev/sdb1
```

**Verify:**
```bash
sudo blkid /dev/sdb1
```
</details>

---

### Question 11: Change Existing Label
**Task:** Change the label of /dev/sdb1 from "OLD" to "NEW".

<details>
<summary>Show Solution</summary>

**For XFS (must be unmounted):**
```bash
sudo umount /dev/sdb1
sudo xfs_admin -L NEW /dev/sdb1
```

**For ext4 (can be mounted):**
```bash
sudo e2label /dev/sdb1 NEW
```
</details>

---

### Question 12: Remove Label
**Task:** Remove the label from XFS filesystem.

<details>
<summary>Show Solution</summary>

```bash
sudo xfs_admin -L -- /dev/sdb1
```

**For ext4:**
```bash
sudo e2label /dev/sdb1 ""
```
</details>

---

### Question 13: Exam Scenario - Complete UUID Mount
**Task:** Create partition, format with XFS, and configure persistent mount using UUID at /backup.

<details>
<summary>Show Solution</summary>

**Step 1: Create partition**
```bash
sudo fdisk /dev/sdb
# Create partition, write and exit
```
```bash
sudo partprobe /dev/sdb
```

**Step 2: Create filesystem**
```bash
sudo mkfs.xfs /dev/sdb1
```

**Step 3: Get UUID**
```bash
sudo blkid /dev/sdb1
```

**Step 4: Create mount point**
```bash
sudo mkdir /backup
```

**Step 5: Add to fstab**
```bash
echo "UUID=your-uuid-here  /backup  xfs  defaults  0 0" | sudo tee -a /etc/fstab
```

**Step 6: Mount and verify**
```bash
sudo mount -a
df -h /backup
```
</details>

---

### Question 14: Exam Scenario - Label Mount
**Task:** Format /dev/sdc1 with ext4, label "ARCHIVE", and configure persistent mount at /archive.

<details>
<summary>Show Solution</summary>

**Step 1: Create filesystem with label**
```bash
sudo mkfs.ext4 -L ARCHIVE /dev/sdc1
```

**Step 2: Create mount point**
```bash
sudo mkdir /archive
```

**Step 3: Add to fstab**
```bash
echo "LABEL=ARCHIVE  /archive  ext4  defaults  0 2" | sudo tee -a /etc/fstab
```

**Step 4: Mount and verify**
```bash
sudo mount -a
df -h /archive
```
</details>

---

### Question 15: Use nofail Option
**Task:** Configure mount that won't prevent boot if device is unavailable.

<details>
<summary>Show Solution</summary>

**Add nofail option in fstab:**
```
UUID=xxx  /mnt/external  xfs  defaults,nofail  0 0
```

**Useful for:**
- Removable drives
- Network storage
- Non-critical mounts
</details>

---

## Quick Reference

### Get UUID and Label
```bash
# All devices
blkid

# Specific device
blkid /dev/sdb1

# With filesystem info
lsblk -f
```

### Set Labels
```bash
# XFS (must be unmounted)
xfs_admin -L LABEL /dev/sdb1

# ext4 (can be mounted)
e2label /dev/sdb1 LABEL
tune2fs -L LABEL /dev/sdb1

# During filesystem creation
mkfs.xfs -L LABEL /dev/sdb1
mkfs.ext4 -L LABEL /dev/sdb1
```

### fstab Entry Formats
```bash
# By UUID
UUID=xxxx-xxxx  /mount  xfs  defaults  0 0

# By LABEL
LABEL=NAME  /mount  xfs  defaults  0 0

# By device (not recommended)
/dev/sdb1  /mount  xfs  defaults  0 0

# Logical volume (preferred for LVM)
/dev/vg_name/lv_name  /mount  xfs  defaults  0 0
```

### Test Configuration
```bash
# Mount all fstab entries
mount -a

# Verify fstab syntax
findmnt --verify
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Find UUID** using `blkid`
2. **Set labels** using `xfs_admin -L` or `e2label`
3. **Configure /etc/fstab** with UUID= or LABEL=
4. **Test configuration** using `mount -a`
5. **Understand fstab fields** (device, mount point, type, options, dump, fsck)
6. **Use `nofail` option** for non-critical mounts
