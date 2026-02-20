# Adjust Process Scheduling

## RHCSA Exam Objective
> Adjust process scheduling

---

## Introduction

Process scheduling determines how CPU time is allocated to processes. The RHCSA exam tests your ability to adjust process priority using `nice` and `renice` commands. Understanding nice values helps you manage system resources effectively.

---

## Nice Value Concept

| Concept | Description |
|---------|-------------|
| Nice value | Priority adjustment (-20 to +19) |
| Lower nice | Higher priority (more CPU time) |
| Higher nice | Lower priority (less CPU time) |
| Default | 0 for regular users |

**Range:** -20 (highest priority) to +19 (lowest priority)

---

## Key Commands

| Command | Description |
|---------|-------------|
| `nice` | Start process with specified nice value |
| `renice` | Change nice value of running process |
| `top` | View and change nice values interactively |
| `ps` | View nice values (NI column) |

---

## Practice Questions

### Question 1: View Process Nice Value
**Task:** Display the nice value of running processes.

<details>
<summary>Show Solution</summary>

```bash
# Using ps
ps -l

# Show specific columns
ps -eo pid,ni,comm

# Using top (NI column)
top
```

**The NI column shows the nice value.**
</details>

---

### Question 2: Start Process with Nice Value
**Task:** Start a command with a nice value of 10 (lower priority).

<details>
<summary>Show Solution</summary>

```bash
nice -n 10 command

# Example
nice -n 10 tar -czf backup.tar.gz /home
```

**Alternative syntax:**
```bash
nice -10 command
```
</details>

---

### Question 3: Start Process with High Priority
**Task:** Start a process with nice value of -10 (higher priority).

<details>
<summary>Show Solution</summary>

```bash
# Requires root privileges
sudo nice -n -10 command

# Example
sudo nice -n -10 /usr/local/bin/critical-task
```

**Note:** Only root can set negative nice values.
</details>

---

### Question 4: Change Nice Value of Running Process
**Task:** Change the nice value of process with PID 1234 to 15.

<details>
<summary>Show Solution</summary>

```bash
renice 15 -p 1234

# Alternative syntax
renice -n 15 -p 1234
```
</details>

---

### Question 5: Increase Priority of Running Process
**Task:** Change process PID 5678 to nice value -5.

<details>
<summary>Show Solution</summary>

```bash
# Requires root
sudo renice -5 -p 5678

# Or
sudo renice -n -5 -p 5678
```
</details>

---

### Question 6: Change Nice for All User Processes
**Task:** Set all processes owned by user "apache" to nice value 10.

<details>
<summary>Show Solution</summary>

```bash
sudo renice 10 -u apache
```
</details>

---

### Question 7: Change Nice for Process Group
**Task:** Change nice value for all processes in process group 1000.

<details>
<summary>Show Solution</summary>

```bash
renice 10 -g 1000
```
</details>

---

### Question 8: View Nice Value of Specific Process
**Task:** Check the nice value of process with PID 1234.

<details>
<summary>Show Solution</summary>

```bash
ps -o pid,ni,comm -p 1234
```

**Output example:**
```
  PID  NI COMMAND
 1234   0 httpd
```
</details>

---

### Question 9: Default Nice Value
**Task:** What is the default nice value for processes?

<details>
<summary>Show Solution</summary>

The default nice value is **0**.

```bash
# Check default
nice
```

**Output:** `0`

- Regular users can only increase nice (lower priority): 0 to 19
- Root can decrease nice (raise priority): -20 to 19
</details>

---

### Question 10: Change Nice from Top
**Task:** Change the nice value of a process using `top`.

<details>
<summary>Show Solution</summary>

1. Run `top`
2. Press `r` (renice)
3. Enter the PID
4. Enter the new nice value
5. Press Enter

**Note:** In top, you're prompted for the renice value, not the absolute nice.
</details>

---

### Question 11: Nice Limitations for Regular Users
**Task:** Understand nice value restrictions.

<details>
<summary>Show Solution</summary>

**Regular users:**
- Can only increase nice value (lower priority)
- Can only nice their own processes
- Cannot set negative nice values

**Root user:**
- Can set any nice value (-20 to +19)
- Can nice any process

```bash
# As regular user (will fail)
nice -n -5 command
# nice: cannot set niceness: Permission denied

# As root (will work)
sudo nice -n -5 command
```
</details>

---

### Question 12: Start Background Process with Low Priority
**Task:** Start a backup script in background with nice value 19.

<details>
<summary>Show Solution</summary>

```bash
nice -n 19 /scripts/backup.sh &
```

**With nohup (survives logout):**
```bash
nohup nice -n 19 /scripts/backup.sh &
```
</details>

---

### Question 13: Exam Scenario - Prioritize Critical Process
**Task:** A critical database process (PID 2345) needs more CPU. Raise its priority.

<details>
<summary>Show Solution</summary>

```bash
# Set to higher priority (lower nice)
sudo renice -10 -p 2345

# Verify
ps -o pid,ni,comm -p 2345
```
</details>

---

### Question 14: Exam Scenario - Lower Priority of Backup
**Task:** A backup process (PID 3456) is impacting production. Lower its priority.

<details>
<summary>Show Solution</summary>

```bash
# Set to lower priority (higher nice)
renice 19 -p 3456

# Verify
ps -o pid,ni,comm -p 3456
```
</details>

---

### Question 15: View All Processes with Nice Values
**Task:** List all processes showing PID, nice value, and command.

<details>
<summary>Show Solution</summary>

```bash
ps -eo pid,ni,comm --sort=-ni
```

**With user info:**
```bash
ps -eo user,pid,ni,comm --sort=-ni
```
</details>

---

## Nice Value Reference

| Nice Value | Priority Level | Who Can Set |
|------------|----------------|-------------|
| -20 | Highest | Root only |
| -10 | High | Root only |
| 0 | Default | Everyone |
| 10 | Low | Everyone |
| 19 | Lowest | Everyone |

---

## Quick Reference

### Starting with Nice
```bash
# Lower priority (nice = 10)
nice -n 10 command

# Higher priority (requires root)
sudo nice -n -10 command
```

### Changing Running Process
```bash
# Renice by PID
renice VALUE -p PID

# Renice by user
renice VALUE -u USERNAME

# Renice by group
renice VALUE -g PGID
```

### Viewing Nice Values
```bash
# Default nice
nice

# Process nice values
ps -eo pid,ni,comm

# In top
top  # NI column
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Understand nice values** (-20 to +19, lower = higher priority)
2. **Start processes with nice** using `nice -n VALUE command`
3. **Change running process priority** using `renice VALUE -p PID`
4. **View nice values** using `ps -o ni` or `top`
5. **Know restrictions**: only root can set negative nice values
6. **Renice by user** using `renice VALUE -u USER`
