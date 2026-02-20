# Configure Time Service Clients

## RHCSA Exam Objective
> Configure time service clients

---

## Introduction

Accurate time synchronization is critical for authentication, logging, and cluster operations. RHEL 9 uses chronyd as the default NTP client. The RHCSA exam tests your ability to configure time zones, check synchronization status, and configure NTP servers.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `timedatectl` | Control system time settings |
| `chronyc` | Chrony client utility |
| `date` | Display/set system date |
| `hwclock` | Hardware clock utility |

---

## Part 1: Viewing Time Information

### Question 1: Display Current Time Settings
**Task:** Show current date, time, timezone, and NTP status.

<details>
<summary>Show Solution</summary>

```bash
timedatectl
```

**Output shows:**
```
               Local time: Mon 2024-03-15 10:30:45 EDT
           Universal time: Mon 2024-03-15 14:30:45 UTC
                 RTC time: Mon 2024-03-15 14:30:45
                Time zone: America/New_York (EDT, -0400)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```
</details>

---

### Question 2: Show Date and Time
**Task:** Display current date and time.

<details>
<summary>Show Solution</summary>

```bash
date
```

**Custom format:**
```bash
date +"%Y-%m-%d %H:%M:%S"
```

**Output:**
```
2024-03-15 10:30:45
```
</details>

---

## Part 2: Time Zone Configuration

### Question 3: List Available Time Zones
**Task:** Show all available time zones.

<details>
<summary>Show Solution</summary>

```bash
timedatectl list-timezones
```

**Filter for specific region:**
```bash
timedatectl list-timezones | grep America
timedatectl list-timezones | grep Toronto
```
</details>

---

### Question 4: Set Time Zone
**Task:** Set timezone to America/Toronto.

<details>
<summary>Show Solution</summary>

```bash
sudo timedatectl set-timezone America/Toronto
```

**Verify:**
```bash
timedatectl
```

**Or check:**
```bash
ls -l /etc/localtime
```
</details>

---

### Question 5: Set Time Zone (Alternative)
**Task:** Set timezone using symlink method.

<details>
<summary>Show Solution</summary>

```bash
sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
```

**Note:** `timedatectl set-timezone` is preferred.
</details>

---

### Question 6: Exam Scenario - Set Timezone
**Task:** Configure system timezone to UTC.

<details>
<summary>Show Solution</summary>

```bash
sudo timedatectl set-timezone UTC
```

**Verify:**
```bash
timedatectl | grep "Time zone"
```
</details>

---

## Part 3: NTP Synchronization

### Question 7: Check NTP Status
**Task:** Verify if NTP synchronization is active.

<details>
<summary>Show Solution</summary>

```bash
timedatectl
```

**Look for:**
```
System clock synchronized: yes
              NTP service: active
```

**Or check chronyd service:**
```bash
systemctl status chronyd
```
</details>

---

### Question 8: Enable NTP Synchronization
**Task:** Enable automatic time synchronization.

<details>
<summary>Show Solution</summary>

```bash
sudo timedatectl set-ntp true
```

**This starts and enables chronyd.**
</details>

---

### Question 9: Disable NTP Synchronization
**Task:** Disable automatic time synchronization.

<details>
<summary>Show Solution</summary>

```bash
sudo timedatectl set-ntp false
```
</details>

---

### Question 10: Check Chrony Synchronization
**Task:** Check chrony synchronization status.

<details>
<summary>Show Solution</summary>

```bash
chronyc tracking
```

**Shows:**
- Reference server
- System time offset
- Last sync time
</details>

---

### Question 11: View Chrony Sources
**Task:** List NTP time sources.

<details>
<summary>Show Solution</summary>

```bash
chronyc sources
```

**Output:**
```
MS Name/IP address     Stratum Poll Reach LastRx Last sample
===============================================================================
^* ntp.example.com          2   6   377    34  +123us[ +156us] +/-   15ms
```

**Symbols:**
- `^` = server
- `*` = current sync source
- `+` = acceptable source
- `-` = combined with selected source
</details>

---

### Question 12: View Chrony Source Statistics
**Task:** Show detailed statistics for NTP sources.

<details>
<summary>Show Solution</summary>

```bash
chronyc sourcestats
```
</details>

---

## Part 4: Configuring Chrony

### Question 13: View Chrony Configuration
**Task:** Display chrony configuration file.

<details>
<summary>Show Solution</summary>

```bash
cat /etc/chrony.conf
```

**Key settings:**
```
# Use public servers from the pool.ntp.org project
pool 2.rhel.pool.ntp.org iburst

# Record rate of drift
driftfile /var/lib/chrony/drift

# Allow system clock to be stepped
makestep 1.0 3
```
</details>

---

### Question 14: Add NTP Server
**Task:** Configure chrony to use ntp.example.com as time source.

<details>
<summary>Show Solution</summary>

**Edit configuration:**
```bash
sudo vi /etc/chrony.conf
```

**Add line:**
```
server ntp.example.com iburst
```

**Or for pool:**
```
pool ntp.example.com iburst
```

**Restart chrony:**
```bash
sudo systemctl restart chronyd
```

**Verify:**
```bash
chronyc sources
```
</details>

---

### Question 15: Configure Multiple NTP Servers
**Task:** Add multiple NTP servers.

<details>
<summary>Show Solution</summary>

**Edit /etc/chrony.conf:**
```
server ntp1.example.com iburst
server ntp2.example.com iburst
server ntp3.example.com iburst
```

**Restart:**
```bash
sudo systemctl restart chronyd
```
</details>

---

### Question 16: Remove Default Pool Servers
**Task:** Use only internal NTP server.

<details>
<summary>Show Solution</summary>

**Edit /etc/chrony.conf:**

**Comment out existing pool lines:**
```bash
sudo vi /etc/chrony.conf
```

```
# Comment out public pools
#pool 2.rhel.pool.ntp.org iburst

# Add internal server
server internal-ntp.company.com iburst
```

**Restart:**
```bash
sudo systemctl restart chronyd
```
</details>

---

### Question 17: Force Time Synchronization
**Task:** Force immediate time sync.

<details>
<summary>Show Solution</summary>

```bash
sudo chronyc makestep
```

**Note:** Only use when time is significantly off.
</details>

---

## Part 5: Manual Time Setting

### Question 18: Set Time Manually
**Task:** Set system time manually (NTP must be off).

<details>
<summary>Show Solution</summary>

**First disable NTP:**
```bash
sudo timedatectl set-ntp false
```

**Set time:**
```bash
sudo timedatectl set-time "2024-03-15 10:30:00"
```

**Or using date:**
```bash
sudo date -s "2024-03-15 10:30:00"
```
</details>

---

### Question 19: Set Date Only
**Task:** Set date without changing time.

<details>
<summary>Show Solution</summary>

```bash
sudo timedatectl set-ntp false
sudo timedatectl set-time "2024-03-15"
```
</details>

---

### Question 20: Sync Hardware Clock
**Task:** Sync hardware clock from system clock.

<details>
<summary>Show Solution</summary>

```bash
sudo hwclock --systohc
```

**Or sync system from hardware:**
```bash
sudo hwclock --hctosys
```
</details>

---

## Part 6: Exam Scenarios

### Question 21: Exam Scenario - Complete NTP Setup
**Task:** Configure system to sync time with time.google.com.

<details>
<summary>Show Solution</summary>

**Edit /etc/chrony.conf:**
```bash
sudo vi /etc/chrony.conf
```

**Add/modify:**
```
server time.google.com iburst
```

**Restart and enable:**
```bash
sudo systemctl restart chronyd
sudo systemctl enable chronyd
```

**Enable NTP:**
```bash
sudo timedatectl set-ntp true
```

**Verify:**
```bash
chronyc sources
timedatectl
```
</details>

---

### Question 22: Exam Scenario - Timezone and NTP
**Task:** 
1. Set timezone to Europe/London
2. Enable NTP synchronization

<details>
<summary>Show Solution</summary>

```bash
# Set timezone
sudo timedatectl set-timezone Europe/London

# Enable NTP
sudo timedatectl set-ntp true

# Verify
timedatectl
```
</details>

---

### Question 23: Verify Synchronization
**Task:** Confirm time is synchronized.

<details>
<summary>Show Solution</summary>

```bash
timedatectl
```

**Check for:**
```
System clock synchronized: yes
```

**And:**
```bash
chronyc tracking
```

**Look for "Leap status: Normal"**
</details>

---

## Quick Reference

### Time Commands
```bash
# View time info
timedatectl
date

# Set timezone
timedatectl list-timezones
timedatectl set-timezone America/Toronto

# NTP control
timedatectl set-ntp true
timedatectl set-ntp false
```

### Chrony Commands
```bash
# Check status
chronyc tracking
chronyc sources
chronyc sourcestats

# Force sync
chronyc makestep
```

### Configuration
```bash
# Config file
/etc/chrony.conf

# Add server
server ntp.example.com iburst

# Restart after changes
systemctl restart chronyd
```

### Common Timezones
| Timezone | Description |
|----------|-------------|
| `UTC` | Coordinated Universal Time |
| `America/New_York` | US Eastern |
| `America/Toronto` | Canada Eastern |
| `America/Los_Angeles` | US Pacific |
| `Europe/London` | UK |
| `Asia/Tokyo` | Japan |

---

## Summary

For the RHCSA exam, ensure you can:

1. **View time settings** using `timedatectl`
2. **Set timezone** using `timedatectl set-timezone`
3. **Enable NTP** using `timedatectl set-ntp true`
4. **Configure NTP servers** in `/etc/chrony.conf`
5. **Check sync status** using `chronyc sources` and `chronyc tracking`
6. **Restart chronyd** after configuration changes
