# Configure Hostname Resolution

## RHCSA Exam Objective
> Configure hostname resolution

---

## Introduction

Hostname resolution converts hostnames to IP addresses. The RHCSA exam tests your ability to set the system hostname and configure local name resolution using /etc/hosts. DNS server configuration is covered in the IP addressing topic.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `hostnamectl` | View/set hostname |
| `hostname` | Display hostname |
| `getent hosts` | Query name resolution |

## Key Files

| File | Purpose |
|------|---------|
| `/etc/hostname` | Persistent hostname |
| `/etc/hosts` | Local static name resolution |
| `/etc/nsswitch.conf` | Name service switch configuration |

---

## Part 1: Setting the Hostname

### Question 1: View Current Hostname
**Task:** Display the current system hostname.

<details>
<summary>Show Solution</summary>

```bash
hostnamectl
```

**Or just the hostname:**
```bash
hostname
```

**Or:**
```bash
hostnamectl hostname
```
</details>

---

### Question 2: Set Static Hostname
**Task:** Set the hostname to server1.example.com.

<details>
<summary>Show Solution</summary>

```bash
sudo hostnamectl set-hostname server1.example.com
```

**Verify:**
```bash
hostnamectl
cat /etc/hostname
```

**Changes are immediate and persistent.**
</details>

---

### Question 3: Set Hostname Using nmtui
**Task:** Set hostname using text interface.

<details>
<summary>Show Solution</summary>

```bash
sudo nmtui
```

**Select "Set system hostname" and enter the new hostname.**
</details>

---

### Question 4: View Hostname File
**Task:** Check the persistent hostname configuration.

<details>
<summary>Show Solution</summary>

```bash
cat /etc/hostname
```

**This file contains just the hostname:**
```
server1.example.com
```
</details>

---

### Question 5: Set Hostname Temporarily
**Task:** Change hostname until next reboot (non-persistent).

<details>
<summary>Show Solution</summary>

```bash
sudo hostname tempname.example.com
```

**Note:** This does not modify /etc/hostname. Use `hostnamectl set-hostname` for persistent changes.
</details>

---

## Part 2: Local Name Resolution with /etc/hosts

### Question 6: View /etc/hosts File
**Task:** Display current static host entries.

<details>
<summary>Show Solution</summary>

```bash
cat /etc/hosts
```

**Default content:**
```
127.0.0.1   localhost localhost.localdomain
::1         localhost localhost.localdomain
```
</details>

---

### Question 7: Add Static Host Entry
**Task:** Add entry mapping server2.example.com to 192.168.1.20.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/hosts
```

**Add line:**
```
192.168.1.20    server2.example.com server2
```

**Format:**
```
IP_ADDRESS    FQDN    ALIAS(es)
```
</details>

---

### Question 8: Add Multiple Host Entries
**Task:** Add entries for web and database servers.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/hosts
```

**Add:**
```
192.168.1.10    web.example.com web
192.168.1.11    db.example.com db database
192.168.1.12    app.example.com app
```
</details>

---

### Question 9: Add IPv6 Host Entry
**Task:** Add IPv6 entry for server3.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/hosts
```

**Add:**
```
2001:db8::3    server3.example.com server3
```
</details>

---

### Question 10: Test Name Resolution
**Task:** Verify that hostname resolves correctly.

<details>
<summary>Show Solution</summary>

```bash
getent hosts server2.example.com
```

**Or:**
```bash
ping -c 1 server2.example.com
```

**Or:**
```bash
host server2.example.com
```
</details>

---

### Question 11: Add Entry for Own Hostname
**Task:** Add /etc/hosts entry for local server.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/hosts
```

**Add (replace with actual IP):**
```
192.168.1.100    server1.example.com server1
```

**Complete /etc/hosts example:**
```
127.0.0.1       localhost localhost.localdomain
::1             localhost localhost.localdomain
192.168.1.100   server1.example.com server1
```
</details>

---

## Part 3: Name Resolution Order

### Question 12: View Name Service Switch Configuration
**Task:** Check the order of name resolution sources.

<details>
<summary>Show Solution</summary>

```bash
cat /etc/nsswitch.conf | grep hosts
```

**Output:**
```
hosts:      files dns myhostname
```

**Order:**
1. `files` - /etc/hosts (checked first)
2. `dns` - DNS servers
3. `myhostname` - local hostname resolution
</details>

---

## Part 4: Exam Scenarios

### Question 13: Exam Scenario - Set FQDN Hostname
**Task:** Set the system hostname to node1.lab.example.com.

<details>
<summary>Show Solution</summary>

```bash
sudo hostnamectl set-hostname node1.lab.example.com
```

**Verify:**
```bash
hostnamectl
hostname
```

**Check persistence:**
```bash
cat /etc/hostname
```
</details>

---

### Question 14: Exam Scenario - Configure Host Resolution
**Task:** Configure system so that:
- server1.example.com resolves to 192.168.0.1
- server2.example.com resolves to 192.168.0.2

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/hosts
```

**Add:**
```
192.168.0.1    server1.example.com server1
192.168.0.2    server2.example.com server2
```

**Verify:**
```bash
getent hosts server1.example.com
getent hosts server2.example.com
```
</details>

---

### Question 15: Exam Scenario - Complete Setup
**Task:** 
1. Set hostname to webserver.company.com
2. Add /etc/hosts entry for the local system with IP 10.0.0.10

<details>
<summary>Show Solution</summary>

```bash
# Set hostname
sudo hostnamectl set-hostname webserver.company.com

# Edit /etc/hosts
sudo vi /etc/hosts
```

**Add to /etc/hosts:**
```
10.0.0.10    webserver.company.com webserver
```

**Verify:**
```bash
hostname
getent hosts webserver.company.com
```
</details>

---

### Question 16: Exam Scenario - Resolve Remote Host
**Task:** Add entry so "dbserver" resolves to 172.25.250.11.

<details>
<summary>Show Solution</summary>

```bash
echo "172.25.250.11    dbserver.example.com dbserver" | sudo tee -a /etc/hosts
```

**Or edit manually:**
```bash
sudo vi /etc/hosts
```

**Add:**
```
172.25.250.11    dbserver.example.com dbserver
```
</details>

---

### Question 17: Verify All Host Entries
**Task:** List all entries from /etc/hosts.

<details>
<summary>Show Solution</summary>

```bash
getent hosts
```

**Or:**
```bash
cat /etc/hosts | grep -v "^#" | grep -v "^$"
```
</details>

---

## Quick Reference

### Hostname Commands
```bash
# View hostname
hostnamectl
hostname

# Set hostname (persistent)
hostnamectl set-hostname HOSTNAME

# View hostname file
cat /etc/hostname
```

### /etc/hosts Format
```
# IP_ADDRESS    FQDN              ALIAS
127.0.0.1      localhost         localhost.localdomain
192.168.1.10   server.example.com server
```

### Test Resolution
```bash
getent hosts HOSTNAME
ping -c 1 HOSTNAME
host HOSTNAME
```

### Resolution Order
```
/etc/nsswitch.conf:
hosts: files dns myhostname
       ^     ^    ^
       |     |    +-- local hostname
       |     +------- DNS servers
       +------------- /etc/hosts (first)
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **View hostname** using `hostnamectl` or `hostname`
2. **Set hostname persistently** using `hostnamectl set-hostname`
3. **Edit /etc/hosts** to add static name resolution entries
4. **Use correct format** in /etc/hosts (IP FQDN alias)
5. **Test resolution** using `getent hosts` or `ping`
6. **Understand resolution order** - /etc/hosts is checked before DNS
