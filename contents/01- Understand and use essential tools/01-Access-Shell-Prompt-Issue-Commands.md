# Access a Shell Prompt and Issue Commands with Correct Syntax

## RHCSA Exam Objective
> Access a shell prompt and issue commands with correct syntax

---

## Table of Contents
1. [Introduction](#introduction)
2. [Accessing the Shell](#accessing-the-shell)
3. [Understanding Command Syntax](#understanding-command-syntax)
4. [Essential Shell Components](#essential-shell-components)
5. [Practice Exam Questions](#practice-exam-questions)
6. [Quick Reference](#quick-reference)

---

## Introduction

The shell is the command-line interface to the Linux operating system. On RHEL, the default shell is **Bash** (Bourne-Again SHell). This topic covers how to access the shell and execute commands using proper syntax.

### What is a Shell?

A shell is both a **command interpreter** and a **programming language**:
- As a command interpreter, it provides the user interface to system utilities
- As a programming language, it allows combining commands into scripts

---

## Accessing the Shell

### Method 1: Virtual Console (Text Mode)

On a RHEL system, you can access virtual consoles using keyboard shortcuts:

| Key Combination | Description |
|-----------------|-------------|
| `Ctrl + Alt + F1` | Graphical login (GNOME Display Manager) |
| `Ctrl + Alt + F2` | First virtual console (tty2) |
| `Ctrl + Alt + F3` | Second virtual console (tty3) |
| `Ctrl + Alt + F4` | Third virtual console (tty4) |
| `Ctrl + Alt + F5` | Fourth virtual console (tty5) |
| `Ctrl + Alt + F6` | Fifth virtual console (tty6) |

**Exam Question Example:**
> You are at the graphical login screen. Switch to a text-based virtual console and log in as user `student`.

**Solution:**
```bash
# Press Ctrl + Alt + F2
# Enter username: student
# Enter password when prompted
```

### Method 2: Terminal Emulator (GUI)

From the GNOME desktop:
1. Click **Activities** (top-left corner)
2. Type "terminal" in the search bar
3. Click on **Terminal** application

Or use the keyboard shortcut (if configured).

### Method 3: SSH Remote Access

To access a remote system's shell via SSH, see Topic 04: Access Remote Systems Using SSH.

---

## Understanding Command Syntax

### Basic Command Structure

```
command [options] [arguments]
```

| Component | Description | Example |
|-----------|-------------|---------|
| **command** | The program/utility to execute | `ls`, `cat`, `mkdir` |
| **options** | Modify command behavior | `-l`, `-a`, `--help` |
| **arguments** | Target files, directories, or values | `/home`, `file.txt` |

### Simple Commands

A simple command is a sequence of words separated by blanks, terminated by a control operator.

**Examples:**
```bash
# Command only
pwd

# Command with option
ls -l

# Command with argument
cat /etc/hostname

# Command with options and arguments
ls -la /var/log
```

### Option Formats

Options can be written in different formats:

| Format | Example | Description |
|--------|---------|-------------|
| Short option | `-l` | Single dash, single character |
| Combined short options | `-la` | Multiple short options combined |
| Long option | `--all` | Double dash, full word |
| Option with value | `-n 5` or `--lines=5` | Option requiring a value |

**Practice:**
```bash
# These are equivalent:
ls -l -a
ls -la
ls -al

# Long option example
ls --all --long

# Option with value
head -n 10 /etc/passwd
head --lines=10 /etc/passwd
```

---

## Essential Shell Components

### 1. The Shell Prompt

The shell prompt indicates the shell is ready to accept commands:

| Prompt | Meaning |
|--------|---------|
| `$` | Regular user |
| `#` | Root user (superuser) |

**Default prompt format:**
```
[username@hostname current_directory]$
```

**Example:**
```
[student@server1 ~]$
[root@server1 /etc]#
```

The `~` (tilde) represents the user's home directory.

### 2. Reserved Words

Bash has reserved words that have special meaning:

```
if    then   elif   else   fi
for   in     until  while  do    done
case  esac   select function
{     }      [[     ]]     !
```

**Example using reserved words:**
```bash
if [ -f /etc/passwd ]; then
    echo "File exists"
fi
```

### 3. Control Operators

Control operators perform control functions:

| Operator | Function |
|----------|----------|
| `;` | Command separator (sequential execution) |
| `&` | Run command in background |
| `&&` | AND - run next command only if previous succeeds |
| `\|\|` | OR - run next command only if previous fails |

**Examples:**
```bash
# Sequential execution
mkdir /tmp/test; cd /tmp/test; touch file1

# Background execution
sleep 100 &

# AND operator
mkdir /tmp/newdir && echo "Directory created successfully"

# OR operator
mkdir /tmp/existingdir || echo "Failed to create directory"
```

> **Note:** For pipes (`|`) and I/O redirection, see Topic 02: Input-Output Redirection.

### 4. Quoting Mechanisms

Quoting removes special meaning from characters:

| Quote Type | Symbol | Effect |
|------------|--------|--------|
| Escape character | `\` | Removes special meaning from next character |
| Single quotes | `'...'` | Preserves literal value of all characters |
| Double quotes | `"..."` | Preserves literal value except `$`, `` ` ``, `\`, and `!` |

**Examples:**
```bash
# Escape character
echo The cost is \$50

# Single quotes - literal interpretation
echo 'The variable is $HOME'
# Output: The variable is $HOME

# Double quotes - variables are expanded
echo "Your home directory is $HOME"
# Output: Your home directory is /home/student

# Preserving spaces
touch "my file.txt"     # Creates one file named "my file.txt"
touch my file.txt       # Creates two files: "my" and "file.txt"
```

### 5. Variables

#### Environment Variables

Common environment variables you should know:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `HOME` | User's home directory | `/home/student` |
| `PATH` | Command search path | `/usr/bin:/bin` |
| `PWD` | Current working directory | `/home/student` |
| `USER` | Current username | `student` |
| `SHELL` | Default shell | `/bin/bash` |
| `HOSTNAME` | System hostname | `server1.example.com` |
| `PS1` | Primary prompt string | `[\u@\h \W]\$` |

**Working with variables:**
```bash
# View variable value
echo $HOME
echo $PATH

# View all environment variables
env
printenv

# Set a variable
MYVAR="Hello World"
echo $MYVAR

# Export variable (make available to child processes)
export MYVAR="Hello World"
```

### 6. Special Parameters

| Parameter | Description |
|-----------|-------------|
| `$?` | Exit status of last command |
| `$$` | Process ID of current shell |
| `$!` | Process ID of last background command |
| `$0` | Name of the shell or script |
| `$#` | Number of positional parameters |

**Example:**
```bash
ls /etc/passwd
echo $?   # Output: 0 (success)

ls /nonexistent
echo $?   # Output: 2 (error - file not found)

echo $$   # Current shell's PID
```

### 7. Exit Status

Every command returns an exit status:

| Exit Status | Meaning |
|-------------|---------|
| `0` | Success |
| `1-255` | Failure (specific codes have specific meanings) |
| `126` | Command found but not executable |
| `127` | Command not found |
| `128+n` | Command terminated by signal n |

**Example:**
```bash
# Check if command succeeded
grep root /etc/passwd
if [ $? -eq 0 ]; then
    echo "Found root user"
fi

# Simpler method using &&
grep root /etc/passwd && echo "Found root user"
```

### 8. Command History

Navigate and reuse previous commands:

| Key/Command | Function |
|-------------|----------|
| Up Arrow | Previous command |
| Down Arrow | Next command |
| `Ctrl + R` | Reverse search history |
| `history` | List command history |
| `!n` | Execute command number n |
| `!!` | Repeat last command |
| `!string` | Execute last command starting with string |

**Examples:**
```bash
# View last 10 commands
history 10

# Repeat last command
!!

# Repeat command #50
!50

# Repeat last command starting with "ls"
!ls

# Repeat last command with sudo
sudo !!
```

### 9. Command Line Editing

Essential keyboard shortcuts:

| Shortcut | Action |
|----------|--------|
| `Ctrl + A` | Move to beginning of line |
| `Ctrl + E` | Move to end of line |
| `Ctrl + U` | Delete from cursor to beginning of line |
| `Ctrl + K` | Delete from cursor to end of line |
| `Ctrl + W` | Delete word before cursor |
| `Ctrl + L` | Clear screen |
| `Ctrl + C` | Cancel current command |
| `Ctrl + D` | Exit shell (or delete character) |
| `Tab` | Command/file completion |
| `Tab Tab` | Show all completions |

### 10. Command Substitution

Use output of one command within another:

```bash
# Modern syntax (preferred)
echo "Today is $(date)"

# Legacy syntax (backticks)
echo "Today is `date`"

# Practical examples
FILES=$(ls /etc/*.conf)
HOSTNAME=$(hostname)
CURRENT_DIR=$(pwd)
```

---

## Practice Exam Questions

### Question 1: Execute Multiple Commands
> Execute three commands on a single line: change to `/tmp`, create a directory called `exam`, and list the contents of `/tmp`.

**Solution:**
```bash
cd /tmp; mkdir exam; ls
```

Or using AND operator (commands depend on previous success):
```bash
cd /tmp && mkdir exam && ls
```

---

### Question 2: Display System Information
> Using proper command syntax, display the following information:
> - Current username
> - Current hostname
> - Current working directory
> - Current shell

**Solution:**
```bash
echo "Username: $USER"
echo "Hostname: $HOSTNAME"
echo "Current directory: $PWD"
echo "Shell: $SHELL"
```

Or using commands:
```bash
whoami
hostname
pwd
echo $SHELL
```

---

### Question 3: Check Command Success
> Run a command to create directory `/tmp/testdir`. If successful, display "Directory created". If it fails, display "Failed to create directory".

**Solution:**
```bash
mkdir /tmp/testdir && echo "Directory created" || echo "Failed to create directory"
```

---

### Question 4: Use Command History
> Execute command number 25 from your history without retyping it.

**Solution:**
```bash
!25
```

---

### Question 5: Handle Filenames with Spaces
> Create a file named `my important file.txt` in `/tmp`.

**Solution:**
```bash
# Using quotes
touch "/tmp/my important file.txt"

# Or using escape characters
touch /tmp/my\ important\ file.txt
```

---

### Question 6: Run Command in Background
> Start a long-running process in the background that won't be terminated when you log out.

**Solution:**
```bash
nohup long_running_command &

# Or using disown
long_running_command &
disown
```

---

### Question 7: View and Modify PATH
> Display your current PATH variable and temporarily add `/opt/custom/bin` to it.

**Solution:**
```bash
# Display current PATH
echo $PATH

# Add directory to PATH (current session only)
export PATH=$PATH:/opt/custom/bin

# Verify
echo $PATH
```

---

### Question 8: Command Substitution
> Store the current date in a variable called `TODAY` and create a file named with that date.

**Solution:**
```bash
TODAY=$(date +%Y-%m-%d)
touch /tmp/backup-$TODAY.tar

# Verify
ls /tmp/backup-*.tar
```

---

### Question 9: Exit Status Check
> Write a command that attempts to read `/etc/shadow`. Capture and display the exit status.

**Solution:**
```bash
cat /etc/shadow
echo "Exit status: $?"
```

---

### Question 10: Virtual Console Access
> From a graphical session, access virtual console 3, log in, and return to the graphical interface.

**Solution:**
```bash
# Press Ctrl + Alt + F3 to access tty3
# Log in with your credentials
# Press Ctrl + Alt + F1 to return to graphical interface
```

---

### Question 11: Execute Command from Specific Directory
> Without changing your current directory, list the contents of `/var/log` and then execute a script located in `/opt/scripts/backup.sh`.

**Solution:**
```bash
# List /var/log without cd
ls /var/log

# Execute script with full path
/opt/scripts/backup.sh

# Or if script isn't executable
bash /opt/scripts/backup.sh
```

---

### Question 12: Group Commands
> Change to `/tmp`, create files `a.txt`, `b.txt`, `c.txt`, and list them - all as a single grouped command that runs in a subshell.

**Solution:**
```bash
(cd /tmp && touch a.txt b.txt c.txt && ls *.txt)
```

After execution, you remain in your original directory.

---

## Quick Reference

### Command Syntax Patterns

```bash
# Basic command
command

# Command with options
command -options

# Command with arguments
command argument1 argument2

# Full syntax
command -options argument1 argument2

# Long options
command --long-option=value
```

### Common Command Execution Patterns

```bash
# Sequential execution
cmd1; cmd2; cmd3

# Conditional execution (AND)
cmd1 && cmd2 && cmd3

# Conditional execution (OR)
cmd1 || cmd2

# Background execution
cmd &

# Pipeline
cmd1 | cmd2 | cmd3

# Subshell execution
(cmd1; cmd2)

# Current shell grouping
{ cmd1; cmd2; }
```

### Essential Commands for the Exam

| Command | Purpose |
|---------|---------|
| `pwd` | Print working directory |
| `cd` | Change directory |
| `ls` | List directory contents |
| `echo` | Display text or variables |
| `cat` | Display file contents |
| `whoami` | Display current username |
| `hostname` | Display system hostname |
| `id` | Display user and group IDs |
| `uname -a` | Display system information |
| `which` | Show full path of command |
| `type` | Display command type |
| `history` | Show command history |
| `clear` | Clear terminal screen |
| `exit` | Exit the shell |

### Prompt Variables (PS1)

| Escape Sequence | Meaning |
|-----------------|---------|
| `\u` | Username |
| `\h` | Hostname (short) |
| `\H` | Hostname (FQDN) |
| `\w` | Current working directory |
| `\W` | Basename of current directory |
| `\$` | `$` for user, `#` for root |
| `\t` | Time (24-hour HH:MM:SS) |
| `\d` | Date (Weekday Month Day) |

**Example:**
```bash
# View current prompt
echo $PS1

# Customize prompt
PS1='[\u@\h \W]\$ '
```

---

## Key Points to Remember

1. **Command Syntax**: `command [options] [arguments]`
2. **Exit Status**: `0` = success, non-zero = failure
3. **Check exit status**: Use `$?` immediately after command
4. **Quoting**: Single quotes = literal, Double quotes = expand variables
5. **Control Operators**: `;` (sequential), `&&` (AND), `||` (OR), `&` (background)
6. **Virtual Consoles**: `Ctrl+Alt+F1-F6`
7. **Command History**: Use `history`, `!!`, `!n`, `!string`
8. **Tab Completion**: Press Tab to complete commands and filenames
9. **Command Substitution**: Use `$(command)` to use output of one command in another
10. **Path**: Use absolute paths (start with `/`) or relative paths (from current directory)

---

## Practice Exercise

Complete the following tasks in order:

1. Open a terminal or switch to a virtual console
2. Display your current username, hostname, and shell
3. Display the current PATH variable
4. Create a directory `/tmp/rhcsa-practice`
5. Change to that directory and verify with `pwd`
6. Create three files: `file1.txt`, `file2.txt`, `file3.txt`
7. Store the current date in a variable called `BACKUP_DATE`
8. Create a file named `backup-$BACKUP_DATE.log`
9. List all files in the directory
10. Check the exit status of the last command
11. Return to your home directory using `~`
12. View the last 5 commands from your history

**Expected Commands:**
```bash
whoami; hostname; echo $SHELL
echo $PATH
mkdir /tmp/rhcsa-practice
cd /tmp/rhcsa-practice && pwd
touch file1.txt file2.txt file3.txt
BACKUP_DATE=$(date +%Y%m%d)
touch backup-$BACKUP_DATE.log
ls -la
echo $?
cd ~
history 5
```

---

*This document covers the RHCSA exam objective: "Access a shell prompt and issue commands with correct syntax"*
