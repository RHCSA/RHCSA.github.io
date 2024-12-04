## 05- Configure systems to mount file systems at boot by universally unique ID (UUID) or label:

The RHCSA exam topic **"Configure systems to mount file systems at boot by universally unique ID (UUID) or label"** tests your ability to configure file systems to mount automatically during boot. This involves modifying the `/etc/fstab` file to use **UUID** or **LABEL** identifiers, ensuring that the correct partitions or logical volumes are mounted persistently across reboots.

---

### **What You Need to Know:**
1. **UUID and LABEL**: These are unique identifiers for partitions or logical volumes. Using UUID or LABEL in `/etc/fstab` ensures file systems are mounted correctly, regardless of device name changes (like `/dev/sda` becoming `/dev/sdb`).
2. **Listing UUID and LABEL**: Use tools like `blkid` or `lsblk` to identify the UUID or LABEL of a partition or logical volume.
3. **Modifying `/etc/fstab`**: Configure persistent mounting by adding the correct entry in the `/etc/fstab` file.
4. **Testing changes**: Use `mount -a` to test if the `/etc/fstab` changes are correct before rebooting.
5. **Handling errors**: Understand how to troubleshoot issues like incorrect `/etc/fstab` entries that could prevent the system from booting correctly.

---

### **1. Understanding UUID and LABEL**

- **UUID (Universally Unique Identifier)**: A unique identifier automatically assigned to each partition or logical volume. It is not dependent on device names like `/dev/sda1`, which may change between boots.
- **LABEL**: A human-readable name assigned to a partition, which can be used as an alternative to UUID.

Using UUID or LABEL in `/etc/fstab` provides a more reliable way to mount file systems compared to device names, which can change depending on how the system detects hardware.

---

### **2. Listing UUID and LABEL of a Partition**

You can use the `blkid` command to list the UUID and LABEL of partitions.

#### **Example Task 1: Find the UUID and LABEL of a Partition**

**Task:** List the UUID and LABEL of the partition **`/dev/sda1`**.

**Command:**
```bash
sudo blkid /dev/sda1
```

#### **Example Output:**
```
/dev/sda1: UUID="e2a1b2c3-1234-5678-9101-a1b2c3d4e5f6" TYPE="ext4" PARTLABEL="root"
```

**Explanation:**
- **UUID** is **`e2a1b2c3-1234-5678-9101-a1b2c3d4e5f6`**.
- **LABEL** is **`root`** if set.

---

#### **Example Task 2: List UUID and LABEL for All Block Devices**

**Task:** Use `blkid` to list the UUID and LABEL of all partitions.

**Command:**
```bash
sudo blkid
```

#### **Example Output:**
```
/dev/sda1: UUID="e2a1b2c3-1234-5678-9101-a1b2c3d4e5f6" TYPE="ext4"
/dev/sdb1: UUID="f3b4c5d6-7890-1121-3141-f5e6d7a8b9c0" TYPE="ext4" LABEL="data"
```

**Explanation:**
- This shows the **UUID**, **LABEL** (if set), and **filesystem type** for each device.

---

### **3. Modifying `/etc/fstab` to Mount by UUID or LABEL**

To configure a file system to mount automatically at boot, you need to add an entry to `/etc/fstab` using its UUID or LABEL.

#### **`/etc/fstab` Format:**
```
UUID=<UUID>  <mount_point>  <filesystem_type>  <options>  <dump>  <fsck_order>
LABEL=<LABEL>  <mount_point>  <filesystem_type>  <options>  <dump>  <fsck_order>
```
- **UUID=<UUID>** or **LABEL=<LABEL>**: Specifies the identifier of the partition or logical volume.
- **<mount_point>**: The directory where the file system will be mounted.
- **<filesystem_type>**: Type of the file system (e.g., `ext4`, `xfs`).
- **<options>**: Mount options (e.g., `defaults`, `noatime`).
- **<dump>**: Backup options, usually set to `0`.
- **<fsck_order>**: File system check order, usually `1` for root and `2` for others.

#### **Example Task 3: Add a File System to `/etc/fstab` Using UUID**

**Task:** Mount the partition **`/dev/sdb1`** at **`/mnt/data`** using its UUID.

1. **Find the UUID**:
   ```bash
   sudo blkid /dev/sdb1
   ```

   **Example UUID Output**:
   ```
   /dev/sdb1: UUID="f3b4c5d6-7890-1121-3141-f5e6d7a8b9c0" TYPE="ext4"
   ```

2. **Edit `/etc/fstab`**:
   ```bash
   sudo nano /etc/fstab
   ```

3. **Add the following line** to `/etc/fstab`:
   ```
   UUID=f3b4c5d6-7890-1121-3141-f5e6d7a8b9c0  /mnt/data  ext4  defaults  0  2
   ```

4. **Test the new configuration**:
   ```bash
   sudo mount -a
   ```

5. **Verify the mount**:
   ```bash
   df -h /mnt/data
   ```

**Explanation:**
- **`UUID=f3b4c5d6-7890-1121-3141-f5e6d7a8b9c0`**: Refers to the UUID of `/dev/sdb1`.
- **`/mnt/data`**: The directory where the file system will be mounted.
- **`ext4`**: The file system type.
- **`defaults`**: Mount options (default behavior).
- **`0 2`**: The file system is not dumped and will be checked after the root file system at boot.

---

#### **Example Task 4: Add a File System to `/etc/fstab` Using LABEL**

**Task:** Mount the partition **`/dev/sdc1`** at **`/mnt/backup`** using its LABEL.

1. **Find the LABEL**:
   ```bash
   sudo blkid /dev/sdc1
   ```

   **Example LABEL Output**:
   ```
   /dev/sdc1: LABEL="backup" UUID="d6e7f8g9-1234-5678-9101-h2i3j4k5l6m7" TYPE="ext4"
   ```

2. **Edit `/etc/fstab`**:
   ```bash
   sudo nano /etc/fstab
   ```

3. **Add the following line** to `/etc/fstab`:
   ```
   LABEL=backup  /mnt/backup  ext4  defaults  0  2
   ```

4. **Test the new configuration**:
   ```bash
   sudo mount -a
   ```

5. **Verify the mount**:
   ```bash
   df -h /mnt/backup
   ```

**Explanation:**
- **`LABEL=backup`**: Refers to the human-readable label assigned to the partition.
- **`/mnt/backup`**: The directory where the file system will be mounted.

---

### **4. Testing `/etc/fstab` Configuration**

After editing `/etc/fstab`, you should test the configuration to avoid issues during the next reboot.

#### **Example Task 5: Test the `/etc/fstab` Configuration**

**Task:** Test the new entries in `/etc/fstab` without rebooting the system.

**Command:**
```bash
sudo mount -a
```

**Explanation:**
- **`mount -a`** mounts all file systems specified in `/etc/fstab` without requiring a reboot. This is useful for testing new entries.

---

### **5. Handling Errors in `/etc/fstab`**

If there is an error in the `/etc/fstab` configuration, such as a mistyped UUID or incorrect mount point, it can prevent the system from booting. To troubleshoot, you can boot into **rescue mode** or use the **emergency shell** to fix the issue.

#### **Example Task 6: Boot into Rescue Mode to Fix `/etc/fstab` Issues**

**Task:** Fix an incorrect `/etc/fstab` entry by booting into rescue mode.

1. **Reboot into the GRUB menu**.
2. **Enter rescue mode** by editing the GRUB entry:
   - Press **`e`** to edit the boot parameters.
   - Add **`systemd.unit=rescue.target`** to the kernel line.
   - Press **`Ctrl + X`** to boot into rescue mode.
3. **Edit `/etc/fstab`** to fix the incorrect entry.

---

### Summary of Skills for RHCSA Exam on Mounting File Systems

 by UUID or LABEL:
1. **Identify UUID or LABEL** using `blkid`.
2. **Modify `/etc/fstab`** to configure file systems to mount at boot using UUID or LABEL.
3. **Test `/etc/fstab` entries** with `mount -a` to ensure the changes are correct.
4. **Troubleshoot issues** by booting into rescue mode or emergency shell if the system fails to boot.
