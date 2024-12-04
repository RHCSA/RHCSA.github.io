## 01- Create, mount, unmount, and use vfat, ext4, and xfs file systems:

The RHCSA exam topic **"Create, mount, unmount, and use vfat, ext4, and xfs file systems"** focuses on your ability to manage different file systems on Linux. You’ll need to know how to create file systems, mount them (both temporarily and persistently), and unmount them. The key file systems for this task are **`vfat`**, **`ext4`**, and **`xfs`**, which are commonly used in Linux environments.

---

### **What You Need to Know:**
1. **File System Types**:
   - **VFAT**: File system often used on USB drives (compatible with Windows).
   - **EXT4**: The default file system for Linux, supporting large files and journaling.
   - **XFS**: High-performance journaling file system, default on RHEL 7 and later.
   
2. **Creating File Systems**: You need to know how to format a disk or partition with `vfat`, `ext4`, or `xfs` using tools like `mkfs`.
   
3. **Mounting and Unmounting**: Mounting file systems both temporarily and persistently using the `/etc/fstab` file.

4. **Ensuring Persistence**: Any changes should be reflected in `/etc/fstab` for automatic mounting during boot.

---

### **1. Creating a File System**

To create a file system, you’ll need to use **`mkfs`** or a variant (e.g., `mkfs.ext4`, `mkfs.xfs`, or `mkfs.vfat`) depending on the file system type. These commands format the disk or partition, making it ready to be mounted.

#### **Example Task 1: Create an `ext4` File System**

**Task:** Format the partition **`/dev/sdb1`** with the `ext4` file system.

**Command:**
```bash
sudo mkfs.ext4 /dev/sdb1
```

#### **Example Output:**
```
mke2fs 1.45.6 (20-Mar-2020)
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: abcdef12-3456-7890-abcd-1234567890ab
```

**Explanation**:
- **`mkfs.ext4`** formats the partition with the `ext4` file system.
- The output shows the new file system's UUID, which can be used for mounting it in `/etc/fstab`.

---

#### **Example Task 2: Create an `xfs` File System**

**Task:** Format the partition **`/dev/sdc1`** with the `xfs` file system.

**Command:**
```bash
sudo mkfs.xfs /dev/sdc1
```

#### **Example Output:**
```
meta-data=/dev/sdc1      isize=512    agcount=4, agsize=65536 blks
data     =               bsize=4096   blocks=262144, imaxpct=25
```

**Explanation**:
- **`mkfs.xfs`** formats the partition with the `xfs` file system, which is known for high performance.

---

#### **Example Task 3: Create a `vfat` File System**

**Task:** Format the partition **`/dev/sdd1`** with the `vfat` file system.

**Command:**
```bash
sudo mkfs.vfat /dev/sdd1
```

#### **Example Output:**
```
mkfs.fat 4.1 (2017-01-24)
```

**Explanation**:
- **`mkfs.vfat`** creates a FAT32-compatible file system, which is useful for USB drives and cross-platform compatibility.

---

### **2. Mounting a File System Temporarily**

After creating a file system, it must be mounted to a directory before it can be used. Temporary mounting is useful for testing or when persistent mounts are not required.

#### **Example Task 4: Mount the `ext4` File System Temporarily**

**Task:** Mount the partition **`/dev/sdb1`** to **`/mnt/data`**.

**Command:**
```bash
sudo mount /dev/sdb1 /mnt/data
```

**Explanation**:
- **`mount /dev/sdb1 /mnt/data`** mounts the `ext4` file system at the `/mnt/data` directory.
- This mount will not persist after reboot unless added to `/etc/fstab`.

---

### **3. Mounting a File System Persistently Using `/etc/fstab`**

To make the mount persistent across reboots, the file system must be added to `/etc/fstab`. This file tells the system which file systems to mount during boot.

#### **Example Task 5: Mount an `ext4` File System Persistently**

**Task:** Mount the partition **`/dev/sdb1`** to **`/mnt/data`** persistently using `/etc/fstab`.

1. **Get the UUID** of the partition:
   ```bash
   sudo blkid /dev/sdb1
   ```

   **Example Output**:
   ```
   /dev/sdb1: UUID="abcdef12-3456-7890-abcd-1234567890ab" TYPE="ext4"
   ```

2. **Edit `/etc/fstab`** to add the entry:
   ```bash
   sudo nano /etc/fstab
   ```

3. **Add the following line** to mount the partition by UUID:
   ```
   UUID=abcdef12-3456-7890-abcd-1234567890ab  /mnt/data  ext4  defaults  0  2
   ```

4. **Test the `/etc/fstab` entry**:
   ```bash
   sudo mount -a
   ```

5. **Verify the mount**:
   ```bash
   df -h /mnt/data
   ```

**Explanation**:
- The file system is now mounted persistently, and it will be automatically mounted during boot.

---

#### **Example Task 6: Mount an `xfs` File System Persistently**

**Task:** Mount the partition **`/dev/sdc1`** to **`/mnt/backup`** using UUID in `/etc/fstab`.

1. **Get the UUID** of the partition:
   ```bash
   sudo blkid /dev/sdc1
   ```

2. **Edit `/etc/fstab`** to add the entry:
   ```
   UUID=<UUID_of_sdc1>  /mnt/backup  xfs  defaults  0  2
   ```

3. **Test the `/etc/fstab` entry**:
   ```bash
   sudo mount -a
   ```

**Explanation**:
- The **`xfs`** file system will be mounted persistently at **`/mnt/backup`**.

---

#### **Example Task 7: Mount a `vfat` File System Persistently**

**Task:** Mount the partition **`/dev/sdd1`** to **`/mnt/usbdrive`** using LABEL in `/etc/fstab`.

1. **Get the LABEL** of the partition:
   ```bash
   sudo blkid /dev/sdd1
   ```

   **Example Output**:
   ```
   /dev/sdd1: LABEL="USBDrive" UUID="f3b4c5d6-7890-1121-3141-f5e6d7a8b9c0" TYPE="vfat"
   ```

2. **Edit `/etc/fstab`** to add the entry:
   ```
   LABEL=USBDrive  /mnt/usbdrive  vfat  defaults  0  0
   ```

3. **Test the `/etc/fstab` entry**:
   ```bash
   sudo mount -a
   ```

**Explanation**:
- The **`vfat`** file system is mounted persistently at **`/mnt/usbdrive`**, using the LABEL instead of UUID.

---

### **4. Unmounting a File System**

Unmounting a file system is necessary when you no longer need it or before making changes to the partition. The **`umount`** command is used for this purpose.

#### **Example Task 8: Unmount a File System**

**Task:** Unmount the file system mounted at **`/mnt/data`**.

**Command:**
```bash
sudo umount /mnt/data
```

**Explanation**:
- **`umount /mnt/data`** unmounts the file system, making it no longer accessible from `/mnt/data`.

---

### Summary of Skills for RHCSA Exam on File Systems:
1. **Create file systems** using `mkfs` commands for **`ext4`**, **`xfs`**, and **`vfat`**.
2. **Mount file systems** temporarily using the `mount` command.
3. **Mount file systems persistently** by editing `/etc/fstab` using **UUID** or **LABEL**.
4. **Unmount file systems** when no longer in use with the `umount` command.
5. **Test mounts** using `mount -a` to check for any errors before rebooting.
