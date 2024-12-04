## 02- Create and remove physical volumes:

The RHCSA exam topic **"Create and remove physical volumes"** focuses on managing **Physical Volumes (PVs)** in **Logical Volume Management (LVM)**. Understanding LVM is essential for managing disk storage in a flexible way. A **Physical Volume** is the first step in LVM, where raw disk space is initialized for use by the LVM system. You can then create **Volume Groups (VGs)** and **Logical Volumes (LVs)** on top of physical volumes.

---

### **What You Need to Know:**
1. **Physical Volumes (PVs)** are the raw partitions or disks that are initialized for use by LVM.
2. **Creating a Physical Volume (PV)** using `pvcreate`.
3. **Viewing Physical Volumes** using `pvs` or `pvdisplay`.
4. **Removing a Physical Volume** using `pvremove`.
5. **Understanding device paths** (`/dev/sda`, `/dev/sdb`, etc.) for physical volumes.
6. Physical volumes can be **entire disks** or **partitions** of a disk.

---

### **1. Creating a Physical Volume Using `pvcreate`**

The **`pvcreate`** command initializes a disk or partition as a physical volume for LVM. Once the disk is initialized as a PV, it can be used to create **Volume Groups (VGs)** and **Logical Volumes (LVs)**.

#### **Example Task 1: Create a Physical Volume on a New Disk**

**Task:** Initialize the disk **`/dev/sdb`** as a physical volume for LVM.

**Command:**
```bash
sudo pvcreate /dev/sdb
```

#### **Example Output:**
```
  Physical volume "/dev/sdb" successfully created.
```

**Explanation:**
- **`pvcreate /dev/sdb`** initializes the disk `/dev/sdb` as a physical volume, making it ready for use by LVM.

---

#### **Example Task 2: Create a Physical Volume on a Partition**

**Task:** Create a physical volume on the partition **`/dev/sda3`**.

**Command:**
```bash
sudo pvcreate /dev/sda3
```

#### **Example Output:**
```
  Physical volume "/dev/sda3" successfully created.
```

**Explanation:**
- You can create a physical volume on a specific partition, like **`/dev/sda3`**, rather than on an entire disk. This is useful when you want to dedicate part of a disk to LVM and use the rest for other purposes.

---

### **2. Viewing Physical Volumes**

After creating a PV, you can list and view its details using the `pvs`, `pvdisplay`, and `pvscan` commands.

#### **Example Task 3: List All Physical Volumes**

**Task:** List all physical volumes on the system.

**Command:**
```bash
sudo pvs
```

#### **Example Output:**
```
  PV         VG       Fmt  Attr PSize   PFree
  /dev/sdb   vg_data  lvm2 a--  100.00g 100.00g
```

**Explanation:**
- **`pvs`** shows a summary of all physical volumes, including the **Volume Group** they are part of, their size, and available space.

---

#### **Example Task 4: View Detailed Information About a Physical Volume**

**Task:** Display detailed information about the physical volume on **`/dev/sdb`**.

**Command:**
```bash
sudo pvdisplay /dev/sdb
```

#### **Example Output:**
```
  --- Physical volume ---
  PV Name               /dev/sdb
  VG Name               vg_data
  PV Size               100.00 GiB
  Allocatable           yes
  PE Size (KByte)       4.00 MiB
  Total PE              25599
  Free PE               25599
  Allocated PE          0
  PV UUID               QRBhft-CypL-XYZ...
```

**Explanation:**
- **`pvdisplay`** provides detailed information about a specific physical volume, including its size, UUID, and the number of physical extents (PEs).

---

### **3. Removing a Physical Volume Using `pvremove`**

You can use **`pvremove`** to remove a physical volume, but it must first be **removed from any Volume Groups (VGs)** before it can be deleted.

#### **Example Task 5: Remove a Physical Volume**

**Task:** Remove the physical volume on **`/dev/sdb`** after ensuring it is no longer in use by any Volume Group.

**Steps:**

1. **Check the Volume Group**: Ensure the PV is not part of any Volume Group using `vgs`.
   ```bash
   sudo vgs
   ```

2. **Remove the Physical Volume**:
   ```bash
   sudo pvremove /dev/sdb
   ```

#### **Example Output:**
```
  Labels on physical volume "/dev/sdb" successfully wiped.
```

**Explanation:**
- **`pvremove /dev/sdb`** wipes the LVM metadata from the physical volume, effectively removing it from LVM. The disk can then be reused for other purposes.

---

### **4. Reusing a Disk After Removing a Physical Volume**

After removing a PV, the disk or partition is no longer under LVM control and can be used for other purposes, like creating new file systems or partitioning for different uses.

#### **Example Task 6: Reuse a Disk After Removing the Physical Volume**

**Task:** Reformat the disk **`/dev/sdb`** after it has been removed as a physical volume.

**Command:**
```bash
sudo mkfs.ext4 /dev/sdb
```

**Explanation:**
- After running `pvremove`, you can reuse the disk for other purposes, such as formatting it with a standard filesystem like **ext4**.

---

### **5. Handling Multiple Physical Volumes**

LVM allows you to combine multiple physical volumes into a single **Volume Group**. This is useful for creating large, flexible storage pools.

#### **Example Task 7: Create Multiple Physical Volumes**

**Task:** Initialize both **`/dev/sdb`** and **`/dev/sdc`** as physical volumes.

**Command:**
```bash
sudo pvcreate /dev/sdb /dev/sdc
```

#### **Example Output:**
```
  Physical volume "/dev/sdb" successfully created.
  Physical volume "/dev/sdc" successfully created.
```

**Explanation:**
- **`pvcreate`** can initialize multiple disks or partitions as physical volumes in a single command.

---

### **Summary of Skills for RHCSA Exam on Creating and Removing Physical Volumes:**
1. **Create physical volumes** using `pvcreate` on disks or partitions.
2. **List and view physical volumes** using `pvs` and `pvdisplay`.
3. **Remove physical volumes** using `pvremove` after ensuring they are not part of any Volume Group.
4. Understand how to initialize multiple disks as physical volumes and manage them under LVM.
