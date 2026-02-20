# List and Identify SELinux File and Process Context

## Overview

SELinux uses security contexts (labels) to determine what actions are permitted. Every file, process, port, and user has an SELinux context. Understanding how to view and interpret these contexts is essential for the RHCSA exam.

---

## SELinux Context Format

### Context Structure

SELinux contexts have four parts:

```
user:role:type:level
```

| Field | Description | Example |
|-------|-------------|---------|
| **User** | SELinux user identity | `system_u`, `unconfined_u` |
| **Role** | SELinux role | `object_r`, `system_r` |
| **Type** | Type (most important for targeted policy) | `httpd_sys_content_t` |
| **Level** | MLS/MCS security level | `s0`, `s0:c0.c1023` |

> **RHCSA Focus**: The **type** field is most important for troubleshooting on RHEL systems using the "targeted" policy.

### Example Context

```
system_u:object_r:httpd_sys_content_t:s0
   │        │            │            │
   │        │            │            └── Level (MLS)
   │        │            └── Type (MOST IMPORTANT)
   │        └── Role
   └── User
```

---

## Viewing File Contexts

### List Files with SELinux Context

```bash
# Show SELinux context with ls
ls -Z

# Long listing with context
ls -lZ

# Show context of specific file
ls -Z /etc/passwd

# Show context of directory
ls -dZ /var/www/html
```

**Example Output:**
```
$ ls -lZ /var/www/html/index.html
-rw-r--r--. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html/index.html
```

### Recursive Listing

```bash
# Show all files recursively with context
ls -lRZ /var/www/

# Find files with specific context type
find /var -context "*httpd*" 2>/dev/null
```

---

## Viewing Process Contexts

### List Processes with SELinux Context

```bash
# Show all processes with SELinux context
ps -eZ

# Show specific process
ps -Z -p $(pgrep httpd)

# Filter by context type
ps -eZ | grep httpd_t
```

**Example Output:**
```
$ ps -eZ | grep httpd
system_u:system_r:httpd_t:s0     1234 ?        00:00:01 httpd
```

### Understanding Process Types

| Process | Expected Type | Description |
|---------|--------------|-------------|
| Apache/httpd | `httpd_t` | Web server process |
| SSH daemon | `sshd_t` | SSH server |
| MariaDB/MySQL | `mysqld_t` | Database server |
| Named/BIND | `named_t` | DNS server |
| Postfix | `postfix_*` | Mail server |

---

## Viewing User Contexts

### Current User Context

```bash
# Show current user's SELinux context
id -Z
```

**Output:**
```
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

### All Logged-in Users

```bash
# Show SELinux context for all users
ps -eZ | grep -E "bash|sh$"
```

---

## Important Context Types

### Common File Types

| Type | Purpose | Location |
|------|---------|----------|
| `httpd_sys_content_t` | Web content (read-only) | `/var/www/html/` |
| `httpd_sys_rw_content_t` | Web content (read-write) | Web app data |
| `sshd_key_t` | SSH keys | `/etc/ssh/` |
| `etc_t` | Config files | `/etc/` |
| `var_log_t` | Log files | `/var/log/` |
| `tmp_t` | Temporary files | `/tmp/` |
| `user_home_t` | User home files | `/home/user/` |
| `home_root_t` | Root home files | `/root/` |
| `default_t` | Unlabeled/generic | Various |

### Common Process Types

| Type | Process |
|------|---------|
| `httpd_t` | Apache web server |
| `sshd_t` | SSH daemon |
| `mysqld_t` | MySQL/MariaDB |
| `named_t` | DNS server |
| `ftpd_t` | FTP server |
| `unconfined_t` | Unconfined processes |

---

## Using semanage for Context Information

### View File Context Rules

```bash
# List all file context rules
sudo semanage fcontext -l

# Filter for specific path
sudo semanage fcontext -l | grep "/var/www"

# Filter for specific type
sudo semanage fcontext -l | grep httpd_sys_content_t
```

### View Default Context for Path

```bash
# See what context should be applied
matchpathcon /var/www/html/index.html
```

**Output:**
```
/var/www/html/index.html    system_u:object_r:httpd_sys_content_t:s0
```

---

## Common Context Scenarios

### Web Server Content

```bash
# Check web content context
ls -lZ /var/www/html/
```

**Expected:**
```
-rw-r--r--. root root system_u:object_r:httpd_sys_content_t:s0 index.html
```

### SSH Files

```bash
# Check SSH directory context
ls -lZ /etc/ssh/
ls -lZ ~/.ssh/
```

### Custom Application Directories

```bash
# If you create custom directories, they may have wrong context
ls -dZ /myapp/
# May show: default_t or unlabeled_t (WRONG for web content!)
```

---

## Practice Questions

### Question 1: View File SELinux Context
Display the SELinux context for `/etc/passwd`.

<details>
<summary>Show Solution</summary>

```bash
ls -Z /etc/passwd
```

**Output:**
```
system_u:object_r:passwd_file_t:s0 /etc/passwd
```

</details>

---

### Question 2: View Directory Context
Display the SELinux context for the `/var/www/html` directory itself (not its contents).

<details>
<summary>Show Solution</summary>

```bash
# Use -d to show directory, not contents
ls -dZ /var/www/html

# Or with long listing
ls -ldZ /var/www/html
```

**Output:**
```
drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html
```

</details>

---

### Question 3: View Process Context
Show the SELinux context for the sshd process.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Filter ps output
ps -eZ | grep sshd

# Method 2: Use pgrep
ps -Z -p $(pgrep -o sshd)
```

**Output:**
```
system_u:system_r:sshd_t:s0-s0:c0.c1023  1234 ?  00:00:00 sshd
```

</details>

---

### Question 4: View Current User Context
What command shows your current SELinux user context?

<details>
<summary>Show Solution</summary>

```bash
id -Z
```

**Output (regular user):**
```
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

**Output (system service):**
```
system_u:system_r:service_t:s0
```

</details>

---

### Question 5: List All Files with Context
List all files in `/etc/ssh/` showing their SELinux contexts with detailed information.

<details>
<summary>Show Solution</summary>

```bash
ls -laZ /etc/ssh/
```

**Output:**
```
drwxr-xr-x. root root system_u:object_r:etc_t:s0        .
drwxr-xr-x. root root system_u:object_r:etc_t:s0        ..
-rw-r--r--. root root system_u:object_r:etc_t:s0        moduli
-rw-r--r--. root root system_u:object_r:etc_t:s0        ssh_config
-rw-------. root root system_u:object_r:sshd_key_t:s0   ssh_host_ed25519_key
-rw-r--r--. root root system_u:object_r:sshd_key_t:s0   ssh_host_ed25519_key.pub
-rw-------. root root system_u:object_r:sshd_key_t:s0   ssh_host_rsa_key
-rw-r--r--. root root system_u:object_r:sshd_key_t:s0   ssh_host_rsa_key.pub
-rw-------. root root system_u:object_r:etc_t:s0        sshd_config
```

</details>

---

### Question 6: Identify the Type Field
In the context `system_u:object_r:httpd_sys_content_t:s0`, identify each field.

<details>
<summary>Show Solution</summary>

```
system_u:object_r:httpd_sys_content_t:s0
    │        │            │            │
    │        │            │            └── Level: s0 (MLS sensitivity)
    │        │            │
    │        │            └── Type: httpd_sys_content_t
    │        │                      (Web content readable by Apache)
    │        │
    │        └── Role: object_r (role for files/objects)
    │
    └── User: system_u (system user)
```

**Key for troubleshooting**: The **type** (`httpd_sys_content_t`) is most important!

</details>

---

### Question 7: Find Expected Context
What should be the default SELinux context for `/var/www/html/newpage.html`?

<details>
<summary>Show Solution</summary>

```bash
# Check the expected context
matchpathcon /var/www/html/newpage.html
```

**Output:**
```
/var/www/html/newpage.html    system_u:object_r:httpd_sys_content_t:s0
```

The expected type is `httpd_sys_content_t`.

</details>

---

### Question 8: Find Apache Process Type
Verify that the Apache web server is running with the correct SELinux context.

<details>
<summary>Show Solution</summary>

```bash
# Find Apache processes
ps -eZ | grep httpd
```

**Expected Output:**
```
system_u:system_r:httpd_t:s0    1234 ?    00:00:01 httpd
system_u:system_r:httpd_t:s0    1235 ?    00:00:00 httpd
```

The type should be `httpd_t` for proper SELinux confinement.

</details>

---

### Question 9: Compare Actual vs Expected Context
A file `/var/www/html/app/data.txt` was created by copying from `/tmp`. Check if it has the correct context.

<details>
<summary>Show Solution</summary>

```bash
# Check actual context
ls -Z /var/www/html/app/data.txt

# Check expected context
matchpathcon /var/www/html/app/data.txt

# Compare them
```

**Likely issue:**
```
# Actual (wrong - inherited from /tmp):
-rw-r--r--. user user unconfined_u:object_r:tmp_t:s0 data.txt

# Expected (correct):
/var/www/html/app/data.txt    system_u:object_r:httpd_sys_content_t:s0
```

The file has `tmp_t` instead of `httpd_sys_content_t` - Apache cannot read it!

</details>

---

### Question 10: List File Context Rules
Show the SELinux file context rules that apply to the `/var/www` directory.

<details>
<summary>Show Solution</summary>

```bash
# List all rules for /var/www
sudo semanage fcontext -l | grep "^/var/www"
```

**Output:**
```
/var/www(/.*)?           all files    system_u:object_r:httpd_sys_content_t:s0
/var/www/cgi-bin(/.*)?   all files    system_u:object_r:httpd_sys_script_exec_t:s0
/var/www/html(/.*)?      all files    system_u:object_r:httpd_sys_content_t:s0
/var/www/icons(/.*)?     all files    system_u:object_r:httpd_sys_content_t:s0
```

</details>

---

## Quick Reference

| Task | Command |
|------|---------|
| List files with context | `ls -Z` |
| Long listing with context | `ls -lZ` |
| Directory context only | `ls -dZ /path` |
| Process contexts | `ps -eZ` |
| Specific process | `ps -Z -p PID` |
| Current user context | `id -Z` |
| Expected context | `matchpathcon /path` |
| List context rules | `semanage fcontext -l` |

---

## Context Components Summary

| Component | Common Values | Notes |
|-----------|--------------|-------|
| **User** | `system_u`, `unconfined_u` | SELinux user (not Linux user) |
| **Role** | `object_r`, `system_r` | Roles for RBAC |
| **Type** | `httpd_sys_content_t`, `etc_t` | **Most important for targeted policy** |
| **Level** | `s0`, `s0:c0.c1023` | MLS security level |

---

## Summary

- View file contexts with `ls -Z` or `ls -lZ`
- View process contexts with `ps -eZ`
- View current user context with `id -Z`
- The **type** field is most important for troubleshooting
- Use `matchpathcon` to see expected context for a path
- Use `semanage fcontext -l` to view context rules
- Files copied/moved may have incorrect contexts
