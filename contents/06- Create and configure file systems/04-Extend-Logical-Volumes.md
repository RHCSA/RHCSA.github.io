# Extend Existing Logical Volumes

## RHCSA Exam Objective
> Extend existing logical volumes

---

## Introduction

Extending logical volumes is a two-step process: extending the LV itself and then resizing the filesystem. The RHCSA exam tests your ability to extend LVs while preserving existing data. This topic focuses on the complete workflow including filesystem resizing.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `lvextend` | Extend logical volume |
| `xfs_growfs` | Grow XFS filesystem |
| `resize2fs` | Resize ext4 filesystem |
| `lvextend -r` | Extend LV and resize filesystem together |

---

## Critical Concepts

| Filesystem | Can Extend Online | Can Shrink |
|------------|-------------------|------------|
| XFS | Yes | No |
| ext4 | Yes | Yes (offline) |

---

## Practice Questions

### Question 1: Check Current LV Size
**Task:** View the current size of logical volume lv_data in vg_data.

<details>
<summary>Show Solution</summary>

```bash
# Brief view
sudo lvs /dev/vg_data/lv_data

# Detailed view
sudo lvdisplay /dev/vg_data/lv_data

# Check filesystem usage
df -h /dev/vg_data/lv_data
```
</details>

---

### Question 2: Check Available Space in VG
**Task:** Verify there is free space in the volume group for extension.

<details>
<summary>Show Solution</summary>

```bash
# View VG free space
sudo vgs vg_data

# Detailed view
sudo vgdisplay vg_data | grep -i free
```

**Output shows "Free PE" (Physical Extents) available.**
</details>

---

### Question 3: Extend LV and XFS Together
**Task:** Extend lv_data by 1GB and resize the XFS filesystem.

<details>
<summary>Show Solution</summary>

**Recommended method (single command):**
```bash
sudo lvextend -L +1G -r /dev/vg_data/lv_data
```

**The `-r` flag (or `--resizefs`) automatically resizes the filesystem.**

**Verify:**
```bash
df -h /dev/vg_data/lv_data
```
</details>

---

### Question 4: Extend LV and XFS Separately
**Task:** Extend lv_data by 2GB, then resize the XFS filesystem manually.

<details>
<summary>Show Solution</summary>

**Step 1: Extend the logical volume**
```bash
sudo lvextend -L +2G /dev/vg_data/lv_data
```

**Step 2: Grow the XFS filesystem**
```bash
sudo xfs_growfs /mountpoint
```

**Note:** `xfs_growfs` requires the mount point, not the device.

**If mounted at /data:**
```bash
sudo xfs_growfs /data
```

**Verify:**
```bash
df -h /data
```
</details>

---

### Question 5: Extend LV and ext4 Together
**Task:** Extend lv_logs by 500MB with ext4 filesystem.

<details>
<summary>Show Solution</summary>

**Single command:**
```bash
sudo lvextend -L +500M -r /dev/vg_data/lv_logs
```

**Verify:**
```bash
df -h /dev/vg_data/lv_logs
```
</details>

---

### Question 6: Extend LV and ext4 Separately
**Task:** Extend lv_logs by 1GB, then resize ext4 manually.

<details>
<summary>Show Solution</summary>

**Step 1: Extend the logical volume**
```bash
sudo lvextend -L +1G /dev/vg_data/lv_logs
```

**Step 2: Resize ext4 filesystem**
```bash
sudo resize2fs /dev/vg_data/lv_logs
```

**Note:** `resize2fs` uses the device path (unlike xfs_growfs).

**Verify:**
```bash
df -h /dev/vg_data/lv_logs
```
</details>

---

### Question 7: Extend to Specific Size
**Task:** Extend lv_data to exactly 5GB total.

<details>
<summary>Show Solution</summary>

```bash
sudo lvextend -L 5G -r /dev/vg_data/lv_data
```

**Note the difference:**
- `-L 5G`: Set size to exactly 5GB
- `-L +5G`: Add 5GB to current size
</details>

---

### Question 8: Extend Using All Free Space
**Task:** Extend lv_data to use all remaining space in the VG.

<details>
<summary>Show Solution</summary>

```bash
sudo lvextend -l +100%FREE -r /dev/vg_data/lv_data
```

**Note:** Use lowercase `-l` for extents/percentages.

**Other percentage options:**
- `-l +50%FREE`: Use 50% of free space
- `-l 100%VG`: Use 100% of VG size
</details>

---

### Question 9: Extend When VG is Full
**Task:** Extend lv_data when there's no free space in VG.

<details>
<summary>Show Solution</summary>

**Step 1: Add new storage to VG**
```bash
# Create new partition and PV
sudo pvcreate /dev/sdc1

# Extend VG
sudo vgextend vg_data /dev/sdc1
```

**Step 2: Extend LV**
```bash
sudo lvextend -L +3G -r /dev/vg_data/lv_data
```

**Verify:**
```bash
df -h /dev/vg_data/lv_data
```
</details>

---

### Question 10: Verify Extension Was Successful
**Task:** Confirm the LV and filesystem were extended properly.

<details>
<summary>Show Solution</summary>

```bash
# Check LV size
sudo lvs /dev/vg_data/lv_data

# Check filesystem size (must match)
df -h /mountpoint

# Compare - both should show same size
```

**If filesystem is smaller than LV, the resize didn't complete:**
```bash
# For XFS
sudo xfs_growfs /mountpoint

# For ext4
sudo resize2fs /dev/vg_data/lv_data
```
</details>

---

### Question 11: Exam Scenario - Extend by Specific Amount
**Task:** The /data filesystem is running low on space. Extend it by 2GB. The logical volume is /dev/vg_data/lv_data with XFS filesystem.

<details>
<summary>Show Solution</summary>

```bash
# Check current sizes
df -h /data
sudo vgs vg_data

# Extend (single command)
sudo lvextend -L +2G -r /dev/vg_data/lv_data

# Verify
df -h /data
```
</details>

---

### Question 12: Exam Scenario - Use All Available Space
**Task:** Extend /var/log to use all available space in its volume group.

<details>
<summary>Show Solution</summary>

```bash
# Find the LV for /var/log
df -h /var/log

# Check VG free space
sudo vgs

# Extend to use all free space
sudo lvextend -l +100%FREE -r /dev/vg_root/lv_log

# Verify
df -h /var/log
```
</details>

---

### Question 13: Exam Scenario - Extend to Exact Size
**Task:** Extend /home LV to exactly 10GB total.

<details>
<summary>Show Solution</summary>

```bash
# Check current size
df -h /home

# Extend to 10GB
sudo lvextend -L 10G -r /dev/vg_data/lv_home

# Verify
df -h /home
```
</details>

---

### Question 14: Common Extension Mistakes
**Task:** Identify and fix common LV extension errors.

<details>
<summary>Show Solution</summary>

**Mistake 1: Forgetting to resize filesystem**
```bash
# Wrong - only extends LV
sudo lvextend -L +1G /dev/vg_data/lv_data

# Filesystem stays same size!
# Fix:
sudo xfs_growfs /mountpoint    # For XFS
sudo resize2fs /dev/vg_data/lv_data  # For ext4
```

**Mistake 2: Using mount point for resize2fs**
```bash
# Wrong
sudo resize2fs /data

# Correct
sudo resize2fs /dev/vg_data/lv_data
```

**Mistake 3: Using device for xfs_growfs**
```bash
# Wrong (may work but not preferred)
sudo xfs_growfs /dev/vg_data/lv_data

# Correct
sudo xfs_growfs /data
```

**Best practice: Use -r flag**
```bash
sudo lvextend -L +1G -r /dev/vg_data/lv_data
```
</details>

---

### Question 15: Extend Root Filesystem
**Task:** Extend the root (/) filesystem while the system is running.

<details>
<summary>Show Solution</summary>

**Both XFS and ext4 can be extended online (while mounted).**

```bash
# Find the LV for root
df -h /

# Extend
sudo lvextend -L +2G -r /dev/vg_root/lv_root

# Verify
df -h /
```

**No reboot required for online extension.**
</details>

---

## XFS vs ext4 Resize Commands

| Operation | XFS | ext4 |
|-----------|-----|------|
| Grow filesystem | `xfs_growfs /mountpoint` | `resize2fs /dev/vg/lv` |
| Requires mount point | Yes | No (uses device) |
| Can extend online | Yes | Yes |
| Can shrink | No | Yes (unmount first) |

---

## Quick Reference

### Single Command Extension (Recommended)
```bash
# Add size
lvextend -L +1G -r /dev/vg_name/lv_name

# Set exact size
lvextend -L 5G -r /dev/vg_name/lv_name

# Use all free space
lvextend -l +100%FREE -r /dev/vg_name/lv_name
```

### Manual Filesystem Resize
```bash
# XFS (use mount point)
xfs_growfs /mountpoint

# ext4 (use device)
resize2fs /dev/vg_name/lv_name
```

### Check Sizes
```bash
# LV size
lvs /dev/vg_name/lv_name

# Filesystem size
df -h /mountpoint

# VG free space
vgs vg_name
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Always use `-r` flag** with `lvextend` to resize filesystem automatically
2. **Check VG free space** before attempting extension
3. **Add storage to VG** if needed using `vgextend`
4. **Know the difference** between `-L +1G` (add) and `-L 1G` (set)
5. **Use `xfs_growfs`** with mount point for XFS
6. **Use `resize2fs`** with device path for ext4
7. **Verify both LV and filesystem** sizes match after extension
