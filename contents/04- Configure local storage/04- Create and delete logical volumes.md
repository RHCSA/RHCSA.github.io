## 04- Create and delete logical volumes:

The RHCSA exam topic **"Create and delete logical volumes"** involves managing **Logical Volumes (LVs)**, a key component of **Logical Volume Management (LVM)**. Logical volumes allow you to create flexible and resizable disk storage, which can be easily managed across multiple physical disks.

---

### **What You Need to Know:**
1. **Logical Volumes (LVs)** are created from **Volume Groups (VGs)**, which are made up of **Physical Volumes (PVs)**.
2. **Creating Logical Volumes** using the `lvcreate` command.
3. **Deleting Logical Volumes** using the `lvremove` command.
4. **Viewing Logical Volumes** using `lvs` and `lvdisplay`.
5. **Understanding size, path, and name** conventions for LVs and VGs.
6. **Resizing Logical Volumes** (optional but useful in managing LVM).

---

### **1. Creating a Logical Volume Using `lvcreate`**

The **`lvcreate`** command is used to create a Logical Volume from an existing **Volume Group (VG)**. Once the Logical Volume is created, it can be formatted with a file system and mounted.

#### **Example Task 1: Create a 5 GB Logical Volume**

**Task:** Create a Logical Volume named **`lv_data`** of size **5 GB** from the Volume Group **`vg_storage`**.

**Command:**
```bash
sudo lvcreate -L 5G -n lv_data vg_storage
```

#### **Example Output:**
```
  Logical volume "lv_data" created.
```

**Explanation:**
- **`-L 5G`** specifies the size of the logical volume (5 GB).
- **`-n lv_data`** sets the name of the logical volume to **`lv_data`**.
- **`vg_storage`** is the Volume Group from which the Logical Volume is created.

After creating the Logical Volume, you can format it with a file system and mount it.

---

### **2. Viewing Logical Volumes Using `lvs` and `lvdisplay`**

You can use **`lvs`** and **`lvdisplay`** to view information about existing Logical Volumes.

#### **Example Task 2: List All Logical Volumes**

**Task:** List all Logical Volumes on the system using `lvs`.

**Command:**
```bash
sudo lvs
```

#### **Example Output:**
```
  LV      VG         Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv_data vg_storage -wi-a-----   5.00g
```

**Explanation:**
- **`lvs`** shows a summary of all Logical Volumes, including the size (**LSize**) and their Volume Group (**VG**).

---

#### **Example Task 3: Display Detailed Information About a Logical Volume**

**Task:** Display detailed information about the Logical Volume **`lv_data`** using `lvdisplay`.

**Command:**
```bash
sudo lvdisplay /dev/vg_storage/lv_data
```

#### **Example Output:**
```
  --- Logical volume ---
  LV Path                /dev/vg_storage/lv_data
  LV Name                lv_data
  VG Name                vg_storage
  LV UUID                5sXL-KeWk-bjjQ-...
  LV Size                5.00 GiB
  LV Status              available
  # open                 0
```

**Explanation:**
- **`lvdisplay`** provides detailed information about a specific Logical Volume, including its **path** (`/dev/vg_storage/lv_data`), size, and status.

---

### **3. Formatting and Mounting the Logical Volume**

After creating a Logical Volume, you need to format it with a file system and mount it for use.

#### **Example Task 4: Format and Mount the Logical Volume**

**Task:** Format the Logical Volume **`lv_data`** with the **ext4** file system and mount it at **`/mnt/data`**.

**Commands:**

1. **Format the Logical Volume**:
   ```bash
   sudo mkfs.ext4 /dev/vg_storage/lv_data
   ```

2. **Create a mount point**:
   ```bash
   sudo mkdir /mnt/data
   ```

3. **Mount the Logical Volume**:
   ```bash
   sudo mount /dev/vg_storage/lv_data /mnt/data
   ```

4. **Verify the mount**:
   ```bash
   df -h /mnt/data
   ```

**Explanation:**
- **`mkfs.ext4`** formats the Logical Volume with the **ext4** file system.
- **`mount`** mounts the Logical Volume to the directory `/mnt/data`.

---

### **4. Deleting a Logical Volume Using `lvremove`**

The **`lvremove`** command is used to delete a Logical Volume. Before removing it, you need to unmount the Logical Volume if it is currently mounted.

#### **Example Task 5: Delete a Logical Volume**

**Task:** Unmount and delete the Logical Volume **`lv_data`**.

**Steps:**

1. **Unmount the Logical Volume**:
   ```bash
   sudo umount /mnt/data
   ```

2. **Remove the Logical Volume**:
   ```bash
   sudo lvremove /dev/vg_storage/lv_data
   ```

#### **Example Output:**
```
  Do you really want to remove active logical volume lv_data? [y/n]: y
  Logical volume "lv_data" successfully removed
```

**Explanation:**
- **`umount`** unmounts the Logical Volume, making it safe to delete.
- **`lvremove`** deletes the Logical Volume **`lv_data`** from the Volume Group **`vg_storage`**.

---

### **5. Extending an Existing Logical Volume (Optional)**

You can extend an existing Logical Volume if more space is required.

#### **Example Task 6: Extend a Logical Volume by 2 GB**

**Task:** Increase the size of the Logical Volume **`lv_data`** by **2 GB**.

**Command:**
```bash
sudo lvextend -L +2G /dev/vg_storage/lv_data
```

#### **Example Output:**
```
  Size of logical volume vg_storage/lv_data changed from 5.00 GiB to 7.00 GiB
  Logical volume lv_data successfully resized.
```

**Explanation:**
- **`lvextend -L +2G`** increases the size of the Logical Volume **`lv_data`** by 2 GB, making its new size **7 GB**.
- After extending the Logical Volume, you may also need to resize the file system (for example, with `resize2fs` for ext4).

---

### **6. Removing a Logical Volume Group (Optional)**

In some cases, you might want to delete an entire Volume Group along with all its Logical Volumes. This would involve using `vgremove`.

#### **Example Task 7: Remove a Volume Group and Its Logical Volumes**

**Task:** Remove the Volume Group **`vg_storage`** and its associated Logical Volumes.

**Steps:**

1. **Remove all Logical Volumes** within the Volume Group:
   ```bash
   sudo lvremove /dev/vg_storage/lv_data
   ```

2. **Remove the Volume Group**:
   ```bash
   sudo vgremove vg_storage
   ```

#### **Example Output:**
```
  Volume group "vg_storage" successfully removed
```

---

### Summary of Skills for RHCSA Exam on Creating and Deleting Logical Volumes:
1. **Create Logical Volumes** using `lvcreate` from a Volume Group.
2. **List and view Logical Volumes** using `lvs` and `lvdisplay`.
3. **Delete Logical Volumes** using `lvremove` after unmounting them.
4. (Optional) **Extend Logical Volumes** using `lvextend` to increase their size.
5. **Format and mount Logical Volumes** to make them usable for file storage.
