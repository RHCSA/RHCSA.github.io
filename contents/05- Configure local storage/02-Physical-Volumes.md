# Create and Remove Physical Volumes

## RHCSA Exam Objective
> Create and remove physical volumes

---

## Introduction

Physical Volumes (PVs) are the foundation of LVM (Logical Volume Manager). A PV is a partition or whole disk that has been initialized for use with LVM. The RHCSA exam tests your ability to create and remove PVs using `pvcreate` and `pvremove` commands.

---

## LVM Architecture Overview

```
Physical Volumes (PV)  →  Volume Groups (VG)  →  Logical Volumes (LV)  →  Filesystem
   /dev/sdb1                  vg_data               lv_data               /mnt/data
   /dev/sdc1
```

---

## Key Commands

| Command | Description |
|---------|-------------|
| `pvcreate` | Initialize partition as physical volume |
| `pvremove` | Remove physical volume signature |
| `pvs` | Display physical volumes (brief) |
| `pvdisplay` | Display physical volumes (detailed) |
| `pvscan` | Scan for physical volumes |

---

## Practice Questions

### Question 1: Display Physical Volumes
**Task:** List all physical volumes on the system.

<details>
<summary>Show Solution</summary>

**Brief output:**
```bash
sudo pvs
```

**Detailed output:**
```bash
sudo pvdisplay
```

**Scan for PVs:**
```bash
sudo pvscan
```
</details>

---

### Question 2: Create Physical Volume
**Task:** Initialize /dev/sdb1 as a physical volume.

<details>
<summary>Show Solution</summary>

```bash
sudo pvcreate /dev/sdb1
```

**Output:**
```
Physical volume "/dev/sdb1" successfully created.
```

**Verify:**
```bash
sudo pvs
```
</details>

---

### Question 3: Create Multiple Physical Volumes
**Task:** Initialize /dev/sdb1 and /dev/sdc1 as physical volumes.

<details>
<summary>Show Solution</summary>

```bash
sudo pvcreate /dev/sdb1 /dev/sdc1
```

**Or separately:**
```bash
sudo pvcreate /dev/sdb1
sudo pvcreate /dev/sdc1
```

**Verify:**
```bash
sudo pvs
```
</details>

---

### Question 4: Create PV on Whole Disk
**Task:** Initialize an entire disk /dev/sdd as a physical volume (without partitioning).

<details>
<summary>Show Solution</summary>

```bash
sudo pvcreate /dev/sdd
```

**Note:** You can use whole disks directly as PVs without creating partitions first. However, using partitions is more common.
</details>

---

### Question 5: View Physical Volume Details
**Task:** Display detailed information about /dev/sdb1 physical volume.

<details>
<summary>Show Solution</summary>

```bash
sudo pvdisplay /dev/sdb1
```

**Output includes:**
- PV Name
- VG Name (if assigned)
- PV Size
- Allocatable status
- PE Size (Physical Extent)
- Total PE / Free PE
</details>

---

### Question 6: Remove Physical Volume
**Task:** Remove /dev/sdb1 from LVM (remove PV signature).

<details>
<summary>Show Solution</summary>

**Prerequisites:**
- PV must not be part of a volume group
- No data should be on the PV

```bash
sudo pvremove /dev/sdb1
```

**Output:**
```
Labels on physical volume "/dev/sdb1" successfully wiped.
```

**Verify:**
```bash
sudo pvs
```
</details>

---

### Question 7: Force Remove Physical Volume
**Task:** Force removal of a physical volume.

<details>
<summary>Show Solution</summary>

```bash
sudo pvremove -f /dev/sdb1
```

**Double force (removes even if in use - dangerous):**
```bash
sudo pvremove -ff /dev/sdb1
```

**Warning:** This can cause data loss if PV is part of VG.
</details>

---

### Question 8: Check PV Status
**Task:** Verify if a partition is already a physical volume.

<details>
<summary>Show Solution</summary>

```bash
sudo pvs /dev/sdb1
```

**If it's a PV, output shows details. If not:**
```
Failed to find physical volume "/dev/sdb1".
```

**Or check with:**
```bash
sudo pvdisplay /dev/sdb1
```
</details>

---

### Question 9: Exam Scenario - Create PV from New Partition
**Task:** Create a partition on /dev/sdb and initialize it as a physical volume.

<details>
<summary>Show Solution</summary>

**Step 1: Create partition**
```bash
sudo fdisk /dev/sdb
```
```
Command: n
Partition number: 1
First sector: Enter
Last sector: +5G
Command: t
Hex code: 8e          # LVM type
Command: w
```

```bash
sudo partprobe /dev/sdb
```

**Step 2: Create physical volume**
```bash
sudo pvcreate /dev/sdb1
```

**Step 3: Verify**
```bash
sudo pvs
```
</details>

---

### Question 10: Exam Scenario - Create Multiple PVs
**Task:** Prepare /dev/sdb1 and /dev/sdb2 for LVM use.

<details>
<summary>Show Solution</summary>

**Create both partitions (type 8e):**
```bash
sudo fdisk /dev/sdb
# Create partition 1 (e.g., 2G) with type 8e
# Create partition 2 (e.g., 3G) with type 8e
# Write and exit
```

```bash
sudo partprobe /dev/sdb
```

**Create physical volumes:**
```bash
sudo pvcreate /dev/sdb1 /dev/sdb2
```

**Verify:**
```bash
sudo pvs
```
</details>

---

### Question 11: Wipe Filesystem Before PV Creation
**Task:** Create PV on a partition that previously had a filesystem.

<details>
<summary>Show Solution</summary>

```bash
# Wipe existing signatures
sudo wipefs -a /dev/sdb1

# Create physical volume
sudo pvcreate /dev/sdb1
```

**Alternative (force):**
```bash
sudo pvcreate -ff /dev/sdb1
```
</details>

---

### Question 12: View PV Allocation
**Task:** See how much space is used/free on physical volumes.

<details>
<summary>Show Solution</summary>

```bash
sudo pvs -o pv_name,pv_size,pv_free
```

**Or detailed:**
```bash
sudo pvdisplay
```

Look for:
- PE Size (Physical Extent size)
- Total PE (Total Physical Extents)
- Free PE (Available Physical Extents)
</details>

---

## Quick Reference

### Create Physical Volumes
```bash
# Single PV
pvcreate /dev/sdb1

# Multiple PVs
pvcreate /dev/sdb1 /dev/sdc1

# Whole disk
pvcreate /dev/sdd

# Force (wipe existing signatures)
pvcreate -ff /dev/sdb1
```

### Display Physical Volumes
```bash
# Brief list
pvs

# Detailed
pvdisplay

# Specific PV
pvdisplay /dev/sdb1

# Scan
pvscan
```

### Remove Physical Volumes
```bash
# Remove PV signature
pvremove /dev/sdb1

# Force remove
pvremove -f /dev/sdb1
```

---

## Important Notes

1. **Partition type 8e** is recommended but not required for LVM
2. **PV must be removed from VG** before using `pvremove`
3. **Use `wipefs -a`** to clear existing filesystem signatures if needed
4. **Physical Extents (PE)** are the smallest unit of allocation (default 4MB)
5. **Whole disks can be PVs** but partitions are more flexible

---

## Summary

For the RHCSA exam, ensure you can:

1. **Create physical volumes** using `pvcreate`
2. **Remove physical volumes** using `pvremove`
3. **Display PV information** using `pvs` and `pvdisplay`
4. **Create partitions with type 8e** before making them PVs
5. **Run `partprobe`** after creating partitions
