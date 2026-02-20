# Configure Privileged Access

## RHCSA Exam Objective
> Configure superuser access

---

## Introduction

Privileged access allows regular users to execute commands as root or another user. The RHCSA exam tests your ability to configure sudo access using the wheel group and sudoers configuration.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `sudo` | Execute command as another user |
| `visudo` | Safely edit sudoers file |
| `su` | Switch user |

## Key Files

| File | Purpose |
|------|---------|
| `/etc/sudoers` | Main sudo configuration |
| `/etc/sudoers.d/` | Additional sudo configurations |

---

## Part 1: Using sudo

### Question 1: Execute Command as Root
**Task:** Run a command with root privileges.

<details>
<summary>Show Solution</summary>

```bash
sudo command
```

**Example:**
```bash
sudo systemctl restart httpd
```
</details>

---

### Question 2: Open Root Shell
**Task:** Open an interactive root shell using sudo.

<details>
<summary>Show Solution</summary>

```bash
sudo -i
```

**Or:**
```bash
sudo su -
```

**Exit with:**
```bash
exit
```
</details>

---

### Question 3: Run Command as Another User
**Task:** Run command as user "webadmin".

<details>
<summary>Show Solution</summary>

```bash
sudo -u webadmin command
```

**Example:**
```bash
sudo -u webadmin whoami
```
</details>

---

### Question 4: Check sudo Privileges
**Task:** View what commands you can run with sudo.

<details>
<summary>Show Solution</summary>

```bash
sudo -l
```

**This lists allowed commands and restrictions.**
</details>

---

## Part 2: Adding Users to wheel Group

### Question 5: Grant sudo Access via wheel Group
**Task:** Give user "john" sudo privileges.

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -aG wheel john
```

**Verify:**
```bash
groups john
```

**The wheel group has sudo access by default in RHEL.**
</details>

---

### Question 6: Verify wheel Group Configuration
**Task:** Check that wheel group has sudo access.

<details>
<summary>Show Solution</summary>

```bash
sudo grep wheel /etc/sudoers
```

**Should show:**
```
%wheel  ALL=(ALL)       ALL
```
</details>

---

### Question 7: Create Admin User
**Task:** Create user "admin1" with full sudo privileges.

<details>
<summary>Show Solution</summary>

```bash
# Create user
sudo useradd admin1

# Set password
sudo passwd admin1

# Add to wheel group
sudo usermod -aG wheel admin1

# Verify
groups admin1
```
</details>

---

## Part 3: Editing sudoers File

### Question 8: Edit sudoers Safely
**Task:** Open sudoers file for editing.

<details>
<summary>Show Solution</summary>

```bash
sudo visudo
```

**Always use visudo - it validates syntax before saving.**
</details>

---

### Question 9: Grant Full sudo to User
**Task:** Give user "manager" full sudo access (not via wheel).

<details>
<summary>Show Solution</summary>

```bash
sudo visudo
```

**Add line:**
```
manager ALL=(ALL) ALL
```

**Format:**
```
USER HOST=(RUNAS) COMMANDS
```
</details>

---

### Question 10: Grant sudo Without Password
**Task:** Allow user "automation" to use sudo without password.

<details>
<summary>Show Solution</summary>

```bash
sudo visudo
```

**Add line:**
```
automation ALL=(ALL) NOPASSWD: ALL
```
</details>

---

### Question 11: Grant Specific Command Access
**Task:** Allow user "backup" to run only /usr/bin/rsync as root.

<details>
<summary>Show Solution</summary>

```bash
sudo visudo
```

**Add line:**
```
backup ALL=(ALL) /usr/bin/rsync
```
</details>

---

### Question 12: Grant Multiple Commands
**Task:** Allow user "webadmin" to manage httpd service.

<details>
<summary>Show Solution</summary>

```bash
sudo visudo
```

**Add line:**
```
webadmin ALL=(ALL) /usr/bin/systemctl start httpd, /usr/bin/systemctl stop httpd, /usr/bin/systemctl restart httpd
```
</details>

---

### Question 13: Grant Group sudo Access
**Task:** Allow group "dbadmins" to run all commands as root.

<details>
<summary>Show Solution</summary>

```bash
sudo visudo
```

**Add line (note % prefix for groups):**
```
%dbadmins ALL=(ALL) ALL
```
</details>

---

### Question 14: Grant Group Access Without Password
**Task:** Allow group "operators" to use sudo without password.

<details>
<summary>Show Solution</summary>

```bash
sudo visudo
```

**Add line:**
```
%operators ALL=(ALL) NOPASSWD: ALL
```
</details>

---

## Part 4: Using sudoers.d Directory

### Question 15: Create Drop-in Configuration
**Task:** Create separate sudo configuration for user "devops".

<details>
<summary>Show Solution</summary>

```bash
sudo visudo -f /etc/sudoers.d/devops
```

**Add content:**
```
devops ALL=(ALL) NOPASSWD: ALL
```

**Files in /etc/sudoers.d/ are included automatically.**
</details>

---

### Question 16: Create Group Configuration File
**Task:** Create sudo config for "webadmins" group.

<details>
<summary>Show Solution</summary>

```bash
sudo visudo -f /etc/sudoers.d/webadmins
```

**Add:**
```
%webadmins ALL=(ALL) /usr/bin/systemctl * httpd, /usr/bin/vim /etc/httpd/*
```
</details>

---

## Part 5: Using su

### Question 17: Switch to Root User
**Task:** Switch to root user.

<details>
<summary>Show Solution</summary>

```bash
su -
```

**Or:**
```bash
su - root
```

**Enter root password when prompted.**
</details>

---

### Question 18: Switch to Another User
**Task:** Switch to user "webadmin".

<details>
<summary>Show Solution</summary>

```bash
su - webadmin
```

**The `-` loads the user's environment.**
</details>

---

### Question 19: Run Command as Another User
**Task:** Run single command as user "dbadmin".

<details>
<summary>Show Solution</summary>

```bash
su - dbadmin -c "command"
```

**Example:**
```bash
su - dbadmin -c "whoami"
```
</details>

---

## Part 6: Exam Scenarios

### Question 20: Exam Scenario - Full Admin Access
**Task:** Create user "sysadmin" with full sudo privileges.

<details>
<summary>Show Solution</summary>

```bash
# Create user
sudo useradd sysadmin

# Set password
sudo passwd sysadmin

# Add to wheel group
sudo usermod -aG wheel sysadmin

# Verify
sudo -l -U sysadmin
```
</details>

---

### Question 21: Exam Scenario - Limited Access
**Task:** Allow user "netadmin" to run only networking commands:
- /usr/sbin/ip
- /usr/bin/nmcli

<details>
<summary>Show Solution</summary>

```bash
sudo visudo -f /etc/sudoers.d/netadmin
```

**Add:**
```
netadmin ALL=(ALL) /usr/sbin/ip, /usr/bin/nmcli
```
</details>

---

### Question 22: Exam Scenario - Service Account
**Task:** Create automation user that can run all commands without password.

<details>
<summary>Show Solution</summary>

```bash
# Create user
sudo useradd -r ansible

# Set password or SSH key
sudo passwd ansible

# Configure sudoers
sudo visudo -f /etc/sudoers.d/ansible
```

**Add:**
```
ansible ALL=(ALL) NOPASSWD: ALL
```
</details>

---

### Question 23: Exam Scenario - Delegate Administration
**Task:** Allow "hradmin" to manage only user accounts (useradd, usermod, userdel, passwd).

<details>
<summary>Show Solution</summary>

```bash
sudo visudo -f /etc/sudoers.d/hradmin
```

**Add:**
```
hradmin ALL=(ALL) /usr/sbin/useradd, /usr/sbin/usermod, /usr/sbin/userdel, /usr/bin/passwd
```
</details>

---

### Question 24: Verify User sudo Access
**Task:** Check if user "john" can use sudo.

<details>
<summary>Show Solution</summary>

```bash
# Check group membership
groups john | grep wheel

# Check sudo permissions
sudo -l -U john
```
</details>

---

## Quick Reference

### sudo Commands
```bash
sudo command            # Run as root
sudo -i                 # Root shell
sudo -u USER command    # Run as user
sudo -l                 # List permissions
sudo -l -U USER         # List user's permissions
```

### Granting sudo via wheel
```bash
usermod -aG wheel USER  # Add to wheel group
```

### sudoers Syntax
```
# Full access
USER ALL=(ALL) ALL

# Without password
USER ALL=(ALL) NOPASSWD: ALL

# Specific commands
USER ALL=(ALL) /path/to/command

# Group (use %)
%GROUP ALL=(ALL) ALL
```

### visudo
```bash
visudo                      # Edit /etc/sudoers
visudo -f /etc/sudoers.d/FILE  # Edit drop-in file
```

### su Commands
```bash
su -                    # Switch to root
su - USER               # Switch to user
su - USER -c "command"  # Run command as user
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Add users to wheel group** using `usermod -aG wheel`
2. **Edit sudoers safely** using `visudo`
3. **Grant full sudo access** with `USER ALL=(ALL) ALL`
4. **Grant passwordless sudo** with `NOPASSWD:`
5. **Grant specific command access** in sudoers
6. **Create drop-in files** in `/etc/sudoers.d/`
7. **Verify sudo access** using `sudo -l`
