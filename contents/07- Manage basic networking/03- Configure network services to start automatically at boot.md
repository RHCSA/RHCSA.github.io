## 03- Configure network services to start automatically at boot:

The RHCSA exam topic **"Configure network services to start automatically at boot"** focuses on managing services, specifically ensuring that key network-related services like **`network`, `firewalld`, `sshd`**, etc., are enabled and start automatically when the system boots. On **RHEL 9**, managing services is handled using **`systemctl`**, the interface for working with **systemd**, which manages the initialization and control of services.

---

### **What You Need to Know:**
1. **Understanding `systemd`**: `systemd` is the init system that manages services on RHEL 9. It controls services via **`systemctl`**.
2. **Enabling and disabling services**: How to ensure services start at boot and how to disable services you don’t need.
3. **Checking the status of services**: Use **`systemctl status`** to check whether services are running.
4. **Starting, stopping, and restarting services**: How to manually control the running state of services.
5. **Ensuring persistence**: When you enable a service, it will automatically start at boot persistently.

---

### **1. Managing Services Using `systemctl`**

The `systemctl` command is used to manage services on RHEL 9. The key operations are enabling (for auto-start at boot), starting (for immediate start), and checking the status of services.

#### **Example Task 1: Enable a Service to Start Automatically at Boot**

**Task:** Enable the **`httpd`** service to start automatically at boot.

1. **Install the `httpd` package** (if not installed):
   ```bash
   sudo dnf install httpd -y
   ```

2. **Enable the `httpd` service to start at boot**:
   ```bash
   sudo systemctl enable httpd
   ```

3. **Start the `httpd` service immediately**:
   ```bash
   sudo systemctl start httpd
   ```

4. **Check the status of the `httpd` service**:
   ```bash
   sudo systemctl status httpd
   ```

#### **Verify that the Service is Enabled at Boot**:
```bash
sudo systemctl is-enabled httpd
```

#### **Example Output**:
```
enabled
```

**Explanation**:
- **`systemctl enable httpd`** ensures that the **`httpd`** service will start automatically at boot.
- **`systemctl start httpd`** starts the service immediately in the current session.
- **`systemctl is-enabled httpd`** confirms that the service is enabled to start at boot.

---

### **2. Disabling a Service from Starting at Boot**

You may need to prevent some services from starting automatically at boot. This is done by disabling the service using `systemctl disable`.

#### **Example Task 2: Disable a Service from Starting Automatically at Boot**

**Task:** Disable the **`firewalld`** service from starting at boot.

1. **Stop the service immediately** (if running):
   ```bash
   sudo systemctl stop firewalld
   ```

2. **Disable the service from starting at boot**:
   ```bash
   sudo systemctl disable firewalld
   ```

3. **Check the status of the `firewalld` service**:
   ```bash
   sudo systemctl status firewalld
   ```

#### **Verify that the Service is Disabled at Boot**:
```bash
sudo systemctl is-enabled firewalld
```

#### **Example Output**:
```
disabled
```

**Explanation**:
- **`systemctl disable firewalld`** ensures that the service will not start automatically when the system boots.
- **`systemctl stop firewalld`** stops the service immediately in the current session.
- **`systemctl is-enabled firewalld`** confirms whether the service is enabled or disabled at boot.

---

### **3. Restarting or Reloading Services**

Some services may need to be restarted or reloaded to apply configuration changes, such as when you update a configuration file or change network settings.

#### **Example Task 3: Restart a Service**

**Task:** Restart the **`sshd`** service after making configuration changes.

1. **Make configuration changes** (for example, edit `/etc/ssh/sshd_config`):
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```

2. **Restart the `sshd` service to apply changes**:
   ```bash
   sudo systemctl restart sshd
   ```

3. **Check the status of the `sshd` service**:
   ```bash
   sudo systemctl status sshd
   ```

**Explanation**:
- **`systemctl restart sshd`** stops and starts the **`sshd`** service, applying any changes made to its configuration.
- Use **`systemctl reload sshd`** if you want to reload the configuration without stopping the service (useful for services that support reloading).

---

### **4. Checking the Status of a Service**

You can use **`systemctl status`** to check whether a service is active (running), inactive (stopped), or failed. This is useful for troubleshooting and verifying that services are running as expected.

#### **Example Task 4: Check the Status of a Service**

**Task:** Check the status of the **`NetworkManager`** service.

**Command:**
```bash
sudo systemctl status NetworkManager
```

#### **Example Output**:
```
● NetworkManager.service - Network Manager
   Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2024-09-25 10:15:36 UTC; 5min ago
     Docs: man:NetworkManager(8)
 Main PID: 874 (NetworkManager)
    Tasks: 3 (limit: 1112)
   Memory: 12.5M
   ...
```

**Explanation**:
- **`systemctl status`** provides detailed information about the service, including whether it is active or inactive, when it started, and its process ID (PID).

---

### **5. Ensuring Persistence of Services**

When you **`enable`** a service with `systemctl`, the service is configured to start automatically after every reboot. You can test this by rebooting the system and verifying the status of the service afterward.

#### **Example Task 5: Verify Service Persistence After Reboot**

**Task:** Reboot the system and check if the **`httpd`** service is still running after the reboot.

1. **Reboot the system**:
   ```bash
   sudo reboot
   ```

2. **After reboot, check the status of the `httpd` service**:
   ```bash
   sudo systemctl status httpd
   ```

**Explanation**:
- After rebooting, the **`httpd`** service should start automatically if it was enabled using **`systemctl enable`**. The **`systemctl status`** command verifies this.

---

### **6. Listing All Enabled Services**

You can list all services that are enabled to start at boot using **`systemctl list-unit-files`**.

#### **Example Task 6: List All Enabled Services**

**Task:** List all services that are enabled to start at boot.

**Command:**
```bash
sudo systemctl list-unit-files --type=service --state=enabled
```

#### **Example Output**:
```
UNIT FILE                            STATE
firewalld.service                    enabled
NetworkManager.service               enabled
sshd.service                         enabled
httpd.service                        enabled
```

**Explanation**:
- **`list-unit-files`** lists all service unit files, and the **`--state=enabled`** option filters to show only services that are enabled to start at boot.

---

### Summary of Skills for RHCSA Exam on Configuring Network Services to Start Automatically at Boot:
1. **Enable and start services** using `systemctl enable` and `systemctl start` to ensure they run immediately and automatically at boot.
2. **Disable services** to prevent them from starting at boot using `systemctl disable`.
3. **Restart or reload services** to apply changes to configuration files using `systemctl restart` or `systemctl reload`.
4. **Check the status of services** using `systemctl status` to verify whether they are running correctly.
5. **Verify persistence** by rebooting the system and checking if the services automatically start as expected.
