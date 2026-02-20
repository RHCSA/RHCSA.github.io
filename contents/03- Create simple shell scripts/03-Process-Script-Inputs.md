# Process Script Inputs

## RHCSA Exam Objective
> Process script inputs ($1, $2, etc.)

---

## Introduction

Shell scripts often need to accept input from users when they are executed. The RHCSA exam tests your ability to process command-line arguments (positional parameters) and use them effectively in scripts.

---

## Positional Parameters

| Parameter | Description |
|-----------|-------------|
| `$0` | Script name |
| `$1` | First argument |
| `$2` | Second argument |
| `$3` - `$9` | Arguments 3-9 |
| `${10}` | Tenth argument (braces required for 10+) |

---

## Special Parameters

| Parameter | Description |
|-----------|-------------|
| `$#` | Number of arguments passed |
| `$@` | All arguments as separate strings |
| `$*` | All arguments as a single string |
| `$$` | Current script's PID |
| `$?` | Exit status of last command |

---

## Practice Questions

### Question 1: Access Single Argument
**Task:** Write a script that greets a user by name passed as an argument.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

echo "Hello, $1!"
```

**Usage:**
```bash
./greet.sh John
# Output: Hello, John!
```
</details>

---

### Question 2: Use Multiple Arguments
**Task:** Write a script that takes two numbers and prints their sum.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

NUM1=$1
NUM2=$2
SUM=$((NUM1 + NUM2))

echo "Sum of $NUM1 and $NUM2 is $SUM"
```

**Usage:**
```bash
./add.sh 5 10
# Output: Sum of 5 and 10 is 15
```
</details>

---

### Question 3: Count Arguments
**Task:** Write a script that displays how many arguments were passed.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

echo "Number of arguments: $#"
```

**Usage:**
```bash
./count.sh one two three
# Output: Number of arguments: 3
```
</details>

---

### Question 4: Check if Arguments Provided
**Task:** Write a script that exits with an error if no arguments are provided.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Error: No arguments provided"
    echo "Usage: $0 <filename>"
    exit 1
fi

echo "Processing: $1"
```
</details>

---

### Question 5: Validate Number of Arguments
**Task:** Write a script that requires exactly two arguments.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Error: Exactly 2 arguments required"
    echo "Usage: $0 <source> <destination>"
    exit 1
fi

echo "Source: $1"
echo "Destination: $2"
```
</details>

---

### Question 6: Display All Arguments
**Task:** Write a script that prints all arguments passed to it.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

echo "Script name: $0"
echo "All arguments: $@"
echo "Number of arguments: $#"
```

**Usage:**
```bash
./args.sh apple banana cherry
# Script name: ./args.sh
# All arguments: apple banana cherry
# Number of arguments: 3
```
</details>

---

### Question 7: Loop Through All Arguments
**Task:** Write a script that processes each argument one by one.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for arg in "$@"; do
    echo "Processing: $arg"
done
```

**Usage:**
```bash
./process.sh file1.txt file2.txt file3.txt
# Processing: file1.txt
# Processing: file2.txt
# Processing: file3.txt
```

**Note:** Always quote `"$@"` to handle arguments with spaces correctly.
</details>

---

### Question 8: Difference Between $@ and $*
**Task:** Demonstrate the difference between `$@` and `$*`.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

echo "Using \"\$@\":"
for arg in "$@"; do
    echo "  Arg: $arg"
done

echo ""
echo "Using \"\$*\":"
for arg in "$*"; do
    echo "  Arg: $arg"
done
```

**Usage:**
```bash
./demo.sh "hello world" "foo bar"
```

**Output:**
```
Using "$@":
  Arg: hello world
  Arg: foo bar

Using "$*":
  Arg: hello world foo bar
```

**Note:** `"$@"` preserves each argument as separate strings; `"$*"` combines them into one.
</details>

---

### Question 9: Default Value for Argument
**Task:** Write a script that uses a default value if no argument is provided.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

NAME=${1:-"World"}
echo "Hello, $NAME!"
```

**Usage:**
```bash
./greet.sh
# Output: Hello, World!

./greet.sh Alice
# Output: Hello, Alice!
```

**Parameter expansion syntax:**
- `${VAR:-default}` - Use default if VAR is unset or empty
- `${VAR:=default}` - Set VAR to default if unset or empty
</details>

---

### Question 10: Shift Arguments
**Task:** Write a script that shifts through arguments.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

echo "Total arguments: $#"

while [ $# -gt 0 ]; do
    echo "Current argument: $1"
    shift
done

echo "Remaining arguments: $#"
```

**Usage:**
```bash
./shift.sh a b c
# Total arguments: 3
# Current argument: a
# Current argument: b
# Current argument: c
# Remaining arguments: 0
```

**Note:** `shift` removes the first argument and shifts the rest down ($2 becomes $1, etc.)
</details>

---

### Question 11: Process Options with Arguments
**Task:** Write a script that handles `-f <filename>` option.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

while [ $# -gt 0 ]; do
    case $1 in
        -f)
            FILENAME=$2
            shift 2
            ;;
        -v)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "Filename: $FILENAME"
echo "Verbose: $VERBOSE"
```

**Usage:**
```bash
./script.sh -f myfile.txt -v
```
</details>

---

### Question 12: Script Name Usage
**Task:** Write a script that shows proper usage instructions using `$0`.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

usage() {
    echo "Usage: $0 <source_file> <destination_file>"
    echo "  Copies source to destination"
    exit 1
}

if [ $# -ne 2 ]; then
    usage
fi

cp "$1" "$2"
echo "Copied $1 to $2"
```
</details>

---

### Question 13: Handle Arguments with Spaces
**Task:** Write a script that correctly handles filenames with spaces.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

for file in "$@"; do
    if [ -f "$file" ]; then
        echo "File exists: $file"
    else
        echo "Not found: $file"
    fi
done
```

**Usage:**
```bash
./check.sh "my file.txt" "another file.txt"
```

**Note:** Always quote `"$@"` and `"$1"` etc. to preserve spaces in arguments.
</details>

---

### Question 14: Create User from Arguments
**Task:** Write a script that creates a user with username and group from arguments.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <group>"
    exit 1
fi

USERNAME=$1
GROUP=$2

if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists"
    exit 1
fi

useradd -G "$GROUP" "$USERNAME"
echo "User $USERNAME created and added to group $GROUP"
```
</details>

---

### Question 15: Backup File from Argument
**Task:** Write a script that backs up a file passed as argument.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

FILE=$1

if [ ! -f "$FILE" ]; then
    echo "Error: $FILE does not exist"
    exit 1
fi

BACKUP="${FILE}.bak"
cp "$FILE" "$BACKUP"
echo "Backed up $FILE to $BACKUP"
```
</details>

---

### Question 16: Exam Scenario - Service Control Script
**Task:** Write a script that takes a service name and action (start/stop/restart).

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <service> <action>"
    echo "Actions: start, stop, restart, status"
    exit 1
fi

SERVICE=$1
ACTION=$2

case $ACTION in
    start|stop|restart|status)
        systemctl $ACTION $SERVICE
        echo "Executed: systemctl $ACTION $SERVICE"
        ;;
    *)
        echo "Invalid action: $ACTION"
        echo "Valid actions: start, stop, restart, status"
        exit 1
        ;;
esac
```
</details>

---

### Question 17: Create Multiple Files from Arguments
**Task:** Write a script that creates multiple files from arguments.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <file1> [file2] [file3] ..."
    exit 1
fi

for file in "$@"; do
    touch "$file"
    echo "Created: $file"
done
```
</details>

---

### Question 18: Validate Argument is a Number
**Task:** Write a script that validates the argument is a number.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <number>"
    exit 1
fi

if [[ $1 =~ ^[0-9]+$ ]]; then
    echo "$1 is a valid number"
else
    echo "$1 is not a valid number"
    exit 1
fi
```
</details>

---

### Question 19: Validate Argument is a File
**Task:** Write a script that checks if the argument is an existing file.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

if [ -f "$1" ]; then
    echo "$1 is a valid file"
    echo "Size: $(stat -c%s "$1") bytes"
else
    echo "$1 is not a valid file"
    exit 1
fi
```
</details>

---

### Question 20: Accept Path Arguments
**Task:** Write a script that sets permissions on a file with path and mode arguments.

<details>
<summary>Show Solution</summary>

```bash
#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <permissions>"
    echo "Example: $0 /tmp/test.txt 755"
    exit 1
fi

FILE=$1
PERMS=$2

if [ ! -e "$FILE" ]; then
    echo "Error: $FILE does not exist"
    exit 1
fi

chmod "$PERMS" "$FILE"
echo "Set permissions $PERMS on $FILE"
```
</details>

---

## Quick Reference

### Positional Parameters
```bash
$0    # Script name
$1    # First argument
$2    # Second argument
$#    # Number of arguments
$@    # All arguments (separate)
$*    # All arguments (as one string)
```

### Parameter Expansion
```bash
${VAR:-default}    # Use default if unset
${VAR:=default}    # Set to default if unset
${VAR:+value}      # Use value if set
${VAR:?message}    # Error if unset
```

### Common Patterns
```bash
# Check arguments exist
[ $# -eq 0 ] && exit 1

# Loop through arguments
for arg in "$@"; do ... done

# Shift arguments
shift      # Remove $1
shift 2    # Remove $1 and $2
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Access positional parameters** using `$1`, `$2`, etc.
2. **Count arguments** using `$#`
3. **Loop through all arguments** using `"$@"`
4. **Validate argument count** before processing
5. **Provide usage messages** using `$0`
6. **Use default values** with `${1:-default}`
7. **Shift arguments** using `shift` command
8. **Handle arguments with spaces** by quoting variables
