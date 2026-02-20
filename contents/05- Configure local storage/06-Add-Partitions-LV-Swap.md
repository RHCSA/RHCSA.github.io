# Add New Partitions, Logical Volumes, and Swap Non-Destructively

## RHCSA Exam Objective
> Add new partitions and logical volumes, and swap to a system non-destructively

---

## Introduction

The RHCSA exam tests your ability to add storage to a running system without affecting existing data or requiring a reboot. This includes adding partitions to disks with existing data, extending LVM storage, and configuring swap space. The key is "non-destructive" - you must preserve existing data.

---

## Part 1: Add Partitions Non-Destructively

### Key Principle
When adding partitions to a disk that already has partitions, use free space and never delete or modify existing partitions.

---

### Question 1: Check Available Free Space
**Task:** Identify free space on a disk for creating new partitions.

<details>
<summary>Show Solution</summary>

```bash
# Using fdisk
sudo fdisk -l /dev/sdb

# Using parted (shows free space)
sudo parted /dev/sdb print free
```

**Look for:**
- Unallocated space after existing partitions
- Free sectors that can be used
</details>

---

### Question 2: Add Partition to Existing Disk
**Task:** Add a new 2GB partition to /dev/sdb which already has partition 1.

<details>
<summary>Show Solution</summary>

```bash
sudo fdisk /dev/sdb
```

```
Command: n          # New partition
Partition number: 2 # Next available number
First sector: Enter # Use default (after existing partitions)
Last sector: +2G
Command: w          # Write
```

```bash
sudo partprobe /dev/sdb
```

**Important:** Default first sector starts after existing partitions, preserving them.
</details>

---

### Question 3: Verify Existing Data After Adding Partition
**Task:** Confirm existing partition data is intact after adding new partition.

<details>
<summary>Show Solution</summary>

```bash
# Check partition table
lsblk /dev/sdb

# Verify existing mount still works
df -h

# Check filesystem (if unmounted)
sudo xfs_repair -n /dev/sdb1    # XFS (dry run)
sudo e2fsck -n /dev/sdb1        # ext4 (dry run)
```
</details>

---

## Part 2: Extend LVM Non-Destructively

### Question 4: Add Disk Space to Existing LV
**Task:** Extend logical volume `lv_data` by adding a new partition, without data loss.

<details>
<summary>Show Solution</summary>

**Step 1: Create new partition (type 8e)**
```bash
sudo fdisk /dev/sdc
# Create partition, set type 8e, write
```
```bash
sudo partprobe /dev/sdc
```

**Step 2: Create physical volume**
```bash
sudo pvcreate /dev/sdc1
```

**Step 3: Extend volume group**
```bash
sudo vgextend vg_data /dev/sdc1
```

**Step 4: Extend logical volume and filesystem**
```bash
sudo lvextend -L +2G -r /dev/vg_data/lv_data
```

**The `-r` flag resizes the filesystem automatically.**

**Verify:**
```bash
df -h /mount/point
```
</details>

---

## Part 2: Configure Swap Space

### Key Commands

| Command | Description |
|---------|-------------|
| `mkswap` | Format as swap space |
| `swapon` | Activate swap |
| `swapoff` | Deactivate swap |
| `free -h` | Show swap usage |

---

### Question 5: View Current Swap
**Task:** Display current swap configuration.

<details>
<summary>Show Solution</summary>

```bash
# Show memory and swap
free -h

# List active swap devices
swapon --show

# Or
cat /proc/swaps
```
</details>

---

### Question 6: Create Swap Partition
**Task:** Create a 1GB swap partition on /dev/sdb.

<details>
<summary>Show Solution</summary>

**Step 1: Create partition with swap type**
```bash
sudo fdisk /dev/sdb
```
```
Command: n
Partition number: 1
First sector: Enter
Last sector: +1G
Command: t
Hex code: 82        # Linux swap
Command: w
```

```bash
sudo partprobe /dev/sdb
```

**Step 2: Format as swap**
```bash
sudo mkswap /dev/sdb1
```

**Step 3: Activate swap**
```bash
sudo swapon /dev/sdb1
```

**Step 4: Verify**
```bash
swapon --show
free -h
```
</details>

---

### Question 7: Create Swap LV
**Task:** Create a 512MB swap logical volume.

<details>
<summary>Show Solution</summary>

**Step 1: Create logical volume**
```bash
sudo lvcreate -L 512M -n lv_swap vg_data
```

**Step 2: Format as swap**
```bash
sudo mkswap /dev/vg_data/lv_swap
```

**Step 3: Activate**
```bash
sudo swapon /dev/vg_data/lv_swap
```

**Verify:**
```bash
swapon --show
```
</details>

---

### Question 8: Configure Persistent Swap
**Task:** Configure swap partition /dev/sdb1 to activate at boot.

<details>
<summary>Show Solution</summary>

**Step 1: Get UUID**
```bash
sudo blkid /dev/sdb1
```

**Step 2: Add to /etc/fstab**
```bash
sudo vim /etc/fstab
```

**Add line:**
```
UUID=swap-uuid-here  none  swap  defaults  0 0
```

**Step 3: Verify**
```bash
sudo swapon -a    # Activate all swap from fstab
swapon --show
```
</details>

---

### Question 9: Configure Persistent Swap LV
**Task:** Configure swap LV to persist across reboots.

<details>
<summary>Show Solution</summary>

**Add to /etc/fstab:**
```
/dev/vg_data/lv_swap  none  swap  defaults  0 0
```

**Or by UUID:**
```bash
sudo blkid /dev/vg_data/lv_swap
```
```
UUID=swap-uuid  none  swap  defaults  0 0
```

**Activate:**
```bash
sudo swapon -a
```
</details>

---

### Question 10: Add Swap Without Reboot
**Task:** Add additional swap space to running system immediately.

<details>
<summary>Show Solution</summary>

```bash
# Create partition or LV
sudo lvcreate -L 1G -n lv_swap2 vg_data

# Format
sudo mkswap /dev/vg_data/lv_swap2

# Activate immediately
sudo swapon /dev/vg_data/lv_swap2

# Add to fstab for persistence
echo "/dev/vg_data/lv_swap2  none  swap  defaults  0 0" | sudo tee -a /etc/fstab
```
</details>

---

### Question 11: Remove Swap
**Task:** Remove swap device /dev/sdb1.

<details>
<summary>Show Solution</summary>

```bash
# Deactivate swap
sudo swapoff /dev/sdb1

# Remove from fstab
sudo vim /etc/fstab
# Remove or comment the swap line

# Verify
swapon --show
```
</details>

---

### Question 12: Create Swap File
**Task:** Create a 1GB swap file.

<details>
<summary>Show Solution</summary>

```bash
# Create file
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024

# Set permissions
sudo chmod 600 /swapfile

# Format as swap
sudo mkswap /swapfile

# Activate
sudo swapon /swapfile

# Verify
swapon --show
```

**Add to fstab for persistence:**
```
/swapfile  none  swap  defaults  0 0
```
</details>

---

### Question 13: Set Swap Priority
**Task:** Configure swap device with specific priority.

<details>
<summary>Show Solution</summary>

**In fstab:**
```
UUID=xxx  none  swap  defaults,pri=10  0 0
UUID=yyy  none  swap  defaults,pri=5   0 0
```

**Higher priority (larger number) is used first.**

**Or with swapon:**
```bash
sudo swapon -p 10 /dev/sdb1
```
</details>

---

## Exam Scenarios

### Question 14: Complete Non-Destructive Storage Addition
**Task:** Add 3GB to existing `lv_data` using a new disk, without affecting current data.

<details>
<summary>Show Solution</summary>

```bash
# 1. Create partition on new disk
sudo fdisk /dev/sdc
# n, 1, Enter, +3G, t, 8e, w

sudo partprobe /dev/sdc

# 2. Create PV
sudo pvcreate /dev/sdc1

# 3. Extend VG
sudo vgextend vg_data /dev/sdc1

# 4. Extend LV and filesystem
sudo lvextend -L +3G -r /dev/vg_data/lv_data

# 5. Verify (data intact, more space)
df -h
```
</details>

---

### Question 15: Add Swap to Running System
**Task:** Add 2GB swap to a running system and make it persistent.

<details>
<summary>Show Solution</summary>

```bash
# Option 1: Using LV
sudo lvcreate -L 2G -n lv_swap vg_data
sudo mkswap /dev/vg_data/lv_swap
sudo swapon /dev/vg_data/lv_swap
echo "/dev/vg_data/lv_swap  none  swap  defaults  0 0" | sudo tee -a /etc/fstab

# Option 2: Using partition
sudo fdisk /dev/sdb
# Create partition type 82
sudo partprobe /dev/sdb
sudo mkswap /dev/sdb2
sudo swapon /dev/sdb2
# Add UUID to fstab
```
</details>

---

## Quick Reference

### Non-Destructive Partition Addition
```bash
# Check free space
parted /dev/sdb print free

# Add partition (fdisk defaults to free space)
fdisk /dev/sdb
# n, number, Enter, +SIZE, w

# Update kernel
partprobe /dev/sdb
```

### Non-Destructive LVM Extension
```bash
# Add PV and extend VG
pvcreate /dev/sdc1
vgextend vg_name /dev/sdc1

# Extend LV and filesystem
lvextend -L +SIZE -r /dev/vg_name/lv_name
```

### Swap Management
```bash
# Create and activate swap
mkswap /dev/sdb1
swapon /dev/sdb1

# Persistent swap in fstab
UUID=xxx  none  swap  defaults  0 0

# View swap
swapon --show
free -h

# Remove swap
swapoff /dev/sdb1
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Add partitions non-destructively** using free space
2. **Extend LVM storage** without unmounting (vgextend, lvextend -r)
3. **Create swap partitions** using mkswap
4. **Create swap logical volumes** in existing VGs
5. **Configure persistent swap** in /etc/fstab
6. **Activate swap immediately** using swapon
7. **Verify operations** with lsblk, df, swapon --show
---

## Part 4: Create and Configure Encrypted Storage (LUKS)

LUKS (Linux Unified Key Setup) is the standard for disk encryption on Linux. This is an important RHCSA topic for securing sensitive data at rest.

---

### Question 15: Create LUKS Encrypted Partition
**Task:** Create a LUKS encrypted partition on /dev/sdc1.

<details>
<summary>Show Solution</summary>

```bash
# Format partition with LUKS encryption
sudo cryptsetup luksFormat /dev/sdc1
```

**You will be prompted:**
```
WARNING!
========
This will overwrite data on /dev/sdc1 irrevocably.

Are you sure? (Type 'yes' in capital letters): YES
Enter passphrase for /dev/sdc1: 
Verify passphrase:
```

**Important:** Save the passphrase securely - it cannot be recovered!
</details>

---

### Question 16: Open and Mount LUKS Device
**Task:** Open the LUKS device, create a filesystem, and mount it.

<details>
<summary>Show Solution</summary>

```bash
# Open the encrypted device
sudo cryptsetup open /dev/sdc1 secretdisk

# Provide passphrase when prompted

# Verify the mapped device exists
ls -l /dev/mapper/secretdisk

# Create filesystem on the mapped device
sudo mkfs.xfs /dev/mapper/secretdisk

# Create mount point and mount
sudo mkdir -p /mnt/encrypted
sudo mount /dev/mapper/secretdisk /mnt/encrypted
```

**Verify:**
```bash
lsblk
df -h /mnt/encrypted
```
</details>

---

### Question 17: Check LUKS Device Status
**Task:** Display the status of an open LUKS device.

<details>
<summary>Show Solution</summary>

```bash
sudo cryptsetup status secretdisk
```

**Output shows:**
```
/dev/mapper/secretdisk is active.
  type:    LUKS2
  cipher:  aes-xts-plain64
  keysize: 512 bits
  key location: keyring
  device:  /dev/sdc1
  sector size:  512
  offset:  32768 sectors
  size:    2064384 sectors
  mode:    read/write
```
</details>

---

### Question 18: Close LUKS Device
**Task:** Safely close an encrypted device.

<details>
<summary>Show Solution</summary>

```bash
# Unmount first
sudo umount /mnt/encrypted

# Close the LUKS device
sudo cryptsetup close secretdisk

# Verify it's closed
ls /dev/mapper/
```
</details>

---

### Question 19: Configure Persistent LUKS Mount
**Task:** Configure LUKS encrypted volume to mount at boot with a key file.

<details>
<summary>Show Solution</summary>

**Step 1: Create a key file**
```bash
sudo dd if=/dev/urandom of=/root/luks-key bs=256 count=1
sudo chmod 400 /root/luks-key
```

**Step 2: Add the key to LUKS device**
```bash
sudo cryptsetup luksAddKey /dev/sdc1 /root/luks-key
```

**Step 3: Get UUID of LUKS device**
```bash
sudo cryptsetup luksUUID /dev/sdc1
```

**Step 4: Configure /etc/crypttab**
```bash
echo 'secretdisk UUID=<uuid> /root/luks-key luks' | sudo tee -a /etc/crypttab
```

**Step 5: Configure /etc/fstab**
```bash
echo '/dev/mapper/secretdisk /mnt/encrypted xfs defaults 0 0' | sudo tee -a /etc/fstab
```

**Step 6: Test configuration**
```bash
sudo systemctl daemon-reload
sudo mount -a
```

**Persistence ensured:** Both crypttab and fstab entries survive reboot.
</details>

---

### Question 20: Change LUKS Passphrase
**Task:** Change the passphrase for an encrypted device.

<details>
<summary>Show Solution</summary>

```bash
sudo cryptsetup luksChangeKey /dev/sdc1
```

**You'll be prompted for:**
1. The current passphrase
2. The new passphrase (twice)

**To add an additional passphrase (LUKS supports multiple):**
```bash
sudo cryptsetup luksAddKey /dev/sdc1
```
</details>

---

### Question 21: List LUKS Key Slots
**Task:** View the key slots used in a LUKS device.

<details>
<summary>Show Solution</summary>

```bash
sudo cryptsetup luksDump /dev/sdc1
```

**Look for the Keyslots section:**
```
Keyslots:
  0: luks2    ← Active key slot
  1: luks2    ← Active key slot
  2-7: (none)  ← Available slots
```

LUKS2 supports up to 32 key slots for multiple passphrases or key files.
</details>

---

### LUKS Quick Reference

| Task | Command |
|------|---------|
| Format with LUKS | `cryptsetup luksFormat /dev/sdX` |
| Open encrypted device | `cryptsetup open /dev/sdX name` |
| Close encrypted device | `cryptsetup close name` |
| Check status | `cryptsetup status name` |
| Change passphrase | `cryptsetup luksChangeKey /dev/sdX` |
| Add passphrase/key | `cryptsetup luksAddKey /dev/sdX [keyfile]` |
| Remove passphrase | `cryptsetup luksRemoveKey /dev/sdX` |
| View LUKS info | `cryptsetup luksDump /dev/sdX` |
| Get UUID | `cryptsetup luksUUID /dev/sdX` |

### Important Files for Persistent LUKS

| File | Purpose |
|------|---------|
| `/etc/crypttab` | Maps LUKS devices to names at boot |
| `/etc/fstab` | Mounts decrypted device |
| `/root/luks-key` | Key file (if using automated unlock) |

### crypttab Format
```
name    device                    keyfile           options
secret  UUID=xxxx-xxxx-xxxx       /root/luks-key    luks
```