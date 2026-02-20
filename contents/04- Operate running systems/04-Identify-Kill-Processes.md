# Identify CPU/Memory Intensive Processes and Kill Processes

## RHCSA Exam Objective
> Identify CPU/memory intensive processes and kill processes

---

## Introduction

Monitoring system resources and managing processes is essential for system administration. The RHCSA exam tests your ability to identify resource-hungry processes using tools like `top`, `ps`, and `kill` them appropriately.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `top` | Interactive process viewer |
| `ps` | Snapshot of current processes |
| `kill` | Send signal to process |
| `killall` | Kill processes by name |
| `pkill` | Kill processes matching pattern |
| `pgrep` | Find processes matching pattern |

---

## Practice Questions

### Question 1: View Processes with Top
**Task:** Use `top` to view running processes in real-time.

<details>
<summary>Show Solution</summary>

```bash
top
```

**Key columns:**
- `PID`: Process ID
- `USER`: Process owner
- `%CPU`: CPU usage percentage
- `%MEM`: Memory usage percentage
- `COMMAND`: Command name

**Interactive keys in top:**
- `q`: Quit
- `k`: Kill a process
- `P`: Sort by CPU usage
- `M`: Sort by memory usage
- `u`: Filter by user
- `1`: Show per-CPU statistics
</details>

---

### Question 2: Sort by CPU Usage
**Task:** Display processes sorted by CPU usage.

<details>
<summary>Show Solution</summary>

**In top:**
```bash
top
# Press 'P' to sort by CPU
```

**Using ps:**
```bash
ps aux --sort=-%cpu | head
```

**Top 10 CPU consumers:**
```bash
ps aux --sort=-%cpu | head -11
```
</details>

---

### Question 3: Sort by Memory Usage
**Task:** Display processes sorted by memory usage.

<details>
<summary>Show Solution</summary>

**In top:**
```bash
top
# Press 'M' to sort by memory
```

**Using ps:**
```bash
ps aux --sort=-%mem | head
```
</details>

---

### Question 4: Find Process by Name
**Task:** Find the PID of the sshd process.

<details>
<summary>Show Solution</summary>

```bash
# Using pgrep
pgrep sshd

# Using pgrep with details
pgrep -a sshd

# Using ps and grep
ps aux | grep sshd

# Using pidof
pidof sshd
```
</details>

---

### Question 5: Find Processes by User
**Task:** List all processes owned by user "apache".

<details>
<summary>Show Solution</summary>

```bash
# Using ps
ps -u apache

# Using top
top -u apache

# Using pgrep
pgrep -u apache
```
</details>

---

### Question 6: Kill Process by PID
**Task:** Kill the process with PID 1234.

<details>
<summary>Show Solution</summary>

```bash
# Graceful termination (SIGTERM)
kill 1234

# Force kill (SIGKILL)
kill -9 1234

# Alternative syntax
kill -SIGKILL 1234
```
</details>

---

### Question 7: Kill Process by Name
**Task:** Kill all processes named "httpd".

<details>
<summary>Show Solution</summary>

```bash
# Using killall
killall httpd

# Using pkill
pkill httpd

# Force kill all
killall -9 httpd
```
</details>

---

### Question 8: List Available Signals
**Task:** Display all available signals.

<details>
<summary>Show Solution</summary>

```bash
kill -l
```

**Common signals:**
| Signal | Number | Description |
|--------|--------|-------------|
| `SIGHUP` | 1 | Hangup / reload |
| `SIGINT` | 2 | Interrupt (Ctrl+C) |
| `SIGKILL` | 9 | Force kill (cannot be caught) |
| `SIGTERM` | 15 | Graceful termination (default) |
| `SIGSTOP` | 19 | Stop process |
| `SIGCONT` | 18 | Continue stopped process |
</details>

---

### Question 9: Send Specific Signal
**Task:** Send SIGHUP to process 5678 to reload its configuration.

<details>
<summary>Show Solution</summary>

```bash
# Using signal name
kill -HUP 5678

# Using signal number
kill -1 5678

# Using full name
kill -SIGHUP 5678
```
</details>

---

### Question 10: Kill from Top
**Task:** Kill a process directly from the `top` interface.

<details>
<summary>Show Solution</summary>

1. Run `top`
2. Press `k`
3. Enter the PID of the process to kill
4. Enter signal number (default is 15/SIGTERM, use 9 for force kill)
5. Press Enter
</details>

---

### Question 11: View Process Tree
**Task:** Display processes in a tree format showing parent-child relationships.

<details>
<summary>Show Solution</summary>

```bash
# Using ps
ps auxf

# Using pstree
pstree

# Show PIDs in tree
pstree -p
```
</details>

---

### Question 12: Find High CPU Process and Kill It
**Task:** Identify the process using the most CPU and terminate it.

<details>
<summary>Show Solution</summary>

```bash
# Find top CPU consumer
ps aux --sort=-%cpu | head -2

# Get PID of top consumer
TOP_PID=$(ps aux --sort=-%cpu | awk 'NR==2 {print $2}')

# Kill it
kill $TOP_PID
```

**Or using top:**
```bash
top
# Note the PID of top CPU process
# Press 'k', enter PID, press Enter
```
</details>

---

### Question 13: Find High Memory Process
**Task:** Identify processes using more than 5% memory.

<details>
<summary>Show Solution</summary>

```bash
ps aux | awk '$4 > 5.0 {print $2, $4, $11}'
```

**Explanation:**
- `$4` is the %MEM column
- `$2` is PID
- `$11` is COMMAND
</details>

---

### Question 14: Monitor Specific Process
**Task:** Monitor CPU and memory usage of process with PID 1234.

<details>
<summary>Show Solution</summary>

```bash
# Using top
top -p 1234

# Using ps in a loop
watch -n 1 'ps -p 1234 -o pid,ppid,%cpu,%mem,cmd'
```
</details>

---

### Question 15: Kill All User Processes
**Task:** Kill all processes owned by user "testuser".

<details>
<summary>Show Solution</summary>

```bash
# Using pkill
pkill -u testuser

# Using killall
killall -u testuser

# Force kill all
pkill -9 -u testuser
```
</details>

---

### Question 16: Background and Foreground Processes
**Task:** Send a running process to background and bring it back.

<details>
<summary>Show Solution</summary>

```bash
# Start a process
sleep 100

# Press Ctrl+Z to stop/suspend it
# [1]+  Stopped    sleep 100

# Send to background
bg

# View background jobs
jobs

# Bring to foreground
fg

# Or by job number
fg %1
```
</details>

---

### Question 17: Run Process in Background
**Task:** Start a command in the background.

<details>
<summary>Show Solution</summary>

```bash
# Using &
sleep 100 &

# Prevent output to terminal
command > /dev/null 2>&1 &

# Using nohup (survives logout)
nohup command &
```
</details>

---

### Question 18: View Process Resource Limits
**Task:** Check resource limits for a process.

<details>
<summary>Show Solution</summary>

```bash
# Current shell limits
ulimit -a

# Specific process limits
cat /proc/<PID>/limits
```
</details>

---

### Question 19: Exam Scenario - Kill Runaway Process
**Task:** A process is consuming 100% CPU. Find and kill it.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Using top
top
# Identify PID with highest %CPU
# Press 'k', enter PID, enter 9 (SIGKILL)

# Method 2: Using ps
ps aux --sort=-%cpu | head -5
# Note the PID
kill -9 <PID>

# Method 3: One-liner to kill highest CPU process
kill -9 $(ps aux --sort=-%cpu | awk 'NR==2 {print $2}')
```
</details>

---

### Question 20: Using htop (if available)
**Task:** Use htop for process management.

<details>
<summary>Show Solution</summary>

```bash
# Install if needed
sudo dnf install htop -y

# Run htop
htop
```

**htop features:**
- Color-coded display
- Mouse support
- Easier process selection
- F9 to kill process
- F6 to sort
</details>

---

## PS Command Common Options

| Option | Description |
|--------|-------------|
| `ps aux` | All processes, user-oriented format |
| `ps -ef` | All processes, full format |
| `ps -u USER` | Processes by user |
| `ps -p PID` | Specific process |
| `ps --sort=-cpu` | Sort by CPU descending |
| `ps --sort=-mem` | Sort by memory descending |
| `ps auxf` | Process tree format |

---

## Quick Reference

### Finding Processes
```bash
# Top CPU consumers
ps aux --sort=-%cpu | head

# Top memory consumers
ps aux --sort=-%mem | head

# Find by name
pgrep processname
```

### Killing Processes
```bash
# By PID
kill PID
kill -9 PID

# By name
killall name
pkill name

# By user
pkill -u username
```

### Signals
```bash
# Default (SIGTERM - graceful)
kill PID

# Force (SIGKILL - immediate)
kill -9 PID

# Reload config (SIGHUP)
kill -1 PID
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Use `top`** to view and sort processes by CPU/memory
2. **Use `ps aux`** with sort options to find intensive processes
3. **Find processes** by name using `pgrep` or `ps | grep`
4. **Kill processes** using `kill`, `killall`, and `pkill`
5. **Understand signals** (SIGTERM, SIGKILL, SIGHUP)
6. **Kill processes by user** using `pkill -u`
7. **Manage background jobs** with `bg`, `fg`, `jobs`
