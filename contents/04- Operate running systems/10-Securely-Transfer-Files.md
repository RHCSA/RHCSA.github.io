# Securely Transfer Files Between Systems

## RHCSA Exam Objective
> Securely transfer files between systems

---

## Introduction

Securely transferring files between systems is essential for system administration. The RHCSA exam tests your ability to use SSH-based tools like `scp`, `sftp`, and `rsync` to copy files securely between hosts.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `scp` | Secure copy over SSH |
| `sftp` | Secure FTP over SSH |
| `rsync` | Efficient file synchronization |

---

## Practice Questions

### Question 1: Copy File to Remote System
**Task:** Copy `/etc/hosts` to remote server 192.168.1.100.

<details>
<summary>Show Solution</summary>

```bash
scp /etc/hosts user@192.168.1.100:/tmp/
```

**Copy to user's home directory:**
```bash
scp /etc/hosts user@192.168.1.100:~
```
</details>

---

### Question 2: Copy File from Remote System
**Task:** Download `/var/log/messages` from remote server to local `/tmp`.

<details>
<summary>Show Solution</summary>

```bash
scp user@192.168.1.100:/var/log/messages /tmp/
```
</details>

---

### Question 3: Copy Directory Recursively
**Task:** Copy the entire `/etc/ssh` directory to remote server.

<details>
<summary>Show Solution</summary>

```bash
scp -r /etc/ssh user@192.168.1.100:/backup/
```

**Note:** `-r` enables recursive copy for directories.
</details>

---

### Question 4: Copy with Different Port
**Task:** Copy a file to a server running SSH on port 2222.

<details>
<summary>Show Solution</summary>

```bash
scp -P 2222 /path/file user@192.168.1.100:/destination/
```

**Note:** Use uppercase `-P` for scp (lowercase `-p` preserves timestamps).
</details>

---

### Question 5: Preserve Permissions During Copy
**Task:** Copy file and preserve original timestamps and permissions.

<details>
<summary>Show Solution</summary>

```bash
scp -p /path/file user@192.168.1.100:/destination/
```
</details>

---

### Question 6: Copy Multiple Files
**Task:** Copy multiple files to remote server.

<details>
<summary>Show Solution</summary>

```bash
scp file1.txt file2.txt file3.txt user@192.168.1.100:/destination/
```

**Using wildcard:**
```bash
scp *.conf user@192.168.1.100:/etc/myapp/
```
</details>

---

### Question 7: Copy Between Two Remote Systems
**Task:** Copy a file from server1 to server2.

<details>
<summary>Show Solution</summary>

```bash
scp user@server1:/path/file user@server2:/destination/
```

**Note:** Your local machine acts as the intermediary.
</details>

---

### Question 8: Use SFTP Interactive Mode
**Task:** Connect to remote server using SFTP.

<details>
<summary>Show Solution</summary>

```bash
sftp user@192.168.1.100
```

**SFTP commands:**
- `ls` - List remote files
- `lls` - List local files
- `cd` - Change remote directory
- `lcd` - Change local directory
- `get file` - Download file
- `put file` - Upload file
- `mget *.txt` - Download multiple files
- `mput *.txt` - Upload multiple files
- `exit` - Quit SFTP
</details>

---

### Question 9: Download File with SFTP
**Task:** Use SFTP to download `/var/log/secure` from remote server.

<details>
<summary>Show Solution</summary>

```bash
sftp user@192.168.1.100
sftp> cd /var/log
sftp> get secure
sftp> exit
```

**Non-interactive:**
```bash
echo "get /var/log/secure" | sftp user@192.168.1.100
```
</details>

---

### Question 10: Upload File with SFTP
**Task:** Use SFTP to upload `backup.tar.gz` to remote `/backup` directory.

<details>
<summary>Show Solution</summary>

```bash
sftp user@192.168.1.100
sftp> cd /backup
sftp> put backup.tar.gz
sftp> exit
```
</details>

---

### Question 11: Sync Directory with Rsync
**Task:** Synchronize local `/var/www` to remote server.

<details>
<summary>Show Solution</summary>

```bash
rsync -avz /var/www/ user@192.168.1.100:/var/www/
```

**Options:**
- `-a`: Archive mode (preserves permissions, timestamps, etc.)
- `-v`: Verbose
- `-z`: Compress during transfer
</details>

---

### Question 12: Rsync with Delete
**Task:** Synchronize and delete files on remote that don't exist locally.

<details>
<summary>Show Solution</summary>

```bash
rsync -avz --delete /var/www/ user@192.168.1.100:/var/www/
```

**Warning:** `--delete` removes files on destination not in source.
</details>

---

### Question 13: Rsync Dry Run
**Task:** Preview what rsync would do without making changes.

<details>
<summary>Show Solution</summary>

```bash
rsync -avzn /var/www/ user@192.168.1.100:/var/www/
```

**Or:**
```bash
rsync -avz --dry-run /var/www/ user@192.168.1.100:/var/www/
```
</details>

---

### Question 14: Rsync with Progress
**Task:** Show progress during large file transfer.

<details>
<summary>Show Solution</summary>

```bash
rsync -avz --progress /path/largefile user@192.168.1.100:/destination/
```
</details>

---

### Question 15: Rsync Specific Port
**Task:** Use rsync with SSH on port 2222.

<details>
<summary>Show Solution</summary>

```bash
rsync -avz -e "ssh -p 2222" /path/ user@192.168.1.100:/destination/
```
</details>

---

### Question 16: Rsync from Remote to Local
**Task:** Download remote directory to local system.

<details>
<summary>Show Solution</summary>

```bash
rsync -avz user@192.168.1.100:/var/backups/ /local/backups/
```

**Note:** Trailing slash matters:
- `/source/` - Contents of source
- `/source` - The directory itself
</details>

---

### Question 17: Rsync Exclude Files
**Task:** Sync directory but exclude log files.

<details>
<summary>Show Solution</summary>

```bash
rsync -avz --exclude '*.log' /var/www/ user@192.168.1.100:/var/www/
```

**Multiple excludes:**
```bash
rsync -avz --exclude '*.log' --exclude '*.tmp' /source/ user@host:/dest/
```
</details>

---

### Question 18: Exam Scenario - Backup to Remote Server
**Task:** Create a backup of `/etc` directory on remote server 192.168.1.100.

<details>
<summary>Show Solution</summary>

```bash
# Using scp
scp -r /etc root@192.168.1.100:/backup/

# Using rsync (more efficient)
rsync -avz /etc/ root@192.168.1.100:/backup/etc/
```
</details>

---

### Question 19: Exam Scenario - Sync Web Content
**Task:** Synchronize web content from development to production server.

<details>
<summary>Show Solution</summary>

```bash
# Dry run first
rsync -avzn /var/www/html/ user@production:/var/www/html/

# If looks good, execute
rsync -avz /var/www/html/ user@production:/var/www/html/
```
</details>

---

### Question 20: Copy with Bandwidth Limit
**Task:** Copy large file with limited bandwidth (1MB/s).

<details>
<summary>Show Solution</summary>

```bash
# Using scp
scp -l 8192 largefile user@192.168.1.100:/destination/
# Note: -l is in Kbit/s (8192 Kbit = 1 MB)

# Using rsync
rsync -avz --bwlimit=1000 largefile user@192.168.1.100:/destination/
# Note: --bwlimit is in KB/s
```
</details>

---

## Command Comparison

| Feature | scp | sftp | rsync |
|---------|-----|------|-------|
| Simple file copy | Yes | Yes | Yes |
| Interactive mode | No | Yes | No |
| Resume transfer | No | Yes | Yes |
| Delta sync | No | No | Yes |
| Exclude patterns | No | No | Yes |
| Bandwidth limit | Yes | No | Yes |

---

## Quick Reference

### SCP
```bash
# Copy to remote
scp file user@host:/path/

# Copy from remote
scp user@host:/path/file ./

# Recursive
scp -r directory user@host:/path/

# Preserve permissions
scp -p file user@host:/path/

# Different port
scp -P 2222 file user@host:/path/
```

### SFTP
```bash
# Connect
sftp user@host

# Commands: get, put, ls, cd, lcd, exit
```

### Rsync
```bash
# Sync to remote
rsync -avz /source/ user@host:/dest/

# Sync from remote
rsync -avz user@host:/source/ /dest/

# Delete extra files on dest
rsync -avz --delete /source/ user@host:/dest/

# Dry run
rsync -avzn /source/ user@host:/dest/

# Exclude files
rsync -avz --exclude '*.log' /source/ user@host:/dest/
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Use `scp`** to copy files to/from remote systems
2. **Use `-r` flag** with scp for directories
3. **Use `-P` flag** with scp for non-standard SSH ports
4. **Use `sftp`** for interactive file transfer
5. **Use `rsync -avz`** for efficient synchronization
6. **Use `--delete`** with rsync to mirror directories
7. **Use `--dry-run`** to preview rsync changes
8. **Understand trailing slash** behavior in rsync
