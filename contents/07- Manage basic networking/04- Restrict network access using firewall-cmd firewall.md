## 04- Restrict network access using firewall-cmd firewall:

The RHCSA exam topic **"Restrict network access using `firewall-cmd` or `firewalld`"** involves managing network traffic rules using the **`firewalld`** service and **`firewall-cmd`** command. **`firewalld`** is the dynamic firewall manager used in RHEL 9, and it allows you to control incoming and outgoing traffic by defining rules for various zones, services, ports, and protocols.


---

### **What You Need to Know:**
1. **Firewalld and `firewall-cmd`**: `firewalld` is the service, and `firewall-cmd` is the command-line tool used to interact with it.
2. **Zones**: Firewalld uses zones to define trust levels for network connections (e.g., `public`, `home`, `internal`). Different zones can have different rules.
3. **Managing services and ports**: You can allow or block specific services (like `http`, `ssh`) or ports (like `80`, `443`) in a specific zone.
4. **Persistence**: You need to ensure that any firewall changes are persistent across reboots.
5. **Testing and troubleshooting**: Verifying firewall rules and ensuring that network access is restricted or allowed as required.

---

### **1. Understanding Firewalld Zones**

**Zones** in `firewalld` define different levels of trust for network interfaces. Each zone has different default rules for allowing or blocking traffic.

Common zones include:
- **public**: This is the default zone and assumes the network is public, so only essential services are allowed.
- **home**: Trusted home network.
- **internal**: A more trusted internal network.

You can assign interfaces to a zone and configure rules based on zones.

---

### **2. Managing Firewalld Service**

Before configuring the firewall, ensure the **`firewalld`** service is running and enabled to start at boot.

#### **Example Task 1: Enable and Start the `firewalld` Service**

**Task:** Ensure the **`firewalld`** service is running and enabled at boot.

1. **Start the `firewalld` service**:
   ```bash
   sudo systemctl start firewalld
   ```

2. **Enable the service to start at boot**:
   ```bash
   sudo systemctl enable firewalld
   ```

3. **Check the status of `firewalld`**:
   ```bash
   sudo systemctl status firewalld
   ```

**Explanation**:
- **`systemctl start firewalld`** starts the firewall service immediately.
- **`systemctl enable firewalld`** ensures the service will start automatically after every reboot.

---

### **3. Configuring Services in Firewalld**

In **`firewalld`**, services like **`http`**, **`https`**, or **`ssh`** are predefined. You can allow or block specific services in different zones.

#### **Example Task 2: Allow HTTP Traffic in the Public Zone**

**Task:** Allow **`http`** traffic in the **public zone**.

1. **Allow HTTP in the public zone**:
   ```bash
   sudo firewall-cmd --zone=public --add-service=http
   ```

2. **Make the change persistent**:
   ```bash
   sudo firewall-cmd --runtime-to-permanent
   ```

3. **Verify the service is allowed**:
   ```bash
   sudo firewall-cmd --zone=public --list-services
   ```

#### **Example Output**:
```
dhcpv6-client http ssh
```

**Explanation**:
- **`--zone=public`** specifies the zone to which the rule applies.
- **`--add-service=http`** allows HTTP traffic in the **public** zone.
- **`--runtime-to-permanent`** makes the changes persistent across reboots.
- **`--list-services`** lists the currently allowed services in the public zone.

---

### **4. Managing Ports in Firewalld**

In addition to services, you can manage access to specific ports using `firewall-cmd`.

#### **Example Task 3: Allow TCP Traffic on Port 8080**

**Task:** Allow traffic on port **8080** (commonly used by web applications) in the **public zone**.

1. **Allow traffic on port 8080**:
   ```bash
   sudo firewall-cmd --zone=public --add-port=8080/tcp
   ```

2. **Make the change persistent**:
   ```bash
   sudo firewall-cmd --runtime-to-permanent
   ```

3. **Verify the port is allowed**:
   ```bash
   sudo firewall-cmd --zone=public --list-ports
   ```

#### **Example Output**:
```
8080/tcp
```

**Explanation**:
- **`--add-port=8080/tcp`** allows TCP traffic on port 8080.
- **`--runtime-to-permanent`** ensures the change will persist across reboots.
- **`--list-ports`** confirms that port 8080 is now open in the **public** zone.

---

### **5. Removing Services or Ports from Firewalld**

To block access to a previously allowed service or port, you need to remove the rule.

#### **Example Task 4: Remove HTTP Access from the Public Zone**

**Task:** Block **HTTP** traffic in the **public zone**.

1. **Remove the `http` service** from the public zone:
   ```bash
   sudo firewall-cmd --zone=public --remove-service=http
   ```

2. **Make the change persistent**:
   ```bash
   sudo firewall-cmd --runtime-to-permanent
   ```

3. **Verify the service is removed**:
   ```bash
   sudo firewall-cmd --zone=public --list-services
   ```

#### **Example Output**:
```
dhcpv6-client ssh
```

**Explanation**:
- **`--remove-service=http`** removes HTTP traffic from the **public** zone.
- **`--runtime-to-permanent`** makes the removal permanent.

---

### **6. Blocking All Incoming Traffic Except SSH**

In some scenarios, you may want to block all incoming traffic except **SSH** to allow remote administration while securing the system.

#### **Example Task 5: Block All Traffic Except SSH**

**Task:** Block all incoming traffic in the **public zone** except for **SSH**.

1. **Remove all services except SSH**:
   ```bash
   sudo firewall-cmd --zone=public --remove-service=http
   sudo firewall-cmd --zone=public --remove-service=https
   sudo firewall-cmd --zone=public --remove-service=dhcpv6-client
   ```

2. **Verify only SSH is allowed**:
   ```bash
   sudo firewall-cmd --zone=public --list-services
   ```

#### **Example Output**:
```
ssh
```

**Explanation**:
- Removing services using **`--remove-service`** blocks traffic for those services. In this case, only SSH remains allowed.

---

### **7. Reloading the Firewall**

Changes made to the firewall using `firewall-cmd` can either be immediate (runtime) or permanent. After changing the configuration, you may need to reload the firewall.

#### **Example Task 6: Reload the Firewall to Apply Changes**

**Task:** Reload the firewall to apply recent changes.

**Command:**
```bash
sudo firewall-cmd --reload
```

**Explanation**:
- **`--reload`** reloads the firewall to apply changes without interrupting active connections.

---

### **8. Testing Firewall Rules**

You should always verify that the firewall rules work as expected after making changes.

#### **Example Task 7: Test Firewall Configuration**

1. **Use `curl` or `wget` to test HTTP access**:
   ```bash
   curl http://localhost:8080
   ```

2. **Test connectivity to allowed ports**:
   ```bash
   nc -zv localhost 8080
   ```

3. **Use `ping` to test whether ICMP (ping) traffic is allowed**:
   ```bash
   ping google.com
   ```

**Explanation**:
- **`curl`** or **`nc` (netcat)** can test access to services or ports.
- **`ping`** tests whether ICMP packets can pass through the firewall.

---

### **9. Checking the Default Zone and Assigning Interfaces**

The **default zone** is the zone that applies to all network interfaces if no specific zone is assigned to an interface. You can change the default zone or assign interfaces to specific zones.

#### **Example Task 8: Set the Default Zone to `internal`**

**Task:** Set the **`internal`** zone as the default for all interfaces.

1. **Change the default zone to `internal`**:
   ```bash
   sudo firewall-cmd --set-default-zone=internal
   ```

2. **Verify the default zone**:
   ```bash
   sudo firewall-cmd --get-default-zone
   ```

#### **Example Output**:
```
internal
```

**Explanation**:
- **`--set-default-zone=internal`** sets the **`internal`** zone as the default for all network interfaces that don’t have an explicit zone assigned.

---

### Summary of Skills for RHCSA Exam on Restricting Network Access Using `firewall-cmd`:
1. **Enable and start the `firewalld` service** using `systemctl start` and `systemctl enable`.
2. **Allow and block services and ports** using `firewall-cmd` with options like `--add-service`, `--remove-service`, `--add-port`, and `--remove-port`.
3. **Make firewall changes persistent** using `--runtime-to-permanent` or **reload** the firewall using `--reload`.
4. **Test firewall rules** using tools like `ping`, `curl`, or `nc` (netcat) to ensure network traffic is properly restricted or allowed.
5. **Configure zones** and manage traffic based on different levels of network trust.

