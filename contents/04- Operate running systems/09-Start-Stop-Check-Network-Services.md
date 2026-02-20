# Start, Stop, and Check the Status of Network Services

## RHCSA Exam Objective
> Start, stop, and check the status of network services

---

## Introduction

Managing services is a core system administration task. The RHCSA exam tests your ability to use `systemctl` to start, stop, enable, disable, and check the status of services, particularly network services.

---

## Key systemctl Commands

| Command | Description |
|---------|-------------|
| `systemctl start` | Start a service |
| `systemctl stop` | Stop a service |
| `systemctl restart` | Restart a service |
| `systemctl reload` | Reload configuration |
| `systemctl status` | Check service status |
| `systemctl enable` | Enable at boot |
| `systemctl disable` | Disable at boot |
| `systemctl is-active` | Check if running |
| `systemctl is-enabled` | Check if enabled |

---

## Practice Questions

### Question 1: Check Service Status
**Task:** Check if the sshd service is running.

<details>
<summary>Show Solution</summary>

```bash
systemctl status sshd
```

**Key information in output:**
- `Active: active (running)` - Service is running
- `Active: inactive (dead)` - Service is stopped
- `Loaded: enabled` - Starts at boot
- `Loaded: disabled` - Does not start at boot
</details>

---

### Question 2: Start a Service
**Task:** Start the httpd (Apache) service.

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

### Question 3: Stop a Service
**Task:** Stop the httpd service.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl stop httpd
```

**Verify:**
```bash
systemctl is-active httpd
```
</details>

---

### Question 4: Restart a Service
**Task:** Restart the sshd service.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl restart sshd
```

**Note:** This stops and starts the service, dropping active connections.
</details>

---

### Question 5: Reload Service Configuration
**Task:** Reload httpd configuration without dropping connections.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl reload httpd
```

**Note:** Not all services support reload. Use `reload-or-restart` as fallback:
```bash
sudo systemctl reload-or-restart httpd
```
</details>

---

### Question 6: Enable Service at Boot
**Task:** Configure sshd to start automatically at boot.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl enable sshd
```

**Verify:**
```bash
systemctl is-enabled sshd
```
</details>

---

### Question 7: Enable and Start Service
**Task:** Enable httpd to start at boot AND start it now.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl enable --now httpd
```

**This combines:**
```bash
sudo systemctl enable httpd
sudo systemctl start httpd
```
</details>

---

### Question 8: Disable Service at Boot
**Task:** Prevent httpd from starting at boot.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl disable httpd
```

**Note:** This doesn't stop the currently running service.
</details>

---

### Question 9: Disable and Stop Service
**Task:** Disable httpd at boot AND stop it now.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl disable --now httpd
```
</details>

---

### Question 10: Check if Service is Active
**Task:** Quickly check if a service is running (script-friendly).

<details>
<summary>Show Solution</summary>

```bash
systemctl is-active sshd
```

**Output:** `active` or `inactive`

**Use in scripts:**
```bash
if systemctl is-active --quiet sshd; then
    echo "SSHD is running"
fi
```
</details>

---

### Question 11: Check if Service is Enabled
**Task:** Check if a service is configured to start at boot.

<details>
<summary>Show Solution</summary>

```bash
systemctl is-enabled httpd
```

**Output:** `enabled`, `disabled`, or `static`
</details>

---

### Question 12: List All Services
**Task:** List all available services and their status.

<details>
<summary>Show Solution</summary>

```bash
# All loaded services
systemctl list-units --type=service

# All services including inactive
systemctl list-units --type=service --all

# List enabled services
systemctl list-unit-files --type=service --state=enabled
```
</details>

---

### Question 13: List Failed Services
**Task:** Show services that failed to start.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-units --failed
```

**Or:**
```bash
systemctl --failed
```
</details>

---

### Question 14: View Service Dependencies
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

### Question 15: Mask a Service
**Task:** Completely prevent a service from starting.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl mask httpd
```

**Unmask:**
```bash
sudo systemctl unmask httpd
```

**Note:** Masking creates a symlink to `/dev/null`, preventing even manual starts.
</details>

---

### Question 16: View Service Configuration
**Task:** Display the systemd unit file for sshd.

<details>
<summary>Show Solution</summary>

```bash
systemctl cat sshd
```

**Or find unit file location:**
```bash
systemctl show sshd --property=FragmentPath
```
</details>

---

### Question 17: Reset Failed Status
**Task:** Clear the failed status of a service.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl reset-failed httpd
```

**Reset all failed:**
```bash
sudo systemctl reset-failed
```
</details>

---

### Question 18: Exam Scenario - Configure Web Server
**Task:** Install Apache, start it, and enable it at boot.

<details>
<summary>Show Solution</summary>

```bash
# Install
sudo dnf install httpd -y

# Enable and start
sudo systemctl enable --now httpd

# Verify
systemctl status httpd
systemctl is-enabled httpd
```
</details>

---

### Question 19: Exam Scenario - Troubleshoot Failed Service
**Task:** The httpd service won't start. Troubleshoot it.

<details>
<summary>Show Solution</summary>

```bash
# Check status
systemctl status httpd

# Check logs
journalctl -u httpd -n 50

# Check for configuration errors
apachectl configtest
# Or
httpd -t

# Check if port is in use
ss -tlnp | grep :80
```
</details>

---

### Question 20: Check Listening Ports
**Task:** Verify which services are listening on network ports.

<details>
<summary>Show Solution</summary>

```bash
# Using ss
ss -tlnp

# Listening TCP ports
ss -tln

# Listening UDP ports
ss -uln

# All listening ports with process info
ss -tulnp
```

**Options:**
- `-t`: TCP
- `-u`: UDP
- `-l`: Listening
- `-n`: Numeric (don't resolve names)
- `-p`: Show process
</details>

---

### Question 21: Daemon-Reload After Unit File Changes
**Task:** After editing a unit file, reload systemd configuration.

<details>
<summary>Show Solution</summary>

```bash
sudo systemctl daemon-reload
```

**Then restart the service:**
```bash
sudo systemctl restart servicename
```
</details>

---

## Common Network Services

| Service | Port | Description |
|---------|------|-------------|
| `sshd` | 22 | Secure Shell |
| `httpd` | 80/443 | Apache Web Server |
| `nginx` | 80/443 | Nginx Web Server |
| `firewalld` | - | Firewall |
| `chronyd` | 123 | Time synchronization |
| `NetworkManager` | - | Network configuration |

---

## Quick Reference

### Service Management
```bash
# Start/Stop/Restart
systemctl start SERVICE
systemctl stop SERVICE
systemctl restart SERVICE
systemctl reload SERVICE

# Enable/Disable
systemctl enable SERVICE
systemctl disable SERVICE

# Enable and start
systemctl enable --now SERVICE

# Check status
systemctl status SERVICE
systemctl is-active SERVICE
systemctl is-enabled SERVICE
```

### Listing Services
```bash
# All services
systemctl list-units --type=service

# Failed services
systemctl --failed

# Enabled services
systemctl list-unit-files --type=service --state=enabled
```

### Troubleshooting
```bash
# View logs
journalctl -u SERVICE

# Check dependencies
systemctl list-dependencies SERVICE

# View unit file
systemctl cat SERVICE
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Start/Stop services** using `systemctl start/stop`
2. **Enable/Disable** services using `systemctl enable/disable`
3. **Use `--now` flag** to combine enable and start
4. **Check status** using `systemctl status` and `is-active`
5. **List services** using `systemctl list-units`
6. **View failed services** using `systemctl --failed`
7. **Troubleshoot** using `journalctl -u servicename`
8. **Check listening ports** using `ss -tlnp`
