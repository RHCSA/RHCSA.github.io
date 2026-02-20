# Use Looping Constructs

## RHCSA Exam Objective
> Use Looping constructs (for, etc.) to process file, command line input

---

## Introduction

Loops allow you to repeat commands multiple times, which is essential for processing files, lists, and automating repetitive tasks. The RHCSA exam tests your ability to use `for`, `while`, and `until` loops effectively in shell scripts.

---

## Loop Types

| Loop | Use Case |
|------|----------|
| `for` | Iterate over a list of items |
| `while` | Repeat while condition is true |
| `until` | Repeat until condition becomes true |

---

## Practice Questions

### Question 1: Basic For Loop
**Task:** Write a script that prints numbers 1 through 5.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for i in 1 2 3 4 5; do
    echo "Number: $i"
done
```

**Using brace expansion:**
```bash
#!/bin/bash

for i in {1..5}; do
    echo "Number: $i"
done
```
</details>

---

### Question 2: For Loop with Range and Step
**Task:** Write a script that prints even numbers from 2 to 10.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for i in {2..10..2}; do
    echo "$i"
done
```

**Output:**
```
2
4
6
8
10
```
</details>

---

### Question 3: Loop Through Files
**Task:** Write a script that lists all `.conf` files in `/etc`.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for file in /etc/*.conf; do
    echo "Found config file: $file"
done
```
</details>

---

### Question 4: Loop Through Files in Directory
**Task:** Write a script that lists all files in `/var/log`.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for file in /var/log/*; do
    if [ -f "$file" ]; then
        echo "File: $file"
    fi
done
```
</details>

---

### Question 5: Process Each Line of a File
**Task:** Write a script that reads `/etc/hosts` line by line and prints each line.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

while read line; do
    echo "$line"
done < /etc/hosts
```

**Alternative using `for` (not recommended for files with spaces):**
```bash
#!/bin/bash

for line in $(cat /etc/hosts); do
    echo "$line"
done
```

**Note:** The `while read` method is preferred because it handles spaces correctly.
</details>

---

### Question 6: Process File with Field Extraction
**Task:** Write a script that reads `/etc/passwd` and extracts usernames.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

while IFS=: read username rest; do
    echo "User: $username"
done < /etc/passwd
```

**Extract specific fields:**
```bash
#!/bin/bash

while IFS=: read username x uid gid comment home shell; do
    echo "User: $username, UID: $uid, Shell: $shell"
done < /etc/passwd
```

**Note:** `IFS=:` sets the field separator to colon for reading `/etc/passwd`.
</details>

---

### Question 7: While Loop with Counter
**Task:** Write a script that counts from 1 to 5 using a while loop.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

counter=1

while [ $counter -le 5 ]; do
    echo "Count: $counter"
    ((counter++))
done
```
</details>

---

### Question 8: Until Loop
**Task:** Write a script that uses `until` to count from 1 to 5.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

counter=1

until [ $counter -gt 5 ]; do
    echo "Count: $counter"
    ((counter++))
done
```

**Note:** `until` is the opposite of `while` - it runs until the condition becomes true.
</details>

---

### Question 9: Loop Through Command Output
**Task:** Write a script that lists all running processes owned by root.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for pid in $(pgrep -u root); do
    echo "Root process PID: $pid"
done
```
</details>

---

### Question 10: Loop with Break
**Task:** Write a script that searches for a file and stops when found.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for file in /etc/*; do
    if [ "$file" = "/etc/passwd" ]; then
        echo "Found: $file"
        break
    fi
done

echo "Search complete"
```
</details>

---

### Question 11: Loop with Continue
**Task:** Write a script that processes files but skips directories.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for item in /etc/*; do
    if [ -d "$item" ]; then
        continue
    fi
    echo "Processing file: $item"
done
```
</details>

---

### Question 12: Nested Loops
**Task:** Write a script that creates a multiplication table for 1-3.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for i in {1..3}; do
    for j in {1..3}; do
        result=$((i * j))
        echo "$i x $j = $result"
    done
done
```
</details>

---

### Question 13: C-Style For Loop
**Task:** Write a script using C-style for loop to count 1 to 5.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for ((i=1; i<=5; i++)); do
    echo "Number: $i"
done
```
</details>

---

### Question 14: Loop Through Array
**Task:** Write a script that loops through an array of server names.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

servers=("web1" "web2" "db1" "db2")

for server in "${servers[@]}"; do
    echo "Processing server: $server"
done
```
</details>

---

### Question 15: Create Multiple Users
**Task:** Write a script that creates users from a list.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

users="alice bob charlie"

for user in $users; do
    if id "$user" &>/dev/null; then
        echo "User $user already exists"
    else
        useradd "$user"
        echo "Created user: $user"
    fi
done
```
</details>

---

### Question 16: Create Multiple Directories
**Task:** Write a script that creates directories dir1 through dir5.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for i in {1..5}; do
    mkdir -p "/tmp/dir$i"
    echo "Created /tmp/dir$i"
done
```
</details>

---

### Question 17: Rename Multiple Files
**Task:** Write a script that renames all `.txt` files to `.bak` in current directory.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for file in *.txt; do
    if [ -f "$file" ]; then
        mv "$file" "${file%.txt}.bak"
        echo "Renamed $file to ${file%.txt}.bak"
    fi
done
```

**Note:** `${file%.txt}` removes the `.txt` extension from the filename.
</details>

---

### Question 18: Process Files Matching Pattern
**Task:** Write a script that counts lines in all log files in `/var/log`.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for logfile in /var/log/*.log; do
    if [ -f "$logfile" ]; then
        lines=$(wc -l < "$logfile")
        echo "$logfile: $lines lines"
    fi
done
```
</details>

---

### Question 19: Infinite Loop with Exit Condition
**Task:** Write a script that monitors a file until it exists.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

FILE="/tmp/trigger.txt"

while true; do
    if [ -e "$FILE" ]; then
        echo "File found!"
        break
    fi
    echo "Waiting for $FILE..."
    sleep 5
done
```
</details>

---

### Question 20: Exam Scenario - Backup Script
**Task:** Write a script that backs up all `.conf` files from `/etc` to `/backup`.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

BACKUP_DIR="/backup"
mkdir -p "$BACKUP_DIR"

for file in /etc/*.conf; do
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR/"
        echo "Backed up: $file"
    fi
done

echo "Backup complete"
```
</details>

---

### Question 21: Exam Scenario - Check Service on Multiple Servers
**Task:** Write a script that pings a list of servers.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

servers="192.168.1.1 192.168.1.2 192.168.1.3"

for server in $servers; do
    if ping -c 1 -W 1 "$server" > /dev/null 2>&1; then
        echo "$server is UP"
    else
        echo "$server is DOWN"
    fi
done
```
</details>

---

### Question 22: Loop Through Lines with Specific Pattern
**Task:** Write a script that finds all users with `/bin/bash` shell.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

while IFS=: read username x x x x x shell; do
    if [ "$shell" = "/bin/bash" ]; then
        echo "User with bash: $username"
    fi
done < /etc/passwd
```
</details>

---

## Loop Control Commands

| Command | Description |
|---------|-------------|
| `break` | Exit the loop immediately |
| `continue` | Skip to next iteration |
| `break n` | Exit n levels of nested loops |
| `continue n` | Skip to next iteration of nth outer loop |

---

## Quick Reference

### For Loop Patterns
```bash
# List
for i in item1 item2 item3; do ... done

# Range
for i in {1..10}; do ... done

# Range with step
for i in {0..100..10}; do ... done

# Files
for file in /path/*.ext; do ... done

# Command output
for item in $(command); do ... done

# C-style
for ((i=0; i<10; i++)); do ... done
```

### While/Until Patterns
```bash
# While condition
while [ condition ]; do ... done

# Until condition
until [ condition ]; do ... done

# Read file
while read line; do ... done < file

# Read with delimiter
while IFS=: read f1 f2; do ... done < file
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Use `for` loops** to iterate over lists, ranges, and files
2. **Use `while` loops** for condition-based repetition
3. **Use `until` loops** when appropriate
4. **Read files line by line** using `while read`
5. **Use `IFS`** to parse delimited data
6. **Apply `break` and `continue`** for loop control
7. **Process file patterns** with glob expressions
8. **Create practical scripts** that use loops for system tasks
