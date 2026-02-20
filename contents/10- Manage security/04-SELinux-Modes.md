# Set Enforcing and Permissive Modes for SELinux

## Overview

SELinux (Security-Enhanced Linux) provides mandatory access control (MAC) that restricts processes and users beyond traditional Linux permissions. Understanding how to view and set SELinux modes is essential for the RHCSA exam.

---

## SELinux Modes

### Three Operating Modes

| Mode | Enforcement | Logging | Use Case |
|------|-------------|---------|----------|
| **Enforcing** | Yes | Yes | Production (default) |
| **Permissive** | No | Yes | Troubleshooting |
| **Disabled** | No | No | Not recommended |

### Mode Descriptions

- **Enforcing**: SELinux policy is enforced. Access violations are blocked and logged.
- **Permissive**: SELinux policy is not enforced but violations are logged. Useful for troubleshooting.
- **Disabled**: SELinux is completely turned off. Requires reboot to re-enable.

> **RHCSA Note**: The exam expects SELinux to be in enforcing mode. Never disable SELinux!

---

## Viewing SELinux Status

### Check Current Mode

```bash
# View current mode
getenforce
```

**Output:**
```
Enforcing
```

### Detailed Status

```bash
# View detailed SELinux status
sestatus
```

**Output:**
```
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
```

### Key sestatus Fields

| Field | Description |
|-------|-------------|
| SELinux status | enabled/disabled |
| Current mode | Runtime mode (enforcing/permissive) |
| Mode from config file | Boot-time setting |
| Loaded policy name | Usually "targeted" on RHEL |

---

## Changing SELinux Mode Temporarily

### Switch to Permissive Mode

```bash
# Set permissive mode (immediate, temporary)
sudo setenforce 0

# Or use word
sudo setenforce Permissive

# Verify
getenforce
```

### Switch to Enforcing Mode

```bash
# Set enforcing mode (immediate, temporary)
sudo setenforce 1

# Or use word
sudo setenforce Enforcing

# Verify
getenforce
```

### Important Notes

- `setenforce` changes mode **immediately** but **temporarily**
- Mode reverts to config file setting on reboot
- Cannot switch to/from Disabled mode with setenforce
- Requires root privileges

---

## Changing SELinux Mode Permanently

### Configuration File

Location: `/etc/selinux/config`

```bash
# View current configuration
cat /etc/selinux/config
```

**Contents:**
```
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing

# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

### Set Permanent Mode

```bash
# Edit configuration file
sudo vi /etc/selinux/config

# Change SELINUX= line to desired mode:
SELINUX=enforcing
# or
SELINUX=permissive
```

### Using sed to Change Mode

```bash
# Set to enforcing
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

# Set to permissive
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config

# Verify change
grep ^SELINUX= /etc/selinux/config
```

---

## Enabling SELinux from Disabled State

### Warning About Disabling

> **Important**: If SELinux has been disabled, re-enabling requires:
> 1. Setting `SELINUX=enforcing` or `permissive` in config
> 2. Creating `.autorelabel` file OR running `fixfiles`
> 3. Rebooting the system

### Re-enable Process

```bash
# 1. Edit config file
sudo vi /etc/selinux/config
# Set: SELINUX=enforcing

# 2. Create autorelabel file (forces relabeling on boot)
sudo touch /.autorelabel

# 3. Reboot
sudo systemctl reboot
```

> **Note**: Relabeling can take a long time on systems with many files!

---

## Kernel Boot Parameters

### Temporary Boot Mode Change

Add to kernel command line in GRUB:

| Parameter | Effect |
|-----------|--------|
| `enforcing=0` | Boot in permissive mode |
| `enforcing=1` | Boot in enforcing mode |
| `selinux=0` | Disable SELinux (not recommended) |
| `selinux=1` | Enable SELinux |

### Edit GRUB at Boot

1. Reboot system
2. Press `e` at GRUB menu
3. Find line starting with `linux` or `linux16`
4. Add parameter (e.g., `enforcing=0`)
5. Press `Ctrl+X` to boot

---

## Practice Questions

### Question 1: Check SELinux Mode
What command shows the current SELinux mode?

<details>
<summary>Show Solution</summary>

```bash
# Simple output
getenforce

# Detailed output
sestatus
```

**getenforce output:**
```
Enforcing
```

</details>

---

### Question 2: Temporarily Set Permissive Mode
Set SELinux to permissive mode without rebooting. Verify the change.

<details>
<summary>Show Solution</summary>

```bash
# Set permissive mode
sudo setenforce 0

# Verify
getenforce
# Output: Permissive

# Also verify with sestatus
sestatus | grep -E "Current mode|Mode from config"
# Current mode:                   permissive
# Mode from config file:          enforcing
```

Note: Config file still shows enforcing because we made a temporary change.

</details>

---

### Question 3: Temporarily Set Enforcing Mode
Set SELinux back to enforcing mode without rebooting.

<details>
<summary>Show Solution</summary>

```bash
# Set enforcing mode
sudo setenforce 1

# Or use the word
sudo setenforce Enforcing

# Verify
getenforce
# Output: Enforcing
```

</details>

---

### Question 4: Permanently Set Permissive Mode
Configure SELinux to start in permissive mode after reboot.

<details>
<summary>Show Solution</summary>

```bash
# Edit config file
sudo vi /etc/selinux/config

# Change line to:
SELINUX=permissive

# Or use sed
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config

# Verify
grep ^SELINUX= /etc/selinux/config
# Output: SELINUX=permissive

# Note: Takes effect after reboot
# To apply immediately as well:
sudo setenforce 0
```

</details>

---

### Question 5: Permanently Set Enforcing Mode
Configure SELinux to run in enforcing mode permanently.

<details>
<summary>Show Solution</summary>

```bash
# Edit config file
sudo vi /etc/selinux/config

# Ensure this line:
SELINUX=enforcing

# Or use sed
sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

# Verify configuration
grep ^SELINUX= /etc/selinux/config

# Apply immediately
sudo setenforce 1

# Verify both runtime and config
sestatus | grep -E "Current mode|Mode from config"
```

</details>

---

### Question 6: Troubleshooting with Permissive Mode
You suspect SELinux is blocking an application. How do you temporarily test this theory?

<details>
<summary>Show Solution</summary>

```bash
# 1. Switch to permissive mode
sudo setenforce 0

# 2. Test the application
# If it works now, SELinux was blocking it

# 3. Check SELinux logs for what was blocked
sudo ausearch -m avc -ts recent

# Or check audit log
sudo grep "denied" /var/log/audit/audit.log | tail

# 4. Return to enforcing mode
sudo setenforce 1

# 5. Fix the SELinux issue (context, boolean, or policy)
```

</details>

---

### Question 7: View SELinux Policy Type
What SELinux policy type is configured on the system?

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Use sestatus
sestatus | grep "Loaded policy"
# Output: Loaded policy name:             targeted

# Method 2: Check config file
grep ^SELINUXTYPE= /etc/selinux/config
# Output: SELINUXTYPE=targeted
```

**Common policy types:**
- `targeted` - Default, protects targeted daemons
- `minimum` - Only selected processes protected
- `mls` - Multi-Level Security (strict)

</details>

---

### Question 8: Boot into Permissive Mode (One-time)
You need to boot the system in permissive mode once without changing configuration.

<details>
<summary>Show Solution</summary>

1. Reboot the system
2. At GRUB menu, press `e` to edit
3. Find the line starting with `linux` or `linux16`
4. Add `enforcing=0` at the end of the line
5. Press `Ctrl+X` to boot

```
# Example kernel line (before):
linux ($root)/vmlinuz-4.18.0 root=/dev/mapper/rhel-root ro

# After adding parameter:
linux ($root)/vmlinuz-4.18.0 root=/dev/mapper/rhel-root ro enforcing=0
```

This change is temporary and only affects this boot.

</details>

---

### Question 9: Re-enable SELinux After Being Disabled
SELinux was disabled on a system. Re-enable it in enforcing mode.

<details>
<summary>Show Solution</summary>

```bash
# 1. Check current status
sestatus
# SELinux status: disabled

# 2. Edit configuration
sudo vi /etc/selinux/config
# Set: SELINUX=enforcing

# 3. Create autorelabel file (IMPORTANT!)
sudo touch /.autorelabel

# 4. Reboot system
sudo systemctl reboot

# After reboot, system will relabel all files
# This may take several minutes

# 5. Verify after reboot
getenforce
# Output: Enforcing
```

> **Warning**: The relabeling process can take 10-30+ minutes depending on disk size!

</details>

---

### Question 10: Verify Runtime vs Configured Mode
Check if the current SELinux mode matches the configured mode.

<details>
<summary>Show Solution</summary>

```bash
# Use sestatus to see both
sestatus | grep -E "Current mode|Mode from config"
```

**Output if they match:**
```
Current mode:                   enforcing
Mode from config file:          enforcing
```

**Output if temporary change was made:**
```
Current mode:                   permissive
Mode from config file:          enforcing
```

If they don't match, someone used `setenforce` to temporarily change the mode.

</details>

---

## Quick Reference

| Task | Command |
|------|---------|
| View current mode | `getenforce` |
| View detailed status | `sestatus` |
| Set permissive (temp) | `sudo setenforce 0` |
| Set enforcing (temp) | `sudo setenforce 1` |
| Config file location | `/etc/selinux/config` |
| Set permanent mode | Edit `SELINUX=` in config |
| Force relabel on boot | `touch /.autorelabel` |

---

## Common setenforce Options

| Command | Effect |
|---------|--------|
| `setenforce 0` | Set permissive mode |
| `setenforce 1` | Set enforcing mode |
| `setenforce Permissive` | Set permissive mode |
| `setenforce Enforcing` | Set enforcing mode |

---

## Summary

- **getenforce**: View current mode (Enforcing/Permissive/Disabled)
- **sestatus**: View detailed SELinux status
- **setenforce 0/1**: Temporarily switch modes (lost on reboot)
- **/etc/selinux/config**: Permanent mode configuration
- **Never disable SELinux** on the RHCSA exam
- Re-enabling from disabled requires relabeling (`touch /.autorelabel`)
