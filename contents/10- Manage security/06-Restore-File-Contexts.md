# Restore Default File Contexts

## Overview

When files are moved, copied, or have incorrect SELinux contexts, you must restore them to their default values. The RHCSA exam requires knowing how to use `restorecon` and `semanage fcontext` to fix file contexts.

---

## Why Contexts Become Wrong

### Common Scenarios

| Scenario | Result |
|----------|--------|
| Files moved (mv) from another location | Keeps original context |
| Files copied with `cp` (no special flags) | Inherits parent directory context |
| Files created in custom directories | May get `default_t` or wrong type |
| After manual chcon changes | Non-persistent changes |
| SELinux was disabled then enabled | Files may be `unlabeled_t` |

### Example Problem

```bash
# File copied from /tmp to web directory
cp /tmp/webpage.html /var/www/html/

# Check context
ls -Z /var/www/html/webpage.html
# Shows: unconfined_u:object_r:tmp_t:s0
# Wrong! Should be httpd_sys_content_t
```

---

## Restoring Contexts with restorecon

### Basic Usage

```bash
# Restore context for a single file
restorecon /var/www/html/webpage.html

# Restore context verbosely
restorecon -v /var/www/html/webpage.html

# Restore recursively
restorecon -R /var/www/html/

# Restore recursively with verbose output
restorecon -Rv /var/www/html/
```

### Common Options

| Option | Description |
|--------|-------------|
| `-v` | Verbose, show changes |
| `-R` | Recursive, process directories |
| `-n` | Dry run, show what would change |
| `-F` | Force reset of context |

### Example

```bash
$ restorecon -Rv /var/www/html/
Relabeled /var/www/html/webpage.html from unconfined_u:object_r:tmp_t:s0 to unconfined_u:object_r:httpd_sys_content_t:s0
```

---

## Understanding semanage fcontext

### How It Works

SELinux maintains a policy database that maps paths to context types:

```
Path Pattern → Context Type
/var/www/html(/.*)? → httpd_sys_content_t
/etc(/.*)? → etc_t
/var/log(/.*)? → var_log_t
```

### View Current Rules

```bash
# List all file context rules
sudo semanage fcontext -l

# Search for specific path
sudo semanage fcontext -l | grep "/var/www"
```

---

## Adding Custom Context Rules

### Syntax

```bash
sudo semanage fcontext -a -t <type> "<path_pattern>"
```

### Examples

```bash
# Add rule for custom web directory
sudo semanage fcontext -a -t httpd_sys_content_t "/mywebsite(/.*)?"

# Add rule for web data that needs write access
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/mywebsite/data(/.*)?"

# Add rule for specific file
sudo semanage fcontext -a -t httpd_sys_content_t "/opt/app/public/index.html"
```

### Apply the Rule

After adding a rule, use `restorecon` to apply it:

```bash
# Apply the new context
sudo restorecon -Rv /mywebsite/
```

---

## Modifying Existing Rules

### Change a Rule

```bash
# Modify existing rule
sudo semanage fcontext -m -t httpd_sys_rw_content_t "/mywebsite(/.*)?"
```

### Delete a Rule

```bash
# Delete custom rule
sudo semanage fcontext -d "/mywebsite(/.*)?"
```

---

## Path Pattern Syntax

### Regular Expression Patterns

| Pattern | Meaning |
|---------|---------|
| `/path` | Exact path only |
| `/path(/.*)?` | Path and all contents |
| `/path/file\.txt` | Literal file (escape .) |
| `/path/[^/]+\.log` | Any .log file in path |

### Examples

```bash
# Directory and all contents
"/var/www/html(/.*)?"

# Only the directory itself
"/var/www/html"

# All .log files in a directory
"/var/log/myapp(/.*)?\.log"
```

---

## Complete Workflow

### Adding New Web Content Directory

```bash
# 1. Create directory
sudo mkdir -p /webapp/public

# 2. Add files
sudo cp index.html /webapp/public/

# 3. Check current (wrong) context
ls -ldZ /webapp/public/
# drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 /webapp/public/

# 4. Add SELinux rule
sudo semanage fcontext -a -t httpd_sys_content_t "/webapp(/.*)?"

# 5. Apply context
sudo restorecon -Rv /webapp/

# 6. Verify
ls -ldZ /webapp/public/
# drwxr-xr-x. root root unconfined_u:object_r:httpd_sys_content_t:s0 /webapp/public/
```

---

## Checking Expected vs Actual Context

### Using matchpathcon

```bash
# See what context a path should have
matchpathcon /var/www/html/index.html
```

**Output:**
```
/var/www/html/index.html    system_u:object_r:httpd_sys_content_t:s0
```

### Comparing Contexts

```bash
# Check actual
ls -Z /var/www/html/file.html

# Check expected  
matchpathcon /var/www/html/file.html

# If different, restore
restorecon -v /var/www/html/file.html
```

---

## Practice Questions

### Question 1: Restore Single File Context
A file `/var/www/html/test.html` has the wrong SELinux context. Restore it to the default.

<details>
<summary>Show Solution</summary>

```bash
# Check current context
ls -Z /var/www/html/test.html

# Restore default context
restorecon -v /var/www/html/test.html

# Verify
ls -Z /var/www/html/test.html
```

</details>

---

### Question 2: Restore Directory Recursively
Restore SELinux contexts for all files in `/var/www/html/` including subdirectories.

<details>
<summary>Show Solution</summary>

```bash
# Restore recursively with verbose output
restorecon -Rv /var/www/html/

# Verify a sample file
ls -Z /var/www/html/
```

</details>

---

### Question 3: Preview Changes (Dry Run)
Show what context changes would be made in `/var/www/` without actually changing anything.

<details>
<summary>Show Solution</summary>

```bash
# Dry run with verbose output
restorecon -Rvn /var/www/

# -n = no changes, just show what would happen
```

</details>

---

### Question 4: Add Custom Directory Rule
You created a web application directory `/webapp` that needs to serve content via Apache. Configure SELinux to allow this.

<details>
<summary>Show Solution</summary>

```bash
# 1. Add SELinux file context rule
sudo semanage fcontext -a -t httpd_sys_content_t "/webapp(/.*)?"

# 2. Apply the context
sudo restorecon -Rv /webapp/

# 3. Verify
ls -ldZ /webapp/
```

</details>

---

### Question 5: Writable Web Directory
Configure `/var/www/html/uploads` so Apache can write to it.

<details>
<summary>Show Solution</summary>

```bash
# 1. Add rule for read-write content
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/uploads(/.*)?"

# 2. Apply context
sudo restorecon -Rv /var/www/html/uploads/

# 3. Verify
ls -ldZ /var/www/html/uploads/
# Should show: httpd_sys_rw_content_t

# 4. Also set filesystem permissions
sudo chown apache:apache /var/www/html/uploads
sudo chmod 755 /var/www/html/uploads
```

</details>

---

### Question 6: View File Context Rules
List all SELinux file context rules for paths starting with `/var/www`.

<details>
<summary>Show Solution</summary>

```bash
sudo semanage fcontext -l | grep "^/var/www"
```

**Output:**
```
/var/www(/.*)?                     all files    system_u:object_r:httpd_sys_content_t:s0
/var/www/cgi-bin(/.*)?             all files    system_u:object_r:httpd_sys_script_exec_t:s0
/var/www/html(/.*)?                all files    system_u:object_r:httpd_sys_content_t:s0
/var/www/html/uploads(/.*)?        all files    system_u:object_r:httpd_sys_rw_content_t:s0
```

</details>

---

### Question 7: Delete Custom Rule
Remove the custom SELinux file context rule for `/webapp`.

<details>
<summary>Show Solution</summary>

```bash
# Delete the rule
sudo semanage fcontext -d "/webapp(/.*)?"

# Verify removal
sudo semanage fcontext -l | grep webapp
# Should show nothing (or only system defaults if any)
```

</details>

---

### Question 8: Fix Moved Files
Files were moved from `/home/user/website/` to `/var/www/html/`. They're not working with Apache. Fix this.

<details>
<summary>Show Solution</summary>

```bash
# 1. Check current (wrong) context
ls -lZ /var/www/html/
# Files likely have user_home_t

# 2. Check expected context
matchpathcon /var/www/html/index.html

# 3. Restore contexts
sudo restorecon -Rv /var/www/html/

# 4. Verify
ls -lZ /var/www/html/
# Should now show httpd_sys_content_t
```

</details>

---

### Question 9: Relabel Entire System
After enabling SELinux on a system where it was disabled, how do you relabel all files?

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Create autorelabel file and reboot
sudo touch /.autorelabel
sudo systemctl reboot

# Method 2: Relabel without reboot (takes long time)
sudo fixfiles -F onboot
sudo systemctl reboot

# Method 3: Manual full relabel (not recommended while running)
sudo fixfiles relabel
```

> **Note**: Full system relabeling can take 10-30+ minutes!

</details>

---

### Question 10: Custom Application Context
Configure a custom directory `/opt/myapp/data` with `httpd_sys_rw_content_t` type, then verify and apply.

<details>
<summary>Show Solution</summary>

```bash
# 1. Create directory if needed
sudo mkdir -p /opt/myapp/data

# 2. Check current context
ls -ldZ /opt/myapp/data

# 3. Add SELinux rule
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/opt/myapp/data(/.*)?"

# 4. Verify rule was added
sudo semanage fcontext -l | grep "/opt/myapp"

# 5. Apply context
sudo restorecon -Rv /opt/myapp/

# 6. Verify final context
ls -ldZ /opt/myapp/data
# Should show: httpd_sys_rw_content_t
```

</details>

---

### Question 11: Complete SELinux Troubleshooting Workflow
**Task:** HTTPD service cannot access `/var/www/html/index.html`. Diagnose and fix the SELinux issue.

<details>
<summary>Show Solution</summary>

```bash
# 1. Check for AVC denials in audit log
sudo ausearch -m avc -ts today | grep httpd

# 2. Check the file's current context
ls -Z /var/www/html/index.html
# Example bad output: unconfined_u:object_r:default_t:s0

# 3. Check expected context
matchpathcon /var/www/html/index.html
# Expected: system_u:object_r:httpd_sys_content_t:s0

# 4. If contexts don't match, restore
sudo restorecon -v /var/www/html/index.html

# 5. Verify the fix
ls -Z /var/www/html/index.html
# Should now show: httpd_sys_content_t

# 6. Test HTTPD access
curl http://localhost/index.html
```

**Full workflow summary:**
1. `ausearch -m avc` → Find what SELinux blocked
2. `ls -Z` → Check current context
3. `matchpathcon` → Check expected context
4. `restorecon` → Fix the context
5. Verify service works

</details>

---

## Quick Reference

| Task | Command |
|------|---------|
| Restore file context | `restorecon file` |
| Restore verbose | `restorecon -v file` |
| Restore recursive | `restorecon -R /path/` |
| Dry run | `restorecon -Rvn /path/` |
| List context rules | `semanage fcontext -l` |
| Add context rule | `semanage fcontext -a -t type "path(/.*)?"` |
| Modify rule | `semanage fcontext -m -t type "path(/.*)?"` |
| Delete rule | `semanage fcontext -d "path(/.*)?"` |
| Check expected context | `matchpathcon /path/file` |

---

## Common Types for semanage

| Type | Purpose |
|------|---------|
| `httpd_sys_content_t` | Web content (read-only) |
| `httpd_sys_rw_content_t` | Web content (read-write) |
| `httpd_sys_script_exec_t` | CGI scripts |
| `samba_share_t` | Samba shares |
| `nfs_t` | NFS exports |
| `public_content_t` | Multiple services read |
| `public_content_rw_t` | Multiple services read/write |

---

## Summary

- **restorecon**: Restores files to their default SELinux context
  - Use `-R` for recursive
  - Use `-v` for verbose output
  - Use `-n` for dry run
- **semanage fcontext**: Manages file context rules
  - `-a` to add rules
  - `-m` to modify rules
  - `-d` to delete rules
  - `-l` to list rules
- Always run `restorecon` after adding rules
- Use `matchpathcon` to check expected context
- Files moved/copied often have wrong context - use restorecon to fix
