## 03- Assign physical volumes to volume groups:

The RHCSA exam topic **"Assign physical volumes to volume groups"** is part of **Logical Volume Management (LVM)**, which is a powerful way to manage disk storage in Linux. A **Volume Group (VG)** is made up of one or more **Physical Volumes (PVs)**, and Logical Volumes (LVs) are created from the storage space provided by a VG. 


---

### **What You Need to Know:**
1. **Physical Volumes (PVs)**: Disks or partitions that are initialized for use in LVM.
2. **Volume Groups (VGs)**: A pool of storage that is created by combining one or more PVs.
3. **Assigning PVs to VGs** using the `vgcreate` and `vgextend` commands.
4. **Viewing Volume Groups** using `vgs` and `vgdisplay`.
5. **Removing a Physical Volume from a Volume Group** (optional, but useful for exam-level understanding).

---

### **1. Creating a Volume Group and Assigning Physical Volumes**

The **`vgcreate`** command is used to create a new **Volume Group (VG)** and assign one or more **Physical Volumes (PVs)** to it. Once a VG is created, Logical Volumes (LVs) can be created from it.

#### **Example Task 1: Create a Volume Group Using a Single Physical Volume**

**Task:** Create a new Volume Group named **`vg_data`** using the physical volume **`/dev/sdb`**.

**Command:**
```bash
sudo vgcreate vg_data /dev/sdb
```

#### **Example Output:**
```
  Volume group "vg_data" successfully created
```

**Explanation:**
- **`vgcreate vg_data /dev/sdb`** creates a new volume group named `vg_data` using the physical volume `/dev/sdb`.
- The space on `/dev/sdb` is now part of the volume group and can be used to create logical volumes.

---

#### **Example Task 2: Create a Volume Group with Multiple Physical Volumes**

**Task:** Create a new Volume Group named **`vg_storage`** by combining two physical volumes **`/dev/sdb`** and **`/dev/sdc`**.

**Command:**
```bash
sudo vgcreate vg_storage /dev/sdb /dev/sdc
```

#### **Example Output:**
```
  Volume group "vg_storage" successfully created
```

**Explanation:**
- This command combines the space from both **`/dev/sdb`** and **`/dev/sdc`** into the volume group **`vg_storage`**, providing a larger storage pool.

---

### **2. Adding Physical Volumes to an Existing Volume Group**

The **`vgextend`** command allows you to add additional physical volumes to an existing Volume Group. This is useful when you need to increase the storage capacity of a Volume Group without disrupting existing logical volumes.

#### **Example Task 3: Add a Physical Volume to an Existing Volume Group**

**Task:** Add the physical volume **`/dev/sdd`** to the existing Volume Group **`vg_data`**.

**Command:**
```bash
sudo vgextend vg_data /dev/sdd
```

#### **Example Output:**
```
  Volume group "vg_data" successfully extended
```

**Explanation:**
- **`vgextend`** adds the physical volume `/dev/sdd` to the **`vg_data`** Volume Group, increasing the total storage available for creating Logical Volumes.

---

### **3. Viewing Information About Volume Groups**

You can list and display detailed information about Volume Groups using commands like **`vgs`** and **`vgdisplay`**.

#### **Example Task 4: List All Volume Groups**

**Task:** Use `vgs` to list all the Volume Groups on the system.

**Command:**
```bash
sudo vgs
```

#### **Example Output:**
```
  VG        #PV #LV #SN Attr   VSize   VFree  
  vg_data     2   1   0 wz--n- 200.00g 50.00g
  vg_storage  2   0   0 wz--n- 300.00g 300.00g
```

**Explanation:**
- **`vgs`** shows a summary of the Volume Groups on the system, including the number of Physical Volumes (**#PV**), Logical Volumes (**#LV**), and the total and free size of each Volume Group (**VSize** and **VFree**).

---

#### **Example Task 5: Display Detailed Information About a Specific Volume Group**

**Task:** Use `vgdisplay` to show detailed information about the Volume Group **`vg_data`**.

**Command:**
```bash
sudo vgdisplay vg_data
```

#### **Example Output:**
```
  --- Volume group ---
  VG Name               vg_data
  System ID             
  Format                lvm2
  VG Size               200.00 GiB
  PE Size               4.00 MiB
  Total PE              51199
  Alloc PE / Size       38400 / 150.00 GiB
  Free  PE / Size       12799 / 50.00 GiB
  VG UUID               J3bF7h-4fzQ-x9FG-...
```

**Explanation:**
- **`vgdisplay`** provides detailed information about the Volume Group, including the total size, the number of Physical Extents (PE), and how much space is allocated or free.

---

### **4. Removing a Physical Volume from a Volume Group**

The **`vgreduce`** command is used to remove a physical volume from a Volume Group. This is useful when you want to reduce the size of a Volume Group or repurpose a disk.

#### **Example Task 6: Remove a Physical Volume from a Volume Group**

**Task:** Remove the physical volume **`/dev/sdd`** from the Volume Group **`vg_data`**.

**Command:**
```bash
sudo vgreduce vg_data /dev/sdd
```

#### **Example Output:**
```
  Removed "/dev/sdd" from volume group "vg_data"
```

**Explanation:**
- **`vgreduce`** removes the physical volume **`/dev/sdd`** from the **`vg_data`** Volume Group, reducing its storage capacity.

---

### **5. Checking Free Space in a Volume Group**

You can use the **`vgs`** or **`vgdisplay`** commands to check how much space is available in a Volume Group.

#### **Example Task 7: Check Free Space in a Volume Group**

**Task:** Check how much free space is available in the Volume Group **`vg_storage`**.

**Command:**
```bash
sudo vgs vg_storage
```

#### **Example Output:**
```
  VG         #PV #LV #SN Attr   VSize   VFree  
  vg_storage   2   0   0 wz--n- 300.00g 300.00g
```

**Explanation:**
- The **`VFree`** column shows that **300 GB** of free space is available in the **`vg_storage`** Volume Group.

---

### Summary of Skills for RHCSA Exam on Assigning Physical Volumes to Volume Groups:
1. **Create a Volume Group** using `vgcreate` and assign one or more physical volumes to it.
2. **Extend an existing Volume Group** by adding more physical volumes with `vgextend`.
3. **View Volume Groups** using `vgs` and `vgdisplay` to check the size, free space, and number of physical and logical volumes.
4. **Remove a physical volume** from a Volume Group using `vgreduce`.
