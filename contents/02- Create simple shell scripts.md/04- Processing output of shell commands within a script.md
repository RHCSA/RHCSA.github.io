## 04- Processing output of shell commands within a script:

The RHCSA exam topic **"Processing output of shell commands within a script"** is crucial because it involves capturing and using the output of shell commands in a script. This skill is essential for creating dynamic and flexible scripts that respond to system information or user input. Shell commands like `ls`, `grep`, `df`, and others can be used within scripts to gather data, which can then be processed using conditionals, loops, or redirections.

---

### **What You Need to Know:**
1. **Command substitution**: Use backticks (`` `command` ``) or `$(command)` to capture and use the output of a shell command in a script.
2. **Using output in variables**: Assign command output to variables for further processing.
3. **Piping and redirection**: Process the output of one command using pipes (`|`) to pass it to another command.
4. **Conditional processing of command output** using `if`, `while`, and other constructs.

---

### **1. Using Command Substitution to Capture Output**

Command substitution allows you to capture the output of a command and use it within your script. You can use either backticks (`` `command` ``) or `$(command)`.

#### **Example Task 1: Capture Output of a Command in a Variable**

**Task:** Write a shell script that captures the current date and prints a message with the date.

**Script:**
```bash
#!/bin/bash
current_date=$(date)
echo "Today's date is: $current_date"
```

**Explanation:**
- **`$(date)`** captures the output of the `date` command and assigns it to the variable `current_date`.
- The script then prints the message "Today's date is:" followed by the current date.

#### **Example Output:**
```
Today's date is: Tue Sep 26 14:30:15 UTC 2024
```

---

### **2. Using Command Substitution in Conditional Statements**

You can use command substitution inside an `if` or other conditional structure to act based on the output of a command.

#### **Example Task 2: Check Disk Space Usage**

**Task:** Write a shell script that checks the disk usage of `/` and prints a warning if it exceeds 80%.

**Script:**
```bash
#!/bin/bash
disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//')

if [ $disk_usage -gt 80 ]; then
    echo "Warning: Disk usage is above 80%."
else
    echo "Disk usage is under control."
fi
```

**Explanation:**
- **`df /`** gives disk space usage for `/`.
- **`grep /`** filters the output for the root partition.
- **`awk '{print $5}'`** extracts the percentage used.
- **`sed 's/%//'`** removes the `%` symbol to get a numeric value.
- The script checks if disk usage is greater than 80 and prints a message accordingly.

#### **Example Output (if disk usage > 80%):**
```
Warning: Disk usage is above 80%.
```

#### **Example Output (if disk usage <= 80%):**
```
Disk usage is under control.
```

---

### **3. Using Command Substitution in Loops**

Command substitution is often used within loops to process the output of commands like `ls`, `cat`, `grep`, or others that return multiple lines of data.

#### **Example Task 3: Loop Over Files in a Directory**

**Task:** Write a shell script that lists all `.txt` files in `/home/examuser/docs/` and prints the filename for each file.

**Script:**
```bash
#!/bin/bash
for file in $(ls /home/examuser/docs/*.txt); do
    echo "Processing file: $file"
done
```

**Explanation:**
- **`$(ls /home/examuser/docs/*.txt)`** captures the list of `.txt` files in the directory.
- The `for` loop iterates over each file and prints the message "Processing file:" followed by the file name.

#### **Example Output:**
```
Processing file: /home/examuser/docs/file1.txt
Processing file: /home/examuser/docs/file2.txt
...
```

---

### **4. Using Piping and Redirection**

You can use pipes (`|`) to chain commands together, sending the output of one command as input to another. You can also redirect output to files using `>` or `>>`.

#### **Example Task 4: Find Active Users and Save to a File**

**Task:** Write a script that lists all logged-in users and saves the list to `/home/examuser/users.txt`.

**Script:**
```bash
#!/bin/bash
who | awk '{print $1}' > /home/examuser/users.txt
echo "Active users have been saved to /home/examuser/users.txt"
```

**Explanation:**
- **`who`** lists all logged-in users.
- **`awk '{print $1}'`** extracts the usernames (first column).
- **`>`** redirects the output to the file `/home/examuser/users.txt`.

#### **Example Output (saved in `/home/examuser/users.txt`):**
```
examuser
admin
...
```

---

### **5. Using Output of One Command as Input for Another**

In shell scripting, you can use output from one command as input to another without storing the intermediate result in a variable.

#### **Example Task 5: Find and Display the Largest File in a Directory**

**Task:** Write a shell script that finds and prints the largest file in `/var/log`.

**Script:**
```bash
#!/bin/bash
largest_file=$(ls -S /var/log | head -n 1)
echo "The largest file in /var/log is: $largest_file"
```

**Explanation:**
- **`ls -S /var/log`** lists files in `/var/log` sorted by size (largest first).
- **`head -n 1`** extracts the first (largest) file.
- The script prints the name of the largest file.

---

### **6. Real-World Example: Backup Script Using Command Output**

#### **Example Task 6: Automated Backup Based on Command Output**

**Task:** Write a script that backs up `/etc/passwd` if it exists and saves it to `/tmp/passwd.bak`. If the file doesn’t exist, print an error message.

**Script:**
```bash
#!/bin/bash
if [ -e /etc/passwd ]; then
    cp /etc/passwd /tmp/passwd.bak
    echo "Backup of /etc/passwd saved to /tmp/passwd.bak"
else
    echo "Error: /etc/passwd does not exist."
fi
```

**Explanation:**
- **`if [ -e /etc/passwd ]`** checks if the file exists.
- **`cp /etc/passwd /tmp/passwd.bak`** creates a backup.
- If the file doesn’t exist, an error message is printed.

---

### **7. Complex Command Processing: Checking Multiple Conditions**

#### **Example Task 7: Check If a Service Is Running and Disk Space is Available**

**Task:** Write a script that checks if the `sshd` service is running and if the disk usage on `/` is below 90%. If both conditions are true, print a success message; otherwise, print an appropriate error message.

**Script:**
```bash
#!/bin/bash
service_status=$(systemctl is-active sshd)
disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//')

if [ "$service_status" = "active" ] && [ $disk_usage -lt 90 ]; then
    echo "The sshd service is running and disk usage is below 90%."
else
    if [ "$service_status" != "active" ]; then
        echo "Error: sshd service is not running."
    fi
    if [ $disk_usage -ge 90 ]; then
        echo "Error: Disk usage is above 90%."
    fi
fi
```

**Explanation:**
- **`systemctl is-active sshd`** checks if the `sshd` service is active.
- **`df /`**, **`grep /`**, and **`awk`** extract the disk usage percentage.
- The script checks if both conditions are met using `&&`, and prints appropriate error messages if either condition fails.

#### **Example Output (if both conditions are true):**
```
The sshd service is running and disk usage is below 90%.
```

#### **Example Output (if `sshd` is not running and disk usage is high):**
```
Error: sshd service is not running.
Error: Disk usage is above 90%.
```

---

### **Summary of Skills for RHCSA Exam on Processing Output of Shell Commands:**
1. **Use command substitution** (`$(command)` or `` `command` ``) to capture output for use in scripts.
2. **Store command output in variables** for processing.
3. **Use pipes (`|`) and redirection (`>` or `>>`)** to pass output between commands or save to files.
4. **Process command output in conditionals** (e.g., `if`, `while`) to make decisions based on system data.
5. **Combine multiple commands** in a script to solve real-world problems, like checking service status or disk space.

