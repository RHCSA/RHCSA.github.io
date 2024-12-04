## 04- Extend existing logical volumes:

The RHCSA exam topic **"Extend existing logical volumes"** involves increasing the size of an existing **Logical Volume (LV)** to accommodate more data without data loss or downtime. This is a critical skill for managing storage dynamically using **Logical Volume Management (LVM)**.

---

### **What You Need to Know:**
1. **Logical Volumes (LVs)** are part of **Volume Groups (VGs)**, which consist of one or more **Physical Volumes (PVs)**.
2. **Extending a Logical Volume** increases its size, and after extending, the file system must be resized to utilize the newly allocated space.
3. **Tools used**: Commands such as `lvextend` to resize the logical volume and `resize2fs` (for `ext4`) or `xfs_growfs` (for `xfs`) to resize the file system.
4. **Resizing should be non-destructive**, meaning no data loss should occur during the extension process.
5. **Persistent changes**: The extension remains across reboots since logical volumes and file systems are persistent structures.

---

### **1. Verifying Free Space in the Volume Group**

Before extending a logical volume, you need to verify that there is enough free space in the **Volume Group (VG)** that the logical volume is part of. You can use the `vgs` or `vgdisplay` commands to check available free space.

#### **Example Task 1: Check Free Space in the Volume Group**

**Task:** Verify how much free space is available in the Volume Group **`vg_data`**.

**Command:**
```bash
sudo vgs vg_data
```

#### **Example Output:**
```
  VG      #PV  #LV  #SN  Attr   VSize   VFree
  vg_data   1    2    0  wz--n- 100.00g  20.00g
```

**Explanation**:
- **`VFree`** shows that there are 20 GB of free space available in the **`vg_data`** volume group, which can be used to extend logical volumes.

---

### **2. Extending the Logical Volume**

Once you’ve confirmed that the **Volume Group (VG)** has free space, you can extend the **Logical Volume (LV)** using the `lvextend` command.

#### **Example Task 2: Extend a Logical Volume by 5 GB**

**Task:** Extend the logical volume **`lv_data`** in the **`vg_data`** volume group by **5 GB**.

**Command:**
```bash
sudo lvextend -L +5G /dev/vg_data/lv_data
```

#### **Example Output:**
```
  Size of logical volume vg_data/lv_data changed from 15.00 GiB to 20.00 GiB.
  Logical volume lv_data successfully resized.
```

**Explanation**:
- **`-L +5G`**: Increases the size of the logical volume by **5 GB**.
- **`/dev/vg_data/lv_data`**: Specifies the logical volume to extend.
- This operation only increases the size of the logical volume. You still need to resize the file system.

---

### **3. Resizing the File System**

After extending the logical volume, you need to resize the file system so that it can use the additional space. The process depends on the file system type:

- **For `ext4`** file systems, use `resize2fs`.
- **For `xfs`** file systems, use `xfs_growfs`.

#### **Example Task 3: Resize an `ext4` File System**

**Task:** Resize the **`ext4`** file system on **`/dev/vg_data/lv_data`** to use the additional space.

**Command:**
```bash
sudo resize2fs /dev/vg_data/lv_data
```

#### **Example Output:**
```
resize2fs 1.45.6 (20-Mar-2020)
Filesystem at /dev/vg_data/lv_data is mounted on /mnt/data; on-line resizing required
The filesystem on /dev/vg_data/lv_data is now 5242880 (4k) blocks long.
```

**Explanation**:
- **`resize2fs`** resizes the file system to fill the newly expanded logical volume. This is done online, so there is no need to unmount the file system.

---

#### **Example Task 4: Resize an `xfs` File System**

**Task:** Resize the **`xfs`** file system on **`/dev/vg_data/lv_data`** to use the additional space.

**Command:**
```bash
sudo xfs_growfs /mnt/data
```

#### **Example Output:**
```
meta-data=/dev/mapper/vg_data-lv_data isize=512    agcount=4, agsize=65536 blks
data     =                       bsize=4096   blocks=5242880, imaxpct=25
```

**Explanation**:
- **`xfs_growfs`** resizes the **`xfs`** file system mounted on **`/mnt/data`** to utilize the extra space added to the logical volume. Note that for `xfs`, the file system must be mounted to resize it.

---

### **4. Verifying the Logical Volume and File System Size**

After resizing the logical volume and the file system, verify that both the logical volume and file system have been resized properly.

#### **Example Task 5: Verify the New Size of the Logical Volume**

**Task:** Verify that the logical volume **`lv_data`** has been extended to 20 GB.

**Command:**
```bash
sudo lvs /dev/vg_data/lv_data
```

#### **Example Output:**
```
  LV      VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv_data vg_data -wi-ao----  20.00g
```

**Explanation**:
- **`LSize`** confirms that the logical volume is now **20 GB**.

---

#### **Example Task 6: Verify the File System Size**

**Task:** Verify that the file system on **`/mnt/data`** has been resized to use the full logical volume size.

**Command:**
```bash
df -h /mnt/data
```

#### **Example Output:**
```
Filesystem                    Size  Used Avail Use% Mounted on
/dev/mapper/vg_data-lv_data     20G  2.0G   18G  10% /mnt/data
```

**Explanation**:
- **`Size`** shows that the file system is now 20 GB, matching the size of the logical volume.

---

### **5. Extending the Logical Volume Using All Free Space**

Sometimes, you may want to extend the logical volume to use all available free space in the Volume Group.

#### **Example Task 7: Extend the Logical Volume to Use All Free Space**

**Task:** Extend the logical volume **`lv_data`** to use all available free space in the Volume Group **`vg_data`**.

**Command:**
```bash
sudo lvextend -l +100%FREE /dev/vg_data/lv_data
```

#### **Example Output:**
```
  Size of logical volume vg_data/lv_data changed from 20.00 GiB to 40.00 GiB.
  Logical volume lv_data successfully resized.
```

**Explanation**:
- **`-l +100%FREE`**: Uses all the free space available in the Volume Group.
- **`/dev/vg_data/lv_data`**: Specifies the logical volume to extend.

After running this, resize the file system using `resize2fs` (for `ext4`) or `xfs_growfs` (for `xfs`) as demonstrated earlier.

---

### Summary of Skills for RHCSA Exam on Extending Logical Volumes:
1. **Check available free space** in the Volume Group using `vgs` or `vgdisplay`.
2. **Extend a logical volume** using `lvextend`, either by a specific size or using all available free space.
3. **Resize the file system** to utilize the newly allocated space using `resize2fs` (for `ext4`) or `xfs_growfs` (for `xfs`).
4. **Verify the changes** by checking the logical volume size with `lvs` and the file system size with `df -h`.
