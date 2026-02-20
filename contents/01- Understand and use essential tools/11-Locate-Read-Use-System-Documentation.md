# Locate, Read, and Use System Documentation

## Introduction

Effective use of system documentation is a critical skill for RHCSA certification. Red Hat emphasizes the ability to find and use documentation during the exam, as you won't have internet access. This guide covers the three primary documentation sources: `man` pages, `info` pages, and files in `/usr/share/doc`.

---

## Manual Pages (man)

The `man` command provides access to the system reference manuals. It is the primary documentation source for Linux commands, system calls, configuration files, and more.

### Basic Syntax

```bash
man [SECTION] COMMAND
```

### Man Page Sections

Understanding sections is crucial for the RHCSA exam:

| Section | Content Type | Examples |
|---------|--------------|----------|
| 1 | User commands (executable programs) | `ls`, `cp`, `grep` |
| 2 | System calls (kernel functions) | `open`, `read`, `write` |
| 3 | Library functions (C library) | `printf`, `malloc` |
| 4 | Special files (devices) | `/dev/null`, `/dev/sda` |
| 5 | File formats and conventions | `/etc/passwd`, `/etc/fstab` |
| 6 | Games | - |
| 7 | Miscellaneous (conventions, protocols) | `ascii`, `utf-8` |
| 8 | System administration commands | `mount`, `useradd`, `systemctl` |
| 9 | Kernel routines (non-standard) | - |

### Common Man Command Usage

```bash
# View man page for a command
man ls

# View man page from specific section
man 5 passwd

# View man page with section specified differently
man passwd.5

# View all man pages for a topic
man -a passwd

# Show location of man page file
man -w passwd

# Display all matching man pages sequentially
man -a intro
```

---

## Navigating Man Pages

Man pages are displayed using the `less` pager. Master these navigation keys:

### Navigation Keys

| Key | Action |
|-----|--------|
| `Space` or `Page Down` | Move forward one page |
| `b` or `Page Up` | Move backward one page |
| `Enter` or `Down Arrow` | Move forward one line |
| `k` or `Up Arrow` | Move backward one line |
| `g` | Go to beginning of document |
| `G` | Go to end of document |
| `/pattern` | Search forward for pattern |
| `?pattern` | Search backward for pattern |
| `n` | Repeat search in same direction |
| `N` | Repeat search in opposite direction |
| `q` | Quit |
| `h` | Display help |

---

## Man Page Structure

Every man page follows a standard structure:

| Section | Description |
|---------|-------------|
| **NAME** | Command name and brief description |
| **SYNOPSIS** | Command syntax and usage format |
| **DESCRIPTION** | Detailed description of the command |
| **OPTIONS** | Available command-line options |
| **EXAMPLES** | Usage examples (if provided) |
| **FILES** | Related configuration files |
| **SEE ALSO** | Related commands and man pages |
| **EXIT STATUS** | Return codes and their meanings |
| **AUTHOR** | Who wrote the command/documentation |
| **BUGS** | Known issues |

### Reading the SYNOPSIS

The SYNOPSIS section uses conventions:

| Format | Meaning |
|--------|---------|
| **bold text** | Type exactly as shown |
| *italic text* or underlined | Replace with appropriate argument |
| `[-abc]` | Options in brackets are optional |
| `-a\|-b` | Options separated by `\|` are mutually exclusive |
| `argument...` | Argument can be repeated |
| `[expression]...` | Entire expression can be repeated |

---

## Searching for Man Pages

### The `apropos` Command

Search man page names and descriptions for keywords:

```bash
# Search for pages related to "password"
apropos password

# Search for pages related to "partition"
apropos partition

# Search with exact match
apropos -e passwd

# Search using wildcard
apropos -w 'user*'

# Search using regular expression
apropos -r 'copy.*file'

# Limit search to specific section
apropos -s 5 passwd
```

### The `man -k` Command

Equivalent to `apropos`:

```bash
# Same as apropos password
man -k password

# Search for network-related commands
man -k network

# Search for commands related to "disk"
man -k disk
```

### The `whatis` Command

Display one-line descriptions of man pages:

```bash
# Show description of passwd command
whatis passwd

# Show descriptions for multiple commands
whatis ls cp mv

# Use wildcard
whatis -w 'ls*'
```

### The `man -f` Command

Equivalent to `whatis`:

```bash
# Same as whatis passwd
man -f passwd

# Show which sections have pages for passwd
man -f passwd
# Output:
# passwd (1)    - update user's authentication tokens
# passwd (5)    - password file
```

---

## Updating the Man Database

The search commands (`apropos`, `whatis`, `man -k`) use a database. If recently installed packages don't appear in searches:

```bash
# Update the man page database (as root)
sudo mandb

# Force recreation of database
sudo mandb -c
```

---

## Info Pages

The GNU Info system provides more detailed, hyperlinked documentation for GNU software. Info pages are organized in a tree structure with nodes.

### Basic Usage

```bash
# View info page for a command
info ls

# View info page for coreutils
info coreutils

# Start at a specific node
info bash 'Basic Shell Features'
```

### Info Navigation Keys

| Key | Action |
|-----|--------|
| `Space` | Scroll forward |
| `Backspace` or `Delete` | Scroll backward |
| `n` | Go to next node |
| `p` | Go to previous node |
| `u` | Go up to parent node |
| `l` | Go to last visited node |
| `t` | Go to top node |
| `Enter` | Follow hyperlink under cursor |
| `Tab` | Move to next hyperlink |
| `/pattern` | Search for pattern |
| `s` or `/` | Search forward |
| `q` | Quit |
| `h` | Display help |
| `?` | Display command summary |

### Info vs Man

| Feature | man | info |
|---------|-----|------|
| Format | Single page | Multiple linked nodes |
| Navigation | Linear scroll | Hyperlinked tree |
| Detail | Concise reference | Extended documentation |
| Primary use | Quick reference | In-depth learning |
| All commands | Yes | Mainly GNU tools |

---

## Using `pinfo` (if available)

`pinfo` is a more user-friendly info viewer with color support:

```bash
# View info page with pinfo
pinfo bash

# Navigation is similar to info but with better visual cues
```

---

## Documentation in /usr/share/doc

The `/usr/share/doc` directory contains additional documentation for installed packages, including:

- README files
- CHANGELOG files
- Configuration examples
- License information
- Sample configurations
- Tutorials and guides

### Exploring /usr/share/doc

```bash
# List all documentation directories
ls /usr/share/doc/

# View documentation for a specific package
ls /usr/share/doc/bash/

# Read the README file
less /usr/share/doc/bash/README

# Find specific documentation
ls /usr/share/doc/ | grep -i ssh

# View sample configuration files
ls /usr/share/doc/rsync*/
```

### Common Files in /usr/share/doc

| File | Purpose |
|------|---------|
| `README` | General information about the package |
| `README.md` | Markdown format readme |
| `CHANGELOG` | Version history and changes |
| `NEWS` | Important changes between versions |
| `TODO` | Planned features |
| `AUTHORS` | List of contributors |
| `LICENSE` or `COPYING` | License information |
| `INSTALL` | Installation instructions |
| `*.conf.example` | Sample configuration files |

---

## Finding Documentation for Installed Packages

### Using rpm to Find Documentation

```bash
# List all documentation files for a package
rpm -qd bash

# Find which package provides a file
rpm -qf /etc/passwd

# Then view its documentation
rpm -qd setup
```

### Using dnf/yum for Documentation

```bash
# List files in a package (includes docs)
dnf repoquery -l bash

# Install documentation for a package
dnf install man-pages
```

---

## The --help Option

Most commands support `--help` for quick reference:

```bash
# View quick help for a command
ls --help

# Some commands use -h
grep -h

# Pipe to less for paging
systemctl --help | less
```

---

## Command-Specific Help

### Built-in Shell Commands

For shell built-ins, use `help`:

```bash
# Get help on shell built-ins
help cd
help alias
help export

# List all built-in commands
help

# View type of command (built-in, alias, or external)
type cd
type ls
```

---

## Practice Questions

### Question 1
Display the man page for the `passwd` command that describes the password file format, not the command itself.

<details>
<summary>Show Solution</summary>

```bash
# The password file format is in section 5
man 5 passwd

# Alternative syntax
man passwd.5

# First, check which sections have passwd pages
man -f passwd
# Output shows:
# passwd (1)    - update user's authentication tokens
# passwd (5)    - password file
```
</details>

---

### Question 2
Find all man pages related to the keyword "network configuration".

<details>
<summary>Show Solution</summary>

```bash
# Using apropos
apropos "network"

# Or use man -k
man -k network

# Search for configuration specifically
apropos "network configuration"

# Or search for multiple terms
apropos network | grep -i config
```
</details>

---

### Question 3
What is the difference between `man -k` and `man -f`? Demonstrate both using "passwd".

<details>
<summary>Show Solution</summary>

```bash
# man -k (apropos) - searches descriptions for keywords
man -k passwd
# Shows all pages with "passwd" in name OR description

# man -f (whatis) - shows exact matches for page names
man -f passwd
# Shows only pages named exactly "passwd"

# Example output of man -f passwd:
# passwd (1)    - update user's authentication tokens
# passwd (5)    - password file

# Example output of man -k passwd:
# Shows many more results including gpasswd, chpasswd, etc.
```
</details>

---

### Question 4
Find the man page for the `/etc/fstab` configuration file and identify which section it is in.

<details>
<summary>Show Solution</summary>

```bash
# Search for fstab
man -f fstab
# Output: fstab (5) - static information about the filesystems

# Configuration files are typically in section 5
man 5 fstab

# Or simply
man fstab
# (Will find section 5 as it's the only one)
```
</details>

---

### Question 5
Use the info system to navigate to the documentation about "Bash Variables".

<details>
<summary>Show Solution</summary>

```bash
# Start info on bash
info bash

# Then navigate:
# 1. Use arrow keys or Tab to move between menu items
# 2. Look for "Shell Variables" or similar
# 3. Press Enter to follow link

# Or go directly to a node
info bash 'Shell Variables'

# Search within info
info bash
# Then press / and type "variables" to search
```
</details>

---

### Question 6
Find the documentation directory for the `httpd` (Apache) package and list its contents.

<details>
<summary>Show Solution</summary>

```bash
# List documentation directory
ls /usr/share/doc/httpd*/

# Or find it
ls /usr/share/doc/ | grep -i httpd

# View README
less /usr/share/doc/httpd/README

# List all doc files for httpd package
rpm -qd httpd
```
</details>

---

### Question 7
What command would you use to get a brief, one-line description of the `tar` command?

<details>
<summary>Show Solution</summary>

```bash
# Using whatis
whatis tar
# Output: tar (1) - an archiving utility

# Using man -f
man -f tar

# Both give the same result - a brief description
```
</details>

---

### Question 8
Search for all commands related to "user management" or "user administration".

<details>
<summary>Show Solution</summary>

```bash
# Search using apropos
apropos user

# More specific search
apropos "user account"

# Search for add user commands
apropos -s 8 user
# Section 8 contains admin commands

# Alternative with regex
apropos -r 'user.*(add|del|mod)'
```
</details>

---

### Question 9
Find sample configuration files for the `rsyslog` package.

<details>
<summary>Show Solution</summary>

```bash
# Check /usr/share/doc
ls /usr/share/doc/rsyslog*/

# Look for example configs
find /usr/share/doc/rsyslog*/ -name "*.conf*"

# List all doc files
rpm -qd rsyslog

# Check for sample files in /etc
ls /etc/rsyslog.d/
```
</details>

---

### Question 10
Use the `help` command to get information about the `cd` built-in command.

<details>
<summary>Show Solution</summary>

```bash
# cd is a shell built-in, not an external command
help cd

# Verify it's a built-in
type cd
# Output: cd is a shell builtin

# Note: man cd would show the shell's built-in section
# help is the primary source for built-ins
```
</details>

---

### Question 11
Find which manual section contains information about the `crontab` file format vs. the `crontab` command.

<details>
<summary>Show Solution</summary>

```bash
# Check all sections for crontab
man -f crontab
# Output:
# crontab (1)   - maintain crontab files for individual users
# crontab (5)   - tables for driving cron

# The command is in section 1
man 1 crontab

# The file format is in section 5
man 5 crontab
```
</details>

---

### Question 12
Navigate to the "SEE ALSO" section of the `ls` man page and identify related commands.

<details>
<summary>Show Solution</summary>

```bash
# Open man page
man ls

# Search for SEE ALSO
/SEE ALSO
# Press Enter, then n to find it

# Or scroll to the end (G key)
# The SEE ALSO section typically lists:
# dir(1), dircolors(1), vdir(1), chmod(1), chown(1), etc.
```
</details>

---

### Question 13
Find documentation about how to configure the SSH daemon.

<details>
<summary>Show Solution</summary>

```bash
# Man page for sshd configuration
man 5 sshd_config

# Or find it first
man -k ssh | grep config
# Output includes: sshd_config (5), ssh_config (5)

# View documentation in /usr/share/doc
ls /usr/share/doc/openssh*/

# Check rpm documentation
rpm -qd openssh-server
```
</details>

---

### Question 14
What is the command to update the database used by `apropos` and `whatis`?

<details>
<summary>Show Solution</summary>

```bash
# Update man page database
sudo mandb

# Force complete rebuild
sudo mandb -c

# Quiet mode (no output)
sudo mandb -q

# Test mode (don't update, just check)
mandb -t
```
</details>

---

### Question 15
Find the man page that describes the format of the `/etc/shadow` file.

<details>
<summary>Show Solution</summary>

```bash
# File formats are in section 5
man 5 shadow

# Verify
man -f shadow
# Output: shadow (5) - shadowed password file

# Or search for it
apropos shadow | grep "password file"
```
</details>

---

### Question 16
How would you display all man pages for `printf` (there may be multiple)?

<details>
<summary>Show Solution</summary>

```bash
# Use -a option to display all matching pages
man -a printf

# After viewing first page, press 'q' then confirm
# to view the next page (from another section)

# Check which sections have printf
man -f printf
# printf (1)    - format and print data
# printf (3)    - formatted output conversion

# View specific sections
man 1 printf    # Shell command
man 3 printf    # C library function
```
</details>

---

### Question 17
Find the location of the man page file for the `ls` command.

<details>
<summary>Show Solution</summary>

```bash
# Use -w option to show path
man -w ls
# Output: /usr/share/man/man1/ls.1.gz

# This shows where the man page file is stored
# Man pages are typically gzip compressed (.gz)
```
</details>

---

### Question 18
Use the info command to find information about file permissions in coreutils.

<details>
<summary>Show Solution</summary>

```bash
# Open coreutils info
info coreutils

# Look for File permissions section
# Use Tab to navigate menus
# Or search with /

# Direct access
info coreutils 'File permissions'

# Or view chmod info
info chmod
```
</details>

---

### Question 19
Determine whether `alias` is a built-in command or external program, and find its documentation.

<details>
<summary>Show Solution</summary>

```bash
# Check the type
type alias
# Output: alias is a shell builtin

# For built-ins, use help
help alias

# Note: man bash also contains info about built-ins
man bash
# Then search: /^SHELL BUILTIN

# There is no separate man page for alias
man alias  # This may or may not exist
```
</details>

---

### Question 20
Find all commands in section 8 (system administration) related to "filesystem".

<details>
<summary>Show Solution</summary>

```bash
# Search in section 8 only
apropos -s 8 filesystem

# Or
man -k filesystem | grep "(8)"

# Alternative search terms
apropos -s 8 "file system"
apropos -s 8 mount
apropos -s 8 disk
```
</details>

---

### Question 21
Read the EXAMPLES section of the `find` command man page.

<details>
<summary>Show Solution</summary>

```bash
# Open find man page
man find

# Search for EXAMPLES
/EXAMPLES
# Press Enter

# Or use less command to search from within man
# Press / then type EXAMPLES and Enter

# Navigate through examples with n (next match)
```
</details>

---

### Question 22
Find documentation about configuring firewall rules (firewalld).

<details>
<summary>Show Solution</summary>

```bash
# Search for firewall-related pages
apropos firewall
man -k firewall

# View firewalld documentation
man firewalld
man firewall-cmd
man 5 firewalld.conf

# Documentation in /usr/share/doc
ls /usr/share/doc/firewalld*/

# View rich rule documentation
man firewalld.richlanguage
```
</details>

---

### Question 23
Find the man page that explains the format of `/etc/group`.

<details>
<summary>Show Solution</summary>

```bash
# File formats are in section 5
man 5 group

# Verify
man -f group
# Output: group (5) - user group file

# Or search
apropos -e group
```
</details>

---

### Question 24
How can you view the quick help for `systemctl` without opening the full man page?

<details>
<summary>Show Solution</summary>

```bash
# Use --help option
systemctl --help

# Pipe to less for easier reading
systemctl --help | less

# For a brief description
whatis systemctl

# View only specific parts
systemctl --help | grep -i "start\|stop\|restart"
```
</details>

---

### Question 25
Find and read the README file for the `sudo` package.

<details>
<summary>Show Solution</summary>

```bash
# Find sudo documentation
ls /usr/share/doc/sudo*/

# Read README
less /usr/share/doc/sudo*/README

# List all doc files
rpm -qd sudo

# View specific files
cat /usr/share/doc/sudo*/CHANGELOG
```
</details>

---

## Quick Reference Cheat Sheet

### Man Commands

| Command | Description |
|---------|-------------|
| `man command` | View man page for command |
| `man N command` | View man page from section N |
| `man -a command` | View all man pages for command |
| `man -k keyword` | Search man page descriptions (apropos) |
| `man -f command` | Show brief description (whatis) |
| `man -w command` | Show location of man page file |

### Search Commands

| Command | Description |
|---------|-------------|
| `apropos keyword` | Search man page names and descriptions |
| `apropos -e name` | Exact match search |
| `apropos -s N keyword` | Search only in section N |
| `whatis command` | Display one-line description |
| `mandb` | Update the man page database |

### Info Commands

| Command | Description |
|---------|-------------|
| `info command` | View info page for command |
| `info command 'Node Name'` | Go directly to specific node |
| `pinfo command` | View info with pinfo (if available) |

### Documentation Locations

| Location | Content |
|----------|---------|
| `/usr/share/man/` | Man page files |
| `/usr/share/info/` | Info page files |
| `/usr/share/doc/` | Package documentation |

### Help Commands

| Command | Description |
|---------|-------------|
| `command --help` | Quick help for commands |
| `help builtin` | Help for shell built-ins |
| `type command` | Show command type |

### Man Page Navigation (less pager)

| Key | Action |
|-----|--------|
| `Space` / `Page Down` | Forward one page |
| `b` / `Page Up` | Backward one page |
| `g` | Go to beginning |
| `G` | Go to end |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next/previous search match |
| `q` | Quit |

---

## Man Page Sections Summary

| Section | Type | Examples |
|---------|------|----------|
| 1 | User commands | ls, grep, tar |
| 5 | File formats | passwd, fstab, hosts |
| 8 | Admin commands | mount, useradd, systemctl |

---

## Key Points for RHCSA Exam

1. **Know man page sections**: Section 1 (commands), 5 (config files), 8 (admin commands)
2. **Use `man -k` or `apropos`**: Find commands when you don't remember the name
3. **Use `man -f` or `whatis`**: Quick one-line descriptions
4. **Specify section when needed**: `man 5 passwd` vs `man 1 passwd`
5. **Navigate efficiently**: `/pattern` to search, `n`/`N` to repeat
6. **Check /usr/share/doc**: For example configs and additional documentation
7. **Use `--help` for quick reference**: Faster than opening full man page
8. **Use `help` for built-ins**: `cd`, `alias`, `export` are shell built-ins
9. **Update database with `mandb`**: If new packages don't appear in searches
10. **Info pages for GNU tools**: More detailed than man pages for some tools
