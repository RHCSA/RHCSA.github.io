## 01- Configure IPv4 and IPv6 addresses:

The RHCSA exam topic **"Configure IPv4 and IPv6 addresses"** covers the skills needed to configure both **IPv4** and **IPv6** addresses on **RHEL 9**. You’ll need to understand how to assign static IP addresses, configure DNS, and ensure changes are persistent across reboots using tools like **`nmcli`**, **`nmtui`**, or by manually editing network configuration files.


---

### **What You Need to Know:**
1. **Understanding IPv4 and IPv6 addressing**: The differences between the two and the structure of addresses.
   - **IPv4**: 32-bit addresses, e.g., `192.168.1.10`.
   - **IPv6**: 128-bit addresses, e.g., `2001:db8::1`.
2. **Using `nmcli`** and `nmtui`**: Tools used for network management in RHEL 9.
3. **Configuring network interfaces**: Assigning static IP addresses (both IPv4 and IPv6) and DNS servers.
4. **Ensuring persistent changes**: Ensuring network configuration changes persist across reboots.
5. **Checking and testing configurations**: Use tools like `ip`, `nmcli`, and `ping` to verify the configuration.

---

### **1. Using `nmcli` to Configure IPv4 and IPv6 Addresses**

**`nmcli`** is a command-line tool to manage network interfaces and is commonly used in RHEL for configuring network settings.

#### **Example Task 1: Configure a Static IPv4 Address Using `nmcli`**

**Task:** Configure the network interface **`eth0`** with a static IPv4 address **`192.168.1.10/24`**, set the default gateway to **`192.168.1.1`**, and assign **`8.8.8.8`** as the DNS server.

1. **Set the static IPv4 address**:
   ```bash
   sudo nmcli con mod eth0 ipv4.addresses 192.168.1.10/24
   ```

2. **Set the default gateway**:
   ```bash
   sudo nmcli con mod eth0 ipv4.gateway 192.168.1.1
   ```

3. **Set the DNS server**:
   ```bash
   sudo nmcli con mod eth0 ipv4.dns "8.8.8.8"
   ```

4. **Set the method to manual (static IP)**:
   ```bash
   sudo nmcli con mod eth0 ipv4.method manual
   ```

5. **Bring the connection up**:
   ```bash
   sudo nmcli con up eth0
   ```

#### **Verify the Configuration**:
```bash
ip addr show eth0
nmcli con show eth0
```

**Explanation**:
- **`nmcli con mod eth0 ipv4.addresses`** assigns the static IP address.
- **`nmcli con mod eth0 ipv4.method manual`** ensures the connection uses a static IP.
- The changes are persistent across reboots because `nmcli` modifies the network configuration stored in `/etc/NetworkManager/system-connections/`.

---

#### **Example Task 2: Configure a Static IPv6 Address Using `nmcli`**

**Task:** Configure **`eth0`** with the static IPv6 address **`2001:db8::10/64`**, set the default IPv6 gateway to **`2001:db8::1`**, and assign the DNS server **`2001:4860:4860::8888`**.

1. **Set the static IPv6 address**:
   ```bash
   sudo nmcli con mod eth0 ipv6.addresses 2001:db8::10/64
   ```

2. **Set the default IPv6 gateway**:
   ```bash
   sudo nmcli con mod eth0 ipv6.gateway 2001:db8::1
   ```

3. **Set the IPv6 DNS server**:
   ```bash
   sudo nmcli con mod eth0 ipv6.dns "2001:4860:4860::8888"
   ```

4. **Set the method to manual for IPv6**:
   ```bash
   sudo nmcli con mod eth0 ipv6.method manual
   ```

5. **Bring the connection up**:
   ```bash
   sudo nmcli con up eth0
   ```

#### **Verify the IPv6 Configuration**:
```bash
ip -6 addr show eth0
nmcli con show eth0
```

**Explanation**:
- **`nmcli con mod eth0 ipv6.addresses`** configures the static IPv6 address.
- **`nmcli con mod eth0 ipv6.method manual`** ensures the IPv6 address is manually set and persistent.

---

### **2. Using `nmtui` for Network Configuration**

**`nmtui`** is a text-based interface for configuring network settings. It's useful if you prefer a more interactive interface over the command line.

#### **Example Task 3: Configure a Static IPv4 Address Using `nmtui`**

**Task:** Use **`nmtui`** to configure a static IPv4 address on **`eth0`**.

1. **Run `nmtui`**:
   ```bash
   sudo nmtui
   ```

2. **Select "Edit a connection"** from the menu.

3. **Choose the network interface** (e.g., `eth0`) and press **Enter**.

4. **Configure the IPv4 address**, gateway, and DNS server:
   - Set the **IPv4 address** to **`192.168.1.10/24`**.
   - Set the **gateway** to **`192.168.1.1`**.
   - Set the **DNS server** to **`8.8.8.8`**.

5. **Change IPv4 method** to **Manual**.

6. **Save the configuration** and **exit**.

7. **Bring the connection up**:
   ```bash
   sudo nmcli con up eth0
   ```

**Explanation**:
- **`nmtui`** provides a menu-driven interface to configure network settings.
- Changes made in **`nmtui`** are persistent because they modify the same configuration files as `nmcli`.

---

### **3. Configuring Static IP Addresses by Editing Configuration Files**

You can manually edit the network configuration files located in **`/etc/NetworkManager/system-connections/`**. This method is sometimes needed when you want full control over the configuration.

#### **Example Task 4: Manually Configure a Static IPv4 Address**

**Task:** Configure **`eth0`** with a static IPv4 address by editing the network configuration file.

1. **Locate the configuration file for the connection**:
   ```bash
   sudo ls /etc/NetworkManager/system-connections/
   ```

2. **Edit the file** (e.g., **`eth0.nmconnection`**):
   ```bash
   sudo nano /etc/NetworkManager/system-connections/eth0.nmconnection
   ```

3. **Modify the file to include the static IP configuration**:
   ```
   [ipv4]
   method=manual
   addresses=192.168.1.10/24
   gateway=192.168.1.1
   dns=8.8.8.8;
   ```

4. **Restart NetworkManager** to apply the changes:
   ```bash
   sudo systemctl restart NetworkManager
   ```

#### **Verify the Configuration**:
```bash
ip addr show eth0
```

**Explanation**:
- Editing the file manually allows you to configure the network without using tools like `nmcli` or `nmtui`. Changes are stored in the persistent configuration files and applied after restarting the network service.

---

### **4. Verifying the Configuration and Testing Connectivity**

Once the IP addresses are configured, verify that they are properly set and test connectivity using common network troubleshooting tools.

#### **Example Task 5: Verify and Test the Configuration**

1. **Verify the IP address**:
   ```bash
   ip addr show eth0
   ```

2. **Verify the connection status**:
   ```bash
   nmcli con show eth0
   ```

3. **Test IPv4 connectivity**:
   ```bash
   ping -c 4 8.8.8.8
   ```

4. **Test IPv6 connectivity**:
   ```bash
   ping6 -c 4 2001:4860:4860::8888
   ```

**Explanation**:
- **`ip addr show`** displays the configured IP addresses.
- **`ping` and `ping6`** test connectivity to an external server using IPv4 and IPv6, respectively.

---

### **5. Ensuring Configuration Persistence Across Reboots**

By default, changes made using **`nmcli`**, **`nmtui`**, or by editing the connection files directly are persistent across reboots. However, it's always a good idea to test this by rebooting the system.

#### **Example Task 6: Verify Persistence After Reboot**

1. **Reboot the system**:
   ```bash
   sudo reboot
   ```

2. **After reboot, verify the IP address**:
   ```bash
   ip addr show eth0
   ```

3. **Verify the connection status**:
   ```bash
   nmcli con show eth0
   ```

**Explanation**:
- Rebooting ensures that the changes are persistent. The static IP address and other settings should remain configured as expected after the reboot.

---

### Summary of Skills for RHCSA Exam on Configuring IPv4 and IPv6 Addresses:
1. **Configure static IPv4 and IPv6 addresses** using **`nmcli`**, **`nmtui`**, or manually editing network files.
2. **Set default gateways and DNS servers** for both IPv4 and IPv6.
3. **Verify the configuration** using `ip`, `nmcli`, `ping`, and `ping6`.
4. **Ensure changes are persistent** by verifying after reboot.
5. **Test network connectivity** to ensure proper communication using `ping` and `ping6`.

