# Configure IPv4 and IPv6 Addresses

## RHCSA Exam Objective
> Configure IPv4 and IPv6 addresses

---

## Introduction

Network configuration is essential for RHCSA. RHEL 9 uses NetworkManager as the primary network management tool. You must be able to configure static and dynamic IP addresses using `nmcli` (command line) or `nmtui` (text UI).

---

## Key Commands

| Command | Description |
|---------|-------------|
| `nmcli` | NetworkManager command-line interface |
| `nmtui` | NetworkManager text user interface |
| `ip addr` | Show IP addresses |
| `ip link` | Show network interfaces |

---

## Part 1: Viewing Network Configuration

### Question 1: Display All Network Interfaces
**Task:** List all network interfaces and their IP addresses.

<details>
<summary>Show Solution</summary>

```bash
ip addr
```

**Or shorter:**
```bash
ip a
```

**Show only IPv4:**
```bash
ip -4 addr
```

**Show only IPv6:**
```bash
ip -6 addr
```
</details>

---

### Question 2: View NetworkManager Connections
**Task:** List all NetworkManager connections.

<details>
<summary>Show Solution</summary>

```bash
nmcli connection show
```

**Or shorter:**
```bash
nmcli con show
```

**Output columns:**
- NAME: Connection name
- UUID: Unique identifier
- TYPE: ethernet, wifi, etc.
- DEVICE: Interface name (empty if not active)
</details>

---

### Question 3: View Connection Details
**Task:** Show detailed settings for connection "enp0s3".

<details>
<summary>Show Solution</summary>

```bash
nmcli connection show enp0s3
```

**Key fields to look for:**
- `ipv4.method`: manual or auto (DHCP)
- `ipv4.addresses`: Static IP address
- `ipv4.gateway`: Default gateway
- `ipv4.dns`: DNS servers
</details>

---

### Question 4: View Device Status
**Task:** Show status of all network devices.

<details>
<summary>Show Solution</summary>

```bash
nmcli device status
```

**Or:**
```bash
nmcli dev status
```
</details>

---

## Part 2: Configure Static IPv4 Address

### Question 5: Configure Static IPv4 Address
**Task:** Configure interface enp0s3 with:
- IP: 192.168.1.100/24
- Gateway: 192.168.1.1
- DNS: 8.8.8.8

<details>
<summary>Show Solution</summary>

```bash
# Set static IP (manual method)
sudo nmcli connection modify enp0s3 ipv4.method manual

# Set IP address with prefix
sudo nmcli connection modify enp0s3 ipv4.addresses 192.168.1.100/24

# Set gateway
sudo nmcli connection modify enp0s3 ipv4.gateway 192.168.1.1

# Set DNS
sudo nmcli connection modify enp0s3 ipv4.dns 8.8.8.8

# Apply changes
sudo nmcli connection up enp0s3
```

**Or all in one command:**
```bash
sudo nmcli connection modify enp0s3 \
    ipv4.method manual \
    ipv4.addresses 192.168.1.100/24 \
    ipv4.gateway 192.168.1.1 \
    ipv4.dns 8.8.8.8

sudo nmcli connection up enp0s3
```
</details>

---

### Question 6: Add Additional IP Address
**Task:** Add a second IP address 192.168.1.101/24 to enp0s3.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 +ipv4.addresses 192.168.1.101/24
sudo nmcli connection up enp0s3
```

**Note:** Use `+` to add, `-` to remove.
</details>

---

### Question 7: Configure Multiple DNS Servers
**Task:** Set DNS servers 8.8.8.8 and 8.8.4.4.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 ipv4.dns "8.8.8.8 8.8.4.4"
sudo nmcli connection up enp0s3
```

**Or add one at a time:**
```bash
sudo nmcli connection modify enp0s3 +ipv4.dns 8.8.4.4
```
</details>

---

### Question 8: Configure DHCP (Automatic)
**Task:** Configure enp0s3 to obtain IP via DHCP.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 ipv4.method auto
sudo nmcli connection up enp0s3
```

**Clear static settings:**
```bash
sudo nmcli connection modify enp0s3 ipv4.addresses ""
sudo nmcli connection modify enp0s3 ipv4.gateway ""
```
</details>

---

## Part 3: Configure IPv6 Address

### Question 9: Configure Static IPv6 Address
**Task:** Configure enp0s3 with IPv6 address 2001:db8::10/64.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 ipv6.method manual
sudo nmcli connection modify enp0s3 ipv6.addresses 2001:db8::10/64
sudo nmcli connection up enp0s3
```

**Verify:**
```bash
ip -6 addr show enp0s3
```
</details>

---

### Question 10: Configure IPv6 Gateway
**Task:** Set IPv6 gateway to 2001:db8::1.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 ipv6.gateway 2001:db8::1
sudo nmcli connection up enp0s3
```
</details>

---

### Question 11: Configure IPv6 DNS
**Task:** Set IPv6 DNS server.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 ipv6.dns 2001:4860:4860::8888
sudo nmcli connection up enp0s3
```
</details>

---

### Question 12: Disable IPv6
**Task:** Disable IPv6 on connection enp0s3.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 ipv6.method disabled
sudo nmcli connection up enp0s3
```
</details>

---

### Question 13: Enable IPv6 Auto Configuration
**Task:** Configure IPv6 to use SLAAC (automatic).

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 ipv6.method auto
sudo nmcli connection up enp0s3
```
</details>

---

## Part 4: Create and Delete Connections

### Question 14: Create New Connection
**Task:** Create a new ethernet connection "myconn" for device enp0s8.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection add \
    con-name myconn \
    type ethernet \
    ifname enp0s8 \
    ipv4.method manual \
    ipv4.addresses 10.0.0.50/24 \
    ipv4.gateway 10.0.0.1
```

**Activate:**
```bash
sudo nmcli connection up myconn
```
</details>

---

### Question 15: Delete Connection
**Task:** Delete connection named "myconn".

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection delete myconn
```
</details>

---

## Part 5: Activate and Deactivate Connections

### Question 16: Activate Connection
**Task:** Bring up connection enp0s3.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection up enp0s3
```
</details>

---

### Question 17: Deactivate Connection
**Task:** Bring down connection enp0s3.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection down enp0s3
```
</details>

---

### Question 18: Reload Connection Files
**Task:** Reload connection configurations from disk.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection reload
```
</details>

---

## Part 6: Using nmtui

### Question 19: Configure Network with nmtui
**Task:** Use text-based interface to configure networking.

<details>
<summary>Show Solution</summary>

```bash
sudo nmtui
```

**Navigation:**
- Use arrow keys to navigate
- Tab to switch between fields
- Enter to select
- Esc to go back

**Options:**
1. Edit a connection
2. Activate a connection
3. Set system hostname
</details>

---

## Part 7: Connection Configuration Files

### Question 20: View Connection File
**Task:** Find and view connection configuration file.

<details>
<summary>Show Solution</summary>

**RHEL 9 uses key-file format:**
```bash
ls /etc/NetworkManager/system-connections/
cat /etc/NetworkManager/system-connections/enp0s3.nmconnection
```

**Example content:**
```ini
[connection]
id=enp0s3
type=ethernet
interface-name=enp0s3

[ipv4]
method=manual
address1=192.168.1.100/24,192.168.1.1
dns=8.8.8.8;

[ipv6]
method=auto
```
</details>

---

## Part 8: Exam Scenarios

### Question 21: Exam Scenario - Complete IPv4 Setup
**Task:** Configure a server with:
- Connection name: static-conn
- Device: enp0s3
- IP: 172.25.250.10/24
- Gateway: 172.25.250.254
- DNS: 172.25.250.254
- Make persistent across reboots

<details>
<summary>Show Solution</summary>

```bash
# Create or modify connection
sudo nmcli connection add \
    con-name static-conn \
    type ethernet \
    ifname enp0s3 \
    ipv4.method manual \
    ipv4.addresses 172.25.250.10/24 \
    ipv4.gateway 172.25.250.254 \
    ipv4.dns 172.25.250.254 \
    connection.autoconnect yes

# Activate
sudo nmcli connection up static-conn
```

**Verify:**
```bash
ip addr show enp0s3
nmcli connection show static-conn | grep ipv4
```
</details>

---

### Question 22: Exam Scenario - Dual Stack Configuration
**Task:** Configure both IPv4 and IPv6:
- IPv4: 192.168.1.50/24
- IPv6: fd00::50/64

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 \
    ipv4.method manual \
    ipv4.addresses 192.168.1.50/24 \
    ipv6.method manual \
    ipv6.addresses fd00::50/64

sudo nmcli connection up enp0s3
```

**Verify:**
```bash
ip addr show enp0s3
```
</details>

---

### Question 23: Exam Scenario - Change Existing Configuration
**Task:** Server has DHCP. Change to static IP 10.0.0.100/8 with gateway 10.0.0.1.

<details>
<summary>Show Solution</summary>

```bash
# Check current connection name
nmcli connection show

# Modify (assuming connection name is enp0s3)
sudo nmcli connection modify enp0s3 \
    ipv4.method manual \
    ipv4.addresses 10.0.0.100/8 \
    ipv4.gateway 10.0.0.1

# Apply
sudo nmcli connection up enp0s3
```
</details>

---

### Question 24: Verify Configuration Persistence
**Task:** Ensure network configuration survives reboot.

<details>
<summary>Show Solution</summary>

**Check autoconnect:**
```bash
nmcli connection show enp0s3 | grep autoconnect
```

**Enable autoconnect if needed:**
```bash
sudo nmcli connection modify enp0s3 connection.autoconnect yes
```

**Configuration files are automatically persistent when using nmcli modify.**
</details>

---

## Quick Reference

### View Network Info
```bash
ip addr                          # Show all IPs
ip -4 addr                       # IPv4 only
ip -6 addr                       # IPv6 only
nmcli connection show            # List connections
nmcli device status              # Device status
```

### Configure IPv4
```bash
# Static IP
nmcli con mod CONN ipv4.method manual
nmcli con mod CONN ipv4.addresses IP/PREFIX
nmcli con mod CONN ipv4.gateway GATEWAY
nmcli con mod CONN ipv4.dns DNS

# DHCP
nmcli con mod CONN ipv4.method auto
```

### Configure IPv6
```bash
# Static
nmcli con mod CONN ipv6.method manual
nmcli con mod CONN ipv6.addresses IP/PREFIX

# Auto (SLAAC)
nmcli con mod CONN ipv6.method auto

# Disable
nmcli con mod CONN ipv6.method disabled
```

### Manage Connections
```bash
nmcli con up CONN               # Activate
nmcli con down CONN             # Deactivate
nmcli con add con-name NAME ... # Create
nmcli con delete NAME           # Delete
nmcli con reload                # Reload files
```

### Common IPv4 Prefixes
| Prefix | Netmask | Hosts |
|--------|---------|-------|
| /8 | 255.0.0.0 | 16M |
| /16 | 255.255.0.0 | 65K |
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /30 | 255.255.255.252 | 2 |

---

## Summary

For the RHCSA exam, ensure you can:

1. **View network configuration** using `ip addr` and `nmcli`
2. **Configure static IPv4** with address, gateway, and DNS
3. **Configure static IPv6** addresses
4. **Switch between DHCP and static** configuration
5. **Create and delete connections** using `nmcli`
6. **Activate connections** using `nmcli connection up`
7. **Use nmtui** as an alternative to nmcli
8. **Ensure persistence** with connection.autoconnect
