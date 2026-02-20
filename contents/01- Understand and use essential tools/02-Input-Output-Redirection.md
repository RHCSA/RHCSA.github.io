# Use Input-Output Redirection (>, >>, |, 2>, etc.)

## RHCSA Exam Objective
> Use input-output redirection (>, >>, |, 2>, etc.)

---

## Table of Contents
1. [Introduction to I/O Redirection](#introduction-to-io-redirection)
2. [File Descriptors](#file-descriptors)
3. [Output Redirection](#output-redirection)
4. [Input Redirection](#input-redirection)
5. [Error Redirection](#error-redirection)
6. [Combining Redirections](#combining-redirections)
7. [Pipes](#pipes)
8. [Here Documents](#here-documents)
9. [Advanced Redirection Techniques](#advanced-redirection-techniques)
10. [Practice Exam Questions](#practice-exam-questions)
11. [Quick Reference](#quick-reference)

---

## Introduction to I/O Redirection

I/O (Input/Output) redirection allows you to control where command input comes from and where output goes. By default:

- **Input** comes from the keyboard (standard input)
- **Output** goes to the terminal screen (standard output)
- **Errors** go to the terminal screen (standard error)

Redirection lets you change these defaults to read from files, write to files, or connect commands together.

> **Note:** For basic command syntax and shell prompt usage, see Topic 01: Access a Shell Prompt and Issue Commands.

---

## File Descriptors

Every process has three default file descriptors:

| File Descriptor | Name | Abbreviation | Default Device | Symbol |
|-----------------|------|--------------|----------------|--------|
| 0 | Standard Input | stdin | Keyboard | `<` |
| 1 | Standard Output | stdout | Screen | `>` or `1>` |
| 2 | Standard Error | stderr | Screen | `2>` |

Understanding file descriptors is essential for proper redirection.

---

## Output Redirection

### Redirect stdout to a File (Overwrite): `>`

The `>` operator redirects standard output to a file, **overwriting** any existing content.

```bash
# Redirect ls output to a file
ls -l /etc > /tmp/etc-listing.txt

# Redirect command output to a file
date > /tmp/current-date.txt

# View the file
cat /tmp/current-date.txt
```

**Important:** If the file exists, it will be **completely overwritten**.

```bash
# This will overwrite any existing content
echo "First line" > /tmp/myfile.txt
echo "Second line" > /tmp/myfile.txt

# File only contains "Second line"
cat /tmp/myfile.txt
```

### Redirect stdout to a File (Append): `>>`

The `>>` operator redirects standard output to a file, **appending** to any existing content.

```bash
# Append to a file
echo "Line 1" > /tmp/logfile.txt
echo "Line 2" >> /tmp/logfile.txt
echo "Line 3" >> /tmp/logfile.txt

# View the file - all three lines are present
cat /tmp/logfile.txt
```

**Practical Example - Creating a Log:**
```bash
# Create a simple log with timestamps
echo "=== Script started at $(date) ===" >> /tmp/script.log
echo "Performing backup..." >> /tmp/script.log
echo "=== Script ended at $(date) ===" >> /tmp/script.log
```

### Explicit stdout Redirection: `1>`

You can explicitly use file descriptor 1 for stdout:

```bash
# These are equivalent
ls -l > /tmp/listing.txt
ls -l 1> /tmp/listing.txt
```

---

## Input Redirection

### Redirect stdin from a File: `<`

The `<` operator redirects standard input from a file instead of the keyboard.

```bash
# Count lines in a file using input redirection
wc -l < /etc/passwd

# Sort contents from a file
sort < /etc/passwd

# Read file content with cat
cat < /etc/hostname
```

**Practical Example - Using sort with Input Redirection:**
```bash
# Create a file with names
echo -e "Charlie\nAlice\nBob" > /tmp/names.txt

# Sort the names using input redirection
sort < /tmp/names.txt
```

### Combining Input and Output Redirection

You can use both input and output redirection in the same command:

```bash
# Sort input file and save to output file
sort < /tmp/names.txt > /tmp/sorted-names.txt

# Process /etc/passwd and save results
wc -l < /etc/passwd > /tmp/user-count.txt
```

---

## Error Redirection

### Redirect stderr to a File: `2>`

The `2>` operator redirects standard error (error messages) to a file.

```bash
# Command that produces an error
ls /nonexistent 2> /tmp/error.log

# View the error
cat /tmp/error.log
```

**Practical Example - Separating Output and Errors:**
```bash
# List directory - output to one file, errors to another
ls -l /etc /nonexistent > /tmp/output.txt 2> /tmp/errors.txt

# View output
cat /tmp/output.txt

# View errors
cat /tmp/errors.txt
```

### Append stderr to a File: `2>>`

```bash
# Append errors to a log file
ls /nonexistent1 2>> /tmp/error.log
ls /nonexistent2 2>> /tmp/error.log

# All errors are collected
cat /tmp/error.log
```

### Discard Error Messages: `2> /dev/null`

The special file `/dev/null` discards any data written to it (like a black hole).

```bash
# Run command and suppress errors
find /etc -name "*.conf" 2> /dev/null

# Try to access restricted files without seeing errors
ls /root 2> /dev/null
```

---

## Combining Redirections

### Redirect stdout and stderr to the Same File

**Method 1: Using `&>` (Preferred in Bash)**
```bash
# Redirect both stdout and stderr to the same file
ls -l /etc /nonexistent &> /tmp/all-output.txt
```

**Method 2: Using `>&` with file descriptors**
```bash
# Redirect stdout to file, then redirect stderr to stdout
ls -l /etc /nonexistent > /tmp/all-output.txt 2>&1
```

**Important:** The order matters! `2>&1` must come after `>` or `>>`.

```bash
# CORRECT: stdout to file first, then stderr to stdout
command > file.txt 2>&1

# INCORRECT: stderr redirected before stdout is redirected
command 2>&1 > file.txt
```

### Append Both stdout and stderr: `&>>`

```bash
# Append both output and errors to a log file
ls -l /etc /nonexistent &>> /tmp/complete.log
```

### Redirect stdout and stderr to Different Files

```bash
# stdout to one file, stderr to another
find / -name "passwd" > /tmp/found.txt 2> /tmp/find-errors.txt
```

### Discard All Output

```bash
# Discard both stdout and stderr
command &> /dev/null

# Or equivalently
command > /dev/null 2>&1
```

---

## Pipes

### Basic Pipe: `|`

The pipe operator `|` sends the stdout of one command to the stdin of another.

```bash
# List files and filter with grep
ls -l /etc | grep conf

# Count files in a directory
ls /etc | wc -l

# View long output page by page
cat /var/log/messages | less
```

### Chaining Multiple Pipes

You can chain multiple commands together:

```bash
# Find all .conf files, sort them, and number the lines
ls /etc/*.conf | sort | nl

# Get the 5 largest files in /var/log
ls -lS /var/log | head -n 6

# Find processes, filter, and count
ps aux | grep httpd | wc -l
```

### Pipe with stderr: `|&`

The `|&` operator pipes both stdout and stderr to the next command.

```bash
# Pipe both output and errors to grep
ls /etc /nonexistent |& grep -i "no such"
```

This is equivalent to:
```bash
ls /etc /nonexistent 2>&1 | grep -i "no such"
```

---

## Here Documents

### Basic Here Document: `<<`

A here document feeds multiple lines of input to a command.

```bash
# Use cat with a here document
cat << EOF
This is line 1
This is line 2
This is line 3
EOF
```

The delimiter (`EOF` in this example) can be any string, but `EOF` is commonly used.

### Here Document with Variable Expansion

Variables are expanded within here documents by default:

```bash
NAME="John"
cat << EOF
Hello, $NAME
Your home directory is $HOME
Today is $(date)
EOF
```

### Here Document Without Variable Expansion

Quote the delimiter to prevent variable expansion:

```bash
cat << 'EOF'
This $VARIABLE will not be expanded
Neither will $(date)
EOF
```

### Here Document with Input Redirection

Create a file from a here document:

```bash
cat << EOF > /tmp/myconfig.txt
# Configuration file
server=localhost
port=8080
timeout=30
EOF
```

### Here Document with Tab Suppression: `<<-`

Use `<<-` to suppress leading tabs (useful in scripts):

```bash
cat <<- EOF
	This line has a leading tab that won't appear
	This one too
EOF
```

---

## Advanced Redirection Techniques

### Using tee Command

The `tee` command reads from stdin and writes to both stdout and files simultaneously.

```bash
# Write to file and display on screen
echo "Hello World" | tee /tmp/hello.txt

# Append instead of overwrite
echo "Another line" | tee -a /tmp/hello.txt

# Write to multiple files
echo "System info" | tee file1.txt file2.txt file3.txt

# Use in a pipeline
ls -l /etc | tee /tmp/listing.txt | grep conf
```

**Practical Example - Logging and Viewing:**
```bash
# Run a command, save output, and view it
find /etc -name "*.conf" 2>/dev/null | tee /tmp/conf-files.txt | wc -l
```

### Using xargs with Pipes

The `xargs` command builds command lines from stdin.

```bash
# Find all .log files and remove them
find /tmp -name "*.log" | xargs rm -f

# Copy files to multiple directories
echo "/tmp/dir1 /tmp/dir2 /tmp/dir3" | xargs -n 1 cp file.txt

# Process each line separately
cat /tmp/servers.txt | xargs -I {} ping -c 1 {}
```

### Noclobber Option

Prevent accidental file overwriting:

```bash
# Enable noclobber
set -o noclobber

# This will now fail if file exists
echo "test" > /tmp/existing-file.txt
# bash: /tmp/existing-file.txt: cannot overwrite existing file

# Force overwrite with >|
echo "test" >| /tmp/existing-file.txt

# Disable noclobber
set +o noclobber
```

### Process Substitution: `<()` and `>()`

Process substitution allows using command output as a file:

```bash
# Compare output of two commands
diff <(ls /dir1) <(ls /dir2)

# Use output as input file
wc -l <(grep error /var/log/messages)
```

### Here Strings: `<<<`

A here string passes a string directly to a command's stdin:

```bash
# Pass a string to a command
cat <<< "Hello World"

# Use with bc for calculations
bc <<< "1+2+3+4"
# Output: 10

# Use with wc to count words
wc -w <<< "one two three four five"
# Output: 5

# Use with read to assign variables
read firstname lastname <<< "John Doe"
echo "First: $firstname, Last: $lastname"
```

### Formatting Output with column

The `column` command formats text into aligned columns:

```bash
# Format whitespace-delimited data into columns
cat file.txt | column -t

# Specify a delimiter
cat /etc/passwd | column -t -s ':'
```

---

## Practice Exam Questions

### Question 1: Redirect Command Output
> Save the output of `ls -la /etc` to a file called `/tmp/etc-contents.txt`.

**Solution:**
```bash
ls -la /etc > /tmp/etc-contents.txt
```

---

### Question 2: Append Output to File
> Append the current date and time to `/tmp/timestamps.txt`.

**Solution:**
```bash
date >> /tmp/timestamps.txt
```

---

### Question 3: Redirect Errors Only
> Run `find /etc -name "*.conf"` and redirect any error messages to `/tmp/find-errors.txt` while displaying normal output on screen.

**Solution:**
```bash
find /etc -name "*.conf" 2> /tmp/find-errors.txt
```

---

### Question 4: Suppress All Errors
> List the contents of `/root` directory without displaying any error messages.

**Solution:**
```bash
ls /root 2> /dev/null
```

---

### Question 5: Redirect stdout and stderr to Same File
> Run `ls -l /etc /nonexistent` and save both output and errors to `/tmp/combined.txt`.

**Solution:**
```bash
ls -l /etc /nonexistent &> /tmp/combined.txt

# Or alternatively:
ls -l /etc /nonexistent > /tmp/combined.txt 2>&1
```

---

### Question 6: Separate stdout and stderr
> Run `find / -name "passwd"` and save successful results to `/tmp/found.txt` and errors to `/tmp/notfound.txt`.

**Solution:**
```bash
find / -name "passwd" > /tmp/found.txt 2> /tmp/notfound.txt
```

---

### Question 7: Use Pipe to Filter Output
> Display only the lines containing "root" from `/etc/passwd`.

**Solution:**
```bash
cat /etc/passwd | grep root

# Or more efficiently:
grep root /etc/passwd
```

---

### Question 8: Chain Multiple Pipes
> List all files in `/etc`, filter for files containing "conf", sort them alphabetically, and display only the first 10.

**Solution:**
```bash
ls /etc | grep conf | sort | head -n 10
```

---

### Question 9: Count Lines with Pipe
> Count how many lines in `/etc/passwd` contain the string "nologin".

**Solution:**
```bash
grep nologin /etc/passwd | wc -l

# Or:
cat /etc/passwd | grep nologin | wc -l
```

---

### Question 10: Input Redirection with Sort
> Sort the contents of `/etc/passwd` and save the result to `/tmp/sorted-passwd.txt`.

**Solution:**
```bash
sort < /etc/passwd > /tmp/sorted-passwd.txt

# Or simply:
sort /etc/passwd > /tmp/sorted-passwd.txt
```

---

### Question 11: Create File with Here Document
> Create a file `/tmp/greeting.txt` containing three lines:
> - "Hello"
> - "Welcome to Linux"  
> - "Goodbye"

**Solution:**
```bash
cat << EOF > /tmp/greeting.txt
Hello
Welcome to Linux
Goodbye
EOF
```

---

### Question 12: Use tee to Log and Display
> Run the command `df -h` and simultaneously display the output on screen and save it to `/tmp/disk-usage.txt`.

**Solution:**
```bash
df -h | tee /tmp/disk-usage.txt
```

---

### Question 13: Append with tee
> Append the output of `free -m` to `/tmp/system-info.txt` while also displaying it on screen.

**Solution:**
```bash
free -m | tee -a /tmp/system-info.txt
```

---

### Question 14: Filter and Save Simultaneously
> Find all processes running as user "apache", count them, and save the full process list to `/tmp/apache-procs.txt`.

**Solution:**
```bash
ps aux | grep apache | tee /tmp/apache-procs.txt | wc -l
```

---

### Question 15: Complex Pipeline
> List the 5 largest files in `/var/log`, showing only the filename and size.

**Solution:**
```bash
ls -lS /var/log | head -n 6 | tail -n 5 | awk '{print $5, $9}'

# Or simpler:
ls -lS /var/log | head -n 6
```

---

### Question 16: Discard All Output
> Run the command `find / -name "*.tmp"` without any output appearing on screen (discard both stdout and stderr).

**Solution:**
```bash
find / -name "*.tmp" &> /dev/null

# Or:
find / -name "*.tmp" > /dev/null 2>&1
```

---

### Question 17: Here Document with Variables
> Create a configuration file `/tmp/app.conf` using a here document that includes the current hostname and date.

**Solution:**
```bash
cat << EOF > /tmp/app.conf
# Application Configuration
# Generated on $(date)
# Hostname: $(hostname)

server_name=$(hostname)
created_date=$(date +%Y-%m-%d)
EOF
```

---

### Question 18: Redirect Errors and Keep Output
> Run `ls -la /etc /root /nonexistent` where:
> - Normal output goes to `/tmp/listing.txt`
> - Errors go to `/tmp/errors.txt`
> - Nothing appears on screen

**Solution:**
```bash
ls -la /etc /root /nonexistent > /tmp/listing.txt 2> /tmp/errors.txt
```

---

## Quick Reference

### Redirection Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `>` | Redirect stdout (overwrite) | `echo "text" > file.txt` |
| `>>` | Redirect stdout (append) | `echo "text" >> file.txt` |
| `<` | Redirect stdin | `sort < file.txt` |
| `2>` | Redirect stderr (overwrite) | `cmd 2> errors.txt` |
| `2>>` | Redirect stderr (append) | `cmd 2>> errors.txt` |
| `&>` | Redirect stdout and stderr | `cmd &> output.txt` |
| `&>>` | Append stdout and stderr | `cmd &>> output.txt` |
| `2>&1` | Redirect stderr to stdout | `cmd > file 2>&1` |
| `1>&2` | Redirect stdout to stderr | `echo "error" 1>&2` |
| `\|` | Pipe stdout to next command | `cmd1 \| cmd2` |
| `\|&` | Pipe stdout and stderr | `cmd1 \|& cmd2` |
| `<<` | Here document | `cat << EOF` |
| `<<-` | Here document (tab suppressed) | `cat <<- EOF` |
| `<<<` | Here string | `cat <<< "string"` |

### Common Patterns

```bash
# Save command output to file
command > file.txt

# Append command output to file
command >> file.txt

# Redirect errors to file
command 2> errors.txt

# Suppress error messages
command 2> /dev/null

# Save both output and errors
command &> all-output.txt

# Send output to file and screen
command | tee file.txt

# Chain commands together
cmd1 | cmd2 | cmd3

# Create file from here document
cat << EOF > file.txt
content
EOF
```

### File Descriptor Summary

| FD | Name | Default | Redirect Operators |
|----|------|---------|-------------------|
| 0 | stdin | keyboard | `<`, `<<`, `<<<` |
| 1 | stdout | screen | `>`, `>>`, `1>`, `1>>` |
| 2 | stderr | screen | `2>`, `2>>` |

### Special Destinations

| Destination | Purpose |
|-------------|---------|
| `/dev/null` | Discard output (black hole) |
| `/dev/zero` | Source of null bytes |
| `/dev/stdin` | Standard input |
| `/dev/stdout` | Standard output |
| `/dev/stderr` | Standard error |

---

## Key Points to Remember

1. **`>` overwrites**, **`>>` appends**
2. **File descriptor 1** = stdout, **File descriptor 2** = stderr
3. **Order matters**: `> file 2>&1` (correct) vs `2>&1 > file` (wrong)
4. **`&>` or `&>>`** redirects both stdout and stderr
5. **`/dev/null`** discards any output written to it
6. **Pipes (`|`)** connect stdout of one command to stdin of another
7. **`|&`** pipes both stdout and stderr
8. **Here documents (`<<`)** allow multi-line input
9. **`tee`** writes to both file and screen
10. **Configuration changes must persist after reboot** - redirect to proper files

---

## Practice Exercise

Complete the following tasks:

1. Create a file `/tmp/redirection-test.txt` with the text "Redirection Test"
2. Append the current date to that file
3. List `/etc` and `/nonexistent`, saving output to `/tmp/output.txt` and errors to `/tmp/errors.txt`
4. Count how many files in `/etc` contain "conf" in their name
5. Create a 3-line configuration file using a here document
6. Use `tee` to save `df -h` output to a file while viewing it
7. Discard all error messages from `find / -name "test"`

**Expected Commands:**
```bash
# 1. Create file
echo "Redirection Test" > /tmp/redirection-test.txt

# 2. Append date
date >> /tmp/redirection-test.txt

# 3. Separate stdout and stderr
ls /etc /nonexistent > /tmp/output.txt 2> /tmp/errors.txt

# 4. Count conf files
ls /etc | grep conf | wc -l

# 5. Here document
cat << EOF > /tmp/myconfig.conf
# Configuration File
setting1=value1
setting2=value2
EOF

# 6. Use tee
df -h | tee /tmp/disk-info.txt

# 7. Discard errors
find / -name "test" 2> /dev/null
```

---

*This document covers the RHCSA exam objective: "Use input-output redirection (>, >>, |, 2>, etc.)"*
