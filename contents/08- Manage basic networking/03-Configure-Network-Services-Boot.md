# Configure Network Services to Start Automatically at Boot

## RHCSA Exam Objective
> Configure network services to start automatically at boot

---

## Introduction

This topic focuses on ensuring network connections start automatically at boot using NetworkManager's autoconnect feature. For enabling services with `systemctl enable`, see [Section 07-02: Start and Stop Services](../07-%20Deploy,%20configure,%20and%20maintain%20systems/02-Start-Stop-Services.md).

---

## Part 1: Network Connection Autoconnect

### Question 1: Check Autoconnect Status
**Task:** Check if connection enp0s3 starts automatically at boot.

<details>
<summary>Show Solution</summary>

```bash
nmcli connection show enp0s3 | grep autoconnect
```

**Look for:**
```
connection.autoconnect:   yes
```
</details>

---

### Question 2: Enable Autoconnect
**Task:** Configure connection enp0s3 to start automatically at boot.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 connection.autoconnect yes
```
</details>

---

### Question 3: Disable Autoconnect
**Task:** Prevent connection from starting automatically.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 connection.autoconnect no
```
</details>

---

### Question 4: Set Autoconnect Priority
**Task:** Set connection priority (higher number = higher priority).

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 connection.autoconnect-priority 100
```

**If multiple connections can activate on same device, highest priority wins.**
</details>

---

### Question 5: Check Autoconnect for All Connections
**Task:** View autoconnect status for all connections.

<details>
<summary>Show Solution</summary>

```bash
nmcli -f NAME,AUTOCONNECT connection show
```
</details>

---

## Part 2: Exam Scenarios

### Question 6: Exam Scenario - Ensure Network at Boot
**Task:** Configure connection enp0s3 to activate automatically after reboot.

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify enp0s3 connection.autoconnect yes
```

**Verify:**
```bash
nmcli connection show enp0s3 | grep autoconnect
```
</details>

---

### Question 7: Exam Scenario - Multiple Connections
**Task:** Configure "office" connection as primary (activates first).

<details>
<summary>Show Solution</summary>

```bash
sudo nmcli connection modify office connection.autoconnect yes
sudo nmcli connection modify office connection.autoconnect-priority 100
```
</details>

---

### Question 8: Exam Scenario - Complete Boot Setup
**Task:** After configuring IP settings, ensure connection activates at boot.

<details>
<summary>Show Solution</summary>

```bash
# Configure IP (example)
sudo nmcli connection modify enp0s3 \
    ipv4.method manual \
    ipv4.addresses 192.168.1.100/24 \
    ipv4.gateway 192.168.1.1 \
    connection.autoconnect yes

# Activate
sudo nmcli connection up enp0s3
```
</details>

---

## Quick Reference

### Connection Autoconnect
```bash
# Check autoconnect
nmcli con show CONN | grep autoconnect

# Enable autoconnect
nmcli con mod CONN connection.autoconnect yes

# Disable autoconnect  
nmcli con mod CONN connection.autoconnect no

# Set priority
nmcli con mod CONN connection.autoconnect-priority NUMBER
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Check autoconnect status** using `nmcli connection show`
2. **Enable autoconnect** using `nmcli connection modify ... connection.autoconnect yes`
3. **Set priority** for multiple connections
4. **Note:** For enabling services at boot, use `systemctl enable` (covered in Section 07)
