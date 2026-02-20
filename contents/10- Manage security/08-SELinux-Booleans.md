# Use Boolean Settings to Modify System SELinux Settings

## Overview

SELinux booleans are switches that enable or disable specific SELinux policy features without modifying or recompiling the policy. They provide a simple way to customize SELinux behavior for common scenarios. Understanding booleans is essential for the RHCSA exam.

---

## Understanding Booleans

### What Are SELinux Booleans?

- On/off switches for specific SELinux policy rules
- Allow customization without writing policy
- Can be changed temporarily or permanently
- Named descriptively (e.g., `httpd_can_network_connect`)

### Boolean States

| State | Meaning |
|-------|---------|
| `on` / `1` | Feature enabled |
| `off` / `0` | Feature disabled |

---

## Viewing Booleans

### List All Booleans

```bash
# List all booleans (simple)
getsebool -a

# List all booleans with descriptions
sudo semanage boolean -l

# Paged output
sudo semanage boolean -l | less
```

### Check Specific Boolean

```bash
# Check single boolean
getsebool httpd_can_network_connect

# Check multiple
getsebool httpd_can_network_connect httpd_enable_homedirs
```

**Output:**
```
httpd_can_network_connect --> off
httpd_enable_homedirs --> off
```

### Filter Booleans

```bash
# Find all httpd-related booleans
getsebool -a | grep httpd

# Find samba-related booleans
getsebool -a | grep samba

# Using semanage with descriptions
sudo semanage boolean -l | grep httpd
```

---

## Setting Booleans Temporarily

### Using setsebool

```bash
# Enable boolean (temporary, lost on reboot)
sudo setsebool httpd_can_network_connect on

# Disable boolean (temporary)
sudo setsebool httpd_can_network_connect off

# Using 1/0 instead of on/off
sudo setsebool httpd_can_network_connect 1
```

### Verify Change

```bash
getsebool httpd_can_network_connect
```

---

## Setting Booleans Permanently

### Using setsebool -P

```bash
# Enable boolean permanently
sudo setsebool -P httpd_can_network_connect on

# Disable boolean permanently
sudo setsebool -P httpd_can_network_connect off
```

> **Note**: The `-P` option makes the change persistent across reboots.

### Using semanage boolean

```bash
# Enable permanently with semanage
sudo semanage boolean -m --on httpd_can_network_connect

# Disable permanently with semanage
sudo semanage boolean -m --off httpd_can_network_connect
```

---

## Getting Boolean Descriptions

### View Description

```bash
# List booleans with full descriptions
sudo semanage boolean -l | grep -i "network connect"
```

**Output:**
```
httpd_can_network_connect      (off  ,  off)  Allow httpd to can network connect
```

### Interpreting Output

```
httpd_can_network_connect      (off  ,  off)
                                 │       │
                                 │       └── Default (policy) value
                                 └── Current value
```

---

## Common Booleans by Service

### Apache/HTTPD Booleans

| Boolean | Purpose |
|---------|---------|
| `httpd_can_network_connect` | Allow Apache to connect to any network port |
| `httpd_can_network_connect_db` | Allow connection to database ports |
| `httpd_can_sendmail` | Allow Apache to send mail |
| `httpd_enable_homedirs` | Allow serving user home directories |
| `httpd_unified` | Unify HTTPD handling of content |
| `httpd_can_network_relay` | Allow HTTP relay (proxy) |

### Samba Booleans

| Boolean | Purpose |
|---------|---------|
| `samba_enable_home_dirs` | Share user home directories |
| `samba_export_all_ro` | Export all files read-only |
| `samba_export_all_rw` | Export all files read-write |

### NFS Booleans

| Boolean | Purpose |
|---------|---------|
| `nfs_export_all_ro` | Export all files read-only |
| `nfs_export_all_rw` | Export all files read-write |

### FTP Booleans

| Boolean | Purpose |
|---------|---------|
| `ftpd_anon_write` | Allow anonymous FTP writes |
| `ftpd_full_access` | Allow full FTP access |
| `ftpd_use_nfs` | Allow FTP to use NFS |
| `ftpd_connect_all_unreserved` | Allow connections to all ports |

### Other Common Booleans

| Boolean | Purpose |
|---------|---------|
| `ssh_sysadm_login` | Allow sysadm_r users to SSH |
| `user_exec_content` | Allow users to execute in home/tmp |
| `virt_use_nfs` | Allow VMs to use NFS |
| `named_write_master_zones` | Allow DNS to write master zones |

---

## Troubleshooting with Booleans

### Finding Required Boolean

When SELinux blocks something, check logs:

```bash
# Check for AVC denials suggesting booleans
sudo ausearch -m avc -ts recent

# Use sealert for suggested fixes
sudo sealert -a /var/log/audit/audit.log | grep -A5 "boolean"
```

### Example: Apache Can't Connect to Network

**Error in audit log:**
```
avc: denied { name_connect } for pid=1234 comm="httpd" ... scontext=httpd_t
```

**Solution:**
```bash
# Enable network connections for Apache
sudo setsebool -P httpd_can_network_connect on
```

---

## Practice Questions

### Question 1: List All Booleans
What command lists all SELinux booleans and their current values?

<details>
<summary>Show Solution</summary>

```bash
# Simple list
getsebool -a

# With descriptions
sudo semanage boolean -l
```

</details>

---

### Question 2: Check Specific Boolean
Check if Apache is allowed to connect to network ports.

<details>
<summary>Show Solution</summary>

```bash
getsebool httpd_can_network_connect
```

**Output:**
```
httpd_can_network_connect --> off
```

If `off`, Apache cannot make outgoing network connections.

</details>

---

### Question 3: Enable Boolean Temporarily
Enable the `httpd_enable_homedirs` boolean without making it permanent.

<details>
<summary>Show Solution</summary>

```bash
# Enable temporarily (no -P flag)
sudo setsebool httpd_enable_homedirs on

# Verify
getsebool httpd_enable_homedirs
# Output: httpd_enable_homedirs --> on

# Note: Will revert to off after reboot
```

</details>

---

### Question 4: Enable Boolean Permanently
Allow Apache to connect to database servers, and make the change persistent.

<details>
<summary>Show Solution</summary>

```bash
# Enable permanently with -P
sudo setsebool -P httpd_can_network_connect_db on

# Verify
getsebool httpd_can_network_connect_db
# Output: httpd_can_network_connect_db --> on
```

</details>

---

### Question 5: Find HTTP-Related Booleans
List all SELinux booleans related to httpd/Apache.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Filter getsebool
getsebool -a | grep httpd

# Method 2: With descriptions
sudo semanage boolean -l | grep httpd
```

**Common output:**
```
httpd_can_network_connect --> off
httpd_can_network_connect_db --> off
httpd_can_sendmail --> off
httpd_enable_cgi --> on
httpd_enable_homedirs --> off
httpd_unified --> on
...
```

</details>

---

### Question 6: Configure Samba Home Directories
Allow Samba to share user home directories permanently.

<details>
<summary>Show Solution</summary>

```bash
# Enable home directory sharing
sudo setsebool -P samba_enable_home_dirs on

# Verify
getsebool samba_enable_home_dirs
# Output: samba_enable_home_dirs --> on
```

</details>

---

### Question 7: Allow Apache to Send Email
Configure SELinux so Apache/PHP can send emails.

<details>
<summary>Show Solution</summary>

```bash
# Enable mail sending
sudo setsebool -P httpd_can_sendmail on

# Verify
getsebool httpd_can_sendmail
```

</details>

---

### Question 8: Check Boolean Description
Find the description for `httpd_can_network_connect` boolean.

<details>
<summary>Show Solution</summary>

```bash
sudo semanage boolean -l | grep httpd_can_network_connect
```

**Output:**
```
httpd_can_network_connect      (off  ,  off)  Allow httpd to can network connect
```

The description shows this boolean allows Apache to make network connections.

</details>

---

### Question 9: Disable Boolean
An FTP server has been incorrectly configured to allow anonymous writes. Disable this feature.

<details>
<summary>Show Solution</summary>

```bash
# Disable anonymous FTP writes
sudo setsebool -P ftpd_anon_write off

# Verify
getsebool ftpd_anon_write
# Output: ftpd_anon_write --> off
```

</details>

---

### Question 10: Troubleshoot Apache Proxy
Apache is configured as a reverse proxy but connections are being blocked. Identify and fix the SELinux boolean.

<details>
<summary>Show Solution</summary>

```bash
# 1. Find relevant booleans
getsebool -a | grep -E "httpd.*(relay|network|proxy)"

# Likely candidates:
# httpd_can_network_connect
# httpd_can_network_relay

# 2. Enable network relay for proxying
sudo setsebool -P httpd_can_network_relay on

# 3. May also need general network connect
sudo setsebool -P httpd_can_network_connect on

# 4. Verify
getsebool httpd_can_network_relay httpd_can_network_connect

# 5. Restart Apache
sudo systemctl restart httpd
```

</details>

---

### Question 11: Multiple Booleans
Enable both `httpd_can_network_connect` and `httpd_can_sendmail` permanently in one command.

<details>
<summary>Show Solution</summary>

```bash
# Set multiple booleans at once
sudo setsebool -P httpd_can_network_connect on httpd_can_sendmail on

# Verify both
getsebool httpd_can_network_connect httpd_can_sendmail
```

</details>

---

### Question 12: View Local Modifications
List only the booleans that have been changed from their default values.

<details>
<summary>Show Solution</summary>

```bash
# Using semanage to see differences
sudo semanage boolean -l | grep -v "(.* , .*)"
# Shows where current != default

# Or look at the two values in parentheses
sudo semanage boolean -l | awk '$3 != $5'

# Simpler: look for mismatched values
sudo semanage boolean -l | grep -E "\(on.*off\)|\(off.*on\)"
```

Format: `(current, default)` - when different, it's been modified.

</details>

---

### Question 13: Allow FTP Access to Home Directories
**Task:** SELinux is preventing FTP service from accessing user home directories. Diagnose and fix this issue permanently.

<details>
<summary>Show Solution</summary>

```bash
# 1. Check audit log for denials
sudo ausearch -m avc -ts recent | grep ftp

# 2. List FTP-related booleans
getsebool -a | grep ftp

# 3. Enable FTP home directory access
sudo setsebool -P ftpd_full_access on

# Or more specifically:
sudo setsebool -P ftp_home_dir on

# 4. Verify
getsebool ftpd_full_access ftp_home_dir
```

</details>

---

### Question 14: Diagnose SELinux Denial with sealert
**Task:** Apache is failing to access a file. Use SELinux troubleshooting tools to diagnose and get fix suggestions.

<details>
<summary>Show Solution</summary>

```bash
# 1. Check for recent AVC denials
sudo ausearch -m avc -ts today

# 2. Use sealert for detailed analysis and suggestions
sudo sealert -a /var/log/audit/audit.log

# 3. Look for specific httpd denials
sudo ausearch -m avc -c httpd

# 4. Apply suggested fix (example output might suggest):
# sudo setsebool -P httpd_can_network_connect on
# or
# sudo restorecon -Rv /var/www/html
```

**Install setroubleshoot if not present:**
```bash
sudo dnf install setroubleshoot-server
```

</details>

---

## Quick Reference

| Task | Command |
|------|---------|
| List all booleans | `getsebool -a` |
| List with descriptions | `sudo semanage boolean -l` |
| Check specific boolean | `getsebool boolean_name` |
| Enable temporarily | `sudo setsebool boolean_name on` |
| Enable permanently | `sudo setsebool -P boolean_name on` |
| Disable temporarily | `sudo setsebool boolean_name off` |
| Disable permanently | `sudo setsebool -P boolean_name off` |
| Search booleans | `getsebool -a \| grep pattern` |

---

## Boolean Value Syntax

| Setting | Meaning |
|---------|---------|
| `on` | Enable |
| `off` | Disable |
| `1` | Enable |
| `0` | Disable |
| `true` | Enable |
| `false` | Disable |

---

## Commands Summary

| Command | Purpose |
|---------|---------|
| `getsebool` | View boolean values |
| `setsebool` | Change boolean values |
| `semanage boolean -l` | List booleans with descriptions |
| `semanage boolean -m` | Modify boolean (alternative to setsebool) |

---

## Summary

- **Booleans** are on/off switches for SELinux policy features
- **getsebool -a** lists all booleans and their values
- **getsebool name** checks a specific boolean
- **setsebool name on/off** changes temporarily
- **setsebool -P name on/off** changes permanently
- **semanage boolean -l** shows descriptions
- Use grep to filter booleans by service (e.g., `httpd`, `samba`)
- When troubleshooting, check audit logs for suggested booleans
- Common booleans control network access, home directories, and file sharing
