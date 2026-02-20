# Boot, Reboot, and Shut Down a System Normally

## RHCSA Exam Objective
> Boot, reboot, and shut down a system normally

---

## Introduction

Managing system power states is a fundamental system administration task. The RHCSA exam tests your ability to properly boot, reboot, and shut down RHEL systems using the correct commands. Understanding the difference between immediate and graceful operations is essential.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `systemctl reboot` | Reboot the system |
| `systemctl poweroff` | Power off the system |
| `systemctl halt` | Halt the system |
| `shutdown` | Schedule or perform shutdown/reboot |

---

## Practice Questions

### Question 1: Reboot the System
**Task:** Reboot the system immediately.

<details>
<summary>Show Solution</summary>

```bash
# Using systemctl (preferred)
sudo systemctl reboot

# Alternative using shutdown
sudo shutdown -r now

# Legacy command
sudo reboot
```
</details>

---

### Question 2: Power Off the System
**Task:** Shut down and power off the system immediately.

<details>
<summary>Show Solution</summary>

```bash
# Using systemctl (preferred)
sudo systemctl poweroff

# Alternative using shutdown
sudo shutdown -h now

# Alternative using poweroff
sudo poweroff
```
</details>

---

### Question 3: Schedule a Shutdown
**Task:** Schedule a system shutdown in 10 minutes.

<details>
<summary>Show Solution</summary>

```bash
sudo shutdown -h +10
```

**With a message to users:**
```bash
sudo shutdown -h +10 "System will shut down for maintenance"
```
</details>

---

### Question 4: Schedule a Reboot
**Task:** Schedule a system reboot at 23:00.

<details>
<summary>Show Solution</summary>

```bash
sudo shutdown -r 23:00
```

**With a warning message:**
```bash
sudo shutdown -r 23:00 "System will reboot for updates"
```
</details>

---

### Question 5: Cancel a Scheduled Shutdown
**Task:** Cancel a previously scheduled shutdown or reboot.

<details>
<summary>Show Solution</summary>

```bash
sudo shutdown -c
```

**With a message:**
```bash
sudo shutdown -c "Shutdown cancelled by admin"
```
</details>

---

### Question 6: Halt the System
**Task:** Halt the system without powering off.

<details>
<summary>Show Solution</summary>

```bash
# Using systemctl
sudo systemctl halt

# Using halt command
sudo halt
```

**Note:** Halt stops the CPU but may not power off the machine. Use `poweroff` to ensure power is cut.
</details>

---

### Question 7: Immediate Shutdown Without Waiting
**Task:** Force an immediate shutdown without waiting for processes.

<details>
<summary>Show Solution</summary>

```bash
# Immediate poweroff
sudo systemctl poweroff --force

# Double force (skip service shutdown)
sudo systemctl poweroff --force --force
```

**Warning:** Force options may cause data loss. Use only when necessary.
</details>

---

### Question 8: Send Wall Message Before Shutdown
**Task:** Send a warning message to all logged-in users before shutting down.

<details>
<summary>Show Solution</summary>

```bash
# Wall message is included with shutdown
sudo shutdown -h +5 "System going down in 5 minutes"

# Send wall message separately
wall "Please save your work. System maintenance in 5 minutes."
```
</details>

---

### Question 9: Check Last Boot Time
**Task:** Display when the system was last booted.

<details>
<summary>Show Solution</summary>

```bash
# Using who
who -b

# Using uptime
uptime

# Using systemd-analyze
systemd-analyze
```
</details>

---

### Question 10: Check System Uptime
**Task:** Display how long the system has been running.

<details>
<summary>Show Solution</summary>

```bash
# Simple uptime
uptime

# Pretty format
uptime -p

# Since when
uptime -s
```

**Example Output:**
```
up 5 days, 3 hours, 22 minutes
```
</details>

---

### Question 11: Exam Scenario - Maintenance Window
**Task:** You need to schedule a reboot for 02:00 AM with a warning message to users. Users should be notified immediately.

<details>
<summary>Show Solution</summary>

```bash
# Schedule reboot at 02:00 with message
sudo shutdown -r 02:00 "Scheduled reboot for security updates at 02:00"
```

**Verify the scheduled shutdown:**
```bash
# Check shutdown status (the message is sent to all users immediately)
cat /run/systemd/shutdown/scheduled
```

**Cancel if needed:**
```bash
sudo shutdown -c "Reboot cancelled"
```
</details>

---

### Question 12: Shutdown Immediately in 1 Minute
**Task:** Shut down the system in 1 minute.

<details>
<summary>Show Solution</summary>

```bash
sudo shutdown -h +1
```

**Note:** `shutdown` without a time argument defaults to +1 minute.
</details>

---

## Shutdown Command Options

| Option | Description |
|--------|-------------|
| `-h` | Halt or power off after shutdown |
| `-r` | Reboot after shutdown |
| `-c` | Cancel a scheduled shutdown |
| `now` | Execute immediately |
| `+N` | Execute in N minutes |
| `HH:MM` | Execute at specific time |

---

## Systemctl Power Commands

| Command | Description |
|---------|-------------|
| `systemctl reboot` | Reboot system |
| `systemctl poweroff` | Power off system |
| `systemctl halt` | Halt system |
| `systemctl suspend` | Suspend to RAM |
| `systemctl hibernate` | Suspend to disk |

---

## Quick Reference

```bash
# Immediate reboot
systemctl reboot

# Immediate poweroff
systemctl poweroff

# Scheduled shutdown in 10 minutes
shutdown -h +10

# Scheduled reboot at specific time
shutdown -r 23:00

# Cancel scheduled shutdown
shutdown -c

# Check uptime
uptime
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Reboot systems** using `systemctl reboot` or `shutdown -r`
2. **Power off systems** using `systemctl poweroff` or `shutdown -h`
3. **Schedule shutdowns/reboots** using `shutdown` with time arguments
4. **Cancel scheduled operations** using `shutdown -c`
5. **Send warning messages** to users before shutdown
6. **Check system uptime** using `uptime`
