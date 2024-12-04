## 03- Configure systems to boot into a specific target automatically:

The RHCSA exam topic **"Configure systems to boot into a specific target automatically"** focuses on understanding **systemd targets** and how to configure a system to boot into a specific target (e.g., graphical mode, multi-user mode, etc.). Systemd targets are used to define the state the system should be in after boot, such as **graphical** mode (with a graphical user interface) or **multi-user** mode (without a graphical interface).



---

### **What You Need to Know:**
1. **Systemd targets**: These are similar to the old runlevels in SysVinit, and they define what services and units are activated when the system boots.
2. **Common systemd targets**:
   - **`graphical.target`**: Boots into a GUI (Graphical User Interface).
   - **`multi-user.target`**: Boots into multi-user mode without a GUI (similar to runlevel 3).
   - **`rescue.target`**: Boots into a rescue mode (single-user mode, minimal services).
   - **`emergency.target`**: Boots into an emergency shell with the most minimal environment.
3. **Changing the default target**: How to set the system to boot into a specific target by default.
4. **Temporarily switching between targets**: How to switch targets temporarily using `systemctl`.
5. **Ensuring persistence**: Any changes you make should be permanent and survive across reboots.

---

### **1. Viewing Current and Available Systemd Targets**

You can view the current target the system is in and list all available targets.

#### **Example Task 1: Check the Current Target**

**Task:** Display the current systemd target.

**Command:**
```bash
systemctl get-default
```

#### **Example Output:**
```
graphical.target
```

**Explanation**:
- **`systemctl get-default`** shows the target the system currently boots into by default.
- The output **`graphical.target`** means the system is set to boot into a graphical interface.

---

#### **Example Task 2: List All Available Targets**

**Task:** List all available systemd targets on the system.

**Command:**
```bash
systemctl list-units --type=target
```

#### **Example Output:**
```
UNIT                LOAD   ACTIVE SUB    DESCRIPTION
basic.target        loaded active active Basic System
graphical.target    loaded active active Graphical Interface
multi-user.target   loaded active active Multi-User System
...
```

**Explanation**:
- **`systemctl list-units --type=target`** lists all the systemd targets currently loaded on the system, showing which ones are active.

---

### **2. Changing the Default Target (Persistent)**

You can configure the system to automatically boot into a specific target by setting a new default target using **`systemctl set-default`**.

#### **Example Task 3: Set the System to Boot into Multi-User Mode by Default**

**Task:** Configure the system to boot into **`multi-user.target`** by default (non-graphical interface).

**Command:**
```bash
sudo systemctl set-default multi-user.target
```

#### **Example Output:**
```
Created symlink /etc/systemd/system/default.target → /lib/systemd/system/multi-user.target.
```

**Explanation**:
- **`systemctl set-default multi-user.target`** changes the default boot target to **`multi-user.target`**, which is similar to runlevel 3 in SysVinit. This configuration is persistent, meaning the system will boot into this target after every reboot.

---

#### **Example Task 4: Set the System to Boot into Graphical Mode by Default**

**Task:** Configure the system to boot into **`graphical.target`** by default (graphical interface).

**Command:**
```bash
sudo systemctl set-default graphical.target
```

#### **Example Output:**
```
Created symlink /etc/systemd/system/default.target → /lib/systemd/system/graphical.target.
```

**Explanation**:
- **`systemctl set-default graphical.target`** sets the system to boot into a graphical environment by default. This is useful if you want the system to boot into a desktop environment (like GNOME or KDE) on startup.

---

### **3. Switching Targets Temporarily (Without Rebooting)**

You can switch targets on a running system without rebooting. This is useful for troubleshooting or testing, and the change is **temporary**.

#### **Example Task 5: Switch to Multi-User Mode Temporarily**

**Task:** Switch the system to **multi-user mode** (non-graphical mode) without rebooting.

**Command:**
```bash
sudo systemctl isolate multi-user.target
```

**Explanation**:
- **`systemctl isolate multi-user.target`** switches the system to **multi-user mode**, which disables the graphical interface. This change is **temporary** and will last until the next reboot, unless you make it permanent with `set-default`.

---

#### **Example Task 6: Switch to Graphical Mode Temporarily**

**Task:** Switch the system to **graphical mode** (graphical interface) without rebooting.

**Command:**
```bash
sudo systemctl isolate graphical.target
```

**Explanation**:
- **`systemctl isolate graphical.target`** switches the system to **graphical mode**, bringing up the desktop environment if it is installed. This is useful for switching back to GUI mode after switching to multi-user mode temporarily.

---

### **4. Making Changes Persistent Across Reboots**

Once you have set the desired default target with **`systemctl set-default`**, the system will boot into that target automatically after every reboot.

#### **Example Task 7: Verify the Default Target**

**Task:** Verify that the system will boot into **multi-user mode** by default.

**Command:**
```bash
systemctl get-default
```

#### **Example Output:**
```
multi-user.target
```

**Explanation**:
- **`systemctl get-default`** verifies which target the system will boot into by default. If the output is **`multi-user.target`**, then the system will boot into multi-user mode after a reboot.

---

### **5. Common Troubleshooting**

- **Check the status of a target**: If switching to a target doesn’t work as expected, you can check the target’s status with `systemctl status <target>`.
  
- **Ensure necessary packages are installed**: For **`graphical.target`**, ensure that a desktop environment (e.g., GNOME) and the `X` server are installed, or else switching to `graphical.target` will fail.

- **Check logs for errors**: Use `journalctl -xe` to check for errors if you encounter problems when switching targets.

---

### Summary of Skills for RHCSA Exam on Configuring Boot Targets:
1. **Check the current target** using `systemctl get-default`.
2. **Set a default target** using `systemctl set-default` to persistently configure the system to boot into a specific target.
3. **Switch targets temporarily** using `systemctl isolate` without rebooting the system.
4. **Understand different systemd targets** like `multi-user.target`, `graphical.target`, `rescue.target`, etc.
5. **Verify target settings** using `systemctl list-units --type=target` and `systemctl get-default`.

