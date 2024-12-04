## 01- Conditionally execute code use of if, test, [], etc:

The RHCSA exam topic **"Conditionally execute code (use of: if, test, [], etc.) in shell script"** is essential because scripting is a key part of system administration. You’ll need to demonstrate how to execute commands conditionally using shell scripting constructs like **`if`**, **`test`**, and the **`[]`** syntax. This is typically used to control the flow of a script based on conditions such as file existence, string comparison, and numerical tests.

---

### **What You Need to Know:**
1. **`if-else` statements** for conditionally executing commands based on a condition.
2. **`test` and `[]`** for evaluating conditions such as file existence, string comparisons, and numerical comparisons.
3. **Logical operators** (`-a`, `-o`, `!`) for combining conditions.
4. **Return codes** (`0` for success, non-zero for failure) for testing command success or failure.
5. **File and directory tests** (`-e`, `-f`, `-d`, etc.).
6. **String and numeric comparisons**.

---

### **1. Using `if` Statements for Conditional Execution**

The `if` statement allows you to execute code based on whether a condition is true or false.

#### **Example Task 1: Check if a File Exists**

**Task:** Write a shell script to check if the file `/etc/passwd` exists and print a message if it does.

**Script:**
```bash
#!/bin/bash
if [ -e /etc/passwd ]; then
    echo "The file /etc/passwd exists."
else
    echo "The file /etc/passwd does not exist."
fi
```

**Explanation:**
- **`if [ -e /etc/passwd ]`**: The `-e` option checks if the file exists.
- **`then`**: If the file exists, it prints "The file /etc/passwd exists."
- **`else`**: If the file doesn’t exist, it prints "The file /etc/passwd does not exist."
- **`fi`**: Ends the `if` block.

---

### **2. Using `test` and `[]` for File Tests**

The `test` command or `[]` are used to evaluate conditions inside the `if` statement. These can be used for file tests, string comparisons, and numerical operations.

#### **Example Task 2: Check if a Directory Exists**

**Task:** Write a shell script that checks if the directory `/var/log` exists and prints a message if it does.

**Script:**
```bash
#!/bin/bash
if test -d /var/log; then
    echo "/var/log is a directory."
else
    echo "/var/log is not a directory."
fi
```

**Or using `[]` (preferred in many cases):**
```bash
#!/bin/bash
if [ -d /var/log ]; then
    echo "/var/log is a directory."
else
    echo "/var/log is not a directory."
fi
```

**Explanation:**
- **`test -d /var/log`** or **`[ -d /var/log ]`** checks if `/var/log` is a directory.
- `-d` tests if the argument is a directory.

---

### **3. Numeric Comparisons**

You can use the `-eq`, `-ne`, `-lt`, `-le`, `-gt`, and `-ge` operators for numeric comparisons.

#### **Example Task 3: Compare Two Numbers**

**Task:** Write a shell script to compare two numbers, `5` and `10`, and print which one is larger.

**Script:**
```bash
#!/bin/bash
num1=5
num2=10
if [ $num1 -gt $num2 ]; then
    echo "$num1 is greater than $num2"
else
    echo "$num1 is less than or equal to $num2"
fi
```

**Explanation:**
- **`-gt`**: Greater than.
- **`$num1` and `$num2`**: Variables holding numeric values.

---

### **4. String Comparisons**

You can use `=` and `!=` for string comparisons, as well as `-z` (empty string) and `-n` (non-empty string) to check for the presence of values.

#### **Example Task 4: Check if a String is Empty**

**Task:** Write a shell script to check if the variable `mystring` is empty.

**Script:**
```bash
#!/bin/bash
mystring=""
if [ -z "$mystring" ]; then
    echo "The string is empty."
else
    echo "The string is not empty."
fi
```

**Explanation:**
- **`-z`**: Checks if the string length is zero (i.e., the string is empty).
- **`"$mystring"`**: The variable that holds the string.

---

### **5. Use of Logical Operators (`-a`, `-o`, `!`)**

Logical operators allow you to combine conditions:
- **`-a`**: AND
- **`-o`**: OR
- **`!`**: NOT

#### **Example Task 5: Combine Conditions Using AND and OR**

**Task:** Write a shell script that checks if the file `/etc/passwd` exists **and** is readable.

**Script:**
```bash
#!/bin/bash
if [ -e /etc/passwd -a -r /etc/passwd ]; then
    echo "/etc/passwd exists and is readable."
else
    echo "/etc/passwd does not exist or is not readable."
fi
```

**Explanation:**
- **`-a`**: Combines the conditions (file exists **and** file is readable).
- **`-r`**: Checks if the file is readable.

#### **Example Task 6: Negate a Condition**

**Task:** Write a shell script that checks if a file `/tmp/testfile` does **not** exist.

**Script:**
```bash
#!/bin/bash
if [ ! -e /tmp/testfile ]; then
    echo "The file /tmp/testfile does not exist."
else
    echo "The file /tmp/testfile exists."
fi
```

**Explanation:**
- **`! -e`**: Negates the condition, checking if the file does **not** exist.

---

### **6. Using Return Codes to Check Command Success**

In shell scripting, commands return an exit status:
- `0` for success.
- Non-zero values indicate failure.

You can use this return code to check whether a command succeeded or failed.

#### **Example Task 7: Check If a Command Succeeded**

**Task:** Write a shell script that checks if the `mkdir` command was successful.

**Script:**
```bash
#!/bin/bash
mkdir /tmp/mydirectory
if [ $? -eq 0 ]; then
    echo "Directory created successfully."
else
    echo "Failed to create directory."
fi
```

**Explanation:**
- **`$?`**: Holds the exit status of the last command.
- **`-eq 0`**: Checks if the exit status is 0, meaning the command was successful.

---

### **7. Case Study: Combining Conditions in a Practical Script**

#### **Example Task 8: File Backup Script Based on Conditions**

**Task:** Write a shell script that checks if the `/etc/passwd` file exists and is readable. If it is, back it up to `/tmp/passwd.bak`.

**Script:**
```bash
#!/bin/bash
if [ -e /etc/passwd -a -r /etc/passwd ]; then
    cp /etc/passwd /tmp/passwd.bak
    if [ $? -eq 0 ]; then
        echo "Backup successful."
    else
        echo "Backup failed."
    fi
else
    echo "/etc/passwd does not exist or is not readable."
fi
```

**Explanation:**
- The first `if` statement checks if `/etc/passwd` exists and is readable.
- If both conditions are true, it attempts to back up the file using `cp`.
- The second `if` checks the exit status of `cp` to verify if the backup was successful.

---

### Summary of Skills for RHCSA Exam on Conditional Execution:
1. **Use `if`, `test`, and `[]`** to conditionally execute code based on file tests, string comparisons, and numeric tests.
2. **Perform logical operations** with `-a` (AND), `-o` (OR), and `!` (NOT).
3. **Check return codes** of commands to determine success or failure.
4. **Combine multiple conditions** in scripts for practical, real-world tasks.
5. Understand and use the **standard file tests** like `-e`, `-f`, `-d`, `-r`, and more.

