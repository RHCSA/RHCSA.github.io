## 06- Add new partitions and logical volumes, and swap to a system non-destructively:

The RHCSA exam topic **"Add new partitions and logical volumes, and swap to a system non-destructively"** focuses on safely adding new storage (partitions and logical volumes) and configuring swap space without losing data or interrupting the system's functionality. You must know how to create, extend, and manage partitions and logical volumes (LVM) on a running system, and add swap space dynamically.

---

### **What You Need to Know:**
1. **Adding new partitions** using tools like `fdisk` (for MBR) or `parted` (for GPT).
2. **Creating and extending logical volumes (LVM)** using `lvcreate`, `lvextend`, and `resize2fs` (or `xfs_growfs` for XFS).
3. **Creating and activating swap space** using a partition or logical volume.
4. **Modifying `/etc/fstab`** to mount new partitions and swap space persistently.
5. **Managing the system non-destructively**, meaning without losing existing data or affecting running services.

---

### **1. Adding a New Partition**

You can add a new partition to a system using **`fdisk`** for MBR or **`parted`** for GPT disks. After partitioning, you can format the partition and mount it.

#### **Example Task 1: Add a New Partition Using `fdisk`**

**Task:** Create a new partition of size **2 GB** on the disk **`/dev/sdb`** using `fdisk`.

**Steps:**

1. **Start `fdisk`**:
   ```bash
   sudo fdisk /dev/sdb
   ```

2. **Create a new partition**:
   - Press **`n`** to create a new partition.
   - Choose **primary** or **logical** (depending on the partition table and existing partitions).
   - Set the **first sector** (press Enter to use the default).
   - Enter **`+2G`** to create a 2 GB partition.

3. **Write changes to the disk**:
   - Press **`w`** to write the changes and exit.

4. **Format the partition**:
   ```bash
   sudo mkfs.ext4 /dev/sdb1
   ```

5. **Create a mount point** and mount the partition:
   ```bash
   sudo mkdir /mnt/newdata
   sudo mount /dev/sdb1 /mnt/newdata
   ```

6. **Add the partition to `/etc/fstab`** for automatic mounting at boot:
   ```bash
   sudo blkid /dev/sdb1  # Get the UUID of the new partition
   ```

   Add this line to `/etc/fstab`:
   ```
   UUID=<UUID_of_sdb1>  /mnt/newdata  ext4  defaults  0  2
   ```

7. **Test the `/etc/fstab` entry**:
   ```bash
   sudo mount -a
   ```

---

### **2. Creating a New Logical Volume**

Logical Volume Management (LVM) allows flexible partitioning. You can create logical volumes, format them, and mount them without rebooting.

#### **Example Task 2: Create a New Logical Volume**

**Task:** Create a new logical volume of size **3 GB** from the Volume Group **`vg_data`**, format it, and mount it at **`/mnt/storage`**.

**Steps:**

1. **Create the Logical Volume**:
   ```bash
   sudo lvcreate -L 3G -n lv_storage vg_data
   ```

2. **Format the Logical Volume**:
   ```bash
   sudo mkfs.ext4 /dev/vg_data/lv_storage
   ```

3. **Create a mount point** and mount the logical volume:
   ```bash
   sudo mkdir /mnt/storage
   sudo mount /dev/vg_data/lv_storage /mnt/storage
   ```

4. **Add the Logical Volume to `/etc/fstab`**:
   ```bash
   sudo blkid /dev/vg_data/lv_storage
   ```

   Add this line to `/etc/fstab`:
   ```
   UUID=<UUID_of_lv_storage>  /mnt/storage  ext4  defaults  0  2
   ```

5. **Test the `/etc/fstab` entry**:
   ```bash
   sudo mount -a
   ```

---

### **3. Extending an Existing Logical Volume Non-Destructively**

You can extend an existing logical volume (for example, if you need more space) without unmounting it, using `lvextend` and resizing the file system.

#### **Example Task 3: Extend an Existing Logical Volume by 2 GB**

**Task:** Extend the logical volume **`/dev/vg_data/lv_storage`** by **2 GB** and resize the file system without unmounting it.

**Steps:**

1. **Extend the Logical Volume**:
   ```bash
   sudo lvextend -L +2G /dev/vg_data/lv_storage
   ```

2. **Resize the file system**:
   - If it's an **ext4** file system:
     ```bash
     sudo resize2fs /dev/vg_data/lv_storage
     ```

   - If it's an **XFS** file system:
     ```bash
     sudo xfs_growfs /mnt/storage
     ```

3. **Verify the new size**:
   ```bash
   df -h /mnt/storage
   ```

**Explanation:**
- **`lvextend -L +2G`** increases the logical volume size by 2 GB.
- **`resize2fs`** or **`xfs_growfs`** resizes the file system to use the new space.

---

### **4. Adding Swap Space Non-Destructively**

You can add new swap space to the system using either a partition or a logical volume.

#### **Example Task 4: Add Swap Space Using a Logical Volume**

**Task:** Create a **1 GB** logical volume for swap in the Volume Group **`vg_data`**, activate it as swap, and make it persistent.

**Steps:**

1. **Create the Logical Volume for swap**:
   ```bash
   sudo lvcreate -L 1G -n lv_swap vg_data
   ```

2. **Format the Logical Volume as swap**:
   ```bash
   sudo mkswap /dev/vg_data/lv_swap
   ```

3. **Activate the swap**:
   ```bash
   sudo swapon /dev/vg_data/lv_swap
   ```

4. **Verify the new swap space**:
   ```bash
   sudo swapon --show
   ```

5. **Make the swap space persistent by adding it to `/etc/fstab`**:
   ```bash
   sudo blkid /dev/vg_data/lv_swap
   ```

   Add this line to `/etc/fstab`:
   ```
   UUID=<UUID_of_lv_swap>  none  swap  sw  0  0
   ```

6. **Test the `/etc/fstab` entry**:
   ```bash
   sudo swapoff -a
   sudo swapon -a
   ```

**Explanation:**
- **`lvcreate`** creates a logical volume for swap.
- **`mkswap`** prepares the logical volume for use as swap.
- **`swapon`** activates the swap immediately, and the `/etc/fstab` entry ensures it is activated at boot.

---

### **5. Adding Swap Space Using a Partition**

Alternatively, you can add swap space using a partition.

#### **Example Task 5: Add Swap Space Using a New Partition**

**Task:** Add a **2 GB** partition on **`/dev/sdb`** as swap space.

**Steps:**

1. **Create a new partition** of size 2 GB on **`/dev/sdb`** using `fdisk` or `parted` (as shown in **Task 1**).

2. **Format the partition as swap**:
   ```bash
   sudo mkswap /dev/sdb1
   ```

3. **Activate the swap**:
   ```bash
   sudo swapon /dev/sdb1
   ```

4. **Verify the swap space**:
   ```bash
   sudo swapon --show
   ```

5. **Add the swap space to `/etc/fstab`**:
   ```bash
   sudo blkid /dev/sdb1
   ```

   Add this line to `/etc/fstab`:
   ```
   UUID=<UUID_of_sdb1>  none  swap  sw  0  0
   ```

6. **Test the `/etc/fstab` entry**:
   ```bash
   sudo swapoff -a
   sudo swapon -a
   ```

---

### Summary of Skills for RHCSA Exam on Adding Partitions, Logical Volumes, and Swap:
1. **Create new partitions** and format them using `fdisk`, `parted`, or `mkfs`.
2. **Create and extend logical volumes** using `lvcreate` and `lvextend`, and resize the file system with `resize2fs` or `xfs_growfs`.
3. **Add and activate swap space** using a new partition or logical volume with `mkswap` and `swapon`.
4. **Update `/etc/fstab`** for persistent mounting and swap configuration.
5. **Test changes non-destructively** to ensure that everything works without rebooting the system.