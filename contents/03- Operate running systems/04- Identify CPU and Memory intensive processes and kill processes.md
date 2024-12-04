## 04- Identify CPU and Memory intensive processes and kill processes:

The RHCSA exam topic **"Identify CPU/memory intensive processes and kill processes"** tests your ability to monitor system performance, identify resource-hungry processes, and terminate those processes if necessary. This skill is essential for managing system resources, troubleshooting performance issues, and maintaining system stability.


---

### **What You Need to Know:**
1. **Monitor system processes** using tools like `top`, `ps`, and `htop`.
2. **Identify CPU/memory intensive processes** using sorting and filtering techniques.
3. **Kill processes** using commands like `kill`, `killall`, and `pkill`.
4. **Understand signals** used to kill processes (e.g., `SIGTERM`, `SIGKILL`).

---

### **1. Identifying CPU and Memory Intensive Processes Using `top`**

The **`top`** command is one of the most commonly used tools to monitor system resource usage in real-time. It shows active processes, sorted by CPU usage by default, and can also be configured to show memory usage.

#### **Example Task 1: Identify CPU/Memory Intensive Processes Using `top`**

**Task:** Use `top` to identify the most CPU and memory-intensive processes.

**Steps:**
1. Run the `top` command:
   ```bash
   top
   ```

2. **Sort by CPU usage** (this is the default behavior):
   - Look at the **%CPU** column to identify processes using the most CPU.

3. **Sort by memory usage**:
   - Press **`Shift + M`** to sort by memory usage (the **%MEM** column).

4. **Identify the process ID (PID)** of the resource-hungry process.

#### **Example Output (from `top`):**
```
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
 2376 root      20   0  227156  17092   2468 S  89.7   4.2   1:27.78 stress
 1375 examuser  20   0  555432  14932   2196 S   2.7   0.4   0:04.56 firefox
```

**Explanation:**
- **`%CPU`**: Shows the CPU usage percentage for each process.
- **`%MEM`**: Shows the memory usage percentage.
- In this example, the **`stress`** command (PID 2376) is consuming 89.7% of the CPU.

---

### **2. Identifying Processes Using `ps`**

The **`ps`** command can be used to list running processes and filter or sort them by CPU or memory usage. Unlike `top`, it provides a snapshot of processes at the time the command is run.

#### **Example Task 2: List Top CPU-Consuming Processes Using `ps`**

**Task:** Use `ps` to list the top 5 processes consuming the most CPU.

**Command:**
```bash
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
```

**Explanation:**
- **`-e`**: Show all processes.
- **`-o pid,comm,%cpu`**: Output the process ID (`pid`), command name (`comm`), and CPU usage (`%cpu`).
- **`--sort=-%cpu`**: Sort the output by CPU usage in descending order.
- **`head -n 6`**: Show only the top 5 results (plus the header).

#### **Example Output:**
```
  PID COMMAND         %CPU
 2376 stress          89.7
  137 firefox         12.5
  245 gnome-shell     10.2
  315 chrome           8.7
  432 Xorg             5.3
```

---

#### **Example Task 3: List Top Memory-Consuming Processes Using `ps`**

**Task:** Use `ps` to list the top 5 processes consuming the most memory.

**Command:**
```bash
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
```

**Explanation:**
- **`-e`**: Show all processes.
- **`-o pid,comm,%mem`**: Output the process ID (`pid`), command name (`comm`), and memory usage (`%mem`).
- **`--sort=-%mem`**: Sort the output by memory usage in descending order.
- **`head -n 6`**: Show the top 5 results (plus the header).

#### **Example Output:**
```
  PID COMMAND         %MEM
 1376 firefox         25.1
  125 chrome          10.4
  425 gnome-shell      8.2
  232 Xorg             7.5
  112 stress           4.5
```

---

### **3. Killing Processes**

You can terminate processes using the **`kill`**, **`killall`**, or **`pkill`** commands. These commands send signals to processes, where **`SIGTERM`** (signal 15) is a graceful termination and **`SIGKILL`** (signal 9) forces the process to stop immediately.

#### **Example Task 4: Kill a Specific Process by PID**

**Task:** Kill the **`stress`** process identified by its PID (2376).

**Command:**
```bash
sudo kill 2376
```

**Explanation:**
- **`kill`** sends the **`SIGTERM`** signal to the process, asking it to terminate gracefully.

#### **Forcing the Process to Stop (Using `SIGKILL`):**
If the process does not stop with `SIGTERM`, you can forcefully terminate it using `SIGKILL`.

```bash
sudo kill -9 2376
```

---

### **4. Killing Processes by Name Using `killall`**

The **`killall`** command is used to terminate all instances of a process by name.

#### **Example Task 5: Kill All Instances of a Process by Name**

**Task:** Kill all instances of the **`stress`** process by name.

**Command:**
```bash
sudo killall stress
```

**Explanation:**
- **`killall stress`** sends the **`SIGTERM`** signal to all processes named **`stress`**.
- If the processes do not terminate, you can use:
  ```bash
  sudo killall -9 stress
  ```

---

### **5. Killing Processes Using `pkill`**

The **`pkill`** command is another way to kill processes based on partial names, full names, or other attributes like the user.

#### **Example Task 6: Kill a Process by Name Using `pkill`**

**Task:** Kill the **`firefox`** process using its name.

**Command:**
```bash
sudo pkill firefox
```

**Explanation:**
- **`pkill firefox`** sends the **`SIGTERM`** signal to the process(es) matching the name **`firefox`**.

#### **Forcing the Process to Stop (Using `SIGKILL`):**
If the process does not stop with `SIGTERM`, you can forcefully terminate it:
```bash
sudo pkill -9 firefox
```

---

### **6. Using `htop` for Interactive Process Management**

**`htop`** is an interactive version of `top` that provides a user-friendly interface to monitor and manage processes. You can use it to identify and kill processes directly within the interface.

#### **Example Task 7: Identify and Kill a Process Using `htop`**

**Task:** Use `htop` to identify a CPU-intensive process and kill it.

**Steps:**
1. Install and run `htop`:
   ```bash
   sudo yum install htop -y
   htop
   ```

2. **Navigate** through the process list using the arrow keys.

3. **Sort by CPU**: Press **F6** and select **CPU** to sort by CPU usage.

4. **Kill a process**:
   - Select the process you want to kill.
   - Press **F9** to kill the process.
   - Select **`SIGKILL` (9)** or **`SIGTERM` (15)** as appropriate.

---

### **7. Handling Stubborn Processes**

Some processes might not terminate with a normal **`SIGTERM`** signal. In these cases, you need to use **`SIGKILL`**, which forces the kernel to terminate the process immediately.

#### **Example Task 8: Force Kill a Stubborn Process**

**Task:** Forcefully kill a process that is consuming 100% of the CPU and not responding to regular kill commands.

**Steps:**
1. Identify the PID of the process using `top` or `ps`.
2. Forcefully kill the process using:
   ```bash
   sudo kill -9 <PID>
   ```

**Explanation:**
- **`-9`** sends the **`SIGKILL`** signal, which immediately terminates the process without allowing it to clean up.

---

### **Summary of Skills for RHCSA Exam on Identifying and Killing Processes:**
1. **Identify CPU and memory-intensive processes** using tools like `top`, `ps`, and `htop`.
2.  **Kill processes by PID** using `kill` and forcefully terminate them using `kill -9`.
3. **Kill processes by name** using `killall` and `pkill`.
4. **Understand and use signals** like `SIGTERM` (default) and `SIGKILL` (forceful termination).
5. Use **`htop`** for an interactive process management experience (optional, but useful).
