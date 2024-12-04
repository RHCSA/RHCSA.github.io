## 02- Use Looping constructs (for, etc.) to process file, command line input:

The RHCSA exam topic **"Use Looping constructs (for, etc.) to process file, command line input in shell scripts"** is fundamental for automating repetitive tasks in Linux. Looping constructs, especially `for`, allow you to process multiple files, iterate over command output, or handle arguments passed to a script.


---

### **What You Need to Know:**
1. **`for` loops**: Used to iterate over a list of values, such as filenames, command-line arguments, or command output.
2. **`while` loops**: Execute a block of code while a certain condition is true.
3. **`until` loops**: Execute a block of code until a condition becomes true.
4. **Process command-line arguments** in loops.
5. **Using loops to handle files** or command output.

---

### **1. Using a `for` Loop to Iterate Over a List of Files**

A **`for` loop** is commonly used to iterate over files or a list of values.

#### **Example Task 1: Use a `for` Loop to List File Details**

**Task:** Write a shell script that prints the details of all `.txt` files in the `/home/examuser/docs` directory.

**Script:**
```bash
#!/bin/bash
for file in /home/examuser/docs/*.txt; do
    ls -l "$file"
done
```

**Explanation:**
- The **`for`** loop iterates over all `.txt` files in the `/home/examuser/docs` directory.
- `ls -l "$file"` prints detailed information for each file.
- **`"$file"`** is used to handle filenames with spaces or special characters.

---

### **2. Processing Command-Line Arguments Using a `for` Loop**

You can use `for` loops to process arguments passed to a script.

#### **Example Task 2: Loop Over Command-Line Arguments**

**Task:** Write a shell script that takes multiple filenames as arguments and displays whether each file exists or not.

**Script:**
```bash
#!/bin/bash
for file in "$@"; do
    if [ -e "$file" ]; then
        echo "$file exists."
    else
        echo "$file does not exist."
    fi
done
```

**Explanation:**
- **`$@`** represents all command-line arguments passed to the script.
- The loop iterates over each file, checking if it exists using `[ -e "$file" ]`.
- A message is printed for each file, stating whether it exists.

#### **Example Command:**
```bash
./script.sh /etc/passwd /nonexistent/file
```

#### **Example Output:**
```
/etc/passwd exists.
/nonexistent/file does not exist.
```

---

### **3. Using a `for` Loop with Command Output**

You can also loop over the output of a command by capturing it into a `for` loop.

#### **Example Task 3: Loop Over Users from `/etc/passwd`**

**Task:** Write a shell script that prints a list of all usernames from `/etc/passwd`.

**Script:**
```bash
#!/bin/bash
for user in $(cut -d: -f1 /etc/passwd); do
    echo "User: $user"
done
```

**Explanation:**
- **`cut -d: -f1 /etc/passwd`** extracts the first field (the username) from the `/etc/passwd` file.
- The `for` loop iterates over each username, printing it with `echo`.

---

### **4. Using a `while` Loop with Conditions**

A `while` loop can also run while a condition remains true, allowing for repetitive execution.

#### **Example Task 5: Countdown Timer Using a `while` Loop**

**Task:** Write a shell script that counts down from 10 to 1.

**Script:**
```bash
#!/bin/bash
counter=10
while [ $counter -gt 0 ]; then
    echo "$counter"
    counter=$((counter - 1))
done
echo "Countdown complete!"
```

**Explanation:**
- **`while [ $counter -gt 0 ]`**: The loop continues as long as `counter` is greater than 0.
- **`counter=$((counter - 1))`**: Decreases the value of `counter` by 1 in each iteration.

---

### **5. Using an `until` Loop**

An **`until` loop** works similarly to a `while` loop, but it runs until a condition becomes true.

#### **Example Task 6: Use an `until` Loop to Wait for a File to Be Created**

**Task:** Write a shell script that waits until a file `/tmp/testfile` is created.

**Script:**
```bash
#!/bin/bash
until [ -e /tmp/testfile ]; then
    echo "Waiting for /tmp/testfile to be created..."
    sleep 2
done
echo "/tmp/testfile has been created!"
```

**Explanation:**
- **`until [ -e /tmp/testfile ]`**: The loop continues until `/tmp/testfile` exists.
- **`sleep 2`** pauses the script for 2 seconds between each check.

---

### **6. Nested `for` Loops**

You can also nest `for` loops inside one another to handle more complex tasks, such as iterating over multiple lists.

#### **Example Task 7: Nested Loop to Combine File Types**

**Task:** Write a shell script that creates backup copies of all `.txt` and `.log` files in `/home/examuser/docs` by appending `.bak` to each file name.

**Script:**
```bash
#!/bin/bash
for ext in txt log; do
    for file in /home/examuser/docs/*.$ext; do
        cp "$file" "$file.bak"
    done
done
```

**Explanation:**
- The outer loop iterates over the file extensions (`txt` and `log`).
- The inner loop finds files with those extensions and creates a backup copy by appending `.bak` to the filename.

---

### **7. Using a `for` Loop to Perform Operations in Parallel**

You can run commands in parallel using the `&` operator inside a loop.

#### **Example Task 8: Run Multiple Commands in Parallel**

**Task:** Write a shell script that pings three different servers (`8.8.8.8`, `8.8.4.4`, and `1.1.1.1`) simultaneously.

**Script:**
```bash
#!/bin/bash
for ip in 8.8.8.8 8.8.4.4 1.1.1.1; do
    ping -c 4 "$ip" &
done
wait
```

**Explanation:**
- **`&`**: Runs the `ping` commands in the background, allowing them to run simultaneously.
- **`wait`**: Ensures the script waits for all background processes to complete before finishing.

---

### Summary of Skills for RHCSA Exam on Looping Constructs:
1. **Use `for` loops** to iterate over files, command output, and arguments.
2. **Use `while` loops** to process input or run continuous tasks based on conditions.
3. **Use `until` loops** to execute code until a condition becomes true.
4. **Process command-line arguments** inside loops to handle multiple inputs.
5. **Combine loops** to handle nested or complex operations, such as iterating over multiple file types.
