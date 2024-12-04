## 03- Interrupt the boot process in order to gain access to a system:

The RHCSA exam topic **"Interrupt the boot process in order to gain access to a system"** is crucial for situations where you need to recover a system, reset forgotten passwords, or fix critical boot issues. You need to understand how to interrupt the boot process using the **GRUB bootloader** to gain privileged access (often root access) without requiring the system’s normal authentication process.

This knowledge is essential for troubleshooting and recovering systems that cannot be accessed normally.

---

### **What You Need to Know:**
1. **Access the GRUB menu**: You need to be able to interrupt the normal boot process to access the GRUB menu.
2. **Edit boot parameters**: Modify kernel boot parameters temporarily in GRUB to boot into single-user mode, emergency mode, or modify the root password.
3. **Boot into emergency or rescue modes**: Use these modes to gain privileged access for system recovery tasks.
4. **Reset the root password**: This is one of the most common reasons to interrupt the boot process.


---

### **1. Reset the Root Password by Interrupting the Boot Process**

One of the most common uses for interrupting the boot process is to **reset a forgotten root password**.

#### **Example Task 4: Reset the Root Password Using GRUB**

**Task:** Reboot the system and reset the root password by interrupting the boot process.

**Steps:**

1. **Reboot the system** and access the GRUB menu.

2. **Select the kernel** to boot from and press **`e`** to edit the boot parameters.

3. **Find the `linux` or `linux16` line** and append **`rd.break`** at the end of the line. This instructs the system to break at the **initramfs** stage before mounting the root filesystem.

4. **Press `Ctrl + X`** or **`F10`** to boot.

5. Once you are dropped into the **initramfs prompt**:
   - **Remount the root filesystem in read-write mode**:
     ```bash
     mount -o remount,rw /sysroot
     ```

   - **Change root into the mounted filesystem**:
     ```bash
     chroot /sysroot
     ```

   - **Reset the root password** using the `passwd` command:
     ```bash
     passwd
     ```

   - **Relabel the SELinux context** on next boot (important for SELinux-enabled systems):
     ```bash
     touch /.autorelabel
     ```

6. **Exit the chroot environment** and reboot:
   ```bash
   exit
   exit
   ```

**Explanation:**
- **`rd.break`** causes the system to stop before mounting the root filesystem, allowing you to access the system and change the root password without normal authentication.
- **`chroot /sysroot`** changes the root directory to the mounted filesystem, allowing you to execute commands like `passwd` to reset the password.
- **`touch /.autorelabel`** forces an SELinux relabeling on reboot, which ensures the system boots properly under SELinux policies.

---

### **5. Using `rd.break` to Access Root Filesystem**

The **`rd.break`** kernel parameter is a powerful tool that allows you to stop the boot process early, before the root filesystem is mounted. This is useful not only for resetting passwords but for making system repairs in an environment where the system is mostly unmounted.

#### **Example Task 5: Interrupt the Boot and Access the Root Filesystem with `rd.break`**

**Task:** Use `rd.break` to drop into a shell and access the root filesystem in read-write mode.

**Steps:**

1. **Reboot the system** and access the GRUB menu.

2. **Edit the boot parameters** by pressing **`e`** on the selected kernel.

3. **Append** `rd.break` to the end of the `linux` line.

4. **Press `Ctrl + X`** or **`F10`** to boot.

5. At the **initramfs prompt**, remount the root filesystem as read-write:
   ```bash
   mount -o remount,rw /sysroot
   ```

6. **Chroot** into the root filesystem:
   ```bash
   chroot /sysroot
   ```

7. Perform the required tasks (e.g., resetting passwords, editing configuration files), and then reboot:
   ```bash
   exit
   exit
   ```

---

### **2. GRUB Recovery Mode**

Some systems may offer a **recovery mode** entry in the GRUB menu by default. This mode can be used to perform system recovery tasks without needing to manually edit GRUB boot parameters.

#### **Example Task 6: Boot into GRUB Recovery Mode**

**Task:** Use the GRUB menu to boot into **recovery mode**.

**Steps:**

1. **Reboot the system** and press **`Esc`** or **`Shift`** to access the GRUB menu.

2. **Select the "Recovery Mode"** entry from the GRUB menu (if available).

3. The system will boot into a limited environment with root access.

**Explanation:**
- Some GRUB configurations provide a built-in **recovery mode** that can be used for troubleshooting and maintenance without manually modifying boot parameters.

---

### Summary of Skills for RHCSA Exam on Interrupting the Boot Process:
1. **Access the GRUB menu** to interrupt the boot process.
2. **Modify GRUB boot parameters** to boot into rescue, emergency, or single-user modes.
3. **Use `rd.break`** to gain access to the root filesystem for password recovery or system repair.
4. **Reset the root password** by interrupting the boot process and using a chroot environment.
5. **Boot into recovery or rescue modes** using GRUB for system troubleshooting.
6. Understand how to remount the root filesystem in **read-write mode** for system modifications.

