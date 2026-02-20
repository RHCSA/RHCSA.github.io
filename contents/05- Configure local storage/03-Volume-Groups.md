# Assign Physical Volumes to Volume Groups

## RHCSA Exam Objective
> Assign physical volumes to volume groups

---

## Introduction

Volume Groups (VGs) pool together one or more Physical Volumes into a single storage unit. From VGs, you create Logical Volumes. The RHCSA exam tests your ability to create VGs, add PVs to existing VGs, and remove PVs from VGs.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `vgcreate` | Create a volume group |
| `vgextend` | Add PV to existing VG |
| `vgreduce` | Remove PV from VG |
| `vgremove` | Delete volume group |
| `vgs` | Display volume groups (brief) |
| `vgdisplay` | Display volume groups (detailed) |

---

## Practice Questions

### Question 1: Display Volume Groups
**Task:** List all volume groups on the system.

<details>
<summary>Show Solution</summary>

**Brief output:**
```bash
sudo vgs
```

**Detailed output:**
```bash
sudo vgdisplay
```

**Scan for VGs:**
```bash
sudo vgscan
```
</details>

---

### Question 2: Create Volume Group
**Task:** Create a volume group named `vg_data` using /dev/sdb1.

<details>
<summary>Show Solution</summary>

**Prerequisites:** /dev/sdb1 must be a physical volume.

```bash
# Ensure PV exists
sudo pvcreate /dev/sdb1

# Create volume group
sudo vgcreate vg_data /dev/sdb1
```

**Output:**
```
Volume group "vg_data" successfully created
```

**Verify:**
```bash
sudo vgs
```
</details>

---

### Question 3: Create VG with Multiple PVs
**Task:** Create volume group `vg_storage` using /dev/sdb1 and /dev/sdc1.

<details>
<summary>Show Solution</summary>

```bash
# Create PVs
sudo pvcreate /dev/sdb1 /dev/sdc1

# Create VG with multiple PVs
sudo vgcreate vg_storage /dev/sdb1 /dev/sdc1
```

**Verify:**
```bash
sudo vgs
sudo pvs
```
</details>

---

### Question 4: View Volume Group Details
**Task:** Display detailed information about `vg_data`.

<details>
<summary>Show Solution</summary>

```bash
sudo vgdisplay vg_data
```

**Output includes:**
- VG Name
- VG Size
- PE Size (Physical Extent size)
- Total PE
- Alloc PE / Free PE
- Number of PVs
- Number of LVs
</details>

---

### Question 5: Add Physical Volume to Existing VG
**Task:** Add /dev/sdc1 to existing volume group `vg_data`.

<details>
<summary>Show Solution</summary>

```bash
# Create PV if not done
sudo pvcreate /dev/sdc1

# Extend VG with new PV
sudo vgextend vg_data /dev/sdc1
```

**Output:**
```
Volume group "vg_data" successfully extended
```

**Verify:**
```bash
sudo vgs vg_data
sudo pvs
```
</details>

---

### Question 6: Remove Physical Volume from VG
**Task:** Remove /dev/sdc1 from volume group `vg_data`.

<details>
<summary>Show Solution</summary>

**Prerequisites:**
- PV must not contain any allocated extents
- Move data off PV first if needed

```bash
# Check if PV has allocated extents
sudo pvdisplay /dev/sdc1

# If data exists, move it to other PVs in VG
sudo pvmove /dev/sdc1

# Remove PV from VG
sudo vgreduce vg_data /dev/sdc1
```

**Output:**
```
Removed "/dev/sdc1" from volume group "vg_data"
```
</details>

---

### Question 7: Delete Volume Group
**Task:** Delete the volume group `vg_test`.

<details>
<summary>Show Solution</summary>

**Prerequisites:** VG must have no logical volumes.

```bash
# Remove all LVs first (if any)
sudo lvremove /dev/vg_test/lv_name

# Remove volume group
sudo vgremove vg_test
```

**Force removal (removes LVs too):**
```bash
sudo vgremove -f vg_test
```
</details>

---

### Question 8: Create VG with Custom PE Size
**Task:** Create a volume group with 16MB physical extent size.

<details>
<summary>Show Solution</summary>

```bash
sudo vgcreate -s 16M vg_custom /dev/sdb1
```

**Note:** 
- Default PE size is 4MB
- PE size affects maximum LV size
- PE size cannot be changed after VG creation
</details>

---

### Question 9: Rename Volume Group
**Task:** Rename `vg_old` to `vg_new`.

<details>
<summary>Show Solution</summary>

```bash
sudo vgrename vg_old vg_new
```

**Note:** Update /etc/fstab if LVs from this VG are mounted.
</details>

---

### Question 10: View PVs in a Volume Group
**Task:** Show which physical volumes belong to `vg_data`.

<details>
<summary>Show Solution</summary>

```bash
# Using pvs with VG filter
sudo pvs | grep vg_data

# Using vgdisplay
sudo vgdisplay -v vg_data | grep "PV Name"

# Direct method
sudo pvs -o pv_name,vg_name
```
</details>

---

### Question 11: Exam Scenario - Create Complete LVM Setup
**Task:** Create a volume group `vg_exam` from two 2GB partitions on /dev/sdb.

<details>
<summary>Show Solution</summary>

**Step 1: Create partitions**
```bash
sudo fdisk /dev/sdb
```
```
Command: n        # Partition 1
Partition: 1
First sector: Enter
Last sector: +2G
Command: t
Hex code: 8e      # LVM

Command: n        # Partition 2
Partition: 2
First sector: Enter
Last sector: +2G
Command: t
Partition: 2
Hex code: 8e

Command: w
```

```bash
sudo partprobe /dev/sdb
```

**Step 2: Create physical volumes**
```bash
sudo pvcreate /dev/sdb1 /dev/sdb2
```

**Step 3: Create volume group**
```bash
sudo vgcreate vg_exam /dev/sdb1 /dev/sdb2
```

**Verify:**
```bash
sudo vgs vg_exam
```
</details>

---

### Question 12: Exam Scenario - Extend VG
**Task:** Add a new 3GB partition to existing `vg_data`.

<details>
<summary>Show Solution</summary>

**Step 1: Create partition**
```bash
sudo fdisk /dev/sdc
```
```
Command: n
Partition: 1
First sector: Enter
Last sector: +3G
Command: t
Hex code: 8e
Command: w
```

```bash
sudo partprobe /dev/sdc
```

**Step 2: Create PV and extend VG**
```bash
sudo pvcreate /dev/sdc1
sudo vgextend vg_data /dev/sdc1
```

**Verify:**
```bash
sudo vgs vg_data
```
</details>

---

## Quick Reference

### Create Volume Groups
```bash
# Create VG with one PV
vgcreate vg_name /dev/sdb1

# Create VG with multiple PVs
vgcreate vg_name /dev/sdb1 /dev/sdc1

# Create VG with custom PE size
vgcreate -s 16M vg_name /dev/sdb1
```

### Display Volume Groups
```bash
# Brief list
vgs

# Detailed
vgdisplay

# Specific VG
vgdisplay vg_name
```

### Modify Volume Groups
```bash
# Add PV to VG
vgextend vg_name /dev/sdc1

# Remove PV from VG (move data first if needed)
pvmove /dev/sdc1
vgreduce vg_name /dev/sdc1

# Remove VG
vgremove vg_name

# Rename VG
vgrename old_name new_name
```

---

## Important Notes

1. **Create PVs before creating VG** - VG requires physical volumes
2. **VG size** is the sum of all PV sizes
3. **PE size** determines allocation granularity (default 4MB)
4. **Always move data** with `pvmove` before removing a PV
5. **Remove LVs** before removing VG

---

## Summary

For the RHCSA exam, ensure you can:

1. **Create volume groups** using `vgcreate`
2. **Add PVs to existing VGs** using `vgextend`
3. **Remove PVs from VGs** using `vgreduce`
4. **Remove volume groups** using `vgremove`
5. **Display VG information** using `vgs` and `vgdisplay`
6. **Move data off PV** using `pvmove` before removal
