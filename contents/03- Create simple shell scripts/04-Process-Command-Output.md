# Processing Output of Shell Commands Within a Script

## RHCSA Exam Objective
> Processing output of shell commands within a script

---

## Introduction

Shell scripts often need to capture the output of commands and use it within the script. The RHCSA exam tests your ability to use command substitution to store and process command output in variables, conditions, and loops.

---

## Command Substitution Syntax

| Syntax | Description |
|--------|-------------|
| `$(command)` | Modern syntax (preferred) |
| `` `command` `` | Legacy syntax (backticks) |

**Note:** `$(command)` is preferred because it's easier to read and can be nested.

---

## Practice Questions

### Question 1: Store Command Output in Variable
**Task:** Write a script that stores the current date in a variable.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

TODAY=$(date +%Y-%m-%d)
echo "Today's date is: $TODAY"
```

**Legacy syntax:**
```bash
#!/bin/bash

TODAY=`date +%Y-%m-%d`
echo "Today's date is: $TODAY"
```
</details>

---

### Question 2: Use Command Output in Filename
**Task:** Write a script that creates a backup file with current timestamp.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"

echo "Creating backup: $BACKUP_FILE"
tar -czf "$BACKUP_FILE" /etc/passwd /etc/group
```
</details>

---

### Question 3: Count Items from Command Output
**Task:** Write a script that counts the number of users in `/etc/passwd`.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

USER_COUNT=$(wc -l < /etc/passwd)
echo "Number of users: $USER_COUNT"
```

**Alternative:**
```bash
#!/bin/bash

USER_COUNT=$(cat /etc/passwd | wc -l)
echo "Number of users: $USER_COUNT"
```
</details>

---

### Question 4: Get Hostname in Script
**Task:** Write a script that includes the hostname in its output.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

HOSTNAME=$(hostname)
echo "Running on server: $HOSTNAME"
```

**Alternative:**
```bash
#!/bin/bash

echo "Running on server: $(hostname)"
```
</details>

---

### Question 5: Get Current User
**Task:** Write a script that displays the current username.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

CURRENT_USER=$(whoami)
echo "Script is running as: $CURRENT_USER"
```

**Alternative using `id`:**
```bash
#!/bin/bash

USER_NAME=$(id -un)
USER_ID=$(id -u)
echo "User: $USER_NAME (UID: $USER_ID)"
```
</details>

---

### Question 6: Use Command Output in Condition
**Task:** Write a script that checks if disk usage exceeds 80%.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$USAGE" -gt 80 ]; then
    echo "Warning: Disk usage is ${USAGE}%"
else
    echo "Disk usage is OK: ${USAGE}%"
fi
```
</details>

---

### Question 7: Process IP Address
**Task:** Write a script that extracts and displays the system's IP address.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

IP_ADDR=$(hostname -I | awk '{print $1}')
echo "Server IP: $IP_ADDR"
```

**Alternative using `ip` command:**
```bash
#!/bin/bash

IP_ADDR=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
echo "Server IP: $IP_ADDR"
```
</details>

---

### Question 8: Get File Size
**Task:** Write a script that gets the size of a specific file.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

FILE="/var/log/messages"
SIZE=$(stat -c%s "$FILE")
echo "$FILE is $SIZE bytes"
```

**Human-readable size:**
```bash
#!/bin/bash

FILE="/var/log/messages"
SIZE=$(du -h "$FILE" | cut -f1)
echo "$FILE is $SIZE"
```
</details>

---

### Question 9: Get Process Count
**Task:** Write a script that counts running processes.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

PROC_COUNT=$(ps aux | wc -l)
echo "Running processes: $PROC_COUNT"
```
</details>

---

### Question 10: Get Memory Usage
**Task:** Write a script that displays available memory.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

FREE_MEM=$(free -m | awk 'NR==2 {print $4}')
echo "Available memory: ${FREE_MEM}MB"
```
</details>

---

### Question 11: Get System Uptime
**Task:** Write a script that shows how long the system has been running.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

UPTIME=$(uptime -p)
echo "System $UPTIME"
```

**Get uptime in days:**
```bash
#!/bin/bash

UPTIME_DAYS=$(awk '{print int($1/86400)}' /proc/uptime)
echo "System has been up for $UPTIME_DAYS days"
```
</details>

---

### Question 12: Nested Command Substitution
**Task:** Write a script that creates a directory with date and hostname.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

DIR_NAME="backup_$(hostname)_$(date +%Y%m%d)"
mkdir -p "/tmp/$DIR_NAME"
echo "Created directory: /tmp/$DIR_NAME"
```
</details>

---

### Question 13: Use Command Output in Loop
**Task:** Write a script that processes all logged-in users.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for user in $(who | awk '{print $1}' | sort -u); do
    echo "Logged in user: $user"
done
```
</details>

---

### Question 14: Extract Field from Command Output
**Task:** Write a script that extracts the kernel version.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

KERNEL=$(uname -r)
echo "Kernel version: $KERNEL"
```

**Extract specific parts:**
```bash
#!/bin/bash

KERNEL_MAJOR=$(uname -r | cut -d. -f1)
KERNEL_MINOR=$(uname -r | cut -d. -f2)
echo "Kernel: $KERNEL_MAJOR.$KERNEL_MINOR"
```
</details>

---

### Question 15: Get Last Line of File
**Task:** Write a script that gets the last entry from a log file.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

LAST_LOG=$(tail -1 /var/log/messages)
echo "Last log entry: $LAST_LOG"
```
</details>

---

### Question 16: Check if Package is Installed
**Task:** Write a script that checks if httpd package is installed.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if rpm -q httpd > /dev/null 2>&1; then
    VERSION=$(rpm -q httpd)
    echo "httpd is installed: $VERSION"
else
    echo "httpd is not installed"
fi
```
</details>

---

### Question 17: Find and Process Files
**Task:** Write a script that finds large files and reports their sizes.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

echo "Files larger than 100MB in /var:"

for file in $(find /var -type f -size +100M 2>/dev/null); do
    SIZE=$(du -h "$file" | cut -f1)
    echo "$file: $SIZE"
done
```
</details>

---

### Question 18: Mathematical Operations with Output
**Task:** Write a script that calculates percentage of free disk space.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

TOTAL=$(df / | awk 'NR==2 {print $2}')
AVAIL=$(df / | awk 'NR==2 {print $4}')
PERCENT=$((AVAIL * 100 / TOTAL))

echo "Free disk space: ${PERCENT}%"
```
</details>

---

### Question 19: Generate Report from Commands
**Task:** Write a script that generates a system summary report.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

echo "=== System Report ==="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo "Kernel: $(uname -r)"
echo "Users logged in: $(who | wc -l)"
echo "Free memory: $(free -m | awk 'NR==2 {print $4}')MB"
echo "Disk usage: $(df -h / | awk 'NR==2 {print $5}')"
```
</details>

---

### Question 20: Exam Scenario - Monitor Service
**Task:** Write a script that checks if sshd is running and reports its PID.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if systemctl is-active --quiet sshd; then
    PID=$(systemctl show sshd --property=MainPID --value)
    echo "SSHD is running with PID: $PID"
else
    echo "SSHD is not running"
fi
```

**Alternative using `pgrep`:**
```bash
#!/bin/bash

PID=$(pgrep -x sshd | head -1)

if [ -n "$PID" ]; then
    echo "SSHD is running with PID: $PID"
else
    echo "SSHD is not running"
fi
```
</details>

---

### Question 21: Capture Command Exit Status
**Task:** Write a script that copies a file and stores the exit status for later use.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

SOURCE="/etc/passwd"
DEST="/tmp/passwd_backup"

cp "$SOURCE" "$DEST" 2>/dev/null
EXIT_CODE=$?

echo "Copy operation exit code: $EXIT_CODE"

if [ $EXIT_CODE -eq 0 ]; then
    echo "Backup successful"
    SIZE=$(stat -c%s "$DEST")
    echo "Backup file size: $SIZE bytes"
else
    echo "Backup failed"
fi
```

**Note:** Storing `$?` in a variable allows you to use the exit status multiple times.
</details>

---

### Question 22: Store Multi-line Output
**Task:** Write a script that stores and processes multiple lines of output.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

# Store multi-line output
USERS=$(cut -d: -f1 /etc/passwd)

echo "All system users:"
echo "$USERS"

# Count users
USER_COUNT=$(echo "$USERS" | wc -l)
echo "Total: $USER_COUNT users"
```
</details>

---

### Question 23: Arithmetic with Command Output
**Task:** Write a script that compares file counts in two directories.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

DIR1="/etc"
DIR2="/var"

COUNT1=$(ls -1 "$DIR1" | wc -l)
COUNT2=$(ls -1 "$DIR2" | wc -l)

echo "$DIR1 has $COUNT1 items"
echo "$DIR2 has $COUNT2 items"

if [ $COUNT1 -gt $COUNT2 ]; then
    echo "$DIR1 has more items"
else
    echo "$DIR2 has more items"
fi
```
</details>

---

### Question 24: Combine Commands in Variable
**Task:** Write a script that creates a formatted log entry.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

LOG_ENTRY="$(date '+%Y-%m-%d %H:%M:%S') [$(hostname)] $(whoami): Script executed"
echo "$LOG_ENTRY" >> /tmp/script.log
echo "Log entry added: $LOG_ENTRY"
```
</details>

---

## Common Commands for Script Output

| Command | Output |
|---------|--------|
| `date` | Current date/time |
| `hostname` | System hostname |
| `whoami` | Current username |
| `pwd` | Current directory |
| `uname -r` | Kernel version |
| `uptime` | System uptime |
| `df` | Disk usage |
| `free` | Memory usage |
| `ps` | Process list |
| `id` | User/group IDs |

---

## Quick Reference

### Command Substitution
```bash
# Modern syntax (preferred)
VAR=$(command)

# Legacy syntax
VAR=`command`

# Nested substitution
VAR=$(cmd1 $(cmd2))
```

### Output Processing
```bash
# Store in variable
OUTPUT=$(command)

# Use in condition
if [ "$(command)" = "value" ]; then

# Use in loop
for item in $(command); do

# Use in filename
file_$(date +%Y%m%d).txt
```

### Exit Status
```bash
command
EXIT_CODE=$?
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Use `$(command)`** for command substitution
2. **Store command output** in variables
3. **Use output in conditions** with `if [ "$(cmd)" ...]`
4. **Use output in loops** with `for item in $(cmd)`
5. **Create dynamic filenames** with embedded commands
6. **Combine multiple commands** in variables
7. **Process and extract** fields from command output
8. **Capture exit status** using `$?`
