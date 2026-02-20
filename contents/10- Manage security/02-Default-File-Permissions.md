# Manage Default File Permissions

## Overview

Default file permissions in Linux are controlled by the **umask** (user file-creation mask). Understanding umask is essential for the RHCSA exam as it determines the default permissions for newly created files and directories.

---

## Understanding Umask

### What is Umask?

The umask is a value that is **subtracted** from the system's default permissions to determine the actual permissions for new files and directories.

| Type | System Default | Calculation |
|------|----------------|-------------|
| **Directories** | 777 (rwxrwxrwx) | 777 - umask = default permission |
| **Files** | 666 (rw-rw-rw-) | 666 - umask = default permission |

> **Note**: Files don't get execute permission by default for security reasons.

### Common Umask Values

| Umask | Directory Permission | File Permission | Use Case |
|-------|---------------------|-----------------|----------|
| 022 | 755 (rwxr-xr-x) | 644 (rw-r--r--) | Standard for root user |
| 002 | 775 (rwxrwxr-x) | 664 (rw-rw-r--) | Standard for regular users |
| 077 | 700 (rwx------) | 600 (rw-------) | Maximum privacy |
| 027 | 750 (rwxr-x---) | 640 (rw-r-----) | Group collaboration |

---

## Working with Umask

### View Current Umask

```bash
# Display current umask (octal)
umask

# Display current umask (symbolic)
umask -S
```

**Example Output:**
```
$ umask
0022

$ umask -S
u=rwx,g=rx,o=rx
```

### Set Umask Temporarily

```bash
# Set umask for current session (octal)
umask 027

# Set umask for current session (symbolic)
umask u=rwx,g=rx,o=
```

### Set Umask Permanently

#### For a Specific User

Edit the user's shell profile:

```bash
# For bash users
echo "umask 027" >> ~/.bashrc

# For login shells
echo "umask 027" >> ~/.bash_profile
```

#### System-Wide for All Users

Edit `/etc/profile` or create a file in `/etc/profile.d/`:

```bash
# Create custom umask file
sudo vi /etc/profile.d/custom-umask.sh
```

Add:
```bash
# Set default umask for all users
umask 027
```

#### For Specific Services

Some services read umask from `/etc/login.defs`:

```bash
# Edit login.defs
sudo vi /etc/login.defs
```

Key directives:
```
UMASK           027
USERGROUPS_ENAB yes
```

---

## Calculating Permissions

### Method 1: Subtraction

```
Directory: 777 - 022 = 755 (rwxr-xr-x)
File:      666 - 022 = 644 (rw-r--r--)
```

### Method 2: Bit Masking (More Accurate)

The umask actually works by **masking out** (removing) permissions:

| Umask Bit | Removes Permission |
|-----------|-------------------|
| 0 | Nothing removed |
| 1 | Execute (x) removed |
| 2 | Write (w) removed |
| 4 | Read (r) removed |
| 7 | All (rwx) removed |

**Example with umask 027:**
```
Directory: 777 with mask 027
  Owner (0): 7 - nothing masked = 7 (rwx)
  Group (2): 7 - write masked = 5 (r-x)
  Other (7): 7 - all masked = 0 (---)
  Result: 750 (rwxr-x---)

File: 666 with mask 027
  Owner (0): 6 - nothing masked = 6 (rw-)
  Group (2): 6 - write masked = 4 (r--)
  Other (7): 6 - all masked = 0 (---)
  Result: 640 (rw-r-----)
```

---

## Verification Commands

### Test Umask Effect

```bash
# Set umask and test
umask 027

# Create test file
touch testfile

# Create test directory
mkdir testdir

# Check permissions
ls -l testfile testdir
```

**Expected Output:**
```
-rw-r-----. 1 user user    0 Jan 15 10:00 testfile
drwxr-x---. 2 user user 4096 Jan 15 10:00 testdir
```

---

## Practice Questions

### Question 1: View Current Umask
What commands display the current umask value in both octal and symbolic format?

<details>
<summary>Show Solution</summary>

```bash
# Octal format
umask

# Symbolic format
umask -S
```

</details>

---

### Question 2: Calculate File Permissions
If the umask is set to 037, what permissions will a newly created file have?

<details>
<summary>Show Solution</summary>

```
File default: 666
Umask:        037

Calculation:
  Owner (0): 6 - nothing masked = 6 (rw-)
  Group (3): 6 - write and execute masked = 4 (r--)
  Other (7): 6 - all masked = 0 (---)

Result: 640 (rw-r-----)
```

Verify:
```bash
umask 037
touch testfile
ls -l testfile
# Output: -rw-r-----
```

</details>

---

### Question 3: Calculate Directory Permissions
If the umask is set to 026, what permissions will a newly created directory have?

<details>
<summary>Show Solution</summary>

```
Directory default: 777
Umask:             026

Calculation:
  Owner (0): 7 - nothing masked = 7 (rwx)
  Group (2): 7 - write masked = 5 (r-x)
  Other (6): 7 - read and write masked = 1 (--x)

Result: 751 (rwxr-x--x)
```

Verify:
```bash
umask 026
mkdir testdir
ls -ld testdir
# Output: drwxr-x--x
```

</details>

---

### Question 4: Set Temporary Umask
Set the umask so that new files have permissions 640 and new directories have permissions 750.

<details>
<summary>Show Solution</summary>

```bash
# Calculate required umask:
# For directory 750: 777 - 750 = 027
# For file 640: 666 - 640 = 026
# Use the more restrictive: 027

umask 027

# Verify
touch file1
mkdir dir1
ls -l file1
ls -ld dir1
```

**Output:**
```
-rw-r-----. 1 user user    0 Jan 15 10:00 file1
drwxr-x---. 2 user user 4096 Jan 15 10:00 dir1
```

</details>

---

### Question 5: Set Permanent Umask for User
Configure the umask 077 permanently for user "developer" so all their new files are private.

<details>
<summary>Show Solution</summary>

```bash
# Switch to or edit the user's profile
sudo vi /home/developer/.bashrc

# Add at the end
umask 077

# Or use echo
sudo bash -c 'echo "umask 077" >> /home/developer/.bashrc'

# Test as the user
su - developer
umask
touch privatefile
ls -l privatefile
# Output: -rw-------
```

</details>

---

### Question 6: System-Wide Umask
Set a system-wide umask of 027 that applies to all users.

<details>
<summary>Show Solution</summary>

```bash
# Create a profile script
sudo vi /etc/profile.d/umask.sh

# Add content
umask 027

# Make it executable (usually not required but good practice)
sudo chmod +x /etc/profile.d/umask.sh

# Test by starting a new login shell
su - testuser
umask
# Output: 0027
```

</details>

---

### Question 7: Symbolic Umask
Set the umask using symbolic notation so that:
- Owner has full permissions
- Group has read and execute only
- Others have no permissions

<details>
<summary>Show Solution</summary>

```bash
# Symbolic umask (what permissions TO GRANT)
umask u=rwx,g=rx,o=

# Verify
umask
# Output: 0027

umask -S
# Output: u=rwx,g=rx,o=

# Test
mkdir testdir
ls -ld testdir
# Output: drwxr-x---
```

</details>

---

### Question 8: Restricted Umask in Script
Create a script that creates files with maximum restriction (only owner can read/write).

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash
# secure_script.sh

# Set restrictive umask
umask 077

# Create secure files
touch /tmp/secure_data.txt
mkdir /tmp/secure_dir

# Verify permissions
ls -l /tmp/secure_data.txt
ls -ld /tmp/secure_dir
```

```bash
# Make executable and run
chmod +x secure_script.sh
./secure_script.sh
```

**Output:**
```
-rw-------. 1 user user    0 Jan 15 10:00 /tmp/secure_data.txt
drwx------. 2 user user 4096 Jan 15 10:00 /tmp/secure_dir
```

</details>

---

## Quick Reference Table

| Task | Command |
|------|---------|
| View umask (octal) | `umask` |
| View umask (symbolic) | `umask -S` |
| Set umask temporarily | `umask 027` |
| Set umask symbolic | `umask u=rwx,g=rx,o=` |
| Permanent for user | Edit `~/.bashrc` |
| System-wide | Create `/etc/profile.d/umask.sh` |

---

## Common Umask Scenarios for RHCSA

| Requirement | Umask | File Result | Directory Result |
|------------|-------|-------------|------------------|
| Files readable by all, writable by owner | 022 | 644 | 755 |
| Files readable by group, not others | 027 | 640 | 750 |
| Files only accessible by owner | 077 | 600 | 700 |
| Group collaboration (group can write) | 002 | 664 | 775 |

---

## Summary

- **Umask** controls default permissions for new files and directories
- Files start with 666, directories with 777, minus the umask
- **Temporary**: Use `umask` command
- **Permanent (user)**: Add to `~/.bashrc`
- **Permanent (system)**: Add to `/etc/profile.d/`
- Common values: 022 (standard), 027 (secure), 077 (private)
