## 05- Adjust process scheduling:

The RHCSA exam topic **"Adjust process scheduling"** tests your understanding of how to manage process priorities in Linux using the **nice** and **renice** commands. These commands allow you to adjust the **priority** at which processes run, which directly impacts how much CPU time they receive. Processes with higher priority will get more CPU time, while those with lower priority will get less.


---

### **What You Need to Know:**
1. **Understanding process priority and niceness**:
   - **Priority (PR)**: This value determines how much CPU time a process gets relative to others.
   - **Nice value (NI)**: This is a user-configurable setting that affects the process's priority. It ranges from **-20 (highest priority)** to **19 (lowest priority)**.
2. **Using the `nice` command** to launch processes with specific priority levels.
3. **Using the `renice` command** to change the priority of running processes.
4. **Viewing the niceness and priority of processes** using `top` and `ps`.

---

### **1. Understanding Niceness and Priority**

- **Nice Value (NI)**: The **niceness** of a process affects its **priority**. A lower nice value (closer to -20) means higher priority, and a higher nice value (closer to 19) means lower priority.
- **Default Nice Value**: Processes are typically started with a default nice value of **0**.

---

### **2. Using `nice` to Start a Process with a Specific Priority**

The **`nice`** command is used to start a process with a specified niceness value. By default, processes are started with a nice value of **0**, but you can specify a different value using `nice`.

#### **Example Task 1: Start a Process with a Low Priority (High Niceness)**

**Task:** Start the `stress` command with a nice value of **10**, which gives it lower priority.

**Command:**
```bash
nice -n 10 stress --cpu 2
```

**Explanation:**
- **`nice -n 10`**: Runs the command with a nice value of 10, giving it lower priority.
- **`stress --cpu 2`**: Starts the `stress` process that consumes CPU resources. This will simulate CPU load for demonstration.

#### **Example Output (from `top`):**
```bash
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
 2376 root      30  10   227156  17092   2468 R  50.0   4.2   0:02.45 stress
```

**Explanation:**
- **NI=10**: The process was started with a nice value of 10, lowering its priority.

---

#### **Example Task 2: Start a Process with a High Priority (Low Niceness)**

**Task:** Start the `stress` command with a nice value of **-5**, giving it a higher priority.

**Command:**
```bash
sudo nice -n -5 stress --cpu 2
```

**Explanation:**
- **`nice -n -5`**: Runs the command with a nice value of **-5**, giving it higher priority.
- You need to use **`sudo`** to set a negative nice value (higher priority), as this requires elevated privileges.

---

### **3. Changing the Niceness of a Running Process Using `renice`**

The **`renice`** command is used to change the niceness of a process that is already running. This is helpful if you need to adjust the priority of a running process dynamically.

#### **Example Task 3: Change the Niceness of a Running Process**

**Task:** Change the niceness of the `stress` process (PID 2376) to **5** after it has already started.

**Command:**
```bash
sudo renice 5 -p 2376
```

**Explanation:**
- **`renice 5 -p 2376`**: Changes the nice value of the process with **PID 2376** to **5**, giving it lower priority.
- **`sudo`** is needed because you are adjusting the priority of a running process.

---

### **4. Viewing the Niceness and Priority of Processes Using `top` and `ps`**

You can view the nice value (`NI`) and priority (`PR`) of processes using **`top`** and **`ps`**.

#### **Example Task 4: View Niceness and Priority in `top`**

**Task:** Use `top` to view the niceness and priority of all processes.

**Steps:**
1. Run the `top` command:
   ```bash
   top
   ```

2. Look for the **NI** (niceness) and **PR** (priority) columns:
   - **NI**: Displays the nice value of each process.
   - **PR**: Displays the priority level, which is derived from the nice value.

#### **Example Output (from `top`):**
```bash
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
 2376 root      25   5   227156  17092   2468 R  75.0   4.2   0:05.23 stress
 1457 examuser  20   0   555432  14932   2196 S   2.7   0.4   0:04.56 firefox
```

- **PR=25, NI=5**: Indicates that the `stress` process has a priority of 25 and a nice value of 5 (lower priority).
- **PR=20, NI=0**: Indicates that the `firefox` process is running with the default priority (nice value 0).

---

#### **Example Task 5: View Niceness and Priority with `ps`**

**Task:** Use `ps` to view the niceness and priority of all processes.

**Command:**
```bash
ps -eo pid,comm,ni,pri
```

**Explanation:**
- **`-e`**: Show all processes.
- **`-o pid,comm,ni,pri`**: Output the process ID (`pid`), command name (`comm`), niceness (`ni`), and priority (`pri`).

#### **Example Output (from `ps`):**
```
  PID COMMAND          NI  PRI
 2376 stress            5   25
 1457 firefox           0   20
 1202 gnome-shell       0   20
```

- **NI=5, PRI=25**: Shows that the `stress` process has a nice value of 5 and a priority of 25 (lower priority).
- **NI=0, PRI=20**: Shows that `firefox` and `gnome-shell` are running with the default niceness (0) and default priority (20).

---

### **5. Adjusting Process Scheduling for Real-World Scenarios**

#### **Example Task 6: Increase Priority for a Critical Process**

**Task:** You need to increase the priority of a database server process (with PID 5678) to ensure it gets more CPU time during peak usage.

**Command:**
```bash
sudo renice -5 -p 5678
```

**Explanation:**
- **`renice -5 -p 5678`** increases the priority of the process with PID 5678 by setting its nice value to **-5**. This gives the process more CPU time, as it now has a higher priority.

---

#### **Example Task 7: Lower Priority for a Resource-Intensive Background Job**

**Task:** A backup process (with PID 6789) is consuming too much CPU, affecting other critical applications. Lower its priority.

**Command:**
```bash
sudo renice 15 -p 6789
```

**Explanation:**
- **`renice 15 -p 6789`** decreases the priority of the backup process by setting its nice value to **15**, giving it less CPU time.

---

### **Summary of Skills for RHCSA Exam on Adjusting Process Scheduling:**
1. **Use `nice` to launch processes** with a specific priority (adjust niceness).
2. **Use `renice` to change the niceness** of already running processes.
3. **View process priority and niceness** using `top` and `ps`.
4. **Understand priority values**: Lower nice values give higher priority, and higher nice values give lower priority.
5. **Use `sudo` for adjusting niceness** values when decreasing niceness (i.e., increasing priority).

