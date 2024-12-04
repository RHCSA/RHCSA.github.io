## 04- Set enforcing and permissive modes for SELinux:

### **RHCSA Exam Topic: Set Enforcing and Permissive Modes for SELinux**

On the RHCSA exam, understanding **SELinux (Security-Enhanced Linux)** is crucial, especially in terms of configuring its modes. SELinux is a security architecture integrated into the Linux kernel that provides mandatory access control (MAC).

---

### **1. SELinux Modes Overview**

SELinux can operate in three modes:

- **Enforcing mode**: SELinux enforces its security policy, blocking unauthorized access attempts.
- **Permissive mode**: SELinux allows all access but logs violations, useful for troubleshooting.
- **Disabled mode**: SELinux is turned off (though you rarely need this for RHCSA).

For the RHCSA exam, you’ll focus on **Enforcing** and **Permissive** modes.

---

### **2. Check Current SELinux Mode**

To check the current SELinux mode:

```bash
sestatus
```

#### **Output Example:**
```bash
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
```

---

### **3. Set SELinux Mode Temporarily**

To change the SELinux mode temporarily (until the next reboot), use the `setenforce` command.

#### **Switch SELinux to Enforcing Mode**:
```bash
sudo setenforce 1
```

#### **Switch SELinux to Permissive Mode**:
```bash
sudo setenforce 0
```

These commands take effect immediately but will revert to the default mode after a reboot.

---

### **4. Set SELinux Mode Permanently**

To permanently configure SELinux to be in either **enforcing** or **permissive** mode (persistent across reboots), you need to modify the **SELinux configuration file**.

1. **Open the SELinux configuration file**:
   ```bash
   sudo vi /etc/selinux/config
   ```

2. **Modify the `SELINUX` directive** to either `enforcing` or `permissive`:
   ```bash
   # This file controls the state of SELinux on the system.
   # SELINUX= can take one of these three values:
   #       enforcing - SELinux security policy is enforced.
   #       permissive - SELinux prints warnings instead of enforcing.
   #       disabled - No SELinux policy is loaded.
   SELINUX=enforcing
   ```

3. **Save and exit** the editor.

4. **Reboot the system** for the changes to take effect:
   ```bash
   sudo reboot
   ```

#### **Note:**
- The setting in the configuration file ensures the SELinux mode remains consistent after reboots.

---

### **5. Verify the Mode After Reboot**

After rebooting, verify that SELinux is in the desired mode:

```bash
sestatus
```

Ensure that the **Current mode** matches the value you set in the configuration file.

---

### **6. Example RHCSA-Style Questions and Answers**

Here are example questions that could appear on the RHCSA exam regarding SELinux.

#### **Question 1: Check the Current SELinux Mode**

**Task:** Verify the current SELinux mode on your system.

**Answer:**

```bash
sestatus
```

#### **Expected Output**:
You should see details about the SELinux status, including whether it’s in **enforcing** or **permissive** mode.

---

#### **Question 2: Temporarily Set SELinux to Permissive Mode**

**Task:** Set the SELinux mode to **permissive** temporarily (without rebooting).

**Answer:**

```bash
sudo setenforce 0
```

---

#### **Question 3: Set SELinux to Enforcing Mode Permanently**

**Task:** Configure SELinux to operate in **enforcing** mode persistently, even after a reboot.

**Answer:**

1. Edit the SELinux configuration file:
   ```bash
   sudo vi /etc/selinux/config
   ```

2. Set the `SELINUX` directive to `enforcing`:
   ```bash
   SELINUX=enforcing
   ```

3. Reboot the system:
   ```bash
   sudo reboot
   ```

4. Verify the change:
   ```bash
   sestatus
   ```

---

### **7. Make the Changes Persistent**

To ensure SELinux remains in the desired mode after a reboot, modifying the **`/etc/selinux/config`** file is critical, as this file determines the SELinux mode at boot.

- **Temporary mode changes** using `setenforce` only last until the system is rebooted.
- **Permanent mode changes** require editing the **SELinux configuration file** and rebooting.

---

### **8. Additional Considerations**

- **Troubleshooting with Permissive Mode**: 
  - When an application isn't working as expected due to SELinux, switching to **permissive** mode can help identify the issue without blocking access. SELinux logs all violations in **`/var/log/audit/audit.log`**.
  
- **Switching Back to Enforcing Mode**:
  - After troubleshooting in **permissive** mode, always remember to switch back to **enforcing** mode to maintain security.

---

### **Summary of RHCSA Skills for SELinux Mode Configuration**

1. **Check SELinux Status**: Use `sestatus` to check the current SELinux mode.
2. **Set SELinux Mode Temporarily**: Use `setenforce 1` or `setenforce 0` to temporarily change the SELinux mode.
3. **Set SELinux Mode Permanently**: Modify the `/etc/selinux/config` file to configure SELinux mode persistently.
4. **Reboot**: To apply permanent SELinux mode changes, a system reboot is required.
