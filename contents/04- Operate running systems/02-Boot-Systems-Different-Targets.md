# Boot Systems into Different Targets Manually

## RHCSA Exam Objective
> Boot systems into different targets manually

---

## Introduction

Systemd targets are groups of units that define system states (similar to runlevels in older systems). The RHCSA exam tests your ability to change targets at runtime and configure the default target. Understanding targets is essential for troubleshooting and system administration.

---

## Common Targets

| Target | Description | Old Runlevel |
|--------|-------------|--------------|
| `poweroff.target` | Shut down system | 0 |
| `rescue.target` | Single-user mode, basic system | 1 |
| `multi-user.target` | Multi-user, no GUI | 3 |
| `graphical.target` | Multi-user with GUI | 5 |
| `reboot.target` | Reboot system | 6 |
| `emergency.target` | Emergency shell (minimal) | - |

---

## Practice Questions

### Question 1: View Current Target
**Task:** Display the current default target.

<details>
<summary>Show Solution</summary>

```bash
systemctl get-default
```

**Example Output:**
```
multi-user.target
```
</details>

---

### Question 2: List All Available Targets
**Task:** List all available targets on the system.

<details>
<summary>Show Solution</summary>

```bash
# List all targets
systemctl list-units --type=target

# List all targets including inactive
systemctl list-units --type=target --all
```
</details>

---

### Question 3: Set Default Target to Multi-User
**Task:** Configure the system to boot into multi-user (non-graphical) mode by default.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl set-default multi-user.target
```

**Verify:**
```bash
systemctl get-default
```
</details>

---

### Question 4: Set Default Target to Graphical
**Task:** Configure the system to boot into graphical mode by default.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl set-default graphical.target
```
</details>

---

### Question 5: Switch to Multi-User Target (Runtime)
**Task:** Switch the running system to multi-user target without rebooting.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl isolate multi-user.target
```

**Note:** `isolate` stops all units not required by the target.
</details>

---

### Question 6: Switch to Graphical Target (Runtime)
**Task:** Switch the running system to graphical target.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl isolate graphical.target
```
</details>

---

### Question 7: Switch to Rescue Target
**Task:** Boot into rescue mode (single-user mode).

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl isolate rescue.target
```

**Note:** Rescue mode requires root password and provides a minimal environment for troubleshooting.
</details>

---

### Question 8: Switch to Emergency Target
**Task:** Boot into emergency mode.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl isolate emergency.target
```

**Differences from rescue:**
- Emergency mounts root filesystem read-only
- Only essential services start
- Requires root password
- Use for severe troubleshooting when rescue fails
</details>

---

### Question 9: View Target Dependencies
**Task:** Display what services are required by multi-user.target.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-dependencies multi-user.target
```

**Show reverse dependencies:**
```bash
systemctl list-dependencies multi-user.target --reverse
```
</details>

---

### Question 10: Boot into Specific Target at GRUB
**Task:** At boot time, modify GRUB to boot into rescue target.

<details>
<summary>Show Solution</summary>

1. At GRUB menu, press `e` to edit the boot entry
2. Find the line starting with `linux` (or `linuxefi`)
3. Add at the end of that line: `systemd.unit=rescue.target`
4. Press `Ctrl+X` to boot

**For emergency target:**
```
systemd.unit=emergency.target
```

**Note:** This is a one-time boot change and doesn't modify the default.
</details>

---

### Question 11: Verify Running Target
**Task:** Check which targets are currently active.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-units --type=target --state=active
```
</details>

---

### Question 12: Exam Scenario - Disable GUI Boot
**Task:** A server is booting into graphical mode but should boot to multi-user mode. Fix this permanently.

<details>
<summary>Show Solution</summary>

```bash
# Check current default
systemctl get-default

# Set to multi-user
sudo systemctl set-default multi-user.target

# Verify
systemctl get-default

# Optionally switch immediately without reboot
sudo systemctl isolate multi-user.target
```
</details>

---

### Question 13: Check Target Configuration File
**Task:** View the symbolic link that defines the default target.

<details>
<summary>Show Solution</summary>

```bash
ls -l /etc/systemd/system/default.target
```

**Output:**
```
lrwxrwxrwx. 1 root root 37 Jan 1 00:00 /etc/systemd/system/default.target -> /lib/systemd/system/multi-user.target
```
</details>

---

### Question 14: Create Target Alias
**Task:** Understand how the default target is implemented.

<details>
<summary>Show Solution</summary>

The default target is a symbolic link:

```bash
# View the link
ls -l /etc/systemd/system/default.target

# Manually set default (alternative method)
sudo ln -sf /lib/systemd/system/graphical.target /etc/systemd/system/default.target
```

**Note:** Use `systemctl set-default` instead of manually creating links.
</details>

---

## Target Comparison

| Rescue vs Emergency |
|---------------------|
| **Rescue**: Mounts all filesystems, starts some services, requires root password |
| **Emergency**: Mounts root read-only, minimal services, for severe issues |

---

## Quick Reference

### View Targets
```bash
# Current default
systemctl get-default

# List active targets
systemctl list-units --type=target

# List all targets
systemctl list-units --type=target --all
```

### Change Default Target
```bash
# Set default to multi-user
systemctl set-default multi-user.target

# Set default to graphical
systemctl set-default graphical.target
```

### Change Runtime Target
```bash
# Switch to target now
systemctl isolate <target>
```

### GRUB Boot Parameters
```bash
# Add to kernel line for one-time boot
systemd.unit=rescue.target
systemd.unit=emergency.target
systemd.unit=multi-user.target
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **View the default target** using `systemctl get-default`
2. **Set the default target** using `systemctl set-default`
3. **Switch targets at runtime** using `systemctl isolate`
4. **Boot into rescue/emergency** modes via GRUB or systemctl
5. **Understand target differences** (rescue vs emergency)
6. **List target dependencies** using `systemctl list-dependencies`
