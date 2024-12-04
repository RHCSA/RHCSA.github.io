## 01- Schedule tasks using at and cron:

The RHCSA exam topic **"Schedule tasks using `at` and `cron`"** focuses on automating task execution at specific times or intervals. **`at`** and **`cron`** are essential tools in Linux for task scheduling:

- **`at`**: Schedules a one-time task at a specific time.
- **`cron`**: Schedules recurring tasks or commands at regular intervals (daily, weekly, monthly, etc.).

---

### **What You Need to Know:**
1. **`at`**: Used for scheduling one-time tasks.
   - Understand how to use `at` to schedule tasks and how to view or remove scheduled jobs.
2. **`cron`**: Used for scheduling recurring tasks.
   - Know how to use `crontab` to schedule recurring tasks for users and system-wide jobs.
   - Understand how to manage cron permissions with **`/etc/cron.allow`** and **`/etc/cron.deny`**.
3. **Persistence**: Ensure scheduled jobs remain active and persistent after reboots and system changes.

---

### **1. Scheduling One-Time Tasks Using `at`**

**`at`** allows you to schedule one-time jobs that execute at a specific time. The **`at` daemon (`atd`)** must be running for scheduled tasks to execute.

#### **Example Task 1: Schedule a One-Time Task Using `at`**

**Task:** Schedule a job to create a file **`/tmp/at_job.txt`** in 5 minutes.

1. **Ensure `atd` service is running**:
   ```bash
   sudo systemctl start atd
   sudo systemctl enable atd
   ```

2. **Schedule the task**:
   ```bash
   echo "touch /tmp/at_job.txt" | at now + 5 minutes
   ```

3. **List the scheduled jobs**:
   ```bash
   atq
   ```

4. **Verify the task after 5 minutes**:
   ```bash
   ls -l /tmp/at_job.txt
   ```

**Explanation**:
- **`at now + 5 minutes`** schedules the command to run 5 minutes from the current time.
- **`atq`** lists all scheduled jobs for the current user.

---

#### **Example Task 2: Remove a Scheduled `at` Job**

**Task:** Cancel a previously scheduled `at` job with job ID **1**.

1. **List scheduled jobs**:
   ```bash
   atq
   ```

   **Example Output**:
   ```
   1   2024-09-25 12:00 a user
   ```

2. **Remove the job**:
   ```bash
   atrm 1
   ```

**Explanation**:
- **`atrm`** removes a scheduled job by its job ID.

---

### **2. Scheduling Recurring Tasks Using `cron`**

**`cron`** is used for scheduling recurring tasks at specific times. There are system-wide cron jobs and user-specific cron jobs.

#### **Crontab Syntax**:
Each line in a `crontab` file represents a job, with the following format:
```
* * * * * command_to_execute
| | | | |
| | | | +--- Day of the week (0 - 7) (Sunday = 0 or 7)
| | | +----- Month (1 - 12)
| | +------- Day of the month (1 - 31)
| +--------- Hour (0 - 23)
+----------- Minute (0 - 59)
```

#### **Example Task 3: Schedule a Recurring Task Using `cron`**

**Task:** Schedule a job to create the file **`/tmp/cron_job.txt`** every day at 2 AM.

1. **Edit the crontab** for the current user:
   ```bash
   crontab -e
   ```

2. **Add the following line** to schedule the job:
   ```
   0 2 * * * touch /tmp/cron_job.txt
   ```

3. **Save and exit**.

4. **Verify the scheduled cron job**:
   ```bash
   crontab -l
   ```

**Explanation**:
- **`0 2 * * *`**: The job will run at **2:00 AM** every day.
- **`crontab -e`** opens the current user's crontab file for editing.
- **`crontab -l`** lists the scheduled cron jobs for the current user.

---

#### **Example Task 4: Schedule a System-Wide Cron Job**

**Task:** Schedule a system-wide cron job to run a script **`/opt/scripts/backup.sh`** at **3 AM** every Sunday.

1. **Edit the system-wide crontab file**:
   ```bash
   sudo nano /etc/crontab
   ```

2. **Add the following line**:
   ```
   0 3 * * 0 root /opt/scripts/backup.sh
   ```

3. **Save and exit**.

**Explanation**:
- **`0 3 * * 0`**: This cron job will run every Sunday at **3:00 AM**.
- **`root`**: The job runs as the `root` user.

---

### **3. Managing Cron Permissions**

You can control which users can schedule cron jobs using the **`/etc/cron.allow`** and **`/etc/cron.deny`** files.

- **`/etc/cron.allow`**: If this file exists, only users listed in it can use `cron`.
- **`/etc/cron.deny`**: Users listed here cannot use `cron` (if `cron.allow` doesn’t exist).

#### **Example Task 5: Restrict a User from Scheduling Cron Jobs**

**Task:** Prevent the user **`bob`** from scheduling cron jobs.

1. **Edit `/etc/cron.deny`**:
   ```bash
   sudo nano /etc/cron.deny
   ```

2. **Add the username `bob`** to the file:
   ```
   bob
   ```

3. **Save and exit**.

**Explanation**:
- The user `bob` will now be blocked from using `cron` to schedule jobs.

---

### **4. Viewing Cron Logs**

To verify that cron jobs have run successfully, you can check the cron logs.

#### **Example Task 6: Check Cron Logs**

1. **View the cron logs** in **`/var/log/cron`**:
   ```bash
   sudo tail -f /var/log/cron
   ```

**Explanation**:
- **`/var/log/cron`** contains log entries for cron job executions. This is useful for troubleshooting scheduled jobs.

---

### **5. Scheduling Tasks Using `cron.d`**

In addition to user-specific and system-wide crontabs, **`/etc/cron.d`** is used to create files for specific jobs that can be scheduled with **custom timing** and **user settings**.

#### **Example Task 7: Schedule a Task Using `cron.d`**

**Task:** Create a cron job in **`/etc/cron.d`** to run the script **`/opt/scripts/cleanup.sh`** every day at 11:30 PM as the user `root`.

1. **Create a new file in `/etc/cron.d`**:
   ```bash
   sudo nano /etc/cron.d/cleanup
   ```

2. **Add the following line** to the file:
   ```
   30 23 * * * root /opt/scripts/cleanup.sh
   ```

3. **Save and exit**.

**Explanation**:
- The job will run every day at **11:30 PM**.
- **`root`** ensures that the job runs with root privileges.

---

### Summary of Skills for RHCSA Exam on Scheduling Tasks Using `at` and `cron`:
1. **Schedule one-time tasks** using `at` and list/remove scheduled jobs with `atq` and `atrm`.
2. **Schedule recurring tasks** using `cron` for both user-specific and system-wide jobs.
3. **Use `crontab -e`** to create or edit user-specific cron jobs and `crontab -l` to list them.
4. **Configure cron permissions** using `/etc/cron.allow` and `/etc/cron.deny` to control which users can schedule cron jobs.
5. **Monitor cron jobs** using **`/var/log/cron`** to ensure they are running correctly.

