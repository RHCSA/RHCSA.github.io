## 09- Start, stop, and check the status of network services:

For the **RHCSA Exam** topic **"Start, stop, and check the status of network services"**, you'll need to demonstrate your ability to manage network-related services on a Red Hat-based system using `systemctl`, the command-line tool for interacting with the `systemd` system and service manager. Network services can include `NetworkManager`, `sshd`, and others related to networking functionality.

Here’s what you need to know and some example questions:

---

### **1. Start, Stop, and Restart Network Services**

You need to know how to start, stop, restart, and check the status of network-related services. This is done with `systemctl` for any service managed by `systemd`.

#### **Example Exam Question 1:**
- **Question**: Start the `NetworkManager` service if it is not running, and ensure it starts automatically on boot.
- **Answer**:
    1. Start the `NetworkManager` service:
       ```bash
       sudo systemctl start NetworkManager
       ```
    2. Enable the `NetworkManager` service to start on boot:
       ```bash
       sudo systemctl enable NetworkManager
       ```

#### **Explanation**:
- `systemctl start <service_name>` starts the service immediately.
- `systemctl enable <service_name>` ensures the service starts automatically on boot.

#### **Example Exam Question 2**:
- **Question**: Stop the `firewalld` service and ensure it does not start on boot.
- **Answer**:
    1. Stop the service:
       ```bash
       sudo systemctl stop firewalld
       ```
    2. Disable the service from starting at boot:
       ```bash
       sudo systemctl disable firewalld
       ```

---

### **2. Check the Status of Network Services**

It's essential to be able to verify whether a service is running or has failed, which can be checked using the `status` command with `systemctl`.

#### **Example Exam Question 3**:
- **Question**: Check the current status of the `sshd` service and confirm if it is running.
- **Answer**:
    ```bash
    sudo systemctl status sshd
    ```

#### **Explanation**:
- `systemctl status <service_name>` shows the current status, including whether the service is active, inactive, failed, or running correctly.

---

### **3. Restarting and Reloading Services**

Restarting services is necessary when configuration changes have been made and need to be applied. Reloading is typically done when a service supports reloading its configuration without a full restart.

#### **Example Exam Question 4**:
- **Question**: Restart the `network` service after changing network configuration files.
- **Answer**:
    ```bash
    sudo systemctl restart network
    ```

#### **Explanation**:
- `systemctl restart <service_name>` stops and then starts the service again, applying any changes made in the configuration files.

#### **Example Exam Question 5**:
- **Question**: Reload the `firewalld` service after making changes to the firewall rules.
- **Answer**:
    ```bash
    sudo firewall-cmd --reload
    ```

Alternatively, you can reload the service using `systemctl`:
```bash
sudo systemctl reload firewalld
```

#### **Explanation**:
- Reloading a service allows it to apply new configuration changes without fully restarting it. Some services (like `firewalld`) support this, but not all.

---

### **4. Enabling and Disabling Services**

In many exam scenarios, you’ll need to ensure that critical network services like `sshd` or `NetworkManager` start automatically after a system reboot.

#### **Example Exam Question 6**:
- **Question**: Ensure that the `sshd` service is enabled to start automatically on boot.
- **Answer**:
    ```bash
    sudo systemctl enable sshd
    ```

#### **Explanation**:
- Enabling a service ensures that it starts automatically on system boot. Disabling it prevents it from starting.

---

### **5. Masking and Unmasking Services**

In some cases, you may be asked to completely disable a service, preventing it from starting manually or automatically. This is done by "masking" the service.

#### **Example Exam Question 7**:
- **Question**: Mask the `NetworkManager` service to prevent it from being started by any means.
- **Answer**:
    ```bash
    sudo systemctl mask NetworkManager
    ```

#### **Explanation**:
- `systemctl mask <service_name>` symlinks the service to `/dev/null`, completely preventing it from being started by any means, including manual attempts.
  
To unmask the service:
```bash
sudo systemctl unmask NetworkManager
```

---

### **6. View Logs of Network Services**

Understanding how to view logs for network services is essential for troubleshooting. This can be done using the `journalctl` command, which reads logs from the `systemd` journal.

#### **Example Exam Question 8**:
- **Question**: View the recent logs for the `NetworkManager` service.
- **Answer**:
    ```bash
    sudo journalctl -u NetworkManager
    ```

#### **Explanation**:
- `journalctl -u <service_name>` shows logs for the specific service.

---

### **Key Services to Manage:**

1. **`NetworkManager`**: Manages network interfaces and settings on modern RHEL systems.
   - `systemctl start/stop/restart/status NetworkManager`
   
2. **`network.service`**: Legacy network service, mostly used in older systems.
   - Some environments might still require managing it.

3. **`sshd`**: The OpenSSH daemon, managing SSH connections (very important for remote administration).
   - `systemctl start/stop/restart/status sshd`

4. **`firewalld`**: The dynamic firewall management service.
   - `systemctl start/stop/restart/status firewalld`
   - `firewall-cmd --reload` is used for applying new rules.

---

### **Practice Summary**:

1. **Start, stop, and check the status** of network-related services using `systemctl`.
2. **Enable and disable services** to control whether they start automatically at boot.
3. **Restart and reload services** to apply configuration changes.
4. **View logs** for network services using `journalctl` for troubleshooting.
5. **Mask and unmask services** when you want to fully disable them or reverse the action.

---

### **Useful Commands for the RHCSA Exam**:

- Start a service:
  ```bash
  sudo systemctl start <service_name>
  ```

- Stop a service:
  ```bash
  sudo systemctl stop <service_name>
  ```

- Restart a service:
  ```bash
  sudo systemctl restart <service_name>
  ```

- Check the status of a service:
  ```bash
  sudo systemctl status <service_name>
  ```

- Enable a service to start at boot:
  ```bash
  sudo systemctl enable <service_name>
  ```

- Disable a service from starting at boot:
  ```bash
  sudo systemctl disable <service_name>
  ```

- View logs for a service:
  ```bash
  sudo journalctl -u <service_name>
  ```

