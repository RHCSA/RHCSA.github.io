# Create and Delete Logical Volumes

## RHCSA Exam Objective
> Create and delete logical volumes

---

## Introduction

Logical Volumes (LVs) are created from Volume Groups and function like traditional partitions. LVs provide flexibility - they can be resized, moved, and span multiple physical disks. The RHCSA exam tests your ability to create, delete, and manage logical volumes.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `lvcreate` | Create logical volume |
| `lvremove` | Delete logical volume |
| `lvs` | Display logical volumes (brief) |
| `lvdisplay` | Display logical volumes (detailed) |
| `lvextend` | Extend logical volume size |
| `lvreduce` | Reduce logical volume size |

---

## Practice Questions

### Question 1: Display Logical Volumes
**Task:** List all logical volumes on the system.

<details>
<summary>Show Solution</summary>

**Brief output:**
```bash
sudo lvs
```

**Detailed output:**
```bash
sudo lvdisplay
```

**Scan for LVs:**
```bash
sudo lvscan
```
</details>

---

### Question 2: Create Logical Volume by Size
**Task:** Create a 2GB logical volume named `lv_data` in volume group `vg_data`.

<details>
<summary>Show Solution</summary>

```bash
sudo lvcreate -L 2G -n lv_data vg_data
```

**Options:**
- `-L 2G`: Size of 2 gigabytes
- `-n lv_data`: Name of logical volume
- `vg_data`: Volume group name

**Verify:**
```bash
sudo lvs
```
</details>

---

### Question 3: Create LV Using All Free Space
**Task:** Create a logical volume using all available space in `vg_data`.

<details>
<summary>Show Solution</summary>

```bash
sudo lvcreate -l 100%FREE -n lv_full vg_data
```

**Options:**
- `-l 100%FREE`: Use 100% of free space
- `-l` (lowercase L): Specify in extents or percentage

**Alternative (percentage of VG):**
```bash
sudo lvcreate -l 50%VG -n lv_half vg_data
```
</details>

---

### Question 4: Create LV by Extents
**Task:** Create a logical volume using 500 physical extents.

<details>
<summary>Show Solution</summary>

```bash
sudo lvcreate -l 500 -n lv_extents vg_data
```

**Note:** 
- Each extent is typically 4MB (default)
- 500 extents = 500 × 4MB = 2000MB ≈ 2GB
</details>

---

### Question 5: View LV Details
**Task:** Display detailed information about `lv_data`.

<details>
<summary>Show Solution</summary>

```bash
sudo lvdisplay /dev/vg_data/lv_data
```

**Output includes:**
- LV Path (/dev/vg_data/lv_data)
- LV Name
- VG Name
- LV Size
- Current LE (Logical Extents)
</details>

---

### Question 6: Delete Logical Volume
**Task:** Delete the logical volume `lv_data` from `vg_data`.

<details>
<summary>Show Solution</summary>

**Prerequisites:** LV must be unmounted.

```bash
# Unmount if mounted
sudo umount /dev/vg_data/lv_data

# Remove logical volume
sudo lvremove /dev/vg_data/lv_data
```

**Confirm with 'y' when prompted.**

**Force removal (no confirmation):**
```bash
sudo lvremove -f /dev/vg_data/lv_data
```
</details>

---

### Question 7: Create Filesystem on LV
**Task:** Create an XFS filesystem on logical volume `lv_data`.

<details>
<summary>Show Solution</summary>

```bash
sudo mkfs.xfs /dev/vg_data/lv_data
```

**For ext4:**
```bash
sudo mkfs.ext4 /dev/vg_data/lv_data
```

**Using device mapper path:**
```bash
sudo mkfs.xfs /dev/mapper/vg_data-lv_data
```

Both paths (`/dev/vg_data/lv_data` and `/dev/mapper/vg_data-lv_data`) refer to the same device.
</details>

---

### Question 8: Mount Logical Volume
**Task:** Mount `lv_data` to `/mnt/data`.

<details>
<summary>Show Solution</summary>

```bash
# Create mount point
sudo mkdir -p /mnt/data

# Mount
sudo mount /dev/vg_data/lv_data /mnt/data

# Verify
df -h /mnt/data
```
</details>

---

### Question 9: Extend Logical Volume
**Task:** Add 1GB to existing logical volume `lv_data`.

<details>
<summary>Show Solution</summary>

```bash
# Extend LV
sudo lvextend -L +1G /dev/vg_data/lv_data

# Resize filesystem (XFS)
sudo xfs_growfs /mnt/data

# Or for ext4
sudo resize2fs /dev/vg_data/lv_data
```

**Extend and resize in one command:**
```bash
sudo lvextend -L +1G -r /dev/vg_data/lv_data
```

**The `-r` flag** automatically resizes the filesystem.
</details>

---

### Question 10: Extend LV to Specific Size
**Task:** Extend `lv_data` to exactly 5GB total.

<details>
<summary>Show Solution</summary>

```bash
sudo lvextend -L 5G -r /dev/vg_data/lv_data
```

**Note:**
- `-L 5G` = set to exactly 5GB
- `-L +5G` = add 5GB to current size
</details>

---

### Question 11: Extend LV Using Percentages
**Task:** Extend `lv_data` to use all remaining space in VG.

<details>
<summary>Show Solution</summary>

```bash
sudo lvextend -l +100%FREE -r /dev/vg_data/lv_data
```

**Extend to use 50% of remaining free space:**
```bash
sudo lvextend -l +50%FREE -r /dev/vg_data/lv_data
```
</details>

---

### Question 12: Reduce Logical Volume
**Task:** Reduce `lv_data` by 500MB.

<details>
<summary>Show Solution</summary>

**Warning:** Data loss possible. Backup first.

**For ext4 only (XFS cannot be shrunk):**
```bash
# Unmount
sudo umount /mnt/data

# Check filesystem
sudo e2fsck -f /dev/vg_data/lv_data

# Reduce filesystem
sudo resize2fs /dev/vg_data/lv_data 4G

# Reduce LV
sudo lvreduce -L 4G /dev/vg_data/lv_data

# Mount
sudo mount /dev/vg_data/lv_data /mnt/data
```

**Note:** XFS filesystems cannot be reduced.
</details>

---

### Question 13: Rename Logical Volume
**Task:** Rename `lv_old` to `lv_new`.

<details>
<summary>Show Solution</summary>

```bash
sudo lvrename vg_data lv_old lv_new
```

**Or with full paths:**
```bash
sudo lvrename /dev/vg_data/lv_old /dev/vg_data/lv_new
```

**Note:** Update /etc/fstab if mounted.
</details>

---

### Question 14: Exam Scenario - Complete LV Setup
**Task:** Create a 3GB logical volume `lv_projects` in `vg_data`, format with XFS, and mount to `/projects`.

<details>
<summary>Show Solution</summary>

```bash
# Create logical volume
sudo lvcreate -L 3G -n lv_projects vg_data

# Create XFS filesystem
sudo mkfs.xfs /dev/vg_data/lv_projects

# Create mount point
sudo mkdir /projects

# Mount
sudo mount /dev/vg_data/lv_projects /projects

# Verify
df -h /projects
```
</details>

---

### Question 15: Exam Scenario - Delete LV
**Task:** Safely remove logical volume `lv_old` from `vg_data`.

<details>
<summary>Show Solution</summary>

```bash
# Check if mounted
mount | grep lv_old

# Unmount if necessary
sudo umount /dev/vg_data/lv_old

# Remove from fstab if present
sudo vim /etc/fstab
# Comment out or remove the line

# Remove logical volume
sudo lvremove /dev/vg_data/lv_old
# Confirm with 'y'
```
</details>

---

## LV Path Formats

Both paths are equivalent:
```
/dev/vg_name/lv_name
/dev/mapper/vg_name-lv_name
```

Example:
```
/dev/vg_data/lv_data
/dev/mapper/vg_data-lv_data
```

---

## Quick Reference

### Create Logical Volumes
```bash
# By size
lvcreate -L 2G -n lv_name vg_name

# By extents
lvcreate -l 500 -n lv_name vg_name

# All free space
lvcreate -l 100%FREE -n lv_name vg_name
```

### Display Logical Volumes
```bash
# Brief list
lvs

# Detailed
lvdisplay

# Specific LV
lvdisplay /dev/vg_name/lv_name
```

### Modify Logical Volumes
```bash
# Extend (add size)
lvextend -L +1G /dev/vg_name/lv_name

# Extend (set size)
lvextend -L 5G /dev/vg_name/lv_name

# Extend with filesystem resize
lvextend -L +1G -r /dev/vg_name/lv_name

# Reduce (ext4 only)
lvreduce -L 2G /dev/vg_name/lv_name
```

### Delete Logical Volumes
```bash
# Interactive
lvremove /dev/vg_name/lv_name

# Force (no prompt)
lvremove -f /dev/vg_name/lv_name
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Create logical volumes** using `lvcreate -L SIZE -n NAME VG`
2. **Delete logical volumes** using `lvremove`
3. **Display LV information** using `lvs` and `lvdisplay`
4. **Extend logical volumes** using `lvextend -L +SIZE -r`
5. **Create filesystems** on LVs using `mkfs.xfs` or `mkfs.ext4`
6. **Use percentage allocation** with `-l 100%FREE`
