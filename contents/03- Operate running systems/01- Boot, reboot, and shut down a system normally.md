## 01- Boot, reboot, and shut down a system normally:

The RHCSA exam topic **"Boot, reboot, and shut down a system normally"** is fundamental for system administration. This topic tests your ability to start, restart, and power off a system using standard Linux commands. You must know how to interact with **`systemctl`**, the **GRUB bootloader**, and handle tasks related to managing system services during the boot process.

---

### **What You Need to Know:**
1. **Rebooting and shutting down** using `systemctl` and `shutdown` commands.
2. **Understanding the GRUB bootloader** and accessing it during boot.
3. **Booting into different targets (runlevels)** such as multi-user and rescue modes.
4. **Viewing and configuring default boot targets** (multi-user, graphical).
5. **Rebooting into a specific target or kernel**.
6. Handling **forced reboots** or shutdowns for emergencies.

---

### **1. Reboot the System**

The **`systemctl`** command is used to manage the system's boot and shutdown processes in **systemd**-based Linux distributions like RHEL. You need to be comfortable using it to reboot the system.

#### **Example Task 1: Reboot the System Immediately**

**Task:** Reboot the system immediately using `systemctl`.

**Command:**
```bash
sudo systemctl reboot
```

**Explanation:**
- **`reboot`** instructs `systemctl` to reboot the system.
- **`sudo`** is required to execute the reboot as a privileged user.

---

### **2. Shut Down the System**

Similarly, you need to be able to power off the system safely.

#### **Example Task 2: Shut Down the System Immediately**

**Task:** Shut down the system immediately using `systemctl`.

**Command:**
```bash
sudo systemctl poweroff
```

**Explanation:**
- **`poweroff`** sends a signal to `systemctl` to shut down and power off the system.

---

### **3. Use the `shutdown` Command**

The `shutdown` command is another way to shut down or reboot the system with additional options such as scheduling the shutdown.

#### **Example Task 3: Schedule a System Shutdown in 5 Minutes**

**Task:** Schedule the system to shut down in 5 minutes.

**Command:**
```bash
sudo shutdown +5
```

**Explanation:**
- **`shutdown +5`** schedules a shutdown 5 minutes from the current time.
- **`sudo`** is needed to execute the shutdown with elevated privileges.
- To cancel a scheduled shutdown, use:
  ```bash
  sudo shutdown -c
  ```

---

### **4. Reboot into Rescue Mode**

Rescue mode (or emergency mode) is used for troubleshooting. In rescue mode, the system boots into a minimal environment, allowing you to troubleshoot system issues.

#### **Example Task 4: Reboot into Rescue Mode**

**Task:** Reboot the system into rescue mode.

**Command:**
```bash
sudo systemctl rescue
```

**Explanation:**
- **`systemctl rescue`** puts the system into rescue mode (similar to runlevel 1 in older systems).
- This mode provides single-user access with minimal services running, useful for recovery tasks.

---

### **5. Reboot into a Specific Target**

In systemd-based systems, **targets** are similar to runlevels. You need to know how to reboot into different targets, such as **multi-user.target** (similar to runlevel 3) or **graphical.target** (similar to runlevel 5).

#### **Example Task 5: Reboot into Multi-User Target**

**Task:** Reboot into the multi-user target (non-graphical).

**Command:**
```bash
sudo systemctl isolate multi-user.target
```

**Explanation:**
- **`isolate multi-user.target`** switches the system to multi-user mode without a graphical interface.
- This is useful for managing servers or systems where you don't need a GUI.

---

### **6. Change the Default Boot Target**

The default boot target determines what state the system boots into (e.g., graphical or multi-user mode). You may be asked to change the default target.

#### **Example Task 6: Change the Default Boot Target to Multi-User Mode**

**Task:** Set the system to boot into the multi-user target by default.

**Command:**
```bash
sudo systemctl set-default multi-user.target
```

**Explanation:**
- **`set-default multi-user.target`** changes the system's default boot target to multi-user mode (text-based, non-graphical).
- After reboot, the system will start in multi-user mode.

#### **Revert to Graphical Mode:**
```bash
sudo systemctl set-default graphical.target
```

---

### **7. Access the GRUB Bootloader**

The **GRUB bootloader** allows you to select different kernels or boot into recovery mode. You need to know how to access and interact with GRUB during system boot.

#### **Example Task 7: Boot into a Specific Kernel from GRUB**

**Task:** Reboot the system and choose an older kernel version from the GRUB menu.

**Steps:**
1. **Reboot the system:**
   ```bash
   sudo reboot
   ```

2. When the system starts, press **`Esc`** or **`Shift`** (depending on your system) to access the **GRUB menu**.
3. Use the arrow keys to select an older kernel version and press **`Enter`**.

**Explanation:**
- The GRUB menu allows you to select a different kernel to boot from, which is useful if the current kernel has issues.

---

### **8. Handle Forced Reboots**

In some situations, you may need to force a reboot or shutdown, especially if the system becomes unresponsive.

#### **Example Task 8: Force a System Reboot**

**Task:** Force a reboot of the system using the `reboot` command with the `--force` option.

**Command:**
```bash
sudo reboot --force
```

**Explanation:**
- **`--force`** forces the system to reboot immediately without properly shutting down services. This should be used cautiously as it can lead to data loss or corruption.

---

### **9. View the System's Boot Logs**

You may need to review boot logs to troubleshoot issues or verify system startup processes.

#### **Example Task 9: View Boot Logs Using `journalctl`**

**Task:** View the boot log of the system using `journalctl`.

**Command:**
```bash
sudo journalctl -b
```

**Explanation:**
- **`-b`** shows the journal logs for the current boot session. You can also use `-b -1` for the previous boot logs.
- This is helpful for diagnosing boot-related issues or understanding the system's startup process.

---

### **10. Boot into Single-User Mode via GRUB**

Single-user mode is another form of rescue mode, which can be accessed via the GRUB menu for recovery tasks such as resetting passwords.

#### **Example Task 10: Boot into Single-User Mode via GRUB**

**Task:** Reboot the system into single-user mode using GRUB.

**Steps:**
1. Reboot the system:
   ```bash
   sudo reboot
   ```

2. Press **`Esc`** or **`Shift`** during boot to access the GRUB menu.

3. Select the kernel you want to boot and press **`e`** to edit the boot parameters.

4. Find the line that starts with `linux` and add **`single`** or **`rescue`** at the end of that line.

5. Press **`Ctrl + X`** or **`F10`** to boot.

**Explanation:**
- Booting into single-user mode gives you root access with minimal services running, which is useful for system recovery.

---

### Summary of Skills for RHCSA Exam on Booting, Rebooting, and Shutting Down:
1. **Reboot and shut down** the system using `systemctl` and `shutdown`.
2. **Reboot into rescue mode** or **multi-user mode** using `systemctl` or GRUB.
3. **Change the default boot target** (e.g., multi-user or graphical) using `systemctl set-default`.
4. **Access and use the GRUB bootloader** to boot into different kernels or modes.
5. **Force a reboot or shutdown** in emergencies.
6. **View boot logs** using `journalctl` for troubleshooting.
