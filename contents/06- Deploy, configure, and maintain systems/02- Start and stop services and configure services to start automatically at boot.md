## 02- Start and stop services and configure services to start automatically at boot:

The RHCSA exam topic **"Start and stop services and configure services to start automatically at boot"** focuses on managing system services using **`systemctl`**, the command used to control the **systemd** service manager. You’ll need to understand how to start, stop, restart, and enable/disable services, and ensure that service configurations are persistent across reboots.

---

### **What You Need to Know:**
1. **Systemd services**: Services in modern Linux systems (like RHEL 7/8/9) are managed by the **systemd** system and service manager. You’ll be using `systemctl` to interact with services.
2. **Start/stop services**: You should know how to manually start, stop, and restart services.
3. **Enable/disable services**: Know how to enable services so they automatically start at boot and how to disable services to prevent them from starting automatically.
4. **Check service status**: You should be able to check whether a service is running, as well as view detailed information about the service.
5. **Persistence**: Ensure that services configured to start at boot remain active across reboots.

---

### **1. Starting and Stopping Services**

To manually start or stop services, you use the `systemctl` command.

#### **Example Task 1: Start a Service**

**Task:** Start the **`httpd`** service (Apache web server) manually.

**Command:**
```bash
sudo systemctl start httpd
```

**Explanation**:
- **`systemctl start httpd`**: Starts the **`httpd`** service immediately.

---

#### **Example Task 2: Stop a Service**

**Task:** Stop the **`httpd`** service manually.

**Command:**
```bash
sudo systemctl stop httpd
```

**Explanation**:
- **`systemctl stop httpd`**: Stops the **`httpd`** service.

---

### **2. Restarting Services**

You can restart services to reload their configuration or reset their state without stopping and starting them manually.

#### **Example Task 3: Restart a Service**

**Task:** Restart the **`httpd`** service.

**Command:**
```bash
sudo systemctl restart httpd
```

**Explanation**:
- **`systemctl restart httpd`**: Stops and starts the service in a single step. This is useful after modifying a service configuration file.

---

### **3. Enabling and Disabling Services at Boot**

To configure services to start automatically at boot or disable them from starting, you use the `enable` and `disable` options with `systemctl`.

#### **Example Task 4: Enable a Service to Start at Boot**

**Task:** Ensure that the **`httpd`** service starts automatically at boot.

**Command:**
```bash
sudo systemctl enable httpd
```

#### **Example Output:**
```
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```

**Explanation**:
- **`systemctl enable httpd`**: Creates the necessary symlinks so that the **`httpd`** service will start automatically when the system boots.
  
---

#### **Example Task 5: Disable a Service from Starting at Boot**

**Task:** Prevent the **`httpd`** service from starting automatically at boot.

**Command:**
```bash
sudo systemctl disable httpd
```

#### **Example Output:**
```
Removed /etc/systemd/system/multi-user.target.wants/httpd.service.
```

**Explanation**:
- **`systemctl disable httpd`**: Removes the symlinks created by the `enable` command, ensuring that the **`httpd`** service does not start automatically at boot.

---

### **4. Checking Service Status**

You should check the status of services to ensure they are running properly or to troubleshoot any issues.

#### **Example Task 6: Check the Status of a Service**

**Task:** Check the current status of the **`httpd`** service.

**Command:**
```bash
sudo systemctl status httpd
```

#### **Example Output:**
```
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Sat 2024-09-25 12:00:00 UTC; 5min ago
```

**Explanation**:
- **`systemctl status httpd`**: Shows whether the service is **active (running)** or **inactive (stopped)**.
- It also provides information on whether the service is enabled to start at boot.

---

### **5. Checking All Enabled Services**

You can list all services that are currently enabled to start at boot.

#### **Example Task 7: List All Enabled Services**

**Task:** Display all services that are enabled to start at boot.

**Command:**
```bash
systemctl list-unit-files --type=service --state=enabled
```

**Explanation**:
- **`list-unit-files`**: Lists all systemd unit files.
- **`--state=enabled`**: Filters the list to show only services that are enabled to start at boot.

---

### **6. Troubleshooting Services**

If a service fails to start, you can inspect its logs to identify the issue.

#### **Example Task 8: View the Logs for a Service**

**Task:** Check the logs for the **`httpd`** service to troubleshoot a failure.

**Command:**
```bash
sudo journalctl -u httpd
```

**Explanation**:
- **`journalctl -u httpd`**: Displays the logs related to the **`httpd`** service. This can help you understand why the service failed to start.

---

### **7. Making Service Configuration Persistent**

When you enable a service with `systemctl enable`, it creates symlinks that ensure the service starts at boot. This ensures that your configuration is **persistent** across reboots.

#### **Example Task 9: Verify the Service Is Enabled After Reboot**

**Task:** Verify that the **`httpd`** service starts automatically after a system reboot.

1. **Reboot the system**:
   ```bash
   sudo reboot
   ```

2. **After reboot, check if the `httpd` service is running**:
   ```bash
   sudo systemctl status httpd
   ```

**Explanation**:
- **`sudo reboot`** reboots the system.
- **`systemctl status httpd`** ensures that the service is running after the reboot.

---

### Summary of Skills for RHCSA Exam on Managing Services:
1. **Start and stop services** using `systemctl start` and `systemctl stop`.
2. **Restart services** using `systemctl restart` to reload configurations or reset service state.
3. **Enable services to start at boot** using `systemctl enable` and disable them with `systemctl disable`.
4. **Check service status** using `systemctl status` to confirm whether a service is active or troubleshoot issues.
5. **Check logs** using `journalctl` to investigate why a service failed to start.
6. **Ensure persistence** by verifying that services start automatically after a reboot when enabled.
