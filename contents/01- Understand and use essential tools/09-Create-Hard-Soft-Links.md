# Create Hard and Soft Links

## Introduction

Links in Linux are pointers to files that allow you to access the same file from multiple locations. Understanding the difference between hard links and soft (symbolic) links is essential for RHCSA certification. This topic tests your ability to create, identify, and manage both types of links.

---

## Understanding Inodes

Before learning about links, you must understand inodes:

| Concept | Description |
|---------|-------------|
| **Inode** | A data structure that stores metadata about a file (permissions, ownership, timestamps, data block locations) |
| **Inode Number** | Unique identifier for each inode within a filesystem |
| **Filename** | Simply a pointer (reference) to an inode |
| **File Data** | Actual content stored in data blocks referenced by the inode |

```bash
# View inode number of a file
ls -i filename.txt

# View detailed inode information
stat filename.txt
```

---

## Hard Links vs Soft Links

### Comparison Table

| Feature | Hard Link | Soft (Symbolic) Link |
|---------|-----------|---------------------|
| **Points to** | Same inode (data blocks) | Pathname of target file |
| **Cross filesystems** | ❌ No | ✅ Yes |
| **Link to directories** | ❌ No (except . and ..) | ✅ Yes |
| **Target must exist** | ✅ Yes (at creation) | ❌ No (can be dangling) |
| **Survives target deletion** | ✅ Yes (data remains) | ❌ No (becomes broken) |
| **Inode number** | Same as original | Different from original |
| **File size** | Same as original | Size of the path string |
| **Identified by** | Same inode number | `l` in ls -l, `->` arrow |

### Visual Representation

```
HARD LINK:
┌──────────┐     ┌──────────┐
│ file.txt │────▶│  Inode   │────▶ Data Blocks
└──────────┘     │  12345   │
┌──────────┐     └──────────┘
│ hardlink │────────────┘
└──────────┘

SOFT LINK:
┌──────────┐     ┌──────────┐
│ file.txt │────▶│  Inode   │────▶ Data Blocks
└──────────┘     │  12345   │
                 └──────────┘
┌──────────┐     ┌──────────┐
│ softlink │────▶│  Inode   │────▶ "file.txt" (path string)
└──────────┘     │  67890   │
                 └──────────┘
```

---

## The `ln` Command

The `ln` command creates links between files.

**Syntax:**
```bash
ln [OPTIONS] TARGET LINK_NAME           # Create hard link
ln -s [OPTIONS] TARGET LINK_NAME        # Create soft link
```

**Common Options:**

| Option | Description |
|--------|-------------|
| `-s` | Create symbolic (soft) link |
| `-f` | Force, remove existing destination files |
| `-i` | Prompt before removing existing files |
| `-v` | Verbose, print name of each linked file |
| `-r` | Create relative symbolic link |
| `-n` | Treat LINK_NAME as normal file if it's a symlink to directory |

---

## Creating Hard Links

Hard links create additional directory entries pointing to the same inode.

**Syntax:**
```bash
ln TARGET LINK_NAME
ln TARGET... DIRECTORY
```

**Examples:**

```bash
# Create a hard link
ln original.txt hardlink.txt

# Verify they share the same inode
ls -li original.txt hardlink.txt
# Output shows same inode number for both

# Check link count (should be 2)
stat original.txt

# Create hard link in different directory
ln /home/user/file.txt /tmp/file_link

# Create multiple hard links in a directory
ln file1.txt file2.txt /backup/
```

### Hard Link Characteristics

```bash
# Create original file
echo "Hello World" > original.txt

# Create hard link
ln original.txt hardlink.txt

# Both files show the same inode
ls -li original.txt hardlink.txt
# 12345 -rw-r--r-- 2 user user 12 Dec 31 10:00 original.txt
# 12345 -rw-r--r-- 2 user user 12 Dec 31 10:00 hardlink.txt

# Link count is 2 (shown as "2" in ls -l output)

# Modify through either name - changes appear in both
echo "Modified" >> hardlink.txt
cat original.txt  # Shows "Hello World\nModified"

# Delete original - hard link still works
rm original.txt
cat hardlink.txt  # Still works! Data remains.
```

---

## Creating Soft (Symbolic) Links

Soft links (symlinks) are special files containing a path to another file.

**Syntax:**
```bash
ln -s TARGET LINK_NAME
ln -s TARGET... DIRECTORY
```

**Examples:**

```bash
# Create a symbolic link
ln -s /path/to/original.txt symlink.txt

# Create symlink with relative path
ln -s ../original.txt symlink.txt

# Create symlink to directory
ln -s /var/log logs

# Create relative symbolic link
ln -sr /path/to/target linkname

# Create symlink with verbose output
ln -sv /etc/hosts /tmp/hosts_link

# Force create (overwrite existing)
ln -sf /new/target existing_link
```

### Soft Link Characteristics

```bash
# Create original file
echo "Hello World" > original.txt

# Create symbolic link
ln -s original.txt symlink.txt

# They have different inodes
ls -li original.txt symlink.txt
# 12345 -rw-r--r-- 1 user user 12 Dec 31 10:00 original.txt
# 67890 lrwxrwxrwx 1 user user 12 Dec 31 10:00 symlink.txt -> original.txt

# Note: symlink shows 'l' as file type and '->' pointing to target

# Delete original - symlink becomes broken (dangling)
rm original.txt
cat symlink.txt  # Error: No such file or directory

# Symlink still exists but points to nothing
ls -l symlink.txt  # Still shows the link
```

---

## Identifying Links

### Using `ls -l`

```bash
# Hard links: Same inode, link count > 1
ls -li file.txt hardlink.txt
# 12345 -rw-r--r-- 2 user user 12 Dec 31 10:00 file.txt
# 12345 -rw-r--r-- 2 user user 12 Dec 31 10:00 hardlink.txt
#       ↑ link count is 2

# Soft links: Different inode, starts with 'l', shows arrow
ls -l symlink.txt
# lrwxrwxrwx 1 user user 8 Dec 31 10:00 symlink.txt -> file.txt
# ↑ 'l' = symbolic link
```

### Using `stat`

```bash
# View detailed file information
stat filename.txt

# Key fields:
# - Inode: The inode number
# - Links: Number of hard links
# - File type: regular file, symbolic link, etc.
```

### Using `readlink`

```bash
# Show target of symbolic link
readlink symlink.txt
# Output: original.txt

# Show absolute path of target
readlink -f symlink.txt
# Output: /home/user/original.txt

# Canonicalize path (resolve all symlinks)
readlink -e symlink.txt
```

### Using `file`

```bash
# Identify file type
file symlink.txt
# Output: symlink.txt: symbolic link to original.txt

file hardlink.txt
# Output: hardlink.txt: ASCII text
```

### Finding Links with `find`

```bash
# Find all symbolic links in a directory
find /path -type l

# Find all hard links to a specific file (by inode)
find /path -inum 12345

# Find broken symbolic links
find /path -xtype l

# Find files with more than one hard link
find /path -type f -links +1
```

---

## Symbolic Links to Directories

```bash
# Create symlink to directory
ln -s /var/log /home/user/logs

# Access directory through symlink
ls /home/user/logs
cd /home/user/logs

# Note: cd into symlink vs physical path
cd /home/user/logs
pwd           # Shows /home/user/logs (logical path)
pwd -P        # Shows /var/log (physical path)
```

---

## Relative vs Absolute Paths in Symlinks

### Absolute Path Symlinks

```bash
# Uses full path - works from anywhere but breaks if target moves
ln -s /home/user/documents/file.txt /tmp/link

readlink /tmp/link
# Output: /home/user/documents/file.txt
```

### Relative Path Symlinks

```bash
# Uses relative path - more portable
cd /tmp
ln -s ../home/user/documents/file.txt link

readlink link
# Output: ../home/user/documents/file.txt

# Create relative link automatically
ln -sr /home/user/file.txt /tmp/link
```

---

## Managing Links

### Removing Links

```bash
# Remove symbolic link (does NOT delete target)
rm symlink.txt
# Or
unlink symlink.txt

# Remove hard link (decreases link count)
rm hardlink.txt
# Original file deleted only when link count reaches 0
```

### Updating Symbolic Links

```bash
# Method 1: Remove and recreate
rm symlink.txt
ln -s new_target symlink.txt

# Method 2: Force overwrite
ln -sf new_target symlink.txt
```

### Copying Links

```bash
# Copy symlink as symlink (default)
cp -P symlink.txt /destination/

# Copy symlink and dereference (copy target file)
cp -L symlink.txt /destination/

# Archive copy preserves symlinks
cp -a source/ destination/
```

---

## Common Use Cases

### 1. Version Management
```bash
# Create versioned files with a current link
ln -s app-v2.0 /opt/app/current
# To upgrade: ln -sf app-v3.0 /opt/app/current
```

### 2. Configuration Files
```bash
# Link configuration file to expected location
ln -s /home/user/dotfiles/.bashrc ~/.bashrc
```

### 3. Library Symlinks
```bash
# Common in /lib and /usr/lib
ls -l /lib/libc.so.6
# libc.so.6 -> libc-2.31.so
```

### 4. Shortcuts to Deep Directories
```bash
ln -s /var/www/html/myproject/public ~/myproject
```

---

## Practice Questions

### Question 1
Create a hard link named `/tmp/hardlink.txt` that points to `/home/user/original.txt`.

<details>
<summary>Show Solution</summary>

```bash
ln /home/user/original.txt /tmp/hardlink.txt

# Verify
ls -li /home/user/original.txt /tmp/hardlink.txt
# Both should show same inode number
```
</details>

---

### Question 2
Create a symbolic link named `/tmp/softlink.txt` that points to `/etc/passwd`.

<details>
<summary>Show Solution</summary>

```bash
ln -s /etc/passwd /tmp/softlink.txt

# Verify
ls -l /tmp/softlink.txt
# Output: lrwxrwxrwx 1 user user 11 ... /tmp/softlink.txt -> /etc/passwd

readlink /tmp/softlink.txt
# Output: /etc/passwd
```
</details>

---

### Question 3
Create a symbolic link `/home/user/logs` that points to the `/var/log` directory.

<details>
<summary>Show Solution</summary>

```bash
ln -s /var/log /home/user/logs

# Verify
ls -l /home/user/logs
# Output: lrwxrwxrwx 1 user user 8 ... /home/user/logs -> /var/log

# Test access
ls /home/user/logs
```
</details>

---

### Question 4
Verify that two files are hard links to each other (share the same inode).

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Compare inode numbers
ls -i file1.txt file2.txt

# Method 2: Use stat
stat file1.txt file2.txt | grep Inode

# Method 3: Check if inodes match
[ $(stat -c %i file1.txt) -eq $(stat -c %i file2.txt) ] && echo "Same inode"
```
</details>

---

### Question 5
Find the target of the symbolic link `/usr/bin/python3`.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Using readlink
readlink /usr/bin/python3

# Method 2: Using readlink with full path
readlink -f /usr/bin/python3

# Method 3: Using ls -l
ls -l /usr/bin/python3

# Method 4: Using file command
file /usr/bin/python3
```
</details>

---

### Question 6
Create a file `/tmp/original.txt` with content "test", create a hard link and a soft link to it, then delete the original file. What happens to each link?

<details>
<summary>Show Solution</summary>

```bash
# Create original file
echo "test" > /tmp/original.txt

# Create hard link
ln /tmp/original.txt /tmp/hardlink.txt

# Create soft link
ln -s /tmp/original.txt /tmp/softlink.txt

# Delete original
rm /tmp/original.txt

# Test hard link - WORKS (data still exists)
cat /tmp/hardlink.txt
# Output: test

# Test soft link - FAILS (broken/dangling link)
cat /tmp/softlink.txt
# Error: No such file or directory

# Verify broken link
ls -l /tmp/softlink.txt
# Shows link but target doesn't exist
```
</details>

---

### Question 7
Find all symbolic links in the `/etc` directory.

<details>
<summary>Show Solution</summary>

```bash
find /etc -type l

# With more details
find /etc -type l -ls

# List with targets
find /etc -type l -exec ls -l {} \;
```
</details>

---

### Question 8
Find all broken (dangling) symbolic links in `/home/user`.

<details>
<summary>Show Solution</summary>

```bash
find /home/user -xtype l

# Or check manually
find /home/user -type l ! -exec test -e {} \; -print
```
</details>

---

### Question 9
Create a symbolic link with a relative path. The link `/opt/app/config` should point to `../shared/config.yml`.

<details>
<summary>Show Solution</summary>

```bash
# Make sure parent directories exist
mkdir -p /opt/app /opt/shared
touch /opt/shared/config.yml

# Create relative symlink
cd /opt/app
ln -s ../shared/config.yml config

# Or use -r option for automatic relative path
ln -sr /opt/shared/config.yml /opt/app/config

# Verify
readlink /opt/app/config
# Output: ../shared/config.yml
```
</details>

---

### Question 10
Replace an existing symbolic link `/tmp/current` to point to a new target `/opt/v2` without manually removing it first.

<details>
<summary>Show Solution</summary>

```bash
ln -sf /opt/v2 /tmp/current

# Verify
readlink /tmp/current
# Output: /opt/v2
```
</details>

---

### Question 11
Determine how many hard links exist for the file `/etc/passwd`.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Using stat
stat /etc/passwd | grep Links
# Or
stat -c %h /etc/passwd

# Method 2: Using ls -l (second column)
ls -l /etc/passwd
# -rw-r--r-- 1 root root ...
#            ↑ This number is the link count
```
</details>

---

### Question 12
Create a hard link to `/etc/hosts` in the `/tmp` directory. Will this work? Why or why not?

<details>
<summary>Show Solution</summary>

```bash
# Try to create hard link
ln /etc/hosts /tmp/hosts_hardlink

# This will WORK if /etc and /tmp are on the same filesystem
# This will FAIL if they are on different filesystems

# Check if same filesystem
df /etc /tmp
# If they show same filesystem, it works

# To verify it worked:
ls -li /etc/hosts /tmp/hosts_hardlink
# Should show same inode number

# If different filesystems, you'll get error:
# "Invalid cross-device link"
# Solution: Use symbolic link instead
ln -s /etc/hosts /tmp/hosts_softlink
```
</details>

---

### Question 13
Find all files in `/home` that have more than one hard link.

<details>
<summary>Show Solution</summary>

```bash
find /home -type f -links +1

# With details
find /home -type f -links +1 -ls
```
</details>

---

### Question 14
Create a symbolic link in the current directory that points to the file `../data/file.txt` using absolute path conversion.

<details>
<summary>Show Solution</summary>

```bash
# Create with absolute path
ln -s $(realpath ../data/file.txt) link.txt

# Or manually specify absolute path
ln -s /full/path/to/data/file.txt link.txt

# Verify
readlink -f link.txt
```
</details>

---

### Question 15
What is the inode number of `/etc/passwd`? Use two different commands to find it.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Using ls -i
ls -i /etc/passwd

# Method 2: Using stat
stat /etc/passwd | grep Inode
# Or
stat -c %i /etc/passwd
```
</details>

---

### Question 16
Create a symbolic link `/var/www/html/site` pointing to `/home/webuser/public_html`.

<details>
<summary>Show Solution</summary>

```bash
# Create the symbolic link
ln -s /home/webuser/public_html /var/www/html/site

# Verify
ls -l /var/www/html/site
readlink /var/www/html/site
```
</details>

---

### Question 17
Copy a directory that contains symbolic links, preserving the links as links (not following them).

<details>
<summary>Show Solution</summary>

```bash
# Using -a (archive) preserves symlinks
cp -a /source/directory /destination/

# Or explicitly with -P (no-dereference)
cp -rP /source/directory /destination/

# Do NOT use -L which follows links
```
</details>

---

### Question 18
Identify whether `/usr/bin/python` is a hard link or symbolic link, and if symbolic, show its target.

<details>
<summary>Show Solution</summary>

```bash
# Check file type
file /usr/bin/python

# If symbolic link, shows target
ls -l /usr/bin/python
# Output like: lrwxrwxrwx ... /usr/bin/python -> python3

# Get just the target
readlink /usr/bin/python

# Get final target (following chain of symlinks)
readlink -f /usr/bin/python
```
</details>

---

### Question 19
Create multiple hard links to a single file and verify the link count increases.

<details>
<summary>Show Solution</summary>

```bash
# Create original file
echo "content" > /tmp/original.txt

# Check initial link count
stat -c "Links: %h" /tmp/original.txt
# Output: Links: 1

# Create first hard link
ln /tmp/original.txt /tmp/link1.txt
stat -c "Links: %h" /tmp/original.txt
# Output: Links: 2

# Create second hard link
ln /tmp/original.txt /tmp/link2.txt
stat -c "Links: %h" /tmp/original.txt
# Output: Links: 3

# All three files share the same inode
ls -li /tmp/original.txt /tmp/link1.txt /tmp/link2.txt
```
</details>

---

### Question 20
Remove a symbolic link without affecting the target file.

<details>
<summary>Show Solution</summary>

```bash
# Create test setup
echo "important data" > /tmp/target.txt
ln -s /tmp/target.txt /tmp/symlink.txt

# Remove the symbolic link (NOT the target)
rm /tmp/symlink.txt
# Or
unlink /tmp/symlink.txt

# Verify target still exists
cat /tmp/target.txt
# Output: important data
```
</details>

---

### Question 21
Explain why you cannot create a hard link to a directory.

<details>
<summary>Show Solution</summary>

```bash
# Attempting to create hard link to directory
ln /home/user/mydir /tmp/dirlink
# Error: hard link not allowed for directory

# Reasons:
# 1. Could create filesystem loops
# 2. Would confuse filesystem tree traversal
# 3. The . and .. entries are special hard links managed by kernel
# 4. Could cause infinite loops in programs like find, du, ls -R

# Solution: Use symbolic link instead
ln -s /home/user/mydir /tmp/dirlink
```
</details>

---

### Question 22
Create a symbolic link and verify it's a symbolic link using the `test` command.

<details>
<summary>Show Solution</summary>

```bash
# Create symbolic link
ln -s /etc/passwd /tmp/passwd_link

# Test if it's a symbolic link
if [ -L /tmp/passwd_link ]; then
    echo "It's a symbolic link"
fi

# Test if it's a symbolic link (one-liner)
test -L /tmp/passwd_link && echo "Symbolic link"

# Test if target exists
test -e /tmp/passwd_link && echo "Target exists"
```
</details>

---

### Question 23
Find all files that are hard-linked to `/etc/passwd` (same inode).

<details>
<summary>Show Solution</summary>

```bash
# Get inode of /etc/passwd
INODE=$(stat -c %i /etc/passwd)

# Find all files with same inode
find / -inum $INODE 2>/dev/null

# One-liner
find / -samefile /etc/passwd 2>/dev/null
```
</details>

---

### Question 24
Create a symbolic link that uses a relative path, then move the link to another directory. What happens?

<details>
<summary>Show Solution</summary>

```bash
# Create target file
mkdir -p /tmp/source /tmp/dest
echo "content" > /tmp/source/file.txt

# Create relative symlink
cd /tmp/source
ln -s file.txt link.txt

# Verify it works
cat /tmp/source/link.txt
# Output: content

# Move link to different directory
mv /tmp/source/link.txt /tmp/dest/

# Try to access - FAILS because relative path is now wrong
cat /tmp/dest/link.txt
# Error: No such file or directory

# The link still points to "file.txt" but from /tmp/dest/
# there's no file.txt

# Lesson: Use absolute paths if link might be moved
# Or use ln -sr for relative links that adjust paths
```
</details>

---

### Question 25
Create symbolic links for a set of configuration files from a central location to their expected paths.

<details>
<summary>Show Solution</summary>

```bash
# Scenario: Manage dotfiles from central repo

# Create central config directory
mkdir -p /home/user/dotfiles

# Create config files
cat > /home/user/dotfiles/bashrc << 'EOF'
# Custom bash configuration
alias ll='ls -la'
EOF

cat > /home/user/dotfiles/vimrc << 'EOF'
" Custom vim configuration
set number
EOF

# Create symbolic links to expected locations
ln -sf /home/user/dotfiles/bashrc /home/user/.bashrc
ln -sf /home/user/dotfiles/vimrc /home/user/.vimrc

# Verify
ls -la /home/user/.bashrc /home/user/.vimrc
```
</details>

---

## Quick Reference Cheat Sheet

### Creating Links

| Command | Description |
|---------|-------------|
| `ln target linkname` | Create hard link |
| `ln -s target linkname` | Create symbolic link |
| `ln -sf target linkname` | Force create/overwrite symbolic link |
| `ln -sr target linkname` | Create relative symbolic link |
| `ln -sv target linkname` | Create symbolic link with verbose output |

### Identifying Links

| Command | Description |
|---------|-------------|
| `ls -l` | Shows `l` prefix for symlinks, link count for hard links |
| `ls -i` | Shows inode numbers |
| `stat file` | Shows detailed inode and link info |
| `readlink link` | Shows target of symbolic link |
| `readlink -f link` | Shows absolute path of final target |
| `file link` | Identifies file type including symlinks |

### Finding Links

| Command | Description |
|---------|-------------|
| `find /path -type l` | Find all symbolic links |
| `find /path -xtype l` | Find broken symbolic links |
| `find /path -samefile file` | Find files with same inode |
| `find /path -links +1` | Find files with multiple hard links |
| `find /path -inum N` | Find files with inode number N |

---

## Key Points for RHCSA Exam

1. **Hard links share the same inode** - Same file data, different names
2. **Soft links are separate files** - Contain path to target
3. **Hard links cannot cross filesystems** - Same filesystem only
4. **Hard links cannot link to directories** - Only symbolic links can
5. **Deleting target breaks soft link** - Creates dangling/broken link
6. **Deleting one hard link doesn't delete data** - Data deleted when link count = 0
7. **Use `ln -s` for symbolic links** - Most common in practice
8. **Use `readlink` to see symlink target** - Essential troubleshooting command
9. **Use `ls -li` to compare inodes** - Verify hard links
10. **Relative paths in symlinks are relative to the link location** - Not current directory
