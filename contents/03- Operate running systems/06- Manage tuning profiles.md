## 06- Manage tuning profiles:

The RHCSA exam topic **"Manage tuning profiles"** involves the use of the **`tuned`** service to optimize system performance for different workloads. **`tuned`** is a daemon that dynamically adapts the system settings based on the active profile, which can be optimized for tasks such as power saving, throughput, or latency.


---

### **What You Need to Know:**
1. **Understand `tuned` and its purpose**: `tuned` is a service that adjusts system performance based on predefined or custom profiles.
2. **Viewing and switching tuning profiles** using `tuned-adm`.
3. **Verifying the active profile** and checking the system status.
4. **Common tuning profiles** and their use cases (e.g., `balanced`, `latency-performance`, `throughput-performance`).
5. **Creating and applying custom tuning profiles**.

---

### **1. Understanding Tuning Profiles**

The **`tuned`** daemon adjusts system settings based on active profiles. These profiles optimize the system for different workloads, such as:
- **Power saving** (reduce energy consumption),
- **Performance** (maximize performance for CPU, disk, and network),
- **Low-latency** (optimize for quick response times, useful for real-time applications).

---

### **2. Viewing Available Tuning Profiles**

The **`tuned-adm`** command is used to manage tuning profiles. You can view the available profiles on your system using this tool.

#### **Example Task 1: List Available Tuning Profiles**

**Task:** List all available tuning profiles on your system.

**Command:**
```bash
sudo tuned-adm list
```

#### **Example Output:**
```
Available profiles:
- balanced
- throughput-performance
- latency-performance
- virtual-guest
- virtual-host
- powersave
Current active profile: balanced
```

**Explanation:**
- This lists all the available tuning profiles and shows the **current active profile**.
- In this example, the `balanced` profile is currently active, which provides a general balance between performance and power saving.

---

### **3. Switching to a Different Tuning Profile**

You can switch the system's active tuning profile to better match the current workload. For example, you might switch to the **`throughput-performance`** profile to optimize for higher network or disk throughput, or to **`latency-performance`** to optimize for low-latency tasks.

#### **Example Task 2: Set the System to Use the `throughput-performance` Profile**

**Task:** Switch the active profile to **`throughput-performance`** to optimize for high throughput.

**Command:**
```bash
sudo tuned-adm profile throughput-performance
```

**Explanation:**
- **`tuned-adm profile throughput-performance`** switches the active profile to **`throughput-performance`**, which is optimized for network and disk throughput (e.g., useful for database servers or file servers).

---

#### **Example Task 3: Verify the Active Tuning Profile**

**Task:** Verify the active tuning profile on the system after switching profiles.

**Command:**
```bash
sudo tuned-adm active
```

#### **Example Output:**
```
Current active profile: throughput-performance
```

**Explanation:**
- This command confirms the active tuning profile. In this case, it confirms that the **`throughput-performance`** profile is active.

---

### **4. Common Tuning Profiles and Their Use Cases**

Here are some of the most commonly used tuning profiles and their purposes:

- **`balanced`**: Default profile providing a balance between performance and power saving.
- **`latency-performance`**: Optimized for low-latency, minimizing response times (useful for real-time applications).
- **`throughput-performance`**: Optimized for maximum throughput, useful for servers with high disk and network I/O.
- **`powersave`**: Focused on minimizing energy usage.
- **`virtual-guest`**: Optimized for running in virtual environments (e.g., virtual machines).
- **`virtual-host`**: Optimized for systems running virtual machine hosts (like KVM or VMware hosts).

---

### **5. Creating and Applying Custom Tuning Profiles**

If none of the pre-configured profiles fit your exact needs, you can create a custom tuning profile by modifying or combining the parameters from existing profiles.

#### **Example Task 4: Create a Custom Tuning Profile**

**Task:** Create a custom tuning profile called `my-custom-profile` that starts with the settings from the `balanced` profile but adjusts the CPU governor to `performance`.

**Steps:**
1. **Create a directory** for the custom profile:
   ```bash
   sudo mkdir /etc/tuned/my-custom-profile
   ```

2. **Create the configuration file**:
   ```bash
   sudo nano /etc/tuned/my-custom-profile/tuned.conf
   ```

3. **Edit the configuration** file to include custom settings:
   ```ini
   [main]
   include=balanced

   [cpu]
   governor=performance
   ```

4. **Activate the custom profile**:
   ```bash
   sudo tuned-adm profile my-custom-profile
   ```

**Explanation:**
- This profile starts by including the settings from the `balanced` profile and then customizes the **CPU governor** to run in **performance** mode (which sets the CPU to its maximum frequency).

---

### **6. Checking the Status of the Tuned Daemon**

To ensure that **`tuned`** is running and applying the correct profile, you can check the status of the `tuned` service.

#### **Example Task 5: Check the Status of the Tuned Daemon**

**Task:** Verify that the `tuned` service is running.

**Command:**
```bash
sudo systemctl status tuned
```

#### **Example Output:**
```
● tuned.service - Dynamic System Tuning Daemon
   Loaded: loaded (/usr/lib/systemd/system/tuned.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2024-09-25 14:31:25 UTC; 10min ago
     Docs: man:tuned(8)
           man:tuned.conf(5)
```

**Explanation:**
- The output shows that the **`tuned`** service is **active** and running.
- **Enabled** indicates that the service starts automatically on boot.

---

### **7. Temporarily Deactivating Tuning**

In some cases, you may want to **temporarily disable** system tuning, for example, during troubleshooting.

#### **Example Task 6: Temporarily Disable System Tuning**

**Task:** Disable the active tuning profile temporarily.

**Command:**
```bash
sudo tuned-adm off
```

**Explanation:**
- **`tuned-adm off`** disables all active tuning, meaning the system will not apply any performance optimizations.

---

### Summary of Skills for RHCSA Exam on Managing Tuning Profiles:
1. **List available tuning profiles** using `tuned-adm list`.
2. **Switch between profiles** to optimize the system for specific workloads using `tuned-adm profile <profile>`.
3. **Verify the active tuning profile** using `tuned-adm active`.
4. **Create custom tuning profiles** by modifying or extending existing profiles.
5. **Check the status of the tuned service** using `systemctl status tuned`.

