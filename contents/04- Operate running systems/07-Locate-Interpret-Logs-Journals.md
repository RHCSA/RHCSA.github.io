# Locate and Interpret System Log Files and Journals

## RHCSA Exam Objective
> Locate and interpret system log files and journals

---

## Introduction

System logs contain critical information about system events, errors, and security. RHEL 9 uses systemd-journald for logging, accessible via `journalctl`. The RHCSA exam tests your ability to find, read, and interpret logs.

---

## Log Locations

| Location | Description |
|----------|-------------|
| `/var/log/` | Traditional log directory |
| `/var/log/messages` | General system messages |
| `/var/log/secure` | Authentication logs |
| `/var/log/boot.log` | Boot messages |
| `/var/log/cron` | Cron job logs |
| `/var/log/dnf.log` | Package manager logs |
| `/var/log/audit/audit.log` | SELinux audit logs |

---

## Practice Questions

### Question 1: View Journal (All Logs)
**Task:** Display all journal entries.

<details>
<summary>Show Solution</summary>

```bash
journalctl
```

**Navigation:**
- Arrow keys or Page Up/Down to scroll
- `q` to quit
- `/` to search
- `G` to go to end
</details>

---

### Question 2: View Recent Logs
**Task:** Display the last 50 journal entries.

<details>
<summary>Show Solution</summary>

```bash
journalctl -n 50
```

**Or show last entries and follow:**
```bash
journalctl -f
```
</details>

---

### Question 3: Follow Logs in Real-Time
**Task:** Monitor logs in real-time (like tail -f).

<details>
<summary>Show Solution</summary>

```bash
journalctl -f
```

**Follow specific unit:**
```bash
journalctl -fu sshd
```
</details>

---

### Question 4: View Logs for Specific Service
**Task:** Display logs for the sshd service.

<details>
<summary>Show Solution</summary>

```bash
journalctl -u sshd
```

**Recent logs only:**
```bash
journalctl -u sshd -n 20
```
</details>

---

### Question 5: View Logs by Priority
**Task:** Display only error and critical messages.

<details>
<summary>Show Solution</summary>

```bash
# Show errors and above
journalctl -p err

# Show only critical
journalctl -p crit
```

**Priority levels:**
| Level | Number | Meaning |
|-------|--------|---------|
| emerg | 0 | System unusable |
| alert | 1 | Immediate action needed |
| crit | 2 | Critical conditions |
| err | 3 | Error conditions |
| warning | 4 | Warning conditions |
| notice | 5 | Normal but significant |
| info | 6 | Informational |
| debug | 7 | Debug messages |
</details>

---

### Question 6: View Logs Since Time
**Task:** Display logs from the last hour.

<details>
<summary>Show Solution</summary>

```bash
journalctl --since "1 hour ago"
```

**Other time formats:**
```bash
# Since specific time
journalctl --since "2024-01-15 10:00:00"

# Since today
journalctl --since today

# Since yesterday
journalctl --since yesterday

# Time range
journalctl --since "09:00" --until "10:00"
```
</details>

---

### Question 7: View Boot Logs
**Task:** Display logs from the current boot.

<details>
<summary>Show Solution</summary>

```bash
journalctl -b
```

**Previous boot:**
```bash
journalctl -b -1
```

**List available boots:**
```bash
journalctl --list-boots
```
</details>

---

### Question 8: View Kernel Messages
**Task:** Display only kernel messages.

<details>
<summary>Show Solution</summary>

```bash
journalctl -k
```

**Or using dmesg:**
```bash
dmesg
```

**With timestamps:**
```bash
dmesg -T
```
</details>

---

### Question 9: View Authentication Logs
**Task:** Check for failed login attempts.

<details>
<summary>Show Solution</summary>

```bash
# Using journalctl
journalctl -u sshd | grep -i failed

# Using traditional log file
cat /var/log/secure | grep -i failed

# Recent authentication failures
journalctl _COMM=sshd | grep -i fail
```
</details>

---

### Question 10: View Logs for Specific PID
**Task:** Display logs for process with PID 1234.

<details>
<summary>Show Solution</summary>

```bash
journalctl _PID=1234
```
</details>

---

### Question 11: View Logs for Specific User
**Task:** Display logs related to user UID 1000.

<details>
<summary>Show Solution</summary>

```bash
journalctl _UID=1000
```
</details>

---

### Question 12: Output in Different Formats
**Task:** Display logs in JSON format.

<details>
<summary>Show Solution</summary>

```bash
# JSON format
journalctl -o json

# JSON pretty
journalctl -o json-pretty

# Short format (default)
journalctl -o short

# Verbose format
journalctl -o verbose
```
</details>

---

### Question 13: Disk Usage by Journal
**Task:** Check how much disk space journals use.

<details>
<summary>Show Solution</summary>

```bash
journalctl --disk-usage
```
</details>

---

### Question 14: View Traditional Log Files
**Task:** Read the system messages log.

<details>
<summary>Show Solution</summary>

```bash
# View entire file
cat /var/log/messages

# Last 50 lines
tail -50 /var/log/messages

# Follow in real-time
tail -f /var/log/messages

# Search for errors
grep -i error /var/log/messages
```
</details>

---

### Question 15: View Cron Logs
**Task:** Check if a cron job ran.

<details>
<summary>Show Solution</summary>

```bash
# Traditional log
cat /var/log/cron

# Using journalctl
journalctl -u crond
```
</details>

---

### Question 16: View Boot Problems
**Task:** Check for boot-related errors.

<details>
<summary>Show Solution</summary>

```bash
# Boot log file
cat /var/log/boot.log

# Journal current boot errors
journalctl -b -p err

# Kernel messages from boot
journalctl -k -b
```
</details>

---

### Question 17: View SELinux Audit Logs
**Task:** Check SELinux denials.

<details>
<summary>Show Solution</summary>

```bash
# Audit log
cat /var/log/audit/audit.log | grep denied

# Using ausearch
ausearch -m AVC

# Recent denials
ausearch -m AVC -ts recent
```
</details>

---

### Question 18: Exam Scenario - Troubleshoot Service
**Task:** The httpd service won't start. Find the error.

<details>
<summary>Show Solution</summary>

```bash
# Check service status
systemctl status httpd

# View recent logs
journalctl -u httpd -n 50

# View errors only
journalctl -u httpd -p err

# Follow logs while attempting restart
journalctl -fu httpd &
systemctl restart httpd
```
</details>

---

### Question 19: Exam Scenario - Find Login Failures
**Task:** Identify failed SSH login attempts in the last hour.

<details>
<summary>Show Solution</summary>

```bash
journalctl -u sshd --since "1 hour ago" | grep -i "failed\|invalid"
```

**Or from secure log:**
```bash
grep -i "failed" /var/log/secure | tail -20
```
</details>

---

### Question 20: Clear Old Logs
**Task:** Remove journal logs older than 7 days.

<details>
<summary>Show Solution</summary>

```bash
sudo journalctl --vacuum-time=7d
```

**By size:**
```bash
sudo journalctl --vacuum-size=500M
```
</details>

---

## Journalctl Options Quick Reference

| Option | Description |
|--------|-------------|
| `-f` | Follow (real-time) |
| `-n NUM` | Last NUM entries |
| `-u UNIT` | Filter by unit/service |
| `-p PRIORITY` | Filter by priority |
| `-b` | Current boot only |
| `-b -1` | Previous boot |
| `--since` | Start time |
| `--until` | End time |
| `-k` | Kernel messages |
| `-o FORMAT` | Output format |
| `--disk-usage` | Show disk usage |

---

## Traditional Log Files

| File | Content |
|------|---------|
| `/var/log/messages` | General system messages |
| `/var/log/secure` | Authentication events |
| `/var/log/boot.log` | Boot messages |
| `/var/log/cron` | Cron job execution |
| `/var/log/dnf.log` | Package installations |
| `/var/log/audit/audit.log` | SELinux and audit events |

---

## Quick Reference

### Common Journalctl Commands
```bash
# All logs
journalctl

# Follow real-time
journalctl -f

# Service logs
journalctl -u servicename

# Boot logs
journalctl -b

# Errors only
journalctl -p err

# Last hour
journalctl --since "1 hour ago"

# Kernel messages
journalctl -k
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Use journalctl** to view system logs
2. **Filter by service** using `-u servicename`
3. **Filter by priority** using `-p err`
4. **Filter by time** using `--since` and `--until`
5. **View current boot** logs using `-b`
6. **Follow logs** in real-time using `-f`
7. **Know log file locations** in `/var/log/`
8. **Interpret log entries** to troubleshoot issues
