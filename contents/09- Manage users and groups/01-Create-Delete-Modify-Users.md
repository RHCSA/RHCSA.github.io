# Create, Delete, and Modify Local User Accounts

## RHCSA Exam Objective
> Create, delete, and modify local user accounts

---

## Introduction

User management is a fundamental RHCSA skill. You must be able to create users with specific attributes, modify existing users, and delete user accounts. This topic focuses on the `useradd`, `usermod`, and `userdel` commands.

**Note:** For group membership management (adding users to groups, changing primary groups), see [03-Groups-Memberships.md](03-Groups-Memberships.md).

---

## Key Commands

| Command | Description |
|---------|-------------|
| `useradd` | Create a new user |
| `usermod` | Modify an existing user |
| `userdel` | Delete a user |
| `id` | Display user/group IDs |
| `getent passwd` | Query user database |

## Key Files

| File | Purpose |
|------|---------|
| `/etc/passwd` | User account information |
| `/etc/shadow` | Encrypted passwords |
| `/etc/login.defs` | Default user settings |
| `/etc/default/useradd` | useradd defaults |
| `/etc/skel/` | Skeleton directory for new users |

---

## Part 1: Creating Users

### Question 1: Create Basic User
**Task:** Create a user named "john".

<details>
<summary>Show Solution</summary>

```bash
sudo useradd john
```

**Verify:**
```bash
id john
getent passwd john
```
</details>

---

### Question 2: Create User with Specific UID
**Task:** Create user "sarah" with UID 2000.

<details>
<summary>Show Solution</summary>

```bash
sudo useradd -u 2000 sarah
```

**Verify:**
```bash
id sarah
```

**Output:**
```
uid=2000(sarah) gid=2000(sarah) groups=2000(sarah)
```
</details>

---

### Question 3: Create User with Home Directory
**Task:** Create user "mike" ensuring home directory is created.

<details>
<summary>Show Solution</summary>

```bash
sudo useradd -m mike
```

**Note:** On RHEL, `-m` is default. Use `-M` to NOT create home directory.

**Verify:**
```bash
ls -la /home/mike
```
</details>

---

### Question 4: Create User with Custom Home Directory
**Task:** Create user "webapp" with home directory /opt/webapp.

<details>
<summary>Show Solution</summary>

```bash
sudo useradd -m -d /opt/webapp webapp
```

**Verify:**
```bash
getent passwd webapp
ls -la /opt/webapp
```
</details>

---

### Question 5: Create User with Specific Shell
**Task:** Create user "admin1" with /bin/bash as login shell.

<details>
<summary>Show Solution</summary>

```bash
sudo useradd -s /bin/bash admin1
```

**Verify:**
```bash
getent passwd admin1 | cut -d: -f7
```
</details>

---

### Question 6: Create User with No Login Shell
**Task:** Create system user "svcaccount" that cannot log in.

<details>
<summary>Show Solution</summary>

```bash
sudo useradd -s /sbin/nologin svcaccount
```

**Or:**
```bash
sudo useradd -s /bin/false svcaccount
```
</details>

---

### Question 7: Create User with Comment
**Task:** Create user "jdoe" with full name "John Doe".

<details>
<summary>Show Solution</summary>

```bash
sudo useradd -c "John Doe" jdoe
```

**Verify:**
```bash
getent passwd jdoe
```

**Output:**
```
jdoe:x:1001:1001:John Doe:/home/jdoe:/bin/bash
```
</details>

---

### Question 8: Create User with Specific Primary Group
**Task:** Create user "devuser" with primary group "developers".

<details>
<summary>Show Solution</summary>

```bash
# First ensure group exists
sudo groupadd developers

# Create user with primary group
sudo useradd -g developers devuser
```

**Verify:**
```bash
id devuser
```
</details>

---

### Question 9: Create User with Multiple Options
**Task:** Create user with:
- Username: testuser
- UID: 3000
- Home: /home/testuser
- Shell: /bin/bash
- Comment: "Test User"

<details>
<summary>Show Solution</summary>

```bash
sudo useradd -u 3000 -m -d /home/testuser -s /bin/bash -c "Test User" testuser
```

**Verify:**
```bash
id testuser
getent passwd testuser
```
</details>

---

### Question 10: Create System User
**Task:** Create system user "mysvc" for a service.

<details>
<summary>Show Solution</summary>

```bash
sudo useradd -r -s /sbin/nologin mysvc
```

**Options:**
- `-r`: System account (UID below 1000)
- `-s /sbin/nologin`: No interactive login
</details>

---

## Part 2: Modifying Users

### Question 11: Change User's Login Shell
**Task:** Change shell for user "john" to /bin/zsh.

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -s /bin/zsh john
```

**Verify:**
```bash
getent passwd john | cut -d: -f7
```
</details>

---

### Question 12: Change User's Home Directory
**Task:** Change home directory of "mike" to /home/mike_new.

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -d /home/mike_new mike
```

**Move existing home directory contents:**
```bash
sudo usermod -d /home/mike_new -m mike
```
</details>

---

### Question 13: Change User's UID
**Task:** Change UID of user "sarah" to 2500.

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -u 2500 sarah
```

**Note:** Files owned by old UID will need ownership update.
</details>

---

### Question 14: Change Username
**Task:** Rename user "jdoe" to "johndoe".

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -l johndoe jdoe
```

**Note:** Home directory name is NOT changed automatically.
</details>

---

### Question 15: Lock User Account
**Task:** Lock user account "baduser" to prevent login.

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -L baduser
```

**Verify (shows ! in password field):**
```bash
sudo grep baduser /etc/shadow
```
</details>

---

### Question 16: Unlock User Account
**Task:** Unlock previously locked user "baduser".

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -U baduser
```
</details>

---

### Question 17: Change User Comment
**Task:** Update comment for user "john" to "John Smith - IT Admin".

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -c "John Smith - IT Admin" john
```
</details>

---

## Part 3: Deleting Users

### Question 18: Delete User (Keep Home Directory)
**Task:** Delete user "testuser" but keep home directory.

<details>
<summary>Show Solution</summary>

```bash
sudo userdel testuser
```

**Home directory remains at /home/testuser.**
</details>

---

### Question 19: Delete User and Home Directory
**Task:** Delete user "mike" and remove home directory.

<details>
<summary>Show Solution</summary>

```bash
sudo userdel -r mike
```

**Option `-r` removes:**
- Home directory
- Mail spool
</details>

---

### Question 20: Force Delete User
**Task:** Delete user even if they are logged in.

<details>
<summary>Show Solution</summary>

```bash
sudo userdel -f username
```

**Warning:** Use with caution. May cause issues if user has running processes.
</details>

---

## Part 4: Viewing User Information

### Question 21: View User Details
**Task:** Display all information about user "john".

<details>
<summary>Show Solution</summary>

```bash
id john
```

**Or from passwd file:**
```bash
getent passwd john
```

**Parse /etc/passwd:**
```
username:x:UID:GID:comment:home:shell
```
</details>

---

### Question 22: List All Users
**Task:** List all local users.

<details>
<summary>Show Solution</summary>

```bash
getent passwd
```

**List only regular users (UID >= 1000):**
```bash
awk -F: '$3 >= 1000 {print $1}' /etc/passwd
```
</details>

---

### Question 23: View Default useradd Settings
**Task:** Display default settings for new users.

<details>
<summary>Show Solution</summary>

```bash
useradd -D
```

**Or view config file:**
```bash
cat /etc/default/useradd
```
</details>

---

## Part 5: Exam Scenarios

### Question 24: Exam Scenario - Complete User Setup
**Task:** Create user "consultant" with:
- UID 5000
- Primary group "contractors"
- Secondary group "projects"
- Shell /bin/bash
- Comment "External Consultant"

<details>
<summary>Show Solution</summary>

```bash
# Create groups if needed
sudo groupadd contractors
sudo groupadd projects

# Create user
sudo useradd -u 5000 -g contractors -G projects -s /bin/bash -c "External Consultant" consultant

# Set password
sudo passwd consultant

# Verify
id consultant
```
</details>

---

### Question 25: Exam Scenario - Service Account
**Task:** Create service account "myapp" that:
- Cannot log in interactively
- Has home directory /opt/myapp
- UID is below 1000

<details>
<summary>Show Solution</summary>

```bash
sudo useradd -r -d /opt/myapp -m -s /sbin/nologin myapp
```

**Verify:**
```bash
id myapp
ls -la /opt/myapp
```
</details>

---

### Question 26: Exam Scenario - Modify Existing User
**Task:** User "alice" needs to:
- Be added to wheel group
- Have shell changed to /bin/bash

<details>
<summary>Show Solution</summary>

```bash
sudo usermod -aG wheel -s /bin/bash alice
```

**Verify:**
```bash
id alice
getent passwd alice
```
</details>

---

## Quick Reference

### useradd Options
```bash
-u UID          # Specify UID
-g GROUP        # Primary group
-G GROUPS       # Supplementary groups
-d HOME         # Home directory path
-m              # Create home directory
-M              # Do NOT create home directory
-s SHELL        # Login shell
-c COMMENT      # User comment/full name
-r              # System account
-e DATE         # Account expiration (YYYY-MM-DD)
```

### usermod Options
```bash
-u UID          # Change UID
-g GROUP        # Change primary group
-G GROUPS       # Set supplementary groups
-aG GROUPS      # Append to supplementary groups
-d HOME         # Change home directory
-m              # Move home contents
-s SHELL        # Change shell
-c COMMENT      # Change comment
-l NEWNAME      # Change username
-L              # Lock account
-U              # Unlock account
```

### userdel Options
```bash
-r              # Remove home directory and mail
-f              # Force delete
```

### /etc/passwd Format
```
username:x:UID:GID:comment:home:shell
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Create users** with `useradd` and specific options (UID, shell, home, groups)
2. **Modify users** with `usermod` (change shell, groups, home, lock/unlock)
3. **Delete users** with `userdel` (with or without home directory)
4. **Verify user information** with `id` and `getent passwd`
5. **Create system accounts** with `-r` and `/sbin/nologin`
