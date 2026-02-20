# List, Set, and Change Standard ugo/rwx Permissions

## Introduction

Understanding and managing file permissions is essential for RHCSA certification. Linux uses a permission system based on three categories of users (user, group, others) and three types of permissions (read, write, execute). This guide covers everything you need to know about standard ugo/rwx permissions for the RHCSA exam.

---

## Understanding Linux Permissions

### The Permission Model

Every file and directory in Linux has three sets of permissions for three categories of users:

| Category | Symbol | Description |
|----------|--------|-------------|
| **User (Owner)** | `u` | The user who owns the file |
| **Group** | `g` | Users who are members of the file's group |
| **Others** | `o` | All other users on the system |
| **All** | `a` | All three categories (u, g, and o) |

### Permission Types

| Permission | Symbol | File Effect | Directory Effect |
|------------|--------|-------------|------------------|
| **Read** | `r` | View file contents | List directory contents |
| **Write** | `w` | Modify file contents | Create/delete files in directory |
| **Execute** | `x` | Run as program/script | Access (cd into) directory |

---

## Viewing Permissions

### Using `ls -l`

```bash
ls -l filename.txt
# Output: -rw-r--r-- 1 user group 1234 Dec 31 10:00 filename.txt
```

### Decoding the Permission String

```
-rw-r--r--
│├──┼──┼──┤
│ │  │  └── Others: r-- (read only)
│ │  └───── Group: r-- (read only)
│ └──────── User: rw- (read, write)
└────────── File type: - (regular file)
```

### File Types

| Symbol | Type |
|--------|------|
| `-` | Regular file |
| `d` | Directory |
| `l` | Symbolic link |
| `c` | Character device |
| `b` | Block device |
| `s` | Socket |
| `p` | Named pipe (FIFO) |

### Examples

```bash
# List permissions
ls -l /etc/passwd
# -rw-r--r-- 1 root root 2847 Dec 31 10:00 /etc/passwd

# List directory permissions
ls -ld /tmp
# drwxrwxrwt 10 root root 4096 Dec 31 10:00 /tmp

# List all files including hidden
ls -la /home/user/

# List with numeric user/group IDs
ls -ln /etc/passwd
```

---

## Octal (Numeric) Permission Notation

### Permission Values

Each permission has a numeric value:

| Permission | Value |
|------------|-------|
| Read (r) | 4 |
| Write (w) | 2 |
| Execute (x) | 1 |
| No permission (-) | 0 |

### Calculating Octal Permissions

Add the values for each category:

| Permission | Calculation | Octal |
|------------|-------------|-------|
| `rwx` | 4+2+1 | 7 |
| `rw-` | 4+2+0 | 6 |
| `r-x` | 4+0+1 | 5 |
| `r--` | 4+0+0 | 4 |
| `-wx` | 0+2+1 | 3 |
| `-w-` | 0+2+0 | 2 |
| `--x` | 0+0+1 | 1 |
| `---` | 0+0+0 | 0 |

### Common Permission Combinations

| Octal | Symbolic | Typical Use |
|-------|----------|-------------|
| 777 | rwxrwxrwx | Full access for everyone (rarely used) |
| 755 | rwxr-xr-x | Executable files, directories |
| 750 | rwxr-x--- | Group-restricted executables/directories |
| 700 | rwx------ | Private directories |
| 666 | rw-rw-rw- | World-writable files (rarely used) |
| 664 | rw-rw-r-- | Group-writable files |
| 644 | rw-r--r-- | Standard files |
| 640 | rw-r----- | Group-readable files |
| 600 | rw------- | Private files |
| 555 | r-xr-xr-x | Read and execute only |
| 444 | r--r--r-- | Read-only for everyone |

---

## The `chmod` Command

The `chmod` command changes file mode (permissions).

### Syntax

```bash
chmod [OPTIONS] MODE FILE...
chmod [OPTIONS] OCTAL-MODE FILE...
```

### Common Options

| Option | Description |
|--------|-------------|
| `-R` | Recursive, apply to directories and contents |
| `-v` | Verbose, show files being processed |
| `-c` | Like verbose, but only report changes |
| `--reference=FILE` | Use FILE's permissions as reference |

---

## Setting Permissions with Octal Mode

### Examples

```bash
# Set rwxr-xr-x (755)
chmod 755 script.sh

# Set rw-r--r-- (644)
chmod 644 document.txt

# Set rwx------ (700)
chmod 700 private_dir/

# Set rw-rw---- (660)
chmod 660 shared_file.txt

# Set permissions recursively
chmod -R 755 /var/www/html/

# Verbose output
chmod -v 644 file.txt
```

---

## Setting Permissions with Symbolic Mode

### Symbolic Mode Format

```
chmod [ugoa][+-=][rwx] file
```

| Component | Options | Description |
|-----------|---------|-------------|
| Who | `u` | User (owner) |
| | `g` | Group |
| | `o` | Others |
| | `a` | All (u, g, and o) |
| Operator | `+` | Add permission |
| | `-` | Remove permission |
| | `=` | Set exact permission |
| Permission | `r` | Read |
| | `w` | Write |
| | `x` | Execute |

### Examples

```bash
# Add execute for user
chmod u+x script.sh

# Remove write for group and others
chmod go-w file.txt

# Add read for everyone
chmod a+r file.txt

# Set user to rwx, group to rx, others to none
chmod u=rwx,g=rx,o= file.txt

# Add execute for all
chmod +x script.sh

# Remove all permissions for others
chmod o= file.txt

# Copy user permissions to group
chmod g=u file.txt

# Add read and execute for group
chmod g+rx directory/

# Multiple operations
chmod u+x,g-w,o-rwx file.txt
```

### Combining Symbolic Operations

```bash
# Add execute for user, remove write for others
chmod u+x,o-w file.txt

# Set different permissions for each
chmod u=rwx,g=rx,o=r file.txt

# Remove write from group and others
chmod go-w file.txt

# Add read to all
chmod a+r file.txt
# Same as:
chmod +r file.txt
```

---

## Directory Permissions

Directories require special consideration:

| Permission | Effect on Directory |
|------------|---------------------|
| `r` (read) | List contents with `ls` |
| `w` (write) | Create, delete, rename files inside |
| `x` (execute) | Access directory with `cd`, access files inside |

### Important Notes

- **Read without execute**: Can list filenames but not access files
- **Execute without read**: Can access files by name but not list contents
- **Write requires execute**: To create/delete files, need both `w` and `x`

```bash
# Standard directory permissions
chmod 755 mydir/    # Owner full, others read/execute

# Private directory
chmod 700 private/  # Only owner can access

# Shared group directory
chmod 775 shared/   # Owner and group full, others read/execute

# Drop-box directory (write-only)
chmod 733 dropbox/  # Others can write but not list
```

---

## Changing File Ownership

### The `chown` Command

Changes file owner and/or group.

**Syntax:**
```bash
chown [OPTIONS] OWNER[:GROUP] FILE...
chown [OPTIONS] :GROUP FILE...
```

**Options:**

| Option | Description |
|--------|-------------|
| `-R` | Recursive |
| `-v` | Verbose |
| `-c` | Report only changes |
| `--reference=FILE` | Use FILE's ownership |
| `-h` | Affect symbolic links instead of target |

**Examples:**

```bash
# Change owner
chown user1 file.txt

# Change owner and group
chown user1:group1 file.txt

# Change only group (note the colon)
chown :group1 file.txt

# Change owner, set group to owner's login group
chown user1: file.txt

# Recursive ownership change
chown -R user1:group1 /var/www/

# Verbose output
chown -v user1:group1 file.txt

# Using reference file
chown --reference=reference.txt target.txt
```

### The `chgrp` Command

Changes only the group ownership.

**Syntax:**
```bash
chgrp [OPTIONS] GROUP FILE...
```

**Examples:**

```bash
# Change group
chgrp developers file.txt

# Recursive group change
chgrp -R developers /opt/project/

# Verbose output
chgrp -v developers file.txt
```

---

## The `umask` Command

The `umask` sets default permissions for newly created files and directories.

### Understanding umask

- umask is a **mask** that removes permissions from defaults
- Default file creation permissions: 666 (rw-rw-rw-)
- Default directory creation permissions: 777 (rwxrwxrwx)
- Actual permissions = Default - umask

### Common umask Values

| umask | File Result | Directory Result | Description |
|-------|-------------|------------------|-------------|
| 022 | 644 (rw-r--r--) | 755 (rwxr-xr-x) | Standard default |
| 027 | 640 (rw-r-----) | 750 (rwxr-x---) | More restrictive |
| 077 | 600 (rw-------) | 700 (rwx------) | Private files |
| 002 | 664 (rw-rw-r--) | 775 (rwxrwxr-x) | Group-friendly |

### umask Commands

```bash
# View current umask (octal)
umask

# View current umask (symbolic)
umask -S

# Set umask for current session
umask 022

# Set restrictive umask
umask 077

# Set group-friendly umask
umask 002
```

### Making umask Permanent

Add to `~/.bashrc` or `~/.bash_profile`:

```bash
echo "umask 027" >> ~/.bashrc
```

---

## Using `stat` to View Permissions

```bash
# View detailed file information
stat file.txt

# Output includes:
# Access: (0644/-rw-r--r--)  Uid: ( 1000/   user)   Gid: ( 1000/   group)

# View only permissions in octal
stat -c %a file.txt
# Output: 644

# View only permissions in symbolic
stat -c %A file.txt
# Output: -rw-r--r--
```

---

## Special Permissions: SUID, SGID, and Sticky Bit

### SUID (Set User ID) - Value: 4

When set on an executable file, it runs with the permissions of the file **owner** instead of the user executing it.

```bash
# Set SUID using symbolic mode
chmod u+s filename

# Set SUID using octal mode (4 in front)
chmod 4755 filename

# Example: passwd command has SUID
ls -l /usr/bin/passwd
# -rwsr-xr-x 1 root root ... /usr/bin/passwd
```

**Understanding SUID display:**
- Lowercase `s`: SUID is set AND owner has execute permission
- Uppercase `S`: SUID is set BUT owner does NOT have execute permission

```bash
chmod 4664 myfile    # Results in -rwSrw-r-- (capital S, no execute)
chmod 4764 myfile    # Results in -rwsrw-r-- (lowercase s, has execute)
```

### SGID (Set Group ID) - Value: 2

- On **files**: Runs with the permissions of the file's **group**
- On **directories**: New files inherit the directory's group

```bash
# Set SGID using symbolic mode
chmod g+s filename

# Set SGID using octal mode (2 in front)
chmod 2755 directory

# SGID on directory - useful for shared directories
chmod 2775 /shared/project/
```

**Understanding SGID display:**
- Lowercase `s`: SGID is set AND group has execute permission
- Uppercase `S`: SGID is set BUT group does NOT have execute permission

### Sticky Bit - Value: 1

When set on a directory, only the file owner, directory owner, or root can delete files within it.

```bash
# Set sticky bit using symbolic mode
chmod o+t directory

# Set sticky bit using octal mode (1 in front)
chmod 1777 directory

# Example: /tmp has sticky bit
ls -ld /tmp
# drwxrwxrwt 10 root root ... /tmp
```

**Understanding Sticky Bit display:**
- Lowercase `t`: Sticky bit is set AND others have execute permission
- Uppercase `T`: Sticky bit is set BUT others do NOT have execute permission

### Setting Multiple Special Permissions

```bash
# Set both SUID and SGID (4+2=6)
chmod 6755 filename

# Set all three: SUID + SGID + Sticky (4+2+1=7)
chmod 7755 directory

# Using symbolic mode
chmod u+s,g+s,o+t directory
```

### Finding Files with Special Permissions

```bash
# Find files with SUID set
find / -perm /4000 -type f 2>/dev/null

# Find files with SGID set
find / -perm /2000 -type f 2>/dev/null

# Find files with SUID or SGID set
find / -perm /6000 -type f 2>/dev/null

# Find directories with sticky bit
find / -perm /1000 -type d 2>/dev/null
```

---

## Using find to Search by Permissions

The `find` command is essential for locating files based on permissions.

### Permission Search Modes

| Mode | Syntax | Meaning |
|------|--------|---------|
| Exact | `find -perm 644` | Exactly 644 permissions |
| Minimum | `find -perm -644` | At least these permissions (this OR higher) |
| Any | `find -perm /644` | Any of these permission bits set |

### Practical Examples

```bash
# Find files with exact permissions
find /home -perm 644
find /home -perm u=rw,g=r,o=r

# Find files with at least read+write for user
find /home -perm -u=rw

# Find world-writable files (security audit)
find / -perm -o=w -type f 2>/dev/null

# Find files where group can write but others cannot read
find /var/log -perm -g=w ! -perm /o=r

# Find files owned by specific user
find /home -user bob -type f

# Find files owned by UID (useful if user deleted)
find / -uid 1001 -type f 2>/dev/null

# Find files owned by root with SUID
find /usr -uid 0 -perm -4000 -type f 2>/dev/null
```

### Combining Find Criteria

```bash
# AND (default) - all conditions must match
find /var -type f -perm -644 -user root

# OR (-o) - either condition matches
find /home -size 100k -o -perm 777

# NOT (! or -not) - exclude matches
find /etc -type f ! -name "*.conf"
find /etc -type f -not -name "*.conf"
```

### Execute Actions on Found Files

```bash
# Change permissions on found files
find /var/www -type f -exec chmod 644 {} \;

# Change ownership on found directories
find /var/www -type d -exec chmod 755 {} \;

# Delete empty files
find /tmp -type f -empty -delete

# Copy found files to backup
find /etc -name "*.conf" -exec cp {} /backup/ \;
```

---

## Practice Questions

### Question 1
Set the permissions on `/tmp/testfile.txt` to allow the owner to read, write, and execute, the group to read and execute, and others to have no access.

<details>
<summary>Show Solution</summary>

```bash
# Using octal notation
chmod 750 /tmp/testfile.txt

# Using symbolic notation
chmod u=rwx,g=rx,o= /tmp/testfile.txt

# Verify
ls -l /tmp/testfile.txt
# -rwxr-x--- 1 user group ... /tmp/testfile.txt
```
</details>

---

### Question 2
Create a file `/home/user/secure.txt` and set permissions so only the owner can read and write to it.

<details>
<summary>Show Solution</summary>

```bash
touch /home/user/secure.txt
chmod 600 /home/user/secure.txt

# Or symbolically
chmod u=rw,go= /home/user/secure.txt

# Verify
ls -l /home/user/secure.txt
# -rw------- 1 user group ... /home/user/secure.txt
```
</details>

---

### Question 3
Change the owner of `/opt/data` to `admin` and the group to `developers`, recursively for all contents.

<details>
<summary>Show Solution</summary>

```bash
chown -R admin:developers /opt/data

# Verify
ls -l /opt/data
```
</details>

---

### Question 4
Add execute permission for the group on the file `script.sh` without changing any other permissions.

<details>
<summary>Show Solution</summary>

```bash
chmod g+x script.sh

# Verify
ls -l script.sh
```
</details>

---

### Question 5
Remove write permission for others on all files in `/var/shared/` recursively.

<details>
<summary>Show Solution</summary>

```bash
chmod -R o-w /var/shared/

# Verify
ls -l /var/shared/
```
</details>

---

### Question 6
Set the default umask so that newly created files have permissions 640 and directories have 750.

<details>
<summary>Show Solution</summary>

```bash
# Calculate: 666 - 640 = 026, but files don't get execute
# For directories: 777 - 750 = 027
# umask 027 achieves both goals

umask 027

# Verify
umask
# Output: 0027

# Test with file
touch testfile
ls -l testfile
# -rw-r----- (640)

# Test with directory
mkdir testdir
ls -ld testdir
# drwxr-x--- (750)
```
</details>

---

### Question 7
What are the octal permissions for a file with `-rwxr-x---`?

<details>
<summary>Show Solution</summary>

```bash
# User: rwx = 4+2+1 = 7
# Group: r-x = 4+0+1 = 5
# Others: --- = 0+0+0 = 0

# Answer: 750

# Verify with stat
stat -c %a file
# Output: 750
```
</details>

---

### Question 8
Change only the group of `/var/log/app.log` to `sysadmin`.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Using chgrp
chgrp sysadmin /var/log/app.log

# Method 2: Using chown with colon
chown :sysadmin /var/log/app.log

# Verify
ls -l /var/log/app.log
```
</details>

---

### Question 9
Set permissions 755 on a directory `/var/www/html` and all its subdirectories, but set 644 on all regular files within.

<details>
<summary>Show Solution</summary>

```bash
# Set directories to 755
find /var/www/html -type d -exec chmod 755 {} \;

# Set files to 644
find /var/www/html -type f -exec chmod 644 {} \;

# Verify
ls -la /var/www/html
```
</details>

---

### Question 10
Create a directory `/shared` that allows full access to the owner, read and execute access to the group, and no access to others.

<details>
<summary>Show Solution</summary>

```bash
mkdir /shared
chmod 750 /shared

# Verify
ls -ld /shared
# drwxr-x--- 2 user group ... /shared
```
</details>

---

### Question 11
View the current permissions of `/etc/shadow` in both symbolic and octal formats.

<details>
<summary>Show Solution</summary>

```bash
# Symbolic format
ls -l /etc/shadow

# Octal format
stat -c %a /etc/shadow

# Both together
stat /etc/shadow
```
</details>

---

### Question 12
Make a shell script executable by everyone.

<details>
<summary>Show Solution</summary>

```bash
chmod a+x script.sh
# Or
chmod +x script.sh
# Or
chmod 755 script.sh

# Verify
ls -l script.sh
```
</details>

---

### Question 13
Set the permissions on `/home/user/private` directory to 700 and all contents to 600.

<details>
<summary>Show Solution</summary>

```bash
# Set directory permissions
chmod 700 /home/user/private

# Set file permissions (for files inside)
chmod 600 /home/user/private/*

# Or use find for recursive with different permissions
chmod 700 /home/user/private
find /home/user/private -type f -exec chmod 600 {} \;
find /home/user/private -type d -exec chmod 700 {} \;
```
</details>

---

### Question 14
Remove all permissions for the group and others from the file `confidential.txt`.

<details>
<summary>Show Solution</summary>

```bash
chmod go= confidential.txt
# Or
chmod go-rwx confidential.txt
# Or
chmod 600 confidential.txt  # Assuming user keeps rw

# Verify
ls -l confidential.txt
```
</details>

---

### Question 15
Copy the permissions from `reference.txt` to `target.txt`.

<details>
<summary>Show Solution</summary>

```bash
chmod --reference=reference.txt target.txt

# Verify
stat -c %a reference.txt target.txt
```
</details>

---

### Question 16
Give the group the same permissions as the owner on `shared.txt`.

<details>
<summary>Show Solution</summary>

```bash
chmod g=u shared.txt

# Verify
ls -l shared.txt
```
</details>

---

### Question 17
Set permissions so that a directory `/data` allows everyone to enter and read contents, but only the owner can create or delete files.

<details>
<summary>Show Solution</summary>

```bash
chmod 755 /data
# Owner: rwx (can create/delete)
# Group: r-x (can enter and read)
# Others: r-x (can enter and read)

# Verify
ls -ld /data
# drwxr-xr-x ... /data
```
</details>

---

### Question 18
What command shows the numeric (octal) permissions of a file?

<details>
<summary>Show Solution</summary>

```bash
# Using stat
stat -c %a filename

# Or full stat output
stat filename | grep Access

# Output example: 0644
```
</details>

---

### Question 19
Create a file with specific permissions 640 immediately (without changing after creation).

<details>
<summary>Show Solution</summary>

```bash
# Set umask first, then create file
(umask 027 && touch newfile.txt)

# Or use install command
install -m 640 /dev/null newfile.txt

# Verify
ls -l newfile.txt
```
</details>

---

### Question 20
Change ownership of all files owned by user `olduser` to `newuser` in `/home/olduser`.

<details>
<summary>Show Solution</summary>

```bash
# Find and change ownership
find /home/olduser -user olduser -exec chown newuser {} \;

# Or if changing everything in directory
chown -R newuser /home/olduser
```
</details>

---

### Question 21
List all files in `/etc` that have write permission for others.

<details>
<summary>Show Solution</summary>

```bash
find /etc -perm -o=w -ls 2>/dev/null
# Or
find /etc -perm -002 -ls 2>/dev/null
```
</details>

---

### Question 22
Recursively set directories to 755 and files to 644 in `/var/www`.

<details>
<summary>Show Solution</summary>

```bash
# Set directories
find /var/www -type d -exec chmod 755 {} \;

# Set files
find /var/www -type f -exec chmod 644 {} \;

# Alternative using chmod with X (capital X)
# X adds execute only to directories and files already executable
chmod -R u=rwX,go=rX /var/www
```
</details>

---

### Question 23
Verify that a script has execute permission before running it.

<details>
<summary>Show Solution</summary>

```bash
# Check with test command
if [ -x script.sh ]; then
    echo "Executable"
else
    echo "Not executable"
fi

# Or check with ls
ls -l script.sh | grep -q "^-..x" && echo "User can execute"

# Or simply
test -x script.sh && echo "Executable"
```
</details>

---

### Question 24
Set permissions so that a file can be read by owner and group, written only by owner, with no access for others.

<details>
<summary>Show Solution</summary>

```bash
chmod 640 filename
# Or
chmod u=rw,g=r,o= filename

# Verify
ls -l filename
# -rw-r----- 1 user group ... filename
```
</details>

---

### Question 25
View the current umask and explain what default permissions would be created for files and directories.

<details>
<summary>Show Solution</summary>

```bash
# View current umask
umask
# Example output: 0022

# View in symbolic format
umask -S
# Example output: u=rwx,g=rx,o=rx

# Explanation for umask 022:
# Files: 666 - 022 = 644 (rw-r--r--)
# Directories: 777 - 022 = 755 (rwxr-xr-x)

# Test it
touch testfile
mkdir testdir
ls -l testfile
# -rw-r--r-- (644)
ls -ld testdir
# drwxr-xr-x (755)
```
</details>

---

### Question 26: Find Files by Permission (Exam Style)
**Task:** Find files and directories under `/var/log/` where the group can write, but others cannot read or write.

<details>
<summary>Show Solution</summary>

```bash
sudo find /var/log/ -perm -g=w ! -perm /o=rw
```

**Explanation:**
- `-perm -g=w`: At least write permission for group
- `! -perm /o=rw`: Neither read nor write permission for others
</details>

---

### Question 27: Find Files by Size or Permission
**Task:** Find files under `/home` that are either exactly 100KB or have permission 644.

<details>
<summary>Show Solution</summary>

```bash
find /home -size 100k -o -perm 644
```

**Note:** `-o` is the OR operator in find.
</details>

---

### Question 28: Find and Copy Files by Owner
**Task:** Find files owned by root in `/usr/bin` and copy them to `/backup/` preserving attributes.

<details>
<summary>Show Solution</summary>

```bash
sudo find /usr/bin -type f -user root -exec cp -p {} /backup/ \;

# Or using -exec with directory target
sudo find /usr/bin -type f -user root -exec cp -p {} /backup/ +
```

**Options:**
- `-p` preserves mode, ownership, and timestamps
- `+` is more efficient than `\;` for large numbers of files
</details>

---

### Question 29: Find Files with SUID Bit Set
**Task:** Find files owned by root with the SUID bit set in `/usr`.

<details>
<summary>Show Solution</summary>

```bash
sudo find /usr -uid 0 -perm -4000

# Or using symbolic
sudo find /usr -user root -perm -u+s

# Or combining both SUID conditions
sudo find /usr -type f -perm /4000 2>/dev/null
```
</details>

---

### Question 30: Find and Delete Empty Files
**Task:** Find and delete all empty files in `/tmp`.

<details>
<summary>Show Solution</summary>

```bash
# Preview first (dry run)
find /tmp -type f -empty -print

# Then delete
sudo find /tmp -type f -empty -delete

# Or using -exec
sudo find /tmp -type f -empty -exec rm {} \;
```
</details>

---

### Question 31: Find Files by Size Range
**Task:** Find all files between 5MB and 10MB in `/var`.

<details>
<summary>Show Solution</summary>

```bash
sudo find /var -type f -size +5M -size -10M

# Explanation:
# +5M means larger than 5MB
# -10M means smaller than 10MB
# Together they define the range
```
</details>

---

## Quick Reference Cheat Sheet

### Viewing Permissions

| Command | Description |
|---------|-------------|
| `ls -l file` | Show permissions in symbolic format |
| `ls -ld dir` | Show directory permissions |
| `stat file` | Show detailed file information |
| `stat -c %a file` | Show permissions in octal |
| `stat -c %A file` | Show permissions in symbolic |

### Changing Permissions

| Command | Description |
|---------|-------------|
| `chmod 755 file` | Set permissions using octal |
| `chmod u+x file` | Add execute for user |
| `chmod go-w file` | Remove write from group and others |
| `chmod a=r file` | Set read-only for all |
| `chmod -R 755 dir` | Recursive permission change |
| `chmod g=u file` | Set group permissions same as user |

### Changing Ownership

| Command | Description |
|---------|-------------|
| `chown user file` | Change owner |
| `chown user:group file` | Change owner and group |
| `chown :group file` | Change only group |
| `chown -R user:group dir` | Recursive ownership change |
| `chgrp group file` | Change only group |

### umask Commands

| Command | Description |
|---------|-------------|
| `umask` | View current umask (octal) |
| `umask -S` | View current umask (symbolic) |
| `umask 022` | Set umask |

---

## Octal Permission Reference

| Octal | Binary | Symbolic | Meaning |
|-------|--------|----------|---------|
| 0 | 000 | `---` | No permissions |
| 1 | 001 | `--x` | Execute only |
| 2 | 010 | `-w-` | Write only |
| 3 | 011 | `-wx` | Write and execute |
| 4 | 100 | `r--` | Read only |
| 5 | 101 | `r-x` | Read and execute |
| 6 | 110 | `rw-` | Read and write |
| 7 | 111 | `rwx` | Full permissions |

---

## Key Points for RHCSA Exam

1. **Know both notations**: Be fluent in both octal (755) and symbolic (u=rwx,g=rx,o=rx)
2. **Remember common permissions**: 644 for files, 755 for directories and scripts
3. **Directories need execute**: To `cd` into a directory or access files, need `x` permission
4. **Use -R for recursive**: `chmod -R` and `chown -R` for directories
5. **chown can change group**: `chown user:group` changes both
6. **umask subtracts from defaults**: 666 for files, 777 for directories
7. **Use stat for details**: `stat -c %a` for octal permissions
8. **chmod g=u copies permissions**: Useful for matching permissions
9. **Only root can chown**: Regular users cannot change file ownership
10. **Use find for selective changes**: Different permissions for files vs directories
