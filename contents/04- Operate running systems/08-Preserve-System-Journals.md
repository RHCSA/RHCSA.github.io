# Preserve System Journals

## RHCSA Exam Objective
> Preserve system journals

---

## Introduction

By default, systemd journal logs are stored in `/run/log/journal/` (volatile storage) and are lost on reboot. The RHCSA exam tests your ability to configure persistent journal storage so logs survive reboots.

---

## Journal Storage Types

| Type | Location | Survives Reboot |
|------|----------|-----------------|
| Volatile | `/run/log/journal/` | No |
| Persistent | `/var/log/journal/` | Yes |

---

## Practice Questions

### Question 1: Check Journal Storage Type
**Task:** Determine if journals are stored persistently.

<details>
<summary>Show Solution</summary>

```bash
# Check if persistent directory exists
ls -la /var/log/journal/

# If directory doesn't exist, journals are volatile
# If it exists and contains subdirectories, journals are persistent
```
</details>

---

### Question 2: Configure Persistent Storage (Method 1)
**Task:** Configure journals to persist across reboots by creating the directory.

<details>
<summary>Show Solution</summary>

```bash
# Create the persistent journal directory
sudo mkdir -p /var/log/journal

# Set correct ownership
sudo systemd-tmpfiles --create --prefix /var/log/journal

# Restart journald
sudo systemctl restart systemd-journald

# Verify
ls -la /var/log/journal/
```
</details>

---

### Question 3: Configure Persistent Storage (Method 2 - Recommended)
**Task:** Configure persistent journals using journald.conf.

<details>
<summary>Show Solution</summary>

```bash
# Edit journald configuration
sudo vim /etc/systemd/journald.conf
```

**Add or modify:**
```ini
[Journal]
Storage=persistent
```

**Apply changes:**
```bash
sudo systemctl restart systemd-journald
```

**Verify:**
```bash
ls -la /var/log/journal/
```
</details>

---

### Question 4: View Available Boots
**Task:** List all stored boot sessions.

<details>
<summary>Show Solution</summary>

```bash
journalctl --list-boots
```

**Example Output (with persistent storage):**
```
-2 abc123... Wed 2024-01-10 10:00:00 EST—Wed 2024-01-10 18:00:00 EST
-1 def456... Thu 2024-01-11 09:00:00 EST—Thu 2024-01-11 22:00:00 EST
 0 ghi789... Fri 2024-01-12 08:00:00 EST—Fri 2024-01-12 15:30:00 EST
```

**Note:** With volatile storage, only boot `0` (current) is available.
</details>

---

### Question 5: View Previous Boot Logs
**Task:** Display logs from the previous boot.

<details>
<summary>Show Solution</summary>

```bash
journalctl -b -1
```

**Two boots ago:**
```bash
journalctl -b -2
```

**Note:** Requires persistent storage to access previous boots.
</details>

---

### Question 6: View Journald Configuration
**Task:** Display the current journald configuration.

<details>
<summary>Show Solution</summary>

```bash
cat /etc/systemd/journald.conf
```

**Or check effective settings:**
```bash
systemd-analyze cat-config systemd/journald.conf
```
</details>

---

### Question 7: Storage Options Explained
**Task:** Understand the Storage options in journald.conf.

<details>
<summary>Show Solution</summary>

**Storage options:**

| Option | Behavior |
|--------|----------|
| `auto` | Persistent if `/var/log/journal/` exists, else volatile (default) |
| `persistent` | Always store persistently (creates directory if needed) |
| `volatile` | Only store in memory (`/run/log/journal/`) |
| `none` | Disable storage (logs forwarded to console/syslog) |

**Recommended for persistence:**
```ini
[Journal]
Storage=persistent
```
</details>

---

### Question 8: Set Journal Size Limits
**Task:** Limit persistent journal storage to 500MB.

<details>
<summary>Show Solution</summary>

```bash
sudo vim /etc/systemd/journald.conf
```

**Add:**
```ini
[Journal]
Storage=persistent
SystemMaxUse=500M
```

**Apply:**
```bash
sudo systemctl restart systemd-journald
```
</details>

---

### Question 9: Check Journal Disk Usage
**Task:** Display how much disk space the journal uses.

<details>
<summary>Show Solution</summary>

```bash
journalctl --disk-usage
```

**Example Output:**
```
Archived and active journals take up 256.0M in the file system.
```
</details>

---

### Question 10: Rotate Journal Files
**Task:** Force immediate rotation of journal files.

<details>
<summary>Show Solution</summary>

```bash
sudo journalctl --rotate
```

**Note:** This starts a new journal file without deleting old ones.
</details>

---

### Question 11: Vacuum Old Journals
**Task:** Remove journals older than 2 weeks.

<details>
<summary>Show Solution</summary>

```bash
sudo journalctl --vacuum-time=2weeks
```

**Remove to reduce size to 500M:**
```bash
sudo journalctl --vacuum-size=500M
```

**Remove all but last 2 journal files:**
```bash
sudo journalctl --vacuum-files=2
```
</details>

---

### Question 12: Exam Scenario - Enable Persistent Journals
**Task:** Configure the system to retain logs across reboots.

<details>
<summary>Show Solution</summary>

```bash
# Edit configuration
sudo vim /etc/systemd/journald.conf

# Set Storage to persistent:
[Journal]
Storage=persistent

# Save and exit (:wq)

# Restart journald
sudo systemctl restart systemd-journald

# Verify directory was created
ls /var/log/journal/

# Verify persistence
journalctl --list-boots
```
</details>

---

### Question 13: Exam Scenario - Limit Storage and Enable Persistence
**Task:** Configure persistent journals with 200MB limit.

<details>
<summary>Show Solution</summary>

```bash
sudo vim /etc/systemd/journald.conf
```

**Configure:**
```ini
[Journal]
Storage=persistent
SystemMaxUse=200M
```

**Apply:**
```bash
sudo systemctl restart systemd-journald

# Verify
journalctl --disk-usage
```
</details>

---

### Question 14: Verify Persistence After Reboot
**Task:** Confirm journals persist after reboot.

<details>
<summary>Show Solution</summary>

```bash
# Before reboot, note the number of boots
journalctl --list-boots

# Reboot
sudo systemctl reboot

# After reboot, check boots again
journalctl --list-boots

# Previous boot should now appear as -1
journalctl -b -1
```
</details>

---

## Journald Configuration Reference

### Key Settings in `/etc/systemd/journald.conf`

| Setting | Description | Default |
|---------|-------------|---------|
| `Storage` | auto, persistent, volatile, none | auto |
| `SystemMaxUse` | Max disk space for journals | 10% of filesystem |
| `SystemKeepFree` | Min free space to maintain | 15% of filesystem |
| `SystemMaxFileSize` | Max size per journal file | 1/8 of SystemMaxUse |
| `MaxRetentionSec` | Max time to keep journals | 0 (no limit) |

---

## Quick Reference

### Enable Persistent Journals
```bash
# Edit config
sudo vim /etc/systemd/journald.conf

# Add:
[Journal]
Storage=persistent

# Restart
sudo systemctl restart systemd-journald
```

### Verify Configuration
```bash
# Check storage location
ls /var/log/journal/

# List boots
journalctl --list-boots

# Check disk usage
journalctl --disk-usage
```

### Manage Journal Size
```bash
# Clean by time
journalctl --vacuum-time=2weeks

# Clean by size
journalctl --vacuum-size=500M

# Rotate logs
journalctl --rotate
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Edit `/etc/systemd/journald.conf`** to set `Storage=persistent`
2. **Restart systemd-journald** after configuration changes
3. **Verify persistence** using `journalctl --list-boots`
4. **Access previous boot logs** using `journalctl -b -1`
5. **Set size limits** with `SystemMaxUse`
6. **Clean old journals** using `--vacuum-time` or `--vacuum-size`
