# Conditionally Execute Code

## RHCSA Exam Objective
> Conditionally execute code (use of: if, test, [], etc.)

---

## Introduction

Shell scripts often need to make decisions based on conditions. The RHCSA exam tests your ability to write scripts that use conditional statements to execute different code paths based on test results. Understanding `if`, `test`, `[ ]`, and `[[ ]]` constructs is essential.

---

## Basic Syntax

### The `if` Statement

```bash
if condition; then
    commands
fi
```

### `if-else` Statement

```bash
if condition; then
    commands
else
    other_commands
fi
```

### `if-elif-else` Statement

```bash
if condition1; then
    commands1
elif condition2; then
    commands2
else
    other_commands
fi
```

---

## Test Commands

| Syntax | Description |
|--------|-------------|
| `test expression` | Traditional test command |
| `[ expression ]` | Equivalent to `test` (POSIX) |
| `[[ expression ]]` | Enhanced test (Bash-specific) |

**Important:** Spaces are required after `[` and before `]`.

---

## File Test Operators

| Operator | Description |
|----------|-------------|
| `-e FILE` | File exists |
| `-f FILE` | File exists and is a regular file |
| `-d FILE` | File exists and is a directory |
| `-r FILE` | File is readable |
| `-w FILE` | File is writable |
| `-x FILE` | File is executable |
| `-s FILE` | File exists and has size > 0 |
| `-L FILE` | File is a symbolic link |

---

## String Test Operators

| Operator | Description |
|----------|-------------|
| `-z STRING` | String is empty (zero length) |
| `-n STRING` | String is not empty |
| `STRING1 = STRING2` | Strings are equal |
| `STRING1 != STRING2` | Strings are not equal |

---

## Numeric Comparison Operators

| Operator | Description |
|----------|-------------|
| `-eq` | Equal |
| `-ne` | Not equal |
| `-lt` | Less than |
| `-le` | Less than or equal |
| `-gt` | Greater than |
| `-ge` | Greater than or equal |

---

## Logical Operators

| Operator | Description |
|----------|-------------|
| `!` | NOT (negation) |
| `-a` | AND (inside `[ ]`) |
| `-o` | OR (inside `[ ]`) |
| `&&` | AND (between commands or inside `[[ ]]`) |
| `\|\|` | OR (between commands or inside `[[ ]]`) |

---

## Practice Questions

### Question 1: Check if File Exists
**Task:** Write a script that checks if `/etc/passwd` exists and prints an appropriate message.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ -e /etc/passwd ]; then
    echo "File /etc/passwd exists"
else
    echo "File /etc/passwd does not exist"
fi
```

**Alternative using `test`:**
```bash
#!/bin/bash

if test -e /etc/passwd; then
    echo "File /etc/passwd exists"
fi
```
</details>

---

### Question 2: Check if Directory Exists
**Task:** Write a script that checks if `/var/log` is a directory.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ -d /var/log ]; then
    echo "/var/log is a directory"
else
    echo "/var/log is not a directory"
fi
```
</details>

---

### Question 3: Check File Permissions
**Task:** Write a script that checks if `/etc/shadow` is readable by the current user.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ -r /etc/shadow ]; then
    echo "You can read /etc/shadow"
else
    echo "You cannot read /etc/shadow"
fi
```
</details>

---

### Question 4: Compare Two Numbers
**Task:** Write a script that compares two numbers and prints which is larger.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

NUM1=10
NUM2=20

if [ $NUM1 -gt $NUM2 ]; then
    echo "$NUM1 is greater than $NUM2"
elif [ $NUM1 -lt $NUM2 ]; then
    echo "$NUM1 is less than $NUM2"
else
    echo "$NUM1 is equal to $NUM2"
fi
```
</details>

---

### Question 5: Check if String is Empty
**Task:** Write a script that checks if a variable is empty.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

VAR=""

if [ -z "$VAR" ]; then
    echo "Variable is empty"
else
    echo "Variable contains: $VAR"
fi
```

**Check if NOT empty:**
```bash
#!/bin/bash

VAR="hello"

if [ -n "$VAR" ]; then
    echo "Variable is not empty: $VAR"
fi
```
</details>

---

### Question 6: String Comparison
**Task:** Write a script that checks if two strings are equal.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

STR1="hello"
STR2="world"

if [ "$STR1" = "$STR2" ]; then
    echo "Strings are equal"
else
    echo "Strings are different"
fi
```

**Note:** Always quote variables in string comparisons to handle spaces.
</details>

---

### Question 7: Multiple Conditions with AND
**Task:** Write a script that checks if a file exists AND is readable.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

FILE="/etc/passwd"

# Method 1: Using -a inside [ ]
if [ -e "$FILE" -a -r "$FILE" ]; then
    echo "$FILE exists and is readable"
fi

# Method 2: Using && between tests
if [ -e "$FILE" ] && [ -r "$FILE" ]; then
    echo "$FILE exists and is readable"
fi

# Method 3: Using [[ ]] with &&
if [[ -e "$FILE" && -r "$FILE" ]]; then
    echo "$FILE exists and is readable"
fi
```
</details>

---

### Question 8: Multiple Conditions with OR
**Task:** Write a script that checks if a file is readable OR writable.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

FILE="/tmp/test.txt"

# Method 1: Using -o inside [ ]
if [ -r "$FILE" -o -w "$FILE" ]; then
    echo "$FILE is readable or writable"
fi

# Method 2: Using || between tests
if [ -r "$FILE" ] || [ -w "$FILE" ]; then
    echo "$FILE is readable or writable"
fi
```
</details>

---

### Question 9: Negation
**Task:** Write a script that executes a command if a file does NOT exist.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

FILE="/tmp/myfile.txt"

if [ ! -e "$FILE" ]; then
    echo "File does not exist, creating it..."
    touch "$FILE"
fi
```
</details>

---

### Question 10: Check User is Root
**Task:** Write a script that checks if it's being run as root.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "Running as root"
else
    echo "Not running as root"
    exit 1
fi
```

**Alternative using $EUID:**
```bash
#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Running as root"
else
    echo "Please run as root"
    exit 1
fi
```
</details>

---

### Question 11: Check Exit Status
**Task:** Write a script that runs a command and checks if it succeeded.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo "Network is reachable"
else
    echo "Network is not reachable"
fi
```

**Using `$?`:**
```bash
#!/bin/bash

ping -c 1 8.8.8.8 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Network is reachable"
else
    echo "Network is not reachable"
fi
```
</details>

---

### Question 12: Check if Directory is Empty
**Task:** Write a script that checks if a directory is empty.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

DIR="/tmp/mydir"

if [ -d "$DIR" ] && [ -z "$(ls -A "$DIR")" ]; then
    echo "Directory is empty"
else
    echo "Directory is not empty or doesn't exist"
fi
```
</details>

---

### Question 13: Check Service Status
**Task:** Write a script that checks if the sshd service is running.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if systemctl is-active --quiet sshd; then
    echo "SSHD is running"
else
    echo "SSHD is not running"
fi
```
</details>

---

### Question 14: Check File Type
**Task:** Write a script that determines if a path is a file, directory, or symbolic link.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

PATH_TO_CHECK="/etc/passwd"

if [ -L "$PATH_TO_CHECK" ]; then
    echo "$PATH_TO_CHECK is a symbolic link"
elif [ -f "$PATH_TO_CHECK" ]; then
    echo "$PATH_TO_CHECK is a regular file"
elif [ -d "$PATH_TO_CHECK" ]; then
    echo "$PATH_TO_CHECK is a directory"
else
    echo "$PATH_TO_CHECK is another type or doesn't exist"
fi
```
</details>

---

### Question 15: Numeric Range Check
**Task:** Write a script that checks if a number is between 1 and 100.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

NUM=50

if [ $NUM -ge 1 ] && [ $NUM -le 100 ]; then
    echo "$NUM is between 1 and 100"
else
    echo "$NUM is outside the range"
fi
```

**Using [[ ]]:**
```bash
#!/bin/bash

NUM=50

if [[ $NUM -ge 1 && $NUM -le 100 ]]; then
    echo "$NUM is between 1 and 100"
fi
```
</details>

---

### Question 16: Case Statement
**Task:** Write a script that uses `case` to handle different options.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

OPTION="start"

case $OPTION in
    start)
        echo "Starting service..."
        ;;
    stop)
        echo "Stopping service..."
        ;;
    restart)
        echo "Restarting service..."
        ;;
    *)
        echo "Unknown option: $OPTION"
        exit 1
        ;;
esac
```
</details>

---

### Question 17: Exam Scenario - Backup Script with Conditions
**Task:** Write a script that:
1. Checks if the source directory exists
2. Checks if the backup directory exists, creates it if not
3. Performs the backup only if source exists

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

SOURCE="/var/www/html"
BACKUP="/backup/www"

# Check if source directory exists
if [ ! -d "$SOURCE" ]; then
    echo "Error: Source directory $SOURCE does not exist"
    exit 1
fi

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP" ]; then
    echo "Creating backup directory..."
    mkdir -p "$BACKUP"
fi

# Perform backup
if [ -d "$SOURCE" ] && [ -d "$BACKUP" ]; then
    cp -r "$SOURCE"/* "$BACKUP"/
    echo "Backup completed successfully"
fi
```
</details>

---

### Question 18: Check File Size
**Task:** Write a script that checks if a log file exceeds 10MB.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

LOGFILE="/var/log/messages"
MAX_SIZE=10485760  # 10MB in bytes

if [ -f "$LOGFILE" ]; then
    SIZE=$(stat -c%s "$LOGFILE")
    if [ $SIZE -gt $MAX_SIZE ]; then
        echo "Log file exceeds 10MB"
    else
        echo "Log file is within limits"
    fi
else
    echo "Log file does not exist"
fi
```
</details>

---

## Common Pitfalls

| Issue | Problem | Solution |
|-------|---------|----------|
| `[: missing ]` | No spaces around brackets | Use `[ expression ]` |
| `unary operator expected` | Empty variable | Quote variables: `"$VAR"` |
| `integer expression expected` | String in numeric comparison | Validate input is numeric |

---

## Quick Reference

### Test Command Syntax
```bash
# These are equivalent:
test -f /etc/passwd
[ -f /etc/passwd ]

# Enhanced test (Bash):
[[ -f /etc/passwd ]]
```

### Exit Status
- `0` = true/success
- Non-zero = false/failure

### Conditional Execution
```bash
# Execute if previous succeeded
command1 && command2

# Execute if previous failed
command1 || command2
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Use `if-then-else-fi`** statements correctly
2. **Apply file tests** (`-e`, `-f`, `-d`, `-r`, `-w`, `-x`)
3. **Compare strings** using `=` and `!=`
4. **Compare numbers** using `-eq`, `-ne`, `-lt`, `-gt`, `-le`, `-ge`
5. **Combine conditions** with `-a`, `-o`, `&&`, `||`
6. **Negate conditions** with `!`
7. **Check command exit status** using `$?` or directly in `if`
8. **Use `case` statements** for multiple options
