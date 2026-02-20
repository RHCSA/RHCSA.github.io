# Create and Edit Text Files

## Introduction

Creating and editing text files is a fundamental skill for RHCSA certification. The **vi/vim** editor is the standard text editor available on all Linux systems and is essential for system administration tasks. This guide covers everything you need to know about **editing text files** using vim for the RHCSA exam.

> **Note:** For creating files (touch, mkdir, etc.), see Topic 08: Create, Delete, Copy, and Move Files and Directories.

---

## Vi/Vim Editor Overview

### What is Vi/Vim?

| Feature | Description |
|---------|-------------|
| **vi** | Original visual editor, available on all Unix/Linux systems |
| **vim** | Vi IMproved - enhanced version with additional features |
| **Availability** | Pre-installed on virtually all Linux distributions |
| **Modal Editor** | Different modes for different operations |

### Why Vi/Vim for RHCSA?

- Available on minimal installations (no GUI required)
- Works over SSH connections
- Required for editing system configuration files
- Efficient once you learn the commands
- Often aliased: `vi` command actually runs `vim`

---

## Vim Modes

Understanding modes is the most important concept in vim:

| Mode | Purpose | Enter Mode | Exit Mode |
|------|---------|------------|-----------|
| **Normal Mode** | Navigation and commands | Press `Esc` | N/A (default mode) |
| **Insert Mode** | Typing/editing text | Press `i`, `a`, `o`, `O`, `I`, `A` | Press `Esc` |
| **Command Mode** | Execute commands | Press `:` from Normal mode | Press `Enter` or `Esc` |
| **Visual Mode** | Select text | Press `v`, `V`, or `Ctrl+V` | Press `Esc` |

### Mode Indicator

When in Insert mode, you'll see `-- INSERT --` at the bottom of the screen.

---

## Opening and Creating Files

### Basic File Operations

```bash
# Open an existing file
vim filename.txt

# Create a new file (or open if exists)
vim newfile.txt

# Open file and go to specific line number
vim +10 filename.txt

# Open file at the last line
vim + filename.txt

# Open multiple files
vim file1.txt file2.txt

# Open file in read-only mode
vim -R filename.txt
# Or use view command
view filename.txt
```

---

## Entering Insert Mode

From Normal mode, use these commands to enter Insert mode:

| Command | Action |
|---------|--------|
| `i` | Insert before cursor |
| `I` | Insert at beginning of line (first non-blank) |
| `a` | Append after cursor |
| `A` | Append at end of line |
| `o` | Open new line below cursor |
| `O` | Open new line above cursor |
| `s` | Substitute character (delete char and enter insert mode) |
| `S` | Substitute entire line |
| `C` | Change from cursor to end of line |
| `cw` | Change word |

### Example: Adding Text

```
1. Open file: vim myfile.txt
2. Press 'i' to enter Insert mode
3. Type your text
4. Press Esc to return to Normal mode
5. Type ':wq' to save and quit
```

---

## Navigation Commands (Normal Mode)

### Basic Movement

| Key | Movement |
|-----|----------|
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |
| Arrow keys | Also work for movement |

### Word Movement

| Command | Movement |
|---------|----------|
| `w` | Move to start of next word |
| `W` | Move to start of next WORD (space-separated) |
| `b` | Move to start of previous word |
| `B` | Move to start of previous WORD |
| `e` | Move to end of current/next word |
| `E` | Move to end of current/next WORD |

### Line Movement

| Command | Movement |
|---------|----------|
| `0` | Move to beginning of line (column 0) |
| `^` | Move to first non-blank character of line |
| `$` | Move to end of line |
| `+` | Move to first non-blank of next line |
| `-` | Move to first non-blank of previous line |

### Screen Movement

| Command | Movement |
|---------|----------|
| `H` | Move to top of screen (High) |
| `M` | Move to middle of screen (Middle) |
| `L` | Move to bottom of screen (Low) |
| `Ctrl+f` | Page forward (full screen) |
| `Ctrl+b` | Page backward (full screen) |
| `Ctrl+d` | Scroll down half screen |
| `Ctrl+u` | Scroll up half screen |
| `zz` | Center screen on cursor |

### File Movement

| Command | Movement |
|---------|----------|
| `gg` | Go to first line of file |
| `G` | Go to last line of file |
| `5G` or `:5` | Go to line 5 |
| `50%` | Go to 50% of file |
| `Ctrl+g` | Show current position in file |

---

## Editing Commands (Normal Mode)

### Deleting Text

| Command | Action |
|---------|--------|
| `x` | Delete character under cursor |
| `X` | Delete character before cursor |
| `dw` | Delete word (from cursor to start of next word) |
| `de` | Delete to end of word |
| `db` | Delete to beginning of word |
| `dd` | Delete entire line |
| `D` or `d$` | Delete from cursor to end of line |
| `d0` | Delete from cursor to beginning of line |
| `dgg` | Delete from current line to beginning of file |
| `dG` | Delete from current line to end of file |
| `5dd` | Delete 5 lines |

### Changing Text

| Command | Action |
|---------|--------|
| `r` | Replace single character |
| `R` | Enter Replace mode (overtype) |
| `cw` | Change word |
| `cc` | Change entire line |
| `C` or `c$` | Change from cursor to end of line |
| `~` | Toggle case of character |

### Copy (Yank) and Paste

| Command | Action |
|---------|--------|
| `yy` or `Y` | Yank (copy) entire line |
| `yw` | Yank word |
| `y$` | Yank to end of line |
| `5yy` | Yank 5 lines |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `xp` | Transpose two characters (delete and paste) |

### Undo and Redo

| Command | Action |
|---------|--------|
| `u` | Undo last change |
| `U` | Undo all changes on current line |
| `Ctrl+r` | Redo (undo the undo) |
| `.` | Repeat last change command |

---

## Search and Replace

### Searching

| Command | Action |
|---------|--------|
| `/pattern` | Search forward for pattern |
| `?pattern` | Search backward for pattern |
| `n` | Repeat search in same direction |
| `N` | Repeat search in opposite direction |
| `*` | Search forward for word under cursor |
| `#` | Search backward for word under cursor |
| `/\<word\>` | Search for whole word only |

### Search Options

```vim
:set ignorecase    " Case-insensitive search
:set noignorecase  " Case-sensitive search (default)
:set hlsearch      " Highlight search matches
:set nohlsearch    " Disable highlight
:nohlsearch        " Clear current highlighting
:set incsearch     " Incremental search (search as you type)
```

### Search and Replace (Substitution)

| Command | Action |
|---------|--------|
| `:s/old/new/` | Replace first occurrence on current line |
| `:s/old/new/g` | Replace all occurrences on current line |
| `:%s/old/new/g` | Replace all occurrences in entire file |
| `:%s/old/new/gc` | Replace all with confirmation |
| `:5,10s/old/new/g` | Replace in lines 5-10 |
| `:.,$s/old/new/g` | Replace from current line to end of file |

### Substitution Flags

| Flag | Meaning |
|------|---------|
| `g` | Global (all occurrences on line) |
| `c` | Confirm each replacement |
| `i` | Case insensitive |
| `I` | Case sensitive |

---

## Saving and Exiting

### Save and Quit Commands

| Command | Action |
|---------|--------|
| `:w` | Write (save) file |
| `:w filename` | Save as filename |
| `:wq` | Write and quit |
| `:wq!` | Write and quit (force) |
| `ZZ` | Write and quit (same as :wq) |
| `:q` | Quit (fails if unsaved changes) |
| `:q!` | Quit without saving (force) |
| `ZQ` | Quit without saving (same as :q!) |
| `:x` | Write and quit (only writes if changes made) |
| `:e!` | Revert to last saved version |

---

## Visual Mode

### Types of Visual Mode

| Command | Selection Type |
|---------|---------------|
| `v` | Character-wise selection |
| `V` | Line-wise selection |
| `Ctrl+v` | Block (column) selection |

### Visual Mode Operations

1. Enter visual mode (`v`, `V`, or `Ctrl+v`)
2. Move cursor to extend selection
3. Apply operator:
   - `d` - Delete selection
   - `y` - Yank (copy) selection
   - `c` - Change selection
   - `>` - Indent right
   - `<` - Indent left
   - `~` - Toggle case
   - `u` - Make lowercase
   - `U` - Make uppercase

### Visual Mode Navigation

| Command | Action |
|---------|--------|
| `o` | Move to other end of selection |
| `O` | Move to other corner (block mode) |
| `gv` | Reselect previous visual selection |

---

## Text Objects

Text objects work with operators (d, c, y) for efficient editing:

| Text Object | Description |
|------------|-------------|
| `iw` | Inner word |
| `aw` | A word (includes space) |
| `is` | Inner sentence |
| `as` | A sentence |
| `ip` | Inner paragraph |
| `ap` | A paragraph |
| `i"` | Inside double quotes |
| `a"` | Around double quotes |
| `i'` | Inside single quotes |
| `i(` or `ib` | Inside parentheses |
| `a(` or `ab` | Around parentheses |
| `i{` or `iB` | Inside braces |
| `i[` | Inside brackets |
| `it` | Inside HTML/XML tags |

### Examples

```
diw   - Delete inner word
ciw   - Change inner word
yi"   - Yank text inside quotes
da(   - Delete around parentheses
ci{   - Change inside braces
```

---

## Multiple Files and Buffers

### Working with Multiple Files

```vim
:e filename      " Edit another file
:e!              " Reload current file (discard changes)
:r filename      " Read file and insert below cursor
:r !command      " Read output of command into file
:buffers         " List all buffers
:bn              " Go to next buffer
:bp              " Go to previous buffer
:b2              " Go to buffer 2
:bd              " Delete (close) current buffer
```

### Split Windows

| Command | Action |
|---------|--------|
| `:split` or `:sp` | Horizontal split |
| `:vsplit` or `:vs` | Vertical split |
| `Ctrl+w w` | Switch between windows |
| `Ctrl+w h/j/k/l` | Move to left/down/up/right window |
| `Ctrl+w q` | Close current window |
| `Ctrl+w =` | Make all windows equal size |

---

## Useful Vim Settings

### Display Settings

```vim
:set number       " Show line numbers
:set nonumber     " Hide line numbers
:set relativenumber " Show relative line numbers
:set ruler        " Show cursor position
:set showmode     " Show current mode
:set showcmd      " Show partial commands
```

### Editing Settings

```vim
:set tabstop=4    " Tab width
:set shiftwidth=4 " Indent width
:set expandtab    " Use spaces instead of tabs
:set autoindent   " Auto-indent new lines
:set smartindent  " Smart auto-indenting
:set paste        " Disable auto-indent for pasting
:set nopaste      " Re-enable auto-indent
```

### The .vimrc File

Create `~/.vimrc` for persistent settings:

```bash
vim ~/.vimrc
```

Example `.vimrc`:

```vim
set number
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set hlsearch
set incsearch
syntax on
```

---

## Quick Reference Cheat Sheet

### Essential Commands for RHCSA

| Task | Command |
|------|---------|
| Open/create file | `vim filename` |
| Enter insert mode | `i` |
| Return to normal mode | `Esc` |
| Save file | `:w` |
| Save and quit | `:wq` or `ZZ` |
| Quit without saving | `:q!` |
| Delete line | `dd` |
| Delete word | `dw` |
| Copy line | `yy` |
| Paste | `p` |
| Undo | `u` |
| Redo | `Ctrl+r` |
| Search | `/pattern` |
| Replace all | `:%s/old/new/g` |
| Go to line N | `:N` or `NG` |
| Go to beginning | `gg` |
| Go to end | `G` |

---

## Common Exam Scenarios

### Scenario 1: Edit Configuration File
```bash
# Edit /etc/hosts file
sudo vim /etc/hosts

# Add a new line at the end:
# Press G to go to end
# Press o to open new line
# Type: 192.168.1.100    myserver.example.com
# Press Esc
# Type :wq to save and quit
```

### Scenario 2: Find and Replace
```bash
# Open file
vim config.txt

# Replace all occurrences of 'old_value' with 'new_value'
:%s/old_value/new_value/g

# Save and quit
:wq
```

### Scenario 3: Delete Multiple Lines
```bash
# Open file
vim file.txt

# Go to line 5
:5

# Delete 10 lines
10dd

# Save and quit
:wq
```

---

## Practice Questions

### Question 1
Create a new file called `/tmp/rhcsa_test.txt` using vim and add the following three lines:
```
This is line one
This is line two
This is line three
```
Save and exit the file.

<details>
<summary>Show Solution</summary>

```bash
vim /tmp/rhcsa_test.txt
# Press i to enter insert mode
# Type:
# This is line one
# This is line two
# This is line three
# Press Esc
# Type :wq and press Enter
```
</details>

---

### Question 2
Open the file `/etc/passwd` in read-only mode using vim.

<details>
<summary>Show Solution</summary>

```bash
vim -R /etc/passwd
# Or
view /etc/passwd
```
</details>

---

### Question 3
Using vim, open `/tmp/rhcsa_test.txt` and delete the second line. Save the changes.

<details>
<summary>Show Solution</summary>

```bash
vim /tmp/rhcsa_test.txt
# Press j to move to line 2 (or type :2)
# Press dd to delete the line
# Type :wq to save and quit
```
</details>

---

### Question 4
In vim, copy the first line and paste it at the end of the file.

<details>
<summary>Show Solution</summary>

```bash
vim /tmp/rhcsa_test.txt
# Press gg to go to first line
# Press yy to yank (copy) the line
# Press G to go to last line
# Press p to paste below
# Type :wq to save and quit
```
</details>

---

### Question 5
Using vim, search for the word "error" in a log file and navigate through all occurrences.

<details>
<summary>Show Solution</summary>

```bash
vim /var/log/messages
# Type /error and press Enter
# Press n to go to next occurrence
# Press N to go to previous occurrence
# Type :q! to quit without saving
```
</details>

---

### Question 6
Replace all occurrences of "http" with "https" in a configuration file.

<details>
<summary>Show Solution</summary>

```bash
vim config.conf
# Type :%s/http/https/g and press Enter
# Type :wq to save and quit
```
</details>

---

### Question 7
In vim, go to line 50 of a file and delete everything from that line to the end of the file.

<details>
<summary>Show Solution</summary>

```bash
vim largefile.txt
# Type :50 or 50G to go to line 50
# Type dG to delete from current line to end
# Type :wq to save and quit
```
</details>

---

### Question 8
Undo the last 3 changes made in vim.

<details>
<summary>Show Solution</summary>

```bash
# Press u three times
# Or type 3u
```
</details>

---

### Question 9
Using vim, insert a new line above the current cursor position without moving to the end of the previous line.

<details>
<summary>Show Solution</summary>

```bash
# Press O (uppercase) to open a new line above
# Type your text
# Press Esc to return to normal mode
```
</details>

---

### Question 10
Create a file with specific content without using an interactive editor.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Using echo
echo "Server configuration file" > /tmp/config.txt

# Method 2: Using cat with heredoc
cat > /tmp/config.txt << EOF
Server configuration file
Created on $(date)
EOF

# Method 3: Using printf
printf "Line1\nLine2\nLine3\n" > /tmp/config.txt
```
</details>

---

### Question 11
In vim, change the word under the cursor to a new word.

<details>
<summary>Show Solution</summary>

```bash
# Position cursor on the word
# Type ciw (change inner word)
# Type the new word
# Press Esc
```
</details>

---

### Question 12
Select and delete 5 lines using visual mode in vim.

<details>
<summary>Show Solution</summary>

```bash
# Press V to enter line visual mode
# Press 4j to extend selection down 4 more lines (total 5)
# Press d to delete selected lines
```
</details>

---

### Question 13
Save the current file with a different name without closing vim.

<details>
<summary>Show Solution</summary>

```bash
# Type :w newfilename.txt
# The file is saved as newfilename.txt
# You continue editing the original file
```
</details>

---

### Question 14
Join the current line with the line below it.

<details>
<summary>Show Solution</summary>

```bash
# Press J (uppercase)
# The next line is appended to current line with a space
```
</details>

---

### Question 15
Set vim to show line numbers and make this setting permanent.

<details>
<summary>Show Solution</summary>

```bash
# Temporary (current session):
:set number

# Permanent (add to ~/.vimrc):
echo "set number" >> ~/.vimrc
```
</details>

---

### Question 16
Replace "error" with "warning" only on lines 10 through 20.

<details>
<summary>Show Solution</summary>

```bash
:10,20s/error/warning/g
```
</details>

---

### Question 17
Delete all blank lines in a file using vim.

<details>
<summary>Show Solution</summary>

```bash
:g/^$/d
# Explanation:
# :g - global command
# /^$/ - pattern matching blank lines
# d - delete
```
</details>

---

### Question 18
Read the contents of another file and insert it below the current line.

<details>
<summary>Show Solution</summary>

```bash
:r /path/to/other/file.txt
```
</details>

---

### Question 19
Insert the output of a shell command into the current file.

<details>
<summary>Show Solution</summary>

```bash
# Insert date below current line
:r !date

# Insert disk usage information
:r !df -h
```
</details>

---

### Question 20
Move 3 lines down and delete them all at once.

<details>
<summary>Show Solution</summary>

```bash
# Move down 3 lines
3j
# Delete 3 lines
3dd

# Or do it in one step:
# Type 3dd from current position to delete current line plus 2 more
```
</details>

---

### Question 21
Toggle the case of all characters in the current line.

<details>
<summary>Show Solution</summary>

```bash
# Move to beginning of line
0
# Enter visual mode and select to end of line
v$
# Toggle case
~
```
</details>

---

### Question 22
Indent multiple lines to the right in vim.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Using visual mode
V       # Enter line visual mode
3j      # Select 3 more lines
>       # Indent right

# Method 2: Using count
>>      # Indent current line
3>>     # Indent current and next 2 lines
```
</details>

---

### Question 23
Search and replace only whole words (not partial matches).

<details>
<summary>Show Solution</summary>

```bash
# Replace whole word "the" with "a" (not "there", "other", etc.)
:%s/\<the\>/a/g
```
</details>

---

### Question 24
Edit a file, make changes, then discard all changes and revert to saved version.

<details>
<summary>Show Solution</summary>

```bash
# After making changes you want to discard:
:e!
# This reloads the file from disk, discarding changes
```
</details>

---

### Question 25
Create a file containing specific text using command line redirection, then verify its contents.

<details>
<summary>Show Solution</summary>

```bash
# Create file with multiple lines
cat > /tmp/server.conf << 'EOF'
# Server Configuration
hostname=webserver01
port=8080
log_level=info
EOF

# Verify contents
cat /tmp/server.conf

# Edit with vim to add more content
vim /tmp/server.conf
# Press G to go to end
# Press o to open new line
# Type: max_connections=100
# Press Esc
# Type :wq
```
</details>

---

## Summary Table: Most Important Commands

| Category | Command | Description |
|----------|---------|-------------|
| **Start Vim** | `vim file` | Open or create file |
| **Insert** | `i` | Insert mode |
| **Insert** | `o` | New line below |
| **Insert** | `O` | New line above |
| **Insert** | `A` | Append at end of line |
| **Exit Insert** | `Esc` | Return to normal mode |
| **Save** | `:w` | Write file |
| **Save & Quit** | `:wq` or `ZZ` | Write and quit |
| **Quit** | `:q!` | Quit without saving |
| **Navigation** | `gg` | Go to beginning |
| **Navigation** | `G` | Go to end |
| **Navigation** | `:N` | Go to line N |
| **Delete** | `dd` | Delete line |
| **Delete** | `dw` | Delete word |
| **Delete** | `x` | Delete character |
| **Copy** | `yy` | Yank line |
| **Paste** | `p` | Paste after |
| **Undo** | `u` | Undo |
| **Redo** | `Ctrl+r` | Redo |
| **Search** | `/pattern` | Search forward |
| **Replace** | `:%s/old/new/g` | Replace all |

---

## Exam Tips

1. **Always know how to exit vim**: `:q!` to quit without saving, `:wq` to save and quit
2. **Practice the essential commands**: `i`, `Esc`, `dd`, `yy`, `p`, `u`, `:wq`
3. **Use visual mode** for selecting and operating on text blocks
4. **Remember search and replace syntax**: `:%s/old/new/g`
5. **Know how to navigate**: `gg` (beginning), `G` (end), `:N` (line N)
6. **Practice creating files** with echo, cat, and vim
7. **Understand modes**: You must be in Insert mode to type text
8. **Use undo liberally**: `u` is your friend when you make mistakes
