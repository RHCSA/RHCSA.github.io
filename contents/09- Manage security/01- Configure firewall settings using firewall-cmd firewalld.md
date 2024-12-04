## 01- Configure firewall settings using firewall-cmd firewalld:

The RHCSA exam topic **"Configure firewall settings using `firewall-cmd` and `firewalld`"** involves managing and configuring the firewall on a **RHEL 9** system. This includes enabling and disabling services and ports, assigning interfaces to zones, and ensuring all changes are persistent across reboots. **`firewalld`** is the default firewall management service, and **`firewall-cmd`** is the command-line interface to interact with it.

---

### **What You Need to Know:**
1. **`firewalld`**: A dynamically managed firewall that supports different **zones** with varying trust levels.
2. **`firewall-cmd`**: The command-line tool to configure `firewalld` for managing services, ports, and network interfaces.
3. **Zones**: Control how network interfaces and services are handled. Common zones include `public`, `home`, and `trusted`.
4. **Managing services and ports**: Allow or block traffic for specific services (like `ssh` or `http`) and ports (like `80/tcp`).
5. **Making changes persistent**: All firewall changes must persist across reboots.
6. **Verifying firewall settings**: Use `firewall-cmd` commands to confirm and test the firewall configuration.

---

### **1. Managing the `firewalld` Service**

The **`firewalld`** service must be running for the firewall settings to be active. Use **`systemctl`** to manage the service.

#### **Example Task 1: Ensure `firewalld` is Running and Enabled at Boot**

**Task:** Start the `firewalld` service and enable it to start at boot.

1. **Start the `firewalld` service**:
   ```bash
   sudo systemctl start firewalld
   ```

2. **Enable `firewalld` to start at boot**:
   ```bash
   sudo systemctl enable firewalld
   ```

3. **Verify the status of `firewalld`**:
   ```bash
   sudo systemctl status firewalld
   ```

**Explanation**:
- **`systemctl start firewalld`** starts the firewall service.
- **`systemctl enable firewalld`** ensures the firewall service starts automatically at boot.
- **`systemctl status firewalld`** verifies that the service is running.

---

### **2. Viewing and Understanding Zones**

**Zones** in `firewalld` define different trust levels for network interfaces. By default, most interfaces are placed in the `public` zone, which is configured for untrusted networks. You can view the available zones and their settings using `firewall-cmd`.

#### **Example Task 2: List Available Zones and View Current Active Zone**

**Task:** List all available firewall zones and check which zone is active.

1. **List all available zones**:
   ```bash
   sudo firewall-cmd --get-zones
   ```

2. **Check the current default zone**:
   ```bash
   sudo firewall-cmd --get-default-zone
   ```

3. **List active zones and associated interfaces**:
   ```bash
   sudo firewall-cmd --get-active-zones
   ```

#### **Example Output**:
```
public
  interfaces: eth0
```

**Explanation**:
- **`--get-zones`** lists all available firewall zones.
- **`--get-default-zone`** shows the default zone that will be applied to network interfaces not explicitly assigned to a zone.
- **`--get-active-zones`** lists the active zones and the interfaces associated with them.

---

### **3. Allowing and Blocking Services**

You can allow or block services by modifying the firewall rules. Services like **`http`**, **`ssh`**, or **`https`** are predefined in **`firewalld`**, and you can enable or disable them easily using `firewall-cmd`.

#### **Example Task 3: Allow SSH and HTTP Traffic in the Public Zone**

**Task:** Allow **`ssh`** and **`http`** services in the `public` zone.

1. **Allow `ssh` in the public zone**:
   ```bash
   sudo firewall-cmd --zone=public --add-service=ssh
   ```

2. **Allow `http` in the public zone**:
   ```bash
   sudo firewall-cmd --zone=public --add-service=http
   ```

3. **Make the changes persistent**:
   ```bash
   sudo firewall-cmd --runtime-to-permanent
   ```

4. **Verify the services are enabled**:
   ```bash
   sudo firewall-cmd --zone=public --list-services
   ```

#### **Example Output**:
```
dhcpv6-client http ssh
```

**Explanation**:
- **`--add-service=ssh`** and **`--add-service=http`** allow incoming SSH and HTTP traffic in the `public` zone.
- **`--runtime-to-permanent`** makes the changes persistent across reboots.
- **`--list-services`** lists all services currently allowed in the `public` zone.

---

### **4. Allowing and Blocking Ports**

In addition to predefined services, you can also allow or block specific ports.

#### **Example Task 4: Allow TCP Traffic on Port 8080**

**Task:** Allow traffic on port **8080** for a web application running in the `public` zone.

1. **Allow TCP traffic on port 8080**:
   ```bash
   sudo firewall-cmd --zone=public --add-port=8080/tcp
   ```

2. **Make the change persistent**:
   ```bash
   sudo firewall-cmd --runtime-to-permanent
   ```

3. **Verify the port is open**:
   ```bash
   sudo firewall-cmd --zone=public --list-ports
   ```

#### **Example Output**:
```
8080/tcp
```

**Explanation**:
- **`--add-port=8080/tcp`** opens TCP port 8080 in the `public` zone.
- **`--runtime-to-permanent`** ensures the port stays open after a reboot.
- **`--list-ports`** confirms that the port is open in the firewall.

---

### **5. Removing Services and Ports**

If you no longer need a service or port to be allowed, you can remove it using **`firewall-cmd`**.

#### **Example Task 5: Remove HTTP and Port 8080 from the Public Zone**

**Task:** Remove the **`http`** service and close **port 8080**.

1. **Remove the `http` service from the public zone**:
   ```bash
   sudo firewall-cmd --zone=public --remove-service=http
   ```

2. **Remove the port 8080 rule**:
   ```bash
   sudo firewall-cmd --zone=public --remove-port=8080/tcp
   ```

3. **Make the changes persistent**:
   ```bash
   sudo firewall-cmd --runtime-to-permanent
   ```

4. **Verify the changes**:
   ```bash
   sudo firewall-cmd --zone=public --list-services
   sudo firewall-cmd --zone=public --list-ports
   ```

#### **Example Output**:
```
dhcpv6-client ssh
```

**Explanation**:
- **`--remove-service=http`** blocks HTTP traffic in the `public` zone.
- **`--remove-port=8080/tcp`** closes port 8080 for TCP traffic.
- **`--runtime-to-permanent`** makes the changes persistent.
- **`--list-services`** and **`--list-ports`** verify that HTTP and port 8080 are no longer allowed.

---

### **6. Assigning Interfaces to Zones**

You can assign network interfaces to specific zones to apply different firewall rules based on the network interface.

#### **Example Task 6: Assign an Interface to a Different Zone**

**Task:** Move the network interface **`eth0`** to the `trusted` zone, where all traffic is allowed.

1. **Change the zone of `eth0` to `trusted`**:
   ```bash
   sudo firewall-cmd --zone=trusted --change-interface=eth0
   ```

2. **Make the change persistent**:
   ```bash
   sudo firewall-cmd --runtime-to-permanent
   ```

3. **Verify the interface is assigned to the `trusted` zone**:
   ```bash
   sudo firewall-cmd --get-active-zones
   ```

#### **Example Output**:
```
trusted
  interfaces: eth0
```

**Explanation**:
- **`--change-interface=eth0`** assigns the `eth0` network interface to the `trusted` zone.
- **`--runtime-to-permanent`** ensures the interface remains in the `trusted` zone after reboot.
- **`--get-active-zones`** lists all active zones and their associated interfaces.

---

### **7. Reloading and Resetting the Firewall**

Sometimes, after modifying the firewall configuration, you may need to reload it to apply changes or reset it to its default state.

#### **Example Task 7: Reload the Firewall and Reset to Default Settings**

1. **Reload the firewall configuration**:
   ```bash
   sudo firewall-cmd --reload
   ```

2. **Reset the firewall to its default settings**:
   ```bash
   sudo firewall-cmd --complete-reload
   ```

**Explanation**:
- **`--reload`** applies any runtime changes without disconnecting current connections.
- **`--complete-reload`** resets the firewall to its default configuration.

---

### **8. Verifying Firewall Rules and Settings**

After configuring firewall rules, it’s important to verify that the changes are applied correctly.

#### **Example Task 8: Verify the Current Firewall Configuration**

1. **List all allowed services in the `public` zone**:
   ```bash
   sudo firewall-cmd --zone=public --list-services
   ```

2. **List all open ports in the `public` zone**:
   ```bash
   sudo firewall-cmd --zone=public --list-ports
   ```

3. **View the complete configuration for the `public` zone**:
   ```bash
   sudo firewall-cmd --zone=public --list-all
   ```

#### **Example Output**:
```
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0
  sources:
  services: dhcpv6-client ssh
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

**Explanation**:
- **`--list-all`** provides a complete view of all rules, services, ports, and settings for the `public` zone.

---

### Summary of Skills for RHCSA Exam on Configuring Firewall Settings:
1. **Start and enable `firewalld`** using `systemctl`.
2. **Allow and block services** using `firewall-cmd --add-service` and `--remove-service`.
3. **Open and close ports** using `firewall-cmd --add-port` and `--remove-port`.
4. **Make all firewall changes persistent** using `--runtime-to-permanent`.
5. **Assign interfaces to zones** using `--change-interface`.
6. **Reload and reset the firewall** using `--reload` and `--complete-reload`.
7. **Verify the firewall configuration** using `firewall-cmd --list-all` and other `firewall-cmd` commands.

