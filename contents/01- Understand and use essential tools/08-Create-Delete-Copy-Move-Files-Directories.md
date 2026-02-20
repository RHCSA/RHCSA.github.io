# Create, Delete, Copy, and Move Files and Directories

## Introduction

Managing files and directories is a core skill for RHCSA certification. This topic covers the essential commands for creating, deleting, copying, and moving files and directories in Linux. These operations are fundamental to system administration and are heavily tested on the RHCSA exam.

---

## Essential Commands Overview

| Operation | Files | Directories |
|-----------|-------|-------------|
| **Create** | `touch`, `>`, `cat`, `echo` | `mkdir` |
| **Delete** | `rm` | `rm -r`, `rmdir` |
| **Copy** | `cp` | `cp -r` |
| **Move/Rename** | `mv` | `mv` |

---

## Creating Files

### The `touch` Command

The `touch` command creates empty files or updates timestamps of existing files.

**Syntax:**
```bash
touch [OPTIONS] FILE...
```

**Common Options:**

| Option | Description |
|--------|-------------|
| `-a` | Change only the access time |
| `-m` | Change only the modification time |
| `-c` | Do not create any files (only update timestamps) |
| `-d STRING` | Parse STRING and use it instead of current time |
| `-r FILE` | Use reference file's times instead of current time |
| `-t STAMP` | Use specified time [[CC]YY]MMDDhhmm[.ss] |

**Examples:**

```bash
# Create a single empty file
touch file1.txt

# Create multiple files at once
touch file1.txt file2.txt file3.txt

# Create file with specific timestamp
touch -t 202312251200.00 holiday.txt

# Update only access time
touch -a existing_file.txt

# Update only modification time
touch -m existing_file.txt

# Use another file's timestamp as reference
touch -r reference_file.txt new_file.txt

# Do not create file if it doesn't exist
touch -c nonexistent.txt
```

### Creating Files with Redirection

```bash
# Create empty file using redirection
> newfile.txt

# Create file with content using echo
echo "Hello World" > file.txt

# Append to file
echo "New line" >> file.txt

# Create file with multiple lines using cat
cat > multiline.txt << EOF
Line 1
Line 2
Line 3
EOF
```

### Creating Files with Content

```bash
# Using printf
printf "Line1\nLine2\n" > file.txt

# Using tee (also displays to screen)
echo "content" | tee file.txt

# Using tee to append
echo "more content" | tee -a file.txt
```

---

## Creating Directories

### The `mkdir` Command

The `mkdir` command creates directories.

**Syntax:**
```bash
mkdir [OPTIONS] DIRECTORY...
```

**Common Options:**

| Option | Description |
|--------|-------------|
| `-p` | Create parent directories as needed (no error if existing) |
| `-m MODE` | Set file mode (permissions) |
| `-v` | Print message for each created directory |

**Examples:**

```bash
# Create a single directory
mkdir projects

# Create multiple directories
mkdir dir1 dir2 dir3

# Create nested directories (parent directories created automatically)
mkdir -p /home/user/projects/webapp/src/main

# Create directory with specific permissions
mkdir -m 755 public_dir
mkdir -m 700 private_dir

# For detailed permission management, see:
# See Topic 10: List, Set, and Change Permissions

# Create directory with verbose output
mkdir -v new_directory

# Create multiple nested directory structures
mkdir -p project/{src,bin,lib,docs}
```

### Brace Expansion for Multiple Directories

```bash
# Create multiple directories with similar names
mkdir dir{1,2,3,4,5}

# Create a directory structure
mkdir -p project/{src/{main,test},docs,build}

# Create directories with number range
mkdir dir{01..10}

# Create year/month directory structure
mkdir -p logs/2024/{01..12}
```

---

## Deleting Files

### The `rm` Command

The `rm` command removes files and directories.

**Syntax:**
```bash
rm [OPTIONS] FILE...
```

**Common Options:**

| Option | Description |
|--------|-------------|
| `-f` | Force removal, ignore nonexistent files, never prompt |
| `-i` | Prompt before every removal |
| `-I` | Prompt once before removing more than three files |
| `-r`, `-R` | Remove directories and their contents recursively |
| `-d` | Remove empty directories |
| `-v` | Verbose, explain what is being done |

**Examples:**

```bash
# Remove a single file
rm file.txt

# Remove multiple files
rm file1.txt file2.txt file3.txt

# Remove with confirmation prompt
rm -i important_file.txt

# Force remove (no prompts, no errors if missing)
rm -f file.txt

# Remove all .log files
rm *.log

# Remove files starting with dash
rm -- -filename
# Or
rm ./-filename

# Verbose removal
rm -v file.txt
```

### Removing Directories

```bash
# Remove empty directory using rmdir
rmdir empty_directory

# Remove empty directory using rm
rm -d empty_directory

# Remove directory and all contents (CAUTION!)
rm -r directory_name

# Force remove directory and contents (no prompts)
rm -rf directory_name

# Remove multiple directories recursively
rm -r dir1 dir2 dir3

# Interactive removal of directory
rm -ri directory_name
```

### The `rmdir` Command

The `rmdir` command removes **empty** directories only.

**Syntax:**
```bash
rmdir [OPTIONS] DIRECTORY...
```

**Options:**

| Option | Description |
|--------|-------------|
| `-p` | Remove directory and its ancestors |
| `-v` | Verbose output |
| `--ignore-fail-on-non-empty` | Ignore failure on non-empty directories |

**Examples:**

```bash
# Remove empty directory
rmdir empty_dir

# Remove nested empty directories
rmdir -p a/b/c    # Removes c, then b, then a (all must be empty)

# Remove with verbose output
rmdir -v empty_dir
```

---

## Copying Files and Directories

### The `cp` Command

The `cp` command copies files and directories.

**Syntax:**
```bash
cp [OPTIONS] SOURCE DEST
cp [OPTIONS] SOURCE... DIRECTORY
```

**Common Options:**

| Option | Description |
|--------|-------------|
| `-r`, `-R` | Copy directories recursively |
| `-a` | Archive mode (same as -dR --preserve=all) |
| `-i` | Prompt before overwrite |
| `-f` | Force overwrite |
| `-n` | Do not overwrite existing files |
| `-u` | Copy only when source is newer |
| `-v` | Verbose output |
| `-p` | Preserve mode, ownership, timestamps |
| `-l` | Hard link files instead of copying |
| `-s` | Create symbolic links instead of copying |

**Examples:**

```bash
# Copy file to new name
cp original.txt copy.txt

# Copy file to directory
cp file.txt /tmp/

# Copy file to directory with new name
cp file.txt /tmp/newname.txt

# Copy multiple files to directory
cp file1.txt file2.txt file3.txt /destination/

# Copy with interactive prompt
cp -i source.txt destination.txt

# Copy and preserve attributes
cp -p source.txt destination.txt

# Copy directory recursively
cp -r source_dir/ destination_dir/

# Archive copy (preserves everything)
cp -a source_dir/ destination_dir/

# Copy only if source is newer
cp -u source.txt destination.txt

# Copy with verbose output
cp -v file.txt /backup/

# Copy all files from one directory to another
cp -r /source/* /destination/

# Copy files matching pattern
cp *.txt /backup/
```

### Copying Directories

```bash
# Copy entire directory
cp -r projects/ projects_backup/

# Copy directory preserving all attributes
cp -a /var/www/ /backup/www/

# Copy directory contents (not the directory itself)
cp -r source_dir/* destination_dir/

# Copy directory with verbose output
cp -rv source/ destination/
```

---

## Moving and Renaming Files and Directories

### The `mv` Command

The `mv` command moves or renames files and directories.

**Syntax:**
```bash
mv [OPTIONS] SOURCE DEST
mv [OPTIONS] SOURCE... DIRECTORY
```

**Common Options:**

| Option | Description |
|--------|-------------|
| `-f` | Force, do not prompt before overwriting |
| `-i` | Prompt before overwrite |
| `-n` | Do not overwrite existing file |
| `-u` | Move only when source is newer |
| `-v` | Verbose output |
| `--backup` | Make backup of destination files |

**Examples:**

```bash
# Rename a file
mv oldname.txt newname.txt

# Move file to directory
mv file.txt /home/user/documents/

# Move file to directory with new name
mv file.txt /destination/newname.txt

# Move multiple files to directory
mv file1.txt file2.txt file3.txt /destination/

# Move with confirmation prompt
mv -i source.txt destination.txt

# Force move (no prompt)
mv -f source.txt destination.txt

# Move only if source is newer
mv -u source.txt destination.txt

# Move with verbose output
mv -v file.txt /backup/

# Move all files matching pattern
mv *.log /var/log/archive/

# Create backup before overwriting
mv --backup=numbered file.txt /destination/
```

### Renaming and Moving Directories

```bash
# Rename directory
mv old_dir_name new_dir_name

# Move directory to another location
mv directory/ /new/location/

# Move directory contents
mv source_dir/* destination_dir/

# Move with verbose output
mv -v projects/ /home/user/backup/
```

---

## Wildcards and Globbing

Wildcards are essential for file operations:

| Wildcard | Description | Example |
|----------|-------------|---------|
| `*` | Matches zero or more characters | `*.txt` matches all .txt files |
| `?` | Matches exactly one character | `file?.txt` matches file1.txt |
| `[abc]` | Matches any character in brackets | `file[123].txt` |
| `[a-z]` | Matches range of characters | `file[a-z].txt` |
| `[!abc]` | Matches any character NOT in brackets | `file[!0-9].txt` |
| `{a,b,c}` | Brace expansion | `file{1,2,3}.txt` |

**Examples:**

```bash
# Copy all .txt files
cp *.txt /backup/

# Move files starting with 'log'
mv log* /var/log/archive/

# Delete files with single character before extension
rm file?.txt

# Copy files with numbers in name
cp report[0-9].pdf /documents/

# Move files NOT starting with a letter
mv [!a-zA-Z]* /numbers/
```

---

## File Listing Commands

### The `ls` Command

Useful for verifying file operations:

| Option | Description |
|--------|-------------|
| `-l` | Long format listing |
| `-a` | Show hidden files |
| `-h` | Human-readable sizes |
| `-R` | Recursive listing |
| `-t` | Sort by modification time |
| `-S` | Sort by size |
| `-r` | Reverse order |

```bash
# List files in long format
ls -l

# List all files including hidden
ls -la

# List with human-readable sizes
ls -lh

# List recursively
ls -R

# List sorted by time
ls -lt
```

---

## Practice Questions

### Question 1
Create a directory structure `/home/user/project` with subdirectories `src`, `bin`, and `docs` using a single command.

<details>
<summary>Show Solution</summary>

```bash
mkdir -p /home/user/project/{src,bin,docs}

# Or without brace expansion:
mkdir -p /home/user/project/src /home/user/project/bin /home/user/project/docs
```
</details>

---

### Question 2
Create 5 empty files named `report1.txt` through `report5.txt` in `/tmp` directory.

<details>
<summary>Show Solution</summary>

```bash
touch /tmp/report{1..5}.txt

# Or:
touch /tmp/report1.txt /tmp/report2.txt /tmp/report3.txt /tmp/report4.txt /tmp/report5.txt
```
</details>

---

### Question 3
Copy the directory `/etc/sysconfig` and all its contents to `/root/backup/` preserving all file attributes.

<details>
<summary>Show Solution</summary>

```bash
cp -a /etc/sysconfig /root/backup/

# Or:
cp -rp /etc/sysconfig /root/backup/

# Create destination if needed:
mkdir -p /root/backup && cp -a /etc/sysconfig /root/backup/
```
</details>

---

### Question 4
Move all `.log` files from `/var/log/` to `/tmp/logs/` creating the destination directory if it doesn't exist.

<details>
<summary>Show Solution</summary>

```bash
mkdir -p /tmp/logs && mv /var/log/*.log /tmp/logs/
```
</details>

---

### Question 5
Delete all files in `/tmp/test/` directory but keep the directory itself.

<details>
<summary>Show Solution</summary>

```bash
rm -rf /tmp/test/*

# Or to also remove hidden files:
rm -rf /tmp/test/* /tmp/test/.*  2>/dev/null

# Best approach for hidden files:
rm -rf /tmp/test/{*,.*} 2>/dev/null
```
</details>

---

### Question 6
Rename the file `/home/user/oldconfig.conf` to `/home/user/newconfig.conf`.

<details>
<summary>Show Solution</summary>

```bash
mv /home/user/oldconfig.conf /home/user/newconfig.conf
```
</details>

---

### Question 7
Create a directory `/data/archive` with permissions 700 (owner read, write, execute only).

<details>
<summary>Show Solution</summary>

```bash
mkdir -p -m 700 /data/archive

# Or in two steps:
mkdir -p /data/archive
chmod 700 /data/archive
```
</details>

---

### Question 8
Copy the file `/etc/hosts` to `/tmp/` and rename it to `hosts.backup` in one command.

<details>
<summary>Show Solution</summary>

```bash
cp /etc/hosts /tmp/hosts.backup
```
</details>

---

### Question 9
Remove the directory `/home/user/oldproject` and all its contents without any confirmation prompts.

<details>
<summary>Show Solution</summary>

```bash
rm -rf /home/user/oldproject
```
</details>

---

### Question 10
Create a file `/tmp/timestamp.txt` with a modification time of January 15, 2024 at 14:30.

<details>
<summary>Show Solution</summary>

```bash
touch -t 202401151430.00 /tmp/timestamp.txt

# Or using date string:
touch -d "2024-01-15 14:30:00" /tmp/timestamp.txt
```
</details>

---

### Question 11
Copy all files from `/home/user/documents/` to `/backup/docs/` but only if the source files are newer than the destination files.

<details>
<summary>Show Solution</summary>

```bash
cp -u /home/user/documents/* /backup/docs/

# For directories:
cp -ru /home/user/documents/* /backup/docs/
```
</details>

---

### Question 12
Create an empty directory structure: `/var/data/2024/01`, `/var/data/2024/02`, through `/var/data/2024/12`.

<details>
<summary>Show Solution</summary>

```bash
mkdir -p /var/data/2024/{01..12}

# Verify:
ls /var/data/2024/
```
</details>

---

### Question 13
Move the directory `/home/user/project` to `/opt/` keeping the same directory name.

<details>
<summary>Show Solution</summary>

```bash
mv /home/user/project /opt/

# Verify:
ls /opt/project
```
</details>

---

### Question 14
Remove all empty directories inside `/tmp/cleanup/` recursively.

<details>
<summary>Show Solution</summary>

```bash
# Using find command
find /tmp/cleanup/ -type d -empty -delete

# Or using rmdir with find
find /tmp/cleanup/ -type d -empty -exec rmdir {} \;
```
</details>

---

### Question 15
Copy `/etc/passwd` to `/tmp/` preserving the original ownership and permissions.

<details>
<summary>Show Solution</summary>

```bash
cp -p /etc/passwd /tmp/

# Or with archive mode:
cp -a /etc/passwd /tmp/
```
</details>

---

### Question 16
Create a file named `-important.txt` in the current directory (note the leading dash).

<details>
<summary>Show Solution</summary>

```bash
touch -- -important.txt

# Or:
touch ./-important.txt
```
</details>

---

### Question 17
Delete the file named `-important.txt` (with leading dash).

<details>
<summary>Show Solution</summary>

```bash
rm -- -important.txt

# Or:
rm ./-important.txt
```
</details>

---

### Question 18
Move all files that start with "backup" and end with ".tar" from current directory to `/archive/`.

<details>
<summary>Show Solution</summary>

```bash
mv backup*.tar /archive/
```
</details>

---

### Question 19
Create nested directories `/app/config/prod` and `/app/config/dev` using one command.

<details>
<summary>Show Solution</summary>

```bash
mkdir -p /app/config/{prod,dev}

# Verify:
ls -la /app/config/
```
</details>

---

### Question 20
Copy only the `.conf` files from `/etc/` to `/backup/conf/` without copying subdirectories.

<details>
<summary>Show Solution</summary>

```bash
mkdir -p /backup/conf
cp /etc/*.conf /backup/conf/
```
</details>

---

### Question 21
Delete all files in current directory that have a number in their filename.

<details>
<summary>Show Solution</summary>

```bash
rm *[0-9]*
```
</details>

---

### Question 22
Create 100 empty files named `file001.txt` through `file100.txt` in `/tmp/files/` directory.

<details>
<summary>Show Solution</summary>

```bash
mkdir -p /tmp/files
touch /tmp/files/file{001..100}.txt

# Verify count:
ls /tmp/files/ | wc -l
```
</details>

---

### Question 23
Move the contents of `/source/` directory to `/destination/` without moving the source directory itself.

<details>
<summary>Show Solution</summary>

```bash
mv /source/* /destination/

# To include hidden files:
mv /source/{*,.*} /destination/ 2>/dev/null

# Or using shopt:
shopt -s dotglob
mv /source/* /destination/
shopt -u dotglob
```
</details>

---

### Question 24
Remove a directory named `old data` that contains spaces in the name.

<details>
<summary>Show Solution</summary>

```bash
rm -r "old data"

# Or:
rm -r 'old data'

# Or escape the space:
rm -r old\ data
```
</details>

---

### Question 25
Create a backup of `/etc/fstab` named `/etc/fstab.bak` and then copy it to `/root/`.

<details>
<summary>Show Solution</summary>

```bash
cp /etc/fstab /etc/fstab.bak
cp /etc/fstab.bak /root/

# Or in one step:
cp /etc/fstab /etc/fstab.bak && cp /etc/fstab.bak /root/
```
</details>

---

## Quick Reference Cheat Sheet

### Creating Files and Directories

| Command | Description |
|---------|-------------|
| `touch file` | Create empty file |
| `touch file{1..5}` | Create files 1-5 |
| `mkdir dir` | Create directory |
| `mkdir -p a/b/c` | Create nested directories |
| `mkdir -m 755 dir` | Create with permissions |
| `mkdir dir{1,2,3}` | Create multiple directories |

### Deleting Files and Directories

| Command | Description |
|---------|-------------|
| `rm file` | Delete file |
| `rm -f file` | Force delete file |
| `rm -i file` | Interactive delete |
| `rm -r dir` | Delete directory recursively |
| `rm -rf dir` | Force delete directory |
| `rmdir dir` | Delete empty directory |
| `rmdir -p a/b/c` | Delete nested empty directories |

### Copying Files and Directories

| Command | Description |
|---------|-------------|
| `cp src dst` | Copy file |
| `cp -r src dst` | Copy directory |
| `cp -a src dst` | Archive copy (preserves all) |
| `cp -p src dst` | Preserve attributes |
| `cp -i src dst` | Interactive copy |
| `cp -u src dst` | Update only (if newer) |
| `cp -v src dst` | Verbose copy |

### Moving/Renaming Files and Directories

| Command | Description |
|---------|-------------|
| `mv old new` | Rename file/directory |
| `mv file dir/` | Move file to directory |
| `mv -i src dst` | Interactive move |
| `mv -f src dst` | Force move |
| `mv -u src dst` | Update only (if newer) |
| `mv -v src dst` | Verbose move |

---

## Common Exam Scenarios

### Scenario 1: Setup Project Structure
Create a complete project directory structure with source, build, and documentation folders.

```bash
mkdir -p /opt/project/{src/{main,test},build,docs,config/{dev,prod}}
touch /opt/project/README.md
touch /opt/project/config/{dev,prod}/settings.conf
```

### Scenario 2: Backup Configuration Files
Copy all configuration files preserving attributes.

```bash
mkdir -p /backup/etc
cp -a /etc/*.conf /backup/etc/
```

### Scenario 3: Clean Up Log Files
Move old logs to archive and remove empty directories.

```bash
mkdir -p /archive/logs
mv /var/log/*.log.old /archive/logs/
find /var/log -type d -empty -delete
```

### Scenario 4: Rename Multiple Files
Rename files following a pattern.

```bash
# Move and rename in a loop
for f in *.txt; do
    mv "$f" "backup_$f"
done
```

---

## Important Notes for RHCSA Exam

1. **Use `-p` with mkdir**: Always use `mkdir -p` to avoid errors when parent directories don't exist
2. **Be careful with `rm -rf`**: Double-check paths before using force recursive delete
3. **Preserve attributes**: Use `cp -a` or `cp -p` when copying system files
4. **Handle special characters**: Use quotes or escape characters for filenames with spaces or special characters
5. **Files with leading dash**: Use `--` or `./` to handle files starting with `-`
6. **Verify operations**: Use `ls -la` to verify file operations completed correctly
7. **Brace expansion**: Master `{a,b,c}` and `{1..10}` for efficient multiple file/directory creation
8. **Wildcards**: Know `*`, `?`, `[]`, and `[!]` for pattern matching

---

## Useful Tips and Commands

### Viewing Exact Timestamps

```bash
# Show exact modification time with full precision
ls --full-time filename

# Example output:
# -rw-r--r-- 1 root root 0 2024-12-18 01:30:09.000000000 +0000 important_file
```

### Quick Directory Navigation

```bash
# Return to previous directory
cd -

# Example:
cd /etc/sysconfig
cd /var/log
cd -   # Returns to /etc/sysconfig
```

---

## Text File Manipulation Commands

These commands are useful for working with file contents:

### The `diff` Command

Compare two files line by line:

```bash
# Basic diff
diff file1.txt file2.txt

# Context format (shows surrounding lines)
diff -c file1.txt file2.txt

# Side-by-side comparison
diff -y file1.txt file2.txt

# Same as diff -y
sdiff file1.txt file2.txt
```

### The `sed` Command (Stream Editor)

Search and replace text in files:

```bash
# Replace first occurrence per line
sed 's/old/new/' file.txt

# Replace all occurrences (global)
sed 's/old/new/g' file.txt

# Edit file in place
sed -i 's/old/new/g' file.txt

# Delete lines matching pattern
sed '/pattern/d' file.txt
```

### The `cut` Command

Extract columns from text:

```bash
# Extract by delimiter and field
cut -d':' -f1 /etc/passwd    # First field (usernames)
cut -d':' -f1,3 /etc/passwd  # First and third fields

# Extract by character position
cut -c1-10 file.txt          # First 10 characters
```

### The `sort` Command

```bash
# Basic alphabetical sort
sort file.txt

# Sort and remove duplicates
sort -u file.txt

# Sort alphabetically, case-insensitive, unique
sort -duf file.txt

# Numeric sort
sort -n file.txt
```

### The `uniq` Command

Remove duplicate adjacent lines (use with sort):

```bash
# Remove duplicates (file must be sorted first)
sort file.txt | uniq

# Count occurrences
sort file.txt | uniq -c

# Show only duplicates
sort file.txt | uniq -d
```

---

## Summary Table: Command Comparison

| Task | Command | Key Options |
|------|---------|-------------|
| Create empty file | `touch` | `-c`, `-t`, `-d` |
| Create directory | `mkdir` | `-p`, `-m`, `-v` |
| Delete file | `rm` | `-f`, `-i`, `-v` |
| Delete directory | `rm -r` / `rmdir` | `-rf`, `-p` |
| Copy file | `cp` | `-p`, `-i`, `-v` |
| Copy directory | `cp -r` | `-a`, `-R` |
| Move/Rename | `mv` | `-i`, `-f`, `-u` |
