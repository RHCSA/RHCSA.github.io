# Diagnose and Correct File Permission Problems

## RHCSA Exam Objective
> Diagnose and correct file permission problems

---

## Introduction

File permission problems are common in system administration. The RHCSA exam tests your ability to identify and fix permission issues involving standard permissions, ownership, special bits (SUID, SGID, sticky bit), and ACLs. Understanding how to diagnose and resolve these issues is essential.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `ls -l` | View permissions and ownership |
| `chmod` | Change permissions |
| `chown` | Change ownership |
| `chgrp` | Change group ownership |
| `getfacl` | View ACLs |
| `setfacl` | Set ACLs |
| `stat` | Detailed file information |

---

## Permission Basics

```
-rwxr-xr-- 1 owner group size date filename
 │││ │││ │││
 │││ │││ ││└─ others execute
 │││ │││ │└── others write
 │││ │││ └─── others read
 │││ ││└───── group execute
 │││ │└────── group write
 │││ └─────── group read
 ││└───────── owner execute
 │└────────── owner write
 └─────────── owner read
```

---

## Practice Questions

### Question 1: View File Permissions
**Task:** Check permissions of a file to diagnose access issues.

<details>
<summary>Show Solution</summary>

```bash
# Basic view
ls -l /path/to/file

# Detailed info
stat /path/to/file

# View ACLs
getfacl /path/to/file

# Check directory permissions (for access)
ls -ld /path/to/directory
```
</details>

---

### Question 2: User Cannot Read File
**Task:** User 'bob' cannot read /data/report.txt. Diagnose and fix.

<details>
<summary>Show Solution</summary>

**Diagnose:**
```bash
ls -l /data/report.txt
```

**Possible issues:**
1. No read permission for others
2. User not in file's group
3. Parent directory lacks execute permission

**Fix - Add read for others:**
```bash
sudo chmod o+r /data/report.txt
```

**Or add user to group:**
```bash
sudo usermod -aG filegroup bob
```

**Check parent directory:**
```bash
ls -ld /data
sudo chmod o+x /data    # If needed
```
</details>

---

### Question 3: User Cannot Write to File
**Task:** User cannot modify /shared/document.txt. Fix the issue.

<details>
<summary>Show Solution</summary>

**Diagnose:**
```bash
ls -l /shared/document.txt
```

**Check current permissions:**
```
-rw-r--r-- 1 root staff 1024 Jan 1 12:00 document.txt
```

**Solutions:**

**Option 1: Add write permission**
```bash
sudo chmod o+w /shared/document.txt
```

**Option 2: Change ownership**
```bash
sudo chown user:user /shared/document.txt
```

**Option 3: Add user to group and add group write**
```bash
sudo usermod -aG staff user
sudo chmod g+w /shared/document.txt
```
</details>

---

### Question 4: User Cannot Execute Script
**Task:** User cannot run /scripts/backup.sh. Fix it.

<details>
<summary>Show Solution</summary>

**Diagnose:**
```bash
ls -l /scripts/backup.sh
```

**If missing execute permission:**
```bash
sudo chmod +x /scripts/backup.sh
```

**For specific users:**
```bash
sudo chmod u+x /scripts/backup.sh   # Owner only
sudo chmod g+x /scripts/backup.sh   # Group only
sudo chmod a+x /scripts/backup.sh   # All users
```
</details>

---

### Question 5: User Cannot Access Directory
**Task:** User cannot cd into /project. Diagnose and fix.

<details>
<summary>Show Solution</summary>

**Diagnose:**
```bash
ls -ld /project
```

**Directory requires:**
- `r` (read): List contents
- `x` (execute): Enter directory
- `w` (write): Create/delete files

**Fix - Add execute permission:**
```bash
sudo chmod o+x /project
```

**For full access:**
```bash
sudo chmod o+rx /project
```
</details>

---

### Question 6: Fix Ownership
**Task:** Change owner of /data/app to user 'appuser' and group 'appgroup'.

<details>
<summary>Show Solution</summary>

```bash
# Change owner and group
sudo chown appuser:appgroup /data/app

# Recursively
sudo chown -R appuser:appgroup /data/app

# Change only owner
sudo chown appuser /data/app

# Change only group
sudo chgrp appgroup /data/app
# Or
sudo chown :appgroup /data/app
```
</details>

---

### Question 7: Set Specific Permissions
**Task:** Set permissions on /data/secret.txt so only owner can read/write.

<details>
<summary>Show Solution</summary>

```bash
sudo chmod 600 /data/secret.txt
```

**Or symbolic:**
```bash
sudo chmod u=rw,go= /data/secret.txt
```

**Verify:**
```bash
ls -l /data/secret.txt
# -rw-------
```
</details>

---

### Question 8: Set Directory for Shared Group Access
**Task:** Configure /shared so group 'developers' has full access.

<details>
<summary>Show Solution</summary>

```bash
# Set ownership
sudo chown :developers /shared

# Set permissions (rwx for group)
sudo chmod 770 /shared

# Or with read for others
sudo chmod 775 /shared

# Recursively for existing content
sudo chown -R :developers /shared
sudo chmod -R g+rwX /shared
```
</details>

---

### Question 9: Set SGID on Directory
**Task:** Configure /projects so new files inherit the group.

<details>
<summary>Show Solution</summary>

```bash
# Set SGID
sudo chmod g+s /projects

# Or numeric (2 prefix)
sudo chmod 2775 /projects
```

**Verify:**
```bash
ls -ld /projects
# drwxrwsr-x (note the 's')
```

**How SGID helps:**
- New files inherit directory's group
- Useful for shared project directories
</details>

---

### Question 10: Set Sticky Bit
**Task:** Configure /tmp-style directory where users can only delete their own files.

<details>
<summary>Show Solution</summary>

```bash
# Set sticky bit
sudo chmod +t /shared

# Or numeric (1 prefix)
sudo chmod 1777 /shared
```

**Verify:**
```bash
ls -ld /shared
# drwxrwxrwt (note the 't')
```

**How sticky bit helps:**
- Users can only delete files they own
- Used on /tmp
</details>

---

### Question 11: Set SUID on Executable
**Task:** Configure /usr/local/bin/backup to run with owner's privileges.

<details>
<summary>Show Solution</summary>

```bash
# Set SUID
sudo chmod u+s /usr/local/bin/backup

# Or numeric (4 prefix)
sudo chmod 4755 /usr/local/bin/backup
```

**Verify:**
```bash
ls -l /usr/local/bin/backup
# -rwsr-xr-x (note the 's')
```

**Warning:** SUID is a security risk. Use carefully.
</details>

---

### Question 12: Use ACLs for Fine-Grained Access
**Task:** Grant user 'bob' read access to /data/report without changing standard permissions.

<details>
<summary>Show Solution</summary>

```bash
# Add ACL for user
sudo setfacl -m u:bob:r /data/report
```

**Verify:**
```bash
getfacl /data/report
```

**Output shows:**
```
user:bob:r--
```
</details>

---

### Question 13: Grant Group ACL
**Task:** Grant group 'auditors' read-only access to /logs directory.

<details>
<summary>Show Solution</summary>

```bash
# Add ACL for group
sudo setfacl -m g:auditors:rx /logs

# Recursively for existing files
sudo setfacl -R -m g:auditors:rx /logs
```

**Verify:**
```bash
getfacl /logs
```
</details>

---

### Question 14: Set Default ACL
**Task:** Configure /projects so new files automatically grant group 'dev' read/write.

<details>
<summary>Show Solution</summary>

```bash
# Set default ACL
sudo setfacl -m d:g:dev:rw /projects
```

**Verify:**
```bash
getfacl /projects
```

**Output shows:**
```
default:group:dev:rw-
```

**New files created will inherit this ACL.**
</details>

---

### Question 15: Remove ACL
**Task:** Remove all ACLs from /data/file.

<details>
<summary>Show Solution</summary>

```bash
# Remove specific ACL
sudo setfacl -x u:bob /data/file

# Remove all ACLs
sudo setfacl -b /data/file
```

**Verify:**
```bash
getfacl /data/file
ls -l /data/file   # No '+' sign means no ACLs
```
</details>

---

### Question 16: Exam Scenario - Web Directory
**Task:** Configure /var/www/html so:
- User 'apache' owns the directory
- Group 'webdev' can write
- New files inherit the webdev group

<details>
<summary>Show Solution</summary>

```bash
# Set ownership
sudo chown apache:webdev /var/www/html

# Set permissions with SGID
sudo chmod 2775 /var/www/html

# Recursively for existing content
sudo chown -R apache:webdev /var/www/html/*
sudo chmod -R g+w /var/www/html/*
```

**Verify:**
```bash
ls -ld /var/www/html
# drwxrwsr-x apache webdev
```
</details>

---

### Question 17: Exam Scenario - Shared Folder
**Task:** Create /share/sales accessible only to 'sales' group members with full access.

<details>
<summary>Show Solution</summary>

```bash
# Create directory
sudo mkdir -p /share/sales

# Set ownership
sudo chown :sales /share/sales

# Set permissions (group only)
sudo chmod 2770 /share/sales
```

**Verify:**
```bash
ls -ld /share/sales
# drwxrws--- root sales
```
</details>

---

### Question 18: Diagnose ACL Issues
**Task:** File has a '+' in permissions but user still cannot access.

<details>
<summary>Show Solution</summary>

```bash
# Check ACLs
getfacl /path/to/file
```

**Look for:**
- mask value limiting effective permissions
- user/group entries
- deny entries

**Fix mask if needed:**
```bash
sudo setfacl -m m:rwx /path/to/file
```
</details>

---

### Question 19: Copy Permissions
**Task:** Copy permissions from one file to another.

<details>
<summary>Show Solution</summary>

```bash
# Copy standard permissions
chmod --reference=source_file target_file

# Copy ACLs
getfacl source_file | setfacl --set-file=- target_file
```
</details>

---

### Question 20: Find Permission Problems
**Task:** Find all files owned by a specific user.

<details>
<summary>Show Solution</summary>

```bash
# Find files by owner
find /path -user username

# Find files by group
find /path -group groupname

# Find world-writable files
find /path -perm -002

# Find SUID files
find /path -perm -4000

# Find files without owner
find /path -nouser
```
</details>

---

## Quick Reference

### Standard Permissions
```bash
# Symbolic
chmod u+rwx,g+rx,o+r file    # Add
chmod u-w file                # Remove
chmod u=rw,g=r,o= file       # Set exactly

# Numeric
chmod 755 file    # rwxr-xr-x
chmod 644 file    # rw-r--r--
chmod 600 file    # rw-------
chmod 777 dir     # rwxrwxrwx
```

### Special Bits
```bash
chmod u+s file    # SUID (4xxx)
chmod g+s dir     # SGID (2xxx)
chmod +t dir      # Sticky (1xxx)
chmod 2775 dir    # SGID + rwxrwxr-x
```

### Ownership
```bash
chown user file
chown user:group file
chown :group file
chown -R user:group dir
```

### ACLs
```bash
getfacl file
setfacl -m u:user:rwx file
setfacl -m g:group:rx file
setfacl -m d:g:group:rw dir    # Default
setfacl -x u:user file          # Remove
setfacl -b file                 # Remove all
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Read permission output** from `ls -l`
2. **Change permissions** using `chmod` (symbolic and numeric)
3. **Change ownership** using `chown` and `chgrp`
4. **Set SGID** on directories for group inheritance
5. **Set sticky bit** for shared directories
6. **Use ACLs** with `setfacl` for fine-grained access
7. **View ACLs** with `getfacl`
8. **Diagnose access issues** by checking all layers
