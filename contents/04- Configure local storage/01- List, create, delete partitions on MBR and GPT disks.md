## 01- List, create, delete partitions on MBR and GPT disks:

The RHCSA exam topic **"List, create, delete partitions on MBR and GPT disks"** tests your ability to manage disk partitions using tools like `fdisk` (for MBR) and `gdisk` or `parted` (for GPT). Understanding partitioning is critical for configuring storage on Linux systems.


---

### **What You Need to Know:**
1. **Master Boot Record (MBR)** and **GUID Partition Table (GPT)** partition schemes.
2. **Listing partitions** using `fdisk`, `gdisk`, and `parted`.
3. **Creating, deleting, and modifying partitions** on MBR (using `fdisk`) and GPT disks (using `gdisk` or `parted`).
4. **Understanding primary, extended, and logical partitions** (for MBR).
5. **Writing changes to disk** and refreshing the partition table without rebooting.

---

### **1. Understanding MBR and GPT Partitioning**

- **MBR (Master Boot Record)** supports up to **4 primary partitions** or **3 primary partitions** and **1 extended partition**, which can hold multiple **logical partitions**. It has a size limit of **2 TB**.
- **GPT (GUID Partition Table)** supports **128 partitions by default**, has no distinction between primary and logical partitions, and supports disks larger than **2 TB**.

---

### **2. Listing Existing Partitions**

You can list the partitions on a disk using tools like `fdisk`, `gdisk`, or `parted`.

#### **Example Task 1: List Partitions on an MBR Disk Using `fdisk`**

**Task:** Use `fdisk` to list partitions on the disk `/dev/sda` (MBR).

**Command:**
```bash
sudo fdisk -l /dev/sda
```

#### **Example Output:**
```
Disk /dev/sda: 100 GiB, 107374182400 bytes, 209715200 sectors
Units: sectors of 1 * 512 = 512 bytes
Device     Boot  Start       End   Sectors  Size Id Type
/dev/sda1  *      2048   1026047   1024000  500M 83 Linux
/dev/sda2       1026048 209715199 208689152 99.5G 8e Linux LVM
```

**Explanation:**
- **`fdisk -l`** lists the partition table on `/dev/sda`.
- The output shows two partitions: a **500M boot partition** and a large **99.5G LVM partition**.

---

#### **Example Task 2: List Partitions on a GPT Disk Using `parted`**

**Task:** Use `parted` to list partitions on a GPT disk `/dev/sdb`.

**Command:**
```bash
sudo parted /dev/sdb print
```

#### **Example Output:**
```
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 100GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  524MB   523MB   ext4
 2      524MB   100GB   99.5GB  ext4
```

**Explanation:**
- **`parted /dev/sdb print`** prints the partition table for `/dev/sdb`, showing two partitions.
- The disk uses the **GPT** partitioning scheme.

---

### **3. Creating and Deleting Partitions on MBR Using `fdisk`**

You can use **`fdisk`** to create and delete partitions on an MBR disk.

#### **Example Task 3: Create a New Partition on an MBR Disk Using `fdisk`**

**Task:** Create a new **1 GB** primary partition on the disk `/dev/sda` using `fdisk`.

**Steps:**

1. **Start `fdisk`**:
   ```bash
   sudo fdisk /dev/sda
   ```

2. **Create a new partition**:
   - Type **`n`** for a new partition.
   - Choose **`p`** for a primary partition.
   - Press **`Enter`** to accept the default partition number.
   - Set the **first sector** (press Enter to use the default).
   - Enter **`+1G`** to create a 1 GB partition.

3. **Write changes to the disk**:
   - Type **`w`** to write the changes and exit.

#### **Example Output:**
```
Command (m for help): n
Partition type:
   p   primary (3 primary, 0 extended, 1 free)
   e   extended
Select (default p): p
Partition number (4, default 4): 
First sector (2048-209715199, default 1026048): 
Last sector, +sectors or +size{K,M,G,T,P} (1026048-209715199, default 209715199): +1G

Command (m for help): w
The partition table has been altered.
```

**Explanation:**
- **`n`** creates a new partition.
- **`p`** selects a primary partition.
- **`+1G`** creates a partition of 1 GB in size.
- **`w`** writes the changes to the partition table.

---

#### **Example Task 4: Delete a Partition on an MBR Disk Using `fdisk`**

**Task:** Delete the newly created partition on `/dev/sda`.

**Steps:**

1. **Start `fdisk`**:
   ```bash
   sudo fdisk /dev/sda
   ```

2. **Delete the partition**:
   - Type **`d`**.
   - Select the partition number (e.g., `4`).

3. **Write changes**:
   - Type **`w`** to write the changes to the disk.

#### **Example Output:**
```
Command (m for help): d
Partition number (1-4, default 4): 4

Partition 4 has been deleted.

Command (m for help): w
The partition table has been altered.
```

---

### **4. Creating and Deleting Partitions on GPT Using `gdisk` or `parted`**

For GPT disks, you can use **`gdisk`** or **`parted`** to create, delete, or modify partitions.

#### **Example Task 5: Create a New Partition on a GPT Disk Using `gdisk`**

**Task:** Create a new **2 GB** partition on a GPT disk `/dev/sdb` using `gdisk`.

**Steps:**

1. **Start `gdisk`**:
   ```bash
   sudo gdisk /dev/sdb
   ```

2. **Create a new partition**:
   - Type **`n`** to create a new partition.
   - Press **`Enter`** to accept the default partition number.
   - Accept the default first sector.
   - Enter **`+2G`** to create a 2 GB partition.

3. **Write changes**:
   - Type **`w`** to write the changes and exit.

#### **Example Output:**
```
Command: n
Partition number (default 3): 
First sector (34-209715166, default = 524288): 
Last sector, +sectors or +size{K,M,G,T,P}: +2G

Command: w
Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING PARTITIONS!!
Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/sdb.
```

---

#### **Example Task 6: Delete a Partition on a GPT Disk Using `gdisk`**

**Task:** Delete the newly created partition on `/dev/sdb` using `gdisk`.

**Steps:**

1. **Start `gdisk`**:
   ```bash
   sudo gdisk /dev/sdb
   ```

2. **Delete the partition**:
   - Type **`d`**.
   - Enter the partition number (e.g., `3`).

3. **Write changes**:
   - Type **`w`** to write the changes to disk.

#### **Example Output:**
```
Command: d
Partition number (1-3): 3

Command: w
Do you want to proceed? (Y/N): y
```

---

### **5. Creating Partitions Using `parted` (for MBR and GPT)**

**`parted`** can be used for both MBR and GPT disks, and it's more user-friendly for working with large disks or GPT partitioning schemes.

#### **Example Task 7: Create a New Partition on a GPT Disk Using `parted`**

**Task:** Create a **3 GB** partition on `/dev/sdb` using `parted`.

**Steps:**

1. **Start `parted`**:
   ```bash
   sudo parted /dev/sdb
   ```

2. **Set the unit to GB**:
   ```bash
   (parted) unit GB
   ```

3. **Create a new partition**:
   ```bash
   (parted) mkpart primary 5 8
   ```

4. **Exit `parted

`**:
   ```bash
   (parted) quit
   ```

#### **Example Output:**
```
(parted) mkpart primary 5 8
```

**Explanation:**
- **`mkpart primary 5 8`** creates a new primary partition from 5 GB to 8 GB on the disk.

---

### **6. Writing Changes and Refreshing the Partition Table**

After creating or deleting partitions, you may need to inform the kernel about changes to the partition table without rebooting.

#### **Example Task 8: Reload Partition Table Without Rebooting**

**Task:** Reload the partition table on `/dev/sda` without rebooting after making changes.

**Command:**
```bash
sudo partprobe /dev/sda
```

**Explanation:**
- **`partprobe`** tells the kernel to re-read the partition table, making the changes available immediately.

---

### Summary of Skills for RHCSA Exam on Managing Partitions:
1. **List partitions** using `fdisk`, `gdisk`, and `parted` on both MBR and GPT disks.
2. **Create and delete partitions** using `fdisk` for MBR and `gdisk` or `parted` for GPT.
3. **Understand primary, extended, and logical partitions** for MBR disks.
4. **Write partition changes to disk** and use `partprobe` to refresh the partition table without rebooting.
