# Configure Systems to Boot into a Specific Target

## RHCSA Exam Objective
> Configure systems to boot into a specific target automatically

---

## Introduction

Systemd targets define the system state (similar to runlevels in older init systems). The RHCSA exam requires you to understand how to set the default boot target and switch between targets.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `systemctl get-default` | Show default boot target |
| `systemctl set-default` | Set default boot target |
| `systemctl isolate` | Switch to different target now |
| `systemctl list-units --type=target` | List targets |

---

## Systemd Targets Overview

### Common Targets

| Target | Description | Old Runlevel |
|--------|-------------|--------------|
| `poweroff.target` | Shut down system | 0 |
| `rescue.target` | Single-user mode (root only) | 1 |
| `multi-user.target` | Multi-user CLI (no GUI) | 3 |
| `graphical.target` | Multi-user with GUI | 5 |
| `reboot.target` | Reboot system | 6 |
| `emergency.target` | Emergency shell (minimal) | - |

---

## Part 1: Viewing and Setting Default Target

### Question 1: View Current Default Target
**Task:** Display the default boot target.

<details>
<summary>Show Solution</summary>

```bash
systemctl get-default
```

**Output:**
```
graphical.target
```
or
```
multi-user.target
```
</details>

---

### Question 2: Set Default to Multi-User (CLI)
**Task:** Configure system to boot to command line (no GUI).

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl set-default multi-user.target
```

**Verify:**
```bash
systemctl get-default
```

**Takes effect on next boot.**
</details>

---

### Question 3: Set Default to Graphical (GUI)
**Task:** Configure system to boot with graphical interface.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl set-default graphical.target
```

**Requires GUI packages to be installed.**
</details>

---

### Question 4: What set-default Does
**Task:** Understand how set-default works.

<details>
<summary>Show Solution</summary>

`systemctl set-default` creates a symlink:

```bash
ls -l /etc/systemd/system/default.target
```

**Output:**
```
/etc/systemd/system/default.target -> /usr/lib/systemd/system/multi-user.target
```

**Manual equivalent:**
```bash
sudo ln -sf /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target
```
</details>

---

## Part 2: Switching Targets at Runtime

### Question 5: Switch to Multi-User Target Now
**Task:** Change to multi-user target without rebooting.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl isolate multi-user.target
```

**Warning:** This will stop graphical services if switching from graphical.target.
</details>

---

### Question 6: Switch to Graphical Target Now
**Task:** Start graphical interface without rebooting.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl isolate graphical.target
```

**Requires GUI packages to be installed.**
</details>

---

### Question 7: Enter Rescue Mode
**Task:** Switch to rescue (single-user) mode.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl isolate rescue.target
```

**Or:**
```bash
sudo systemctl rescue
```

**Rescue mode:**
- Single-user
- Root filesystem mounted
- Network not started
- Requires root password
</details>

---

### Question 8: Enter Emergency Mode
**Task:** Switch to emergency mode.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl emergency
```

**Emergency mode:**
- Most minimal mode
- Root filesystem mounted read-only
- No services started
- Used for serious troubleshooting
</details>

---

## Part 3: Listing Targets

### Question 9: List All Targets
**Task:** Show all available targets.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-units --type=target
```

**List all (including inactive):**
```bash
systemctl list-units --type=target --all
```
</details>

---

### Question 10: List Target Unit Files
**Task:** Show all target unit files.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-unit-files --type=target
```
</details>

---

### Question 11: View Target Dependencies
**Task:** Show what graphical.target includes.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-dependencies graphical.target
```

**graphical.target depends on multi-user.target which depends on basic.target, etc.**
</details>

---

## Part 4: Boot Target at GRUB

### Question 12: Boot to Different Target Once
**Task:** Boot to rescue.target from GRUB (one-time).

<details>
<summary>Show Solution</summary>

**At GRUB menu:**
1. Press `e` to edit boot entry
2. Find line starting with `linux`
3. Add at end of line:
```
systemd.unit=rescue.target
```
4. Press `Ctrl+X` to boot

**This only affects current boot.**
</details>

---

### Question 13: Boot to Emergency Target from GRUB
**Task:** Boot to emergency mode from GRUB.

<details>
<summary>Show Solution</summary>

**At GRUB menu:**
1. Press `e` to edit boot entry
2. Find line starting with `linux`
3. Add at end of line:
```
systemd.unit=emergency.target
```
4. Press `Ctrl+X` to boot
</details>

---

## Part 5: Exam Scenarios

### Question 14: Exam Scenario - CLI Boot
**Task:** Ensure system boots to CLI (multi-user mode) with no graphical interface.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl set-default multi-user.target
```

**Verify:**
```bash
systemctl get-default
```

**Should output:**
```
multi-user.target
```
</details>

---

### Question 15: Exam Scenario - Enable GUI
**Task:** Configure system to boot with graphical interface.

<details>
<summary>Show Solution</summary>

**First, ensure GUI packages are installed:**
```bash
sudo dnf group install "Server with GUI"
```

**Set target:**
```bash
sudo systemctl set-default graphical.target
```
</details>

---

### Question 16: Check Current Target
**Task:** Verify which target system is currently running.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-units --type=target --state=active
```

**Look for:**
- `graphical.target` = GUI mode
- `multi-user.target` = CLI mode
</details>

---

### Question 17: Exam Scenario - Troubleshooting Boot
**Task:** System won't boot normally. How to boot into rescue mode?

<details>
<summary>Show Solution</summary>

**At GRUB:**
1. Press `e` to edit
2. Add to linux line: `systemd.unit=rescue.target`
3. Press `Ctrl+X`

**Once booted:**
```bash
# Fix issues
# Then reboot
systemctl reboot
```
</details>

---

## Quick Reference

### Setting Default Target
```bash
# View current default
systemctl get-default

# Set default to CLI
systemctl set-default multi-user.target

# Set default to GUI
systemctl set-default graphical.target
```

### Switching Targets at Runtime
```bash
# Switch to specific target
systemctl isolate multi-user.target
systemctl isolate graphical.target

# Enter rescue mode
systemctl rescue

# Enter emergency mode
systemctl emergency
```

### GRUB Boot Parameters
```
# Add to linux line for one-time boot:
systemd.unit=rescue.target
systemd.unit=emergency.target
systemd.unit=multi-user.target
```

### Target Comparison
| Target | Network | Multi-user | GUI | Use Case |
|--------|---------|------------|-----|----------|
| `emergency.target` | No | No | No | Critical recovery |
| `rescue.target` | No | No | No | Single-user fixes |
| `multi-user.target` | Yes | Yes | No | Server (typical) |
| `graphical.target` | Yes | Yes | Yes | Desktop/GUI |

---

## Summary

For the RHCSA exam, ensure you can:

1. **View default target** using `systemctl get-default`
2. **Set default target** using `systemctl set-default`
3. **Switch targets at runtime** using `systemctl isolate`
4. **Use rescue.target** for single-user troubleshooting
5. **Boot to specific target from GRUB** using `systemd.unit=` parameter
6. **Understand target hierarchy** (graphical depends on multi-user)
