## 02- Boot systems into different targets manually:

The RHCSA exam topic **"Boot systems into different targets manually"** focuses on your ability to control how a Linux system boots using **systemd targets**. In systemd-based systems (such as RHEL), **targets** are analogous to runlevels in older SysVinit systems, determining the operational state of the system (e.g., graphical mode, multi-user mode, or rescue mode).

Understanding how to boot into different targets is essential for troubleshooting, configuring boot behavior, and maintaining systems. This includes switching between targets in a running system, changing the default boot target, and booting into specific targets using the **GRUB bootloader**.


---

### **What You Need to Know:**
1. **Different systemd targets** and their purpose:
   - **multi-user.target**: Multi-user mode without a graphical interface (analogous to runlevel 3).
   - **graphical.target**: Multi-user mode with a graphical interface (analogous to runlevel 5).
   - **rescue.target**: Single-user mode for maintenance (analogous to runlevel 1).
   - **emergency.target**: Minimal environment, without mounting filesystems (for critical recovery).
2. **Switching targets** on a running system using `systemctl`.
3. **Changing the default boot target**.
4. **Booting into different targets via GRUB**.

---

### **1. Understanding systemd Targets**

In a systemd-based system, targets represent system states that define which services and processes are active. Each target is responsible for a different system configuration:

- **multi-user.target**: The system is running in full multi-user mode with networking but without a graphical interface. This is often used for servers.
- **graphical.target**: The system starts in graphical mode, with a desktop environment. This is typically the default for workstations.
- **rescue.target**: Boots into single-user mode with only the essential services running. It's used for maintenance or recovery.
- **emergency.target**: Provides a minimal shell without any services or mounts. It’s the lowest level of recovery, where even `/` may not be mounted.

---

### **2. Switching Between Targets on a Running System**

You can switch between targets on a running system using the `systemctl isolate` command. This command immediately switches the system to the specified target.

#### **Example Task 1: Switch to Multi-User Target (Non-Graphical Mode)**

**Task:** Switch the running system from the graphical target to the multi-user target.

**Command:**
```bash
sudo systemctl isolate multi-user.target
```

**Explanation:**
- **`systemctl isolate multi-user.target`** immediately switches the system to **multi-user mode**, which is equivalent to a system without a graphical interface (text-based login).

---

#### **Example Task 2: Switch to Graphical Target**

**Task:** Switch the system back to graphical mode from multi-user mode.

**Command:**
```bash
sudo systemctl isolate graphical.target
```

**Explanation:**
- **`systemctl isolate graphical.target`** switches the system back to **graphical mode**, starting the desktop environment (if installed).

---

### **3. Changing the Default Boot Target**

You can set the default boot target for the system using the `systemctl set-default` command. This determines which target the system boots into automatically after a restart.

#### **Example Task 3: Change the Default Boot Target to Multi-User Mode**

**Task:** Set the system to boot into **multi-user mode** by default (instead of graphical mode).

**Command:**
```bash
sudo systemctl set-default multi-user.target
```

**Explanation:**
- **`set-default multi-user.target`** sets multi-user mode (non-graphical) as the default boot target. The next time the system boots, it will not load a graphical environment.

#### **To Revert to Graphical Target (Default Mode for Workstations):**
```bash
sudo systemctl set-default graphical.target
```

**Explanation:**
- This command sets graphical mode as the default boot target.

---

### **4. Booting Into a Specific Target via GRUB**

In some cases, especially during troubleshooting, you may need to boot into a specific target (such as rescue or emergency mode) using the **GRUB** bootloader. This can be done by editing the boot parameters during startup.

#### **Example Task 4: Boot into Rescue Mode via GRUB**

**Task:** Reboot the system and boot into **rescue mode** using the GRUB bootloader.

**Steps:**
1. **Reboot the system**:
   ```bash
   sudo reboot
   ```

2. **Access the GRUB menu**: During the boot process, press **`Esc`** or **`Shift`** (depending on your system) to access the GRUB menu.

3. **Edit the boot parameters**:
   - Select the kernel you want to boot and press **`e`** to edit.
   - Find the line that begins with `linux` and append **`systemd.unit=rescue.target`** at the end of the line.
   - Press **`Ctrl + X`** or **`F10`** to boot with the modified parameters.

**Explanation:**
- Adding **`systemd.unit=rescue.target`** to the boot line tells the system to boot into **rescue mode**.
- **Rescue mode** provides single-user access and is useful for maintenance tasks like fixing configuration errors.

---

#### **Example Task 5: Boot into Emergency Mode via GRUB**

**Task:** Reboot into **emergency mode** using the GRUB bootloader.

**Steps:**
1. **Reboot the system**:
   ```bash
   sudo reboot
   ```

2. **Access the GRUB menu**: Press **`Esc`** or **`Shift`** to enter the GRUB menu.

3. **Edit the boot parameters**:
   - Select the kernel and press **`e`**.
   - On the line starting with `linux`, append **`systemd.unit=emergency.target`**.
   - Press **`Ctrl + X`** or **`F10`** to boot.

**Explanation:**
- **Emergency mode** is a minimal environment where even the root filesystem may not be mounted. It's used for critical recovery tasks, such as repairing corrupted filesystems or resetting the root password.

---

### **5. Temporary Boot Target via GRUB**

Sometimes you might need to boot into a specific target only once (e.g., for recovery or maintenance). You can specify a target through GRUB without changing the system’s default boot target.

#### **Example Task 6: Temporarily Boot into Multi-User Mode via GRUB**

**Task:** Temporarily boot into **multi-user mode** (text-based) using the GRUB bootloader without changing the default boot target.

**Steps:**
1. **Reboot the system**:
   ```bash
   sudo reboot
   ```

2. **Access the GRUB menu**: Press **`Esc`** or **`Shift`** to enter the GRUB menu.

3. **Edit the boot parameters**:
   - Select the kernel and press **`e`** to edit.
   - On the line starting with `linux`, append **`systemd.unit=multi-user.target`**.
   - Press **`Ctrl + X`** or **`F10`** to boot.

**Explanation:**
- This temporarily boots the system into **multi-user mode** (without graphical interface) without permanently changing the default target.

---

### **6. Viewing Active Target**

You may need to verify which target the system is currently using. This can be done using the `systemctl get-default` command.

#### **Example Task 7: View the Current Default Target**

**Task:** Display the current default boot target for the system.

**Command:**
```bash
systemctl get-default
```

**Explanation:**
- This command prints the default target the system will boot into (e.g., `multi-user.target` or `graphical.target`).

---

### **7. Reboot into Rescue or Emergency Mode Directly**

You can also reboot directly into **rescue** or **emergency mode** using `systemctl`.

#### **Example Task 8: Reboot Directly into Rescue Mode**

**Task:** Reboot the system into **rescue mode**.

**Command:**
```bash
sudo systemctl isolate rescue.target
```

**Explanation:**
- **`isolate rescue.target`** switches the system to **rescue mode** without the need for a full reboot.

#### **Example Task 9: Reboot Directly into Emergency Mode**

**Task:** Reboot the system into **emergency mode**.

**Command:**
```bash
sudo systemctl isolate emergency.target
```

**Explanation:**
- **`isolate emergency.target`** puts the system in **emergency mode**, a more basic recovery state than rescue mode.

---

### **Summary of Skills for RHCSA Exam on Booting into Different Targets:**
1. **Understand systemd targets** and their purpose (multi-user, graphical, rescue, emergency).
2. **Switch between targets** using `systemctl isolate`.
3. **Change the default boot target** using `systemctl set-default`.
4. **Boot into specific targets using GRUB**, such as rescue or emergency mode by editing the boot parameters.
5. **View the current default boot target** using `systemctl get-default`.
6. **Use emergency or rescue targets** for system recovery and maintenance.

