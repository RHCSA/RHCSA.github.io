# Restrict Network Access Using firewall-cmd

## RHCSA Exam Objective
> Restrict network access using firewall-cmd

---

## Introduction

Firewalld is the default firewall management tool in RHEL 9. It uses zones to define trust levels for network connections. The RHCSA exam tests your ability to manage firewall rules using `firewall-cmd`.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `firewall-cmd` | Firewall management tool |
| `firewall-cmd --state` | Check if firewall is running |
| `firewall-cmd --list-all` | Show current configuration |
| `firewall-cmd --reload` | Reload firewall rules |

---

## Firewalld Concepts

### Zones
Zones define the trust level for network connections. Each zone has a default set of rules.

| Zone | Description |
|------|-------------|
| `public` | Default zone, untrusted networks |
| `trusted` | All traffic accepted |
| `drop` | Drop all incoming, no reply |
| `block` | Reject all incoming with ICMP reply |
| `work` | Trusted work network |
| `home` | Trusted home network |
| `internal` | Internal networks |
| `external` | External/masquerading |
| `dmz` | DMZ zone |

### Runtime vs Permanent
- **Runtime**: Changes apply immediately but are lost after reload/reboot
- **Permanent**: Changes saved to configuration, require reload to apply

**Always use `--permanent` and then `--reload` for persistent changes.**

---

## Part 1: Firewall Status and Basic Info

### Question 1: Check Firewall Status
**Task:** Verify if firewalld is running.

<details>
<summary>Show Solution</summary>

```bash
firewall-cmd --state
```

**Or:**
```bash
systemctl status firewalld
```
</details>

---

### Question 2: Start and Enable Firewall
**Task:** Start firewalld and enable it at boot.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl enable --now firewalld
```

**Verify:**
```bash
firewall-cmd --state
```
</details>

---

### Question 3: View Current Configuration
**Task:** Display all firewall settings for default zone.

<details>
<summary>Show Solution</summary>

```bash
firewall-cmd --list-all
```

**For specific zone:**
```bash
firewall-cmd --zone=public --list-all
```
</details>

---

### Question 4: List All Zones
**Task:** Show all available zones.

<details>
<summary>Show Solution</summary>

```bash
firewall-cmd --get-zones
```

**List active zones:**
```bash
firewall-cmd --get-active-zones
```
</details>

---

### Question 5: View Default Zone
**Task:** Show the default zone.

<details>
<summary>Show Solution</summary>

```bash
firewall-cmd --get-default-zone
```
</details>

---

## Part 2: Managing Services

### Question 6: List Allowed Services
**Task:** Show services allowed in current zone.

<details>
<summary>Show Solution</summary>

```bash
firewall-cmd --list-services
```
</details>

---

### Question 7: List All Available Services
**Task:** Show all services that can be added.

<details>
<summary>Show Solution</summary>

```bash
firewall-cmd --get-services
```
</details>

---

### Question 8: Add Service Permanently
**Task:** Allow HTTP traffic permanently.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

**Verify:**
```bash
firewall-cmd --list-services
```
</details>

---

### Question 9: Add Multiple Services
**Task:** Allow HTTP and HTTPS permanently.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-service=http --add-service=https
sudo firewall-cmd --reload
```

**Verify:**
```bash
firewall-cmd --list-services
```
</details>

---

### Question 10: Remove Service
**Task:** Remove HTTP from allowed services.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --remove-service=http
sudo firewall-cmd --reload
```
</details>

---

## Part 3: Managing Ports

### Question 11: Allow Specific Port
**Task:** Allow TCP port 8080 permanently.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

**Verify:**
```bash
firewall-cmd --list-ports
```
</details>

---

### Question 12: Allow Port Range
**Task:** Allow TCP ports 5000-5010.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-port=5000-5010/tcp
sudo firewall-cmd --reload
```
</details>

---

### Question 13: Allow UDP Port
**Task:** Allow UDP port 53 (DNS).

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-port=53/udp
sudo firewall-cmd --reload
```
</details>

---

### Question 14: Remove Port
**Task:** Remove TCP port 8080.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --remove-port=8080/tcp
sudo firewall-cmd --reload
```
</details>

---

### Question 15: List Allowed Ports
**Task:** Show all allowed ports.

<details>
<summary>Show Solution</summary>

```bash
firewall-cmd --list-ports
```
</details>

---

## Part 4: Managing Zones

### Question 16: Set Default Zone
**Task:** Change default zone to internal.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --set-default-zone=internal
```

**Verify:**
```bash
firewall-cmd --get-default-zone
```
</details>

---

### Question 17: Add Service to Specific Zone
**Task:** Add SSH to the internal zone.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --zone=internal --permanent --add-service=ssh
sudo firewall-cmd --reload
```
</details>

---

### Question 18: Assign Interface to Zone
**Task:** Assign interface enp0s3 to internal zone.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --zone=internal --permanent --add-interface=enp0s3
sudo firewall-cmd --reload
```

**Or via nmcli:**
```bash
sudo nmcli connection modify enp0s3 connection.zone internal
sudo nmcli connection up enp0s3
```
</details>

---

### Question 19: Check Interface Zone
**Task:** Find which zone interface enp0s3 belongs to.

<details>
<summary>Show Solution</summary>

```bash
firewall-cmd --get-zone-of-interface=enp0s3
```
</details>

---

## Part 5: Rich Rules

### Question 20: Add Rich Rule - Allow IP
**Task:** Allow all traffic from 192.168.1.100.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.100" accept'
sudo firewall-cmd --reload
```
</details>

---

### Question 21: Add Rich Rule - Block IP
**Task:** Block all traffic from 10.0.0.50.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.0.0.50" reject'
sudo firewall-cmd --reload
```
</details>

---

### Question 22: Add Rich Rule - Allow Service from Network
**Task:** Allow SSH only from 192.168.1.0/24 network.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" service name="ssh" accept'
sudo firewall-cmd --reload
```
</details>

---

### Question 23: Add Rich Rule - Allow Port from IP
**Task:** Allow TCP port 3306 from 10.0.0.10.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.0.0.10" port port="3306" protocol="tcp" accept'
sudo firewall-cmd --reload
```
</details>

---

### Question 24: List Rich Rules
**Task:** Show all rich rules.

<details>
<summary>Show Solution</summary>

```bash
firewall-cmd --list-rich-rules
```
</details>

---

### Question 25: Remove Rich Rule
**Task:** Remove a rich rule.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="192.168.1.100" accept'
sudo firewall-cmd --reload
```
</details>

---

## Part 6: Exam Scenarios

### Question 26: Exam Scenario - Web Server Firewall
**Task:** Configure firewall to allow HTTP and HTTPS traffic.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

# Verify
firewall-cmd --list-services
```
</details>

---

### Question 27: Exam Scenario - Custom Port
**Task:** Allow access to application running on TCP port 8443.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-port=8443/tcp
sudo firewall-cmd --reload

# Verify
firewall-cmd --list-ports
```
</details>

---

### Question 28: Exam Scenario - Database Access
**Task:** Allow MySQL (3306) only from IP 192.168.100.10.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.100.10" port port="3306" protocol="tcp" accept'
sudo firewall-cmd --reload

# Verify
firewall-cmd --list-rich-rules
```
</details>

---

### Question 29: Exam Scenario - Block Specific Host
**Task:** Block all traffic from 172.25.1.5.

<details>
<summary>Show Solution</summary>

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="172.25.1.5" drop'
sudo firewall-cmd --reload
```
</details>

---

### Question 30: Exam Scenario - Complete Setup
**Task:** Configure firewall for a web server:
1. Allow SSH
2. Allow HTTP and HTTPS
3. Allow port 8080
4. Block host 10.0.0.99

<details>
<summary>Show Solution</summary>

```bash
# Ensure firewalld is running
sudo systemctl enable --now firewalld

# Add services
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https

# Add port
sudo firewall-cmd --permanent --add-port=8080/tcp

# Block host
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.0.0.99" drop'

# Reload
sudo firewall-cmd --reload

# Verify
firewall-cmd --list-all
```
</details>

---

## Quick Reference

### Status and Info
```bash
firewall-cmd --state
firewall-cmd --get-default-zone
firewall-cmd --get-active-zones
firewall-cmd --list-all
firewall-cmd --list-services
firewall-cmd --list-ports
```

### Add/Remove Services
```bash
# Add service
firewall-cmd --permanent --add-service=SERVICE
firewall-cmd --reload

# Remove service
firewall-cmd --permanent --remove-service=SERVICE
firewall-cmd --reload
```

### Add/Remove Ports
```bash
# Add port
firewall-cmd --permanent --add-port=PORT/PROTOCOL
firewall-cmd --reload

# Remove port
firewall-cmd --permanent --remove-port=PORT/PROTOCOL
firewall-cmd --reload
```

### Rich Rules
```bash
# Allow IP
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="IP" accept'

# Block IP
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="IP" drop'

# Allow service from network
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="NETWORK" service name="SERVICE" accept'

# List rich rules
firewall-cmd --list-rich-rules
```

### Common Services
| Service | Port |
|---------|------|
| ssh | 22/tcp |
| http | 80/tcp |
| https | 443/tcp |
| dns | 53/tcp+udp |
| nfs | 2049/tcp |
| smtp | 25/tcp |
| mysql | 3306/tcp |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Check firewall status** using `firewall-cmd --state`
2. **Add/remove services** using `--add-service` and `--remove-service`
3. **Add/remove ports** using `--add-port` and `--remove-port`
4. **Use --permanent** for persistent changes
5. **Reload firewall** using `firewall-cmd --reload`
6. **Use rich rules** to allow/block specific IPs or networks
7. **Verify configuration** using `firewall-cmd --list-all`
