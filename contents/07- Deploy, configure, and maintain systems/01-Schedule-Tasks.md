# Schedule Tasks Using at, cron, and systemd Timer Units

## RHCSA Exam Objective
> Schedule tasks using at and cron

---

## Introduction

Task scheduling is essential for system automation. The RHCSA exam tests your ability to schedule one-time tasks with `at` and recurring tasks with `cron`. You should also understand systemd timers as they are increasingly used in RHEL.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `at` | Schedule one-time task |
| `atq` | List pending at jobs |
| `atrm` | Remove at job |
| `crontab -e` | Edit user crontab |
| `crontab -l` | List user crontab |
| `crontab -r` | Remove user crontab |

---

## Part 1: at Command (One-Time Tasks)

### Question 1: Schedule One-Time Task
**Task:** Schedule a script to run at 3:00 PM today.

<details>
<summary>Show Solution</summary>

```bash
at 3:00 PM
at> /path/to/script.sh
at> <Ctrl+D>
```

**Or using echo:**
```bash
echo "/path/to/script.sh" | at 3:00 PM
```
</details>

---

### Question 2: Schedule Task at Specific Time and Date
**Task:** Schedule a command to run at 10:30 AM on March 15.

<details>
<summary>Show Solution</summary>

```bash
at 10:30 AM Mar 15
at> /usr/local/bin/backup.sh
at> <Ctrl+D>
```

**Other time formats:**
```bash
at now + 2 hours
at midnight
at noon
at teatime    # 4:00 PM
at tomorrow
at now + 1 week
```
</details>

---

### Question 3: List Pending at Jobs
**Task:** View all scheduled at jobs.

<details>
<summary>Show Solution</summary>

```bash
atq
```

**Output example:**
```
2    Mon Mar 15 10:30:00 2024 a user
```

**View job details:**
```bash
at -c 2    # Shows job number 2 contents
```
</details>

---

### Question 4: Remove at Job
**Task:** Remove scheduled at job number 3.

<details>
<summary>Show Solution</summary>

```bash
atrm 3
```

**Verify:**
```bash
atq
```
</details>

---

### Question 5: Schedule Task Relative to Now
**Task:** Run a command in 30 minutes.

<details>
<summary>Show Solution</summary>

```bash
at now + 30 minutes
at> /usr/bin/cleanup.sh
at> <Ctrl+D>
```

**Relative time examples:**
- `now + 1 hour`
- `now + 2 days`
- `now + 1 week`
</details>

---

## Part 2: cron (Recurring Tasks)

### Crontab Format

```
* * * * * command
│ │ │ │ │
│ │ │ │ └─ Day of week (0-7, 0 and 7 = Sunday)
│ │ │ └─── Month (1-12)
│ │ └───── Day of month (1-31)
│ └─────── Hour (0-23)
└───────── Minute (0-59)
```

### Special Characters
| Character | Meaning |
|-----------|---------|
| `*` | Any value |
| `,` | List (1,3,5) |
| `-` | Range (1-5) |
| `/` | Step (*/5 = every 5) |

---

### Question 6: Edit User Crontab
**Task:** Open crontab editor to add scheduled tasks.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**First time asks for editor - select vim (or nano).**
</details>

---

### Question 7: Schedule Daily Task
**Task:** Run /scripts/backup.sh every day at 2:00 AM.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add line:**
```
0 2 * * * /scripts/backup.sh
```

**Explanation:**
- Minute: 0
- Hour: 2 (2:00 AM)
- Day: * (every day)
- Month: * (every month)
- Day of week: * (every day)
</details>

---

### Question 8: Schedule Hourly Task
**Task:** Run a command every hour.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add line:**
```
0 * * * * /path/to/command
```

**This runs at minute 0 of every hour.**
</details>

---

### Question 9: Schedule Task Every 15 Minutes
**Task:** Run a script every 15 minutes.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add line:**
```
*/15 * * * * /path/to/script.sh
```
</details>

---

### Question 10: Schedule Weekly Task
**Task:** Run backup every Sunday at 1:00 AM.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add line:**
```
0 1 * * 0 /scripts/weekly-backup.sh
```

**Or:**
```
0 1 * * Sun /scripts/weekly-backup.sh
```
</details>

---

### Question 11: Schedule Monthly Task
**Task:** Run report on the 1st of every month at midnight.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add line:**
```
0 0 1 * * /scripts/monthly-report.sh
```
</details>

---

### Question 12: Schedule Task Multiple Times
**Task:** Run script at 8 AM and 5 PM every weekday.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add line:**
```
0 8,17 * * 1-5 /scripts/workday-task.sh
```

**Explanation:**
- `8,17`: 8 AM and 5 PM
- `1-5`: Monday through Friday
</details>

---

### Question 13: View Crontab
**Task:** Display current user's crontab entries.

<details>
<summary>Show Solution</summary>

```bash
crontab -l
```

**View another user's crontab (as root):**
```bash
sudo crontab -l -u username
```
</details>

---

### Question 14: Remove Crontab
**Task:** Remove all crontab entries for current user.

<details>
<summary>Show Solution</summary>

```bash
crontab -r
```

**Remove with confirmation:**
```bash
crontab -ri
```
</details>

---

### Question 15: Edit Another User's Crontab
**Task:** Edit crontab for user 'webadmin'.

<details>
<summary>Show Solution</summary>

```bash
sudo crontab -e -u webadmin
```
</details>

---

### Question 16: System Crontab Files
**Task:** Understand system cron directories.

<details>
<summary>Show Solution</summary>

**System cron directories:**
| Directory | Purpose |
|-----------|---------|
| `/etc/crontab` | System crontab (has user field) |
| `/etc/cron.d/` | Additional crontabs |
| `/etc/cron.hourly/` | Scripts run hourly |
| `/etc/cron.daily/` | Scripts run daily |
| `/etc/cron.weekly/` | Scripts run weekly |
| `/etc/cron.monthly/` | Scripts run monthly |

**To add a daily task via directory:**
```bash
sudo cp myscript.sh /etc/cron.daily/
sudo chmod +x /etc/cron.daily/myscript.sh
```
</details>

---

### Question 17: Exam Scenario - Database Backup
**Task:** Schedule database backup every day at 11:30 PM.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add:**
```
30 23 * * * /usr/local/bin/db-backup.sh
```
</details>

---

### Question 18: Exam Scenario - Log Rotation
**Task:** Run log cleanup at 3:15 AM on Sundays.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add:**
```
15 3 * * 0 /scripts/log-cleanup.sh
```
</details>

---

### Question 19: Redirect Cron Output
**Task:** Schedule task and redirect output to a log file.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add:**
```
0 2 * * * /scripts/backup.sh >> /var/log/backup.log 2>&1
```

**Or suppress output:**
```
0 2 * * * /scripts/backup.sh > /dev/null 2>&1
```
</details>

---

### Question 20: Use Environment Variables in Cron
**Task:** Set PATH in crontab.

<details>
<summary>Show Solution</summary>

```bash
crontab -e
```

**Add at top:**
```
PATH=/usr/local/bin:/usr/bin:/bin
SHELL=/bin/bash
MAILTO=admin@example.com

0 2 * * * backup.sh
```
</details>

---

### Question 21: Restrict User from Using Cron
**Task:** Prevent user "bob" from scheduling cron jobs.

<details>
<summary>Show Solution</summary>

```bash
# Add user to cron.deny
echo "bob" | sudo tee -a /etc/cron.deny
```

**Access control rules:**
- If `/etc/cron.allow` exists, only users listed can use cron
- If `/etc/cron.allow` doesn't exist, `/etc/cron.deny` is checked
- Root can always use cron

**To allow only specific users:**
```bash
echo "alice" | sudo tee /etc/cron.allow
echo "admin" | sudo tee -a /etc/cron.allow
```
</details>

---

### Question 22: Check Cron Execution Logs
**Task:** Verify that scheduled cron jobs have executed.

<details>
<summary>Show Solution</summary>

```bash
# View cron log
sudo tail -f /var/log/cron

# Search for specific job
sudo grep "backup.sh" /var/log/cron

# Using journalctl
sudo journalctl -u crond
```
</details>

---

### Question 23: Create System-Wide Cron Job
**Task:** Schedule a system-wide job to run `/opt/scripts/cleanup.sh` at 3 AM every Sunday.

<details>
<summary>Show Solution</summary>

**Option 1: Edit /etc/crontab**
```bash
sudo vi /etc/crontab
```
Add:
```
0 3 * * 0 root /opt/scripts/cleanup.sh
```

**Option 2: Use /etc/cron.d/**
```bash
sudo vi /etc/cron.d/cleanup
```
Add:
```
0 3 * * 0 root /opt/scripts/cleanup.sh
```

**Option 3: Use cron directories**
```bash
# For daily jobs
sudo cp /opt/scripts/cleanup.sh /etc/cron.daily/

# For weekly jobs
sudo cp /opt/scripts/cleanup.sh /etc/cron.weekly/
```
</details>

---

## Part 3: systemd Timers

### Question 24: List Active Timers
**Task:** View all active systemd timers.

<details>
<summary>Show Solution</summary>

```bash
systemctl list-timers
```

**Include inactive:**
```bash
systemctl list-timers --all
```
</details>

---

### Question 22: View Timer Status
**Task:** Check status of a specific timer.

<details>
<summary>Show Solution</summary>

```bash
systemctl status dnf-makecache.timer
```
</details>

---

## Quick Reference

### at Command
```bash
at TIME                      # Schedule task
atq                          # List pending jobs
atrm JOB_NUMBER             # Remove job
at -c JOB_NUMBER            # View job details

# Time formats
at 3:00 PM
at noon
at midnight
at now + 1 hour
at tomorrow
```

### crontab
```bash
crontab -e                   # Edit crontab
crontab -l                   # List crontab
crontab -r                   # Remove crontab
crontab -e -u USER          # Edit user's crontab (root)

# Format: minute hour day month dayofweek command
0 2 * * * /path/script.sh   # 2:00 AM daily
*/15 * * * * /path/cmd      # Every 15 minutes
0 8,17 * * 1-5 /path/cmd    # 8AM, 5PM on weekdays
```

### Common Cron Schedules
| Schedule | Cron Expression |
|----------|----------------|
| Every minute | `* * * * *` |
| Every hour | `0 * * * *` |
| Every day at 2 AM | `0 2 * * *` |
| Every Sunday at 1 AM | `0 1 * * 0` |
| Every weekday at 8 AM | `0 8 * * 1-5` |
| 1st of month at midnight | `0 0 1 * *` |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Schedule one-time tasks** using `at`
2. **List and remove at jobs** using `atq` and `atrm`
3. **Edit user crontab** using `crontab -e`
4. **Write correct cron expressions** (minute hour day month dayofweek)
5. **Use special characters** (*, /, -, ,) in cron
6. **Redirect cron output** to files or /dev/null
7. **List systemd timers** using `systemctl list-timers`
