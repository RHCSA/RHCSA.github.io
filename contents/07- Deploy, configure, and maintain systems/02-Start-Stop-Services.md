# Start and Stop Services and Configure Automatic Startup

## RHCSA Exam Objective
> Start and stop services and configure services to start automatically at boot

---

## Introduction

Managing services with `systemctl` is a core RHCSA skill. You must be able to start, stop, enable, disable services and check their status. Services in RHEL 9 are managed by systemd.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `systemctl start` | Start a service |
| `systemctl stop` | Stop a service |
| `systemctl restart` | Restart a service |
| `systemctl reload` | Reload configuration |
| `systemctl enable` | Enable at boot |
| `systemctl disable` | Disable at boot |
| `systemctl status` | View service status |
| `systemctl is-active` | Check if running |
| `systemctl is-enabled` | Check if enabled at boot |

---

## Part 1: Starting and Stopping Services

### Question 1: Start a Service
**Task:** Start the httpd service.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl start httpd
```

**Verify:**
```bash
systemctl status httpd
```
</details>

---

### Question 2: Stop a Service
**Task:** Stop the httpd service.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl stop httpd
```
</details>

---

### Question 3: Restart a Service
**Task:** Restart the sshd service.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl restart sshd
```

**Use restart when:**
- Service needs full restart
- Configuration changes require restart
</details>

---

### Question 4: Reload Service Configuration
**Task:** Reload httpd configuration without stopping.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl reload httpd
```

**Use reload when:**
- Service supports reload
- Want to apply configuration without interruption

**Note:** Not all services support reload.
</details>

---

### Question 5: Reload or Restart
**Task:** Reload if supported, otherwise restart.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl reload-or-restart httpd
```

**This is safer - tries reload first, falls back to restart.**
</details>

---

## Part 2: Checking Service Status

### Question 6: View Service Status
**Task:** Check detailed status of chronyd service.

<details>
<summary>Show Solution</summary>

```bash
systemctl status chronyd
```

**Output shows:**
- Loaded: enabled/disabled
- Active: running/stopped
- Recent log entries
- PID information
</details>

---

### Question 7: Check if Service is Running
**Task:** Check if sshd is currently active.

<details>
<summary>Show Solution</summary>

```bash
systemctl is-active sshd
```

**Returns:**
- `active` if running
- `inactive` if stopped

**Use in scripts:**
```bash
if systemctl is-active sshd > /dev/null; then
    echo "SSH is running"
fi
```
</details>

---

### Question 8: Check if Service is Enabled
**Task:** Check if chronyd is enabled at boot.

<details>
<summary>Show Solution</summary>

```bash
systemctl is-enabled chronyd
```

**Returns:**
- `enabled` - starts at boot
- `disabled` - does not start at boot
- `static` - cannot be enabled directly
</details>

---

### Question 9: Check if Service Failed
**Task:** Check if a service has failed.

<details>
<summary>Show Solution</summary>

```bash
systemctl is-failed httpd
```

**List all failed services:**
```bash
systemctl --failed
```
</details>

---

## Part 3: Enabling and Disabling Services

### Question 10: Enable Service at Boot
**Task:** Configure httpd to start automatically at boot.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl enable httpd
```

**This creates a symlink from:**
`/etc/systemd/system/multi-user.target.wants/httpd.service`
**to:**
`/usr/lib/systemd/system/httpd.service`
</details>

---

### Question 11: Enable and Start in One Command
**Task:** Enable httpd at boot AND start it now.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl enable --now httpd
```

**This is equivalent to:**
```bash
sudo systemctl enable httpd
sudo systemctl start httpd
```
</details>

---

### Question 12: Disable Service at Boot
**Task:** Prevent firewalld from starting at boot.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl disable firewalld
```

**Note:** This does not stop the currently running service.
</details>

---

### Question 13: Disable and Stop in One Command
**Task:** Disable and stop a service.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl disable --now firewalld
```
</details>

---

### Question 14: Prevent Service from Starting
**Task:** Completely prevent a service from being started.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl mask httpd
```

**This creates a symlink to /dev/null.**

**Unmask:**
```bash
sudo systemctl unmask httpd
```

**Use mask when:**
- You want to prevent service from starting even manually
- Another service might try to start it as dependency
</details>

---

## Part 4: Listing Services

### Question 15: List All Service Units
**Task:** List all service units.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-units --type=service
```

**List all (including inactive):**
```bash
systemctl list-units --type=service --all
```
</details>

---

### Question 16: List Enabled Services
**Task:** Show all enabled services.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-unit-files --type=service --state=enabled
```
</details>

---

### Question 17: List Running Services
**Task:** Show only running services.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-units --type=service --state=running
```
</details>

---

## Part 5: Service Dependencies

### Question 18: View Service Dependencies
**Task:** Show what services httpd depends on.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-dependencies httpd
```

**Reverse dependencies (what depends on httpd):**
```bash
systemctl list-dependencies httpd --reverse
```
</details>

---

## Part 6: Exam Scenarios

### Question 19: Exam Scenario - Web Server Setup
**Task:** Configure httpd to:
1. Start now
2. Start automatically at boot

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl enable --now httpd
```

**Verify:**
```bash
systemctl is-active httpd
systemctl is-enabled httpd
```
</details>

---

### Question 20: Exam Scenario - Disable Service
**Task:** Ensure cups (printing service) does not run and is not started at boot.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl disable --now cups
```

**Verify:**
```bash
systemctl status cups
```
</details>

---

### Question 21: Exam Scenario - Multiple Services
**Task:** Enable sshd and chronyd at boot.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl enable sshd chronyd
```

**Or enable and start:**
```bash
sudo systemctl enable --now sshd chronyd
```
</details>

---

### Question 22: View Service Unit File
**Task:** View the configuration file for sshd service.

<details>
<summary>Show Solution</summary>

```bash
systemctl cat sshd
```

**Or find and view:**
```bash
systemctl show sshd -p FragmentPath
cat /usr/lib/systemd/system/sshd.service
```
</details>

---

### Question 23: Edit Service Configuration
**Task:** Create an override for a service.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl edit httpd
```

**This creates override at:**
`/etc/systemd/system/httpd.service.d/override.conf`

**After editing, reload:**
```bash
sudo systemctl daemon-reload
```
</details>

---

## Quick Reference

### Service Management
```bash
# Start/Stop
systemctl start SERVICE
systemctl stop SERVICE
systemctl restart SERVICE
systemctl reload SERVICE

# Enable/Disable at boot
systemctl enable SERVICE
systemctl disable SERVICE
systemctl enable --now SERVICE    # Enable + start
systemctl disable --now SERVICE   # Disable + stop

# Mask (prevent starting entirely)
systemctl mask SERVICE
systemctl unmask SERVICE

# Status
systemctl status SERVICE
systemctl is-active SERVICE
systemctl is-enabled SERVICE
```

### Listing Services
```bash
systemctl list-units --type=service
systemctl list-units --type=service --state=running
systemctl list-unit-files --type=service
systemctl --failed
```

### Service States Summary
| State | Meaning |
|-------|---------|
| `active (running)` | Service is running |
| `inactive (dead)` | Service is stopped |
| `enabled` | Starts at boot |
| `disabled` | Does not start at boot |
| `static` | Cannot be enabled (dependency only) |
| `masked` | Completely blocked from starting |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Start and stop services** using `systemctl start/stop`
2. **Enable services at boot** using `systemctl enable`
3. **Use --now flag** to enable/start or disable/stop together
4. **Check service status** using `systemctl status`, `is-active`, `is-enabled`
5. **List services** by type and state
6. **Mask services** to prevent them from starting
7. **View service dependencies** using `list-dependencies`
