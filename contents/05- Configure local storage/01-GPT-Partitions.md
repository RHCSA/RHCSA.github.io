# List, Create, Delete Partitions on GPT Disks

## RHCSA Exam Objective
> List, create, delete partitions on MBR and GPT disks

---

## Introduction

The RHCSA exam tests your ability to manage disk partitions using GPT (GUID Partition Table). GPT is the modern partitioning standard that supports disks larger than 2TB and allows more than 4 primary partitions. You must know `fdisk`, `gdisk`, and `parted` commands.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `lsblk` | List block devices |
| `fdisk -l` | List all partitions |
| `fdisk` | Partition tool (supports GPT) |
| `gdisk` | GPT-specific partition tool |
| `parted` | Advanced partition tool |
| `partprobe` | Inform kernel of partition changes |

---

## Practice Questions

### Question 1: List All Block Devices
**Task:** Display all block devices and their partitions.

<details>
<summary>Show Solution</summary>

```bash
lsblk
```

**Output shows:**
- Device name (sda, sdb, etc.)
- Size
- Type (disk, part)
- Mount point

**Alternative:**
```bash
lsblk -f
```
Shows filesystem type and UUID.
</details>

---

### Question 2: List All Partitions
**Task:** Display detailed partition information for all disks.

<details>
<summary>Show Solution</summary>

```bash
sudo fdisk -l
```

**For specific disk:**
```bash
sudo fdisk -l /dev/sdb
```

**Shows:**
- Disk size
- Partition table type (GPT/MBR)
- Partition number, start, end, size, type
</details>

---

### Question 3: Check Partition Table Type
**Task:** Determine if a disk uses GPT or MBR.

<details>
<summary>Show Solution</summary>

```bash
sudo fdisk -l /dev/sdb | grep "Disklabel type"
```

**Output:**
```
Disklabel type: gpt
```

**Or using parted:**
```bash
sudo parted /dev/sdb print | grep "Partition Table"
```
</details>

---

### Question 4: Create GPT Partition with fdisk
**Task:** Create a new 500MB partition on /dev/sdb using fdisk.

<details>
<summary>Show Solution</summary>

```bash
sudo fdisk /dev/sdb
```

**Interactive commands:**
```
Command: g          # Create new GPT partition table (if new disk)
Command: n          # New partition
Partition number: 1 # Press Enter for default
First sector:       # Press Enter for default
Last sector: +500M  # Size of 500MB
Command: w          # Write changes and exit
```

**Inform kernel:**
```bash
sudo partprobe /dev/sdb
```

**Verify:**
```bash
lsblk /dev/sdb
```
</details>

---

### Question 5: Create Multiple Partitions
**Task:** Create two partitions: 1GB and 2GB on /dev/sdc.

<details>
<summary>Show Solution</summary>

```bash
sudo fdisk /dev/sdc
```

**Commands:**
```
Command: g          # Create GPT table
Command: n          # First partition
Partition number: 1
First sector: Enter
Last sector: +1G
Command: n          # Second partition
Partition number: 2
First sector: Enter
Last sector: +2G
Command: w          # Write and exit
```

```bash
sudo partprobe /dev/sdc
```
</details>

---

### Question 6: Create Partition with gdisk
**Task:** Create a 1GB partition on /dev/sdb using gdisk.

<details>
<summary>Show Solution</summary>

```bash
sudo gdisk /dev/sdb
```

**Commands:**
```
Command: n          # New partition
Partition number: 1 # Enter for default
First sector:       # Enter for default
Last sector: +1G    # Size
Hex code: 8300      # Linux filesystem (default)
Command: w          # Write
Proceed: Y          # Confirm
```

```bash
sudo partprobe /dev/sdb
```
</details>

---

### Question 7: Delete a Partition with fdisk
**Task:** Delete partition 2 from /dev/sdb.

<details>
<summary>Show Solution</summary>

```bash
sudo fdisk /dev/sdb
```

**Commands:**
```
Command: d          # Delete partition
Partition number: 2 # Partition to delete
Command: w          # Write changes
```

```bash
sudo partprobe /dev/sdb
```

**Verify:**
```bash
lsblk /dev/sdb
```
</details>

---

### Question 8: Delete Partition with gdisk
**Task:** Delete partition 1 from /dev/sdc using gdisk.

<details>
<summary>Show Solution</summary>

```bash
sudo gdisk /dev/sdc
```

**Commands:**
```
Command: d          # Delete
Partition number: 1
Command: w          # Write
Proceed: Y
```

```bash
sudo partprobe /dev/sdc
```
</details>

---

### Question 9: Create Partition with parted
**Task:** Create a 2GB partition on /dev/sdb using parted.

<details>
<summary>Show Solution</summary>

```bash
# Create GPT label (if new disk)
sudo parted /dev/sdb mklabel gpt

# Create partition
sudo parted /dev/sdb mkpart primary 1MiB 2GiB
```

**Interactive mode:**
```bash
sudo parted /dev/sdb
(parted) mklabel gpt
(parted) mkpart primary 1MiB 2GiB
(parted) quit
```

**Note:** parted writes changes immediately (no write command needed).
</details>

---

### Question 10: Delete Partition with parted
**Task:** Delete partition 1 from /dev/sdb using parted.

<details>
<summary>Show Solution</summary>

```bash
sudo parted /dev/sdb rm 1
```

**Interactive:**
```bash
sudo parted /dev/sdb
(parted) print         # View partitions
(parted) rm 1          # Remove partition 1
(parted) quit
```
</details>

---

### Question 11: Create Partition for LVM
**Task:** Create a partition and set its type for LVM use.

<details>
<summary>Show Solution</summary>

**Using fdisk:**
```bash
sudo fdisk /dev/sdb
```

```
Command: n          # New partition
Partition number: 1
First sector: Enter
Last sector: +5G
Command: t          # Change type
Hex code: 8e        # Linux LVM (or "lvm")
Command: w          # Write
```

**Using gdisk:**
```bash
sudo gdisk /dev/sdb
```

```
Command: n
Partition number: 1
First sector: Enter
Last sector: +5G
Hex code: 8e00      # Linux LVM
Command: w
```

```bash
sudo partprobe /dev/sdb
```
</details>

---

### Question 12: View Partition Type Codes
**Task:** List available partition type codes in fdisk.

<details>
<summary>Show Solution</summary>

```bash
sudo fdisk /dev/sdb
```

```
Command: l          # List partition types
```

**Common types:**
| Code | Type |
|------|------|
| 83 | Linux |
| 82 | Linux swap |
| 8e | Linux LVM |

Press `q` to quit without saving.
</details>

---

### Question 13: Print Partition Table with parted
**Task:** Display the partition table of /dev/sdb.

<details>
<summary>Show Solution</summary>

```bash
sudo parted /dev/sdb print
```

**Shows:**
- Disk model
- Disk size
- Partition table type
- Partitions with number, start, end, size, filesystem, flags
</details>

---

### Question 14: Exam Scenario - Create Two Partitions
**Task:** On disk /dev/sdb, create:
- Partition 1: 1GB for regular filesystem
- Partition 2: 2GB for LVM

<details>
<summary>Show Solution</summary>

```bash
sudo fdisk /dev/sdb
```

```
Command: g          # GPT label
Command: n          # Partition 1
Partition number: 1
First sector: Enter
Last sector: +1G
Command: n          # Partition 2
Partition number: 2
First sector: Enter
Last sector: +2G
Command: t          # Change type
Partition number: 2
Hex code: 8e        # LVM
Command: w          # Write
```

```bash
sudo partprobe /dev/sdb
lsblk /dev/sdb
```
</details>

---

### Question 15: Exam Scenario - Delete and Recreate
**Task:** Delete all partitions on /dev/sdc and create a new 3GB partition.

<details>
<summary>Show Solution</summary>

```bash
sudo fdisk /dev/sdc
```

```
Command: d          # Delete (repeat for each partition)
Partition number: 1
Command: d          # If more partitions
Partition number: 2
Command: g          # Create new GPT table (clears all)
Command: n          # New partition
Partition number: 1
First sector: Enter
Last sector: +3G
Command: w          # Write
```

```bash
sudo partprobe /dev/sdc
```

**Alternative using parted:**
```bash
sudo parted /dev/sdc mklabel gpt   # Wipes all partitions
sudo parted /dev/sdc mkpart primary 1MiB 3GiB
```
</details>

---

## Quick Reference

### fdisk Commands
```
g - Create new GPT partition table
n - Add new partition
d - Delete partition
t - Change partition type
l - List partition types
p - Print partition table
w - Write changes and exit
q - Quit without saving
```

### gdisk Commands
```
n - Add new partition
d - Delete partition
t - Change partition type
l - List partition types
p - Print partition table
w - Write changes
q - Quit without saving
```

### parted Commands
```bash
# Create GPT label
parted /dev/sdb mklabel gpt

# Create partition
parted /dev/sdb mkpart primary 1MiB 2GiB

# Delete partition
parted /dev/sdb rm 1

# Print partitions
parted /dev/sdb print
```

### Common Partition Size Suffixes
| Suffix | Meaning |
|--------|---------|
| M | Megabytes |
| G | Gigabytes |
| MiB | Mebibytes (fdisk/gdisk) |
| GiB | Gibibytes (parted) |

---

## Important Notes

1. **Always run `partprobe`** after creating/deleting partitions with fdisk/gdisk
2. **parted writes immediately** - no write command needed
3. **Use `g` command in fdisk** to create GPT partition table on new disk
4. **Partition type 8e** is for LVM, **82** is for swap
5. **Back up data** before modifying partition tables

---

## Summary

For the RHCSA exam, ensure you can:

1. **List block devices** using `lsblk`
2. **View partitions** using `fdisk -l`
3. **Create GPT partitions** using `fdisk`, `gdisk`, or `parted`
4. **Delete partitions** using any of the three tools
5. **Change partition types** (especially for LVM: 8e)
6. **Run `partprobe`** to update kernel
