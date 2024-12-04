## 03- Process script inputs ($1, $2, etc.):

The RHCSA exam topic **"Process script inputs (`$1`, `$2`, etc.)"** focuses on handling positional parameters in shell scripts. Positional parameters are used to pass arguments to a script and are crucial for making scripts dynamic and flexible. This topic tests your ability to handle command-line inputs within scripts using variables like **`$1`, `$2`**, and others, allowing you to process user-provided data.


---

### **What You Need to Know:**
1. **Positional Parameters**: `$1`, `$2`, etc., represent command-line arguments passed to the script.
2. **Special Variables**:
   - `$0`: The name of the script.
   - `$#`: The number of arguments passed.
   - `$@` and `$*`: All arguments passed to the script.
   - `"$@"`: Treats each argument as a separate string (preserves spaces).
   - `$?`: The exit status of the last command.

---

### **1. Accessing Script Arguments**

Positional parameters like **`$1`, `$2`**, etc., allow you to access command-line arguments passed to the script. These arguments can be filenames, numbers, or any other data.

#### **Example Task 1: Print Command-Line Arguments**

**Task:** Write a shell script that prints the first and second arguments passed to it.

**Script:**
```bash
#!/bin/bash
echo "First argument: $1"
echo "Second argument: $2"
```

#### **Example Command:**
```bash
./script.sh apple banana
```

#### **Example Output:**
```
First argument: apple
Second argument: banana
```

**Explanation:**
- **`$1`** accesses the first argument (`apple`).
- **`$2`** accesses the second argument (`banana`).

---

### **2. Checking the Number of Arguments**

You can use **`$#`** to check how many arguments were passed to the script, which is useful for validating input.

#### **Example Task 2: Check if Exactly Two Arguments Are Passed**

**Task:** Write a shell script that checks if exactly two arguments are passed. If not, print an error message.

**Script:**
```bash
#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Error: You must provide exactly two arguments."
    exit 1
fi
echo "First argument: $1"
echo "Second argument: $2"
```

#### **Example Command 1 (with incorrect number of arguments):**
```bash
./script.sh apple
```

#### **Example Output 1:**
```
Error: You must provide exactly two arguments.
```

#### **Example Command 2 (with correct number of arguments):**
```bash
./script.sh apple banana
```

#### **Example Output 2:**
```
First argument: apple
Second argument: banana
```

**Explanation:**
- **`$#`** counts the number of arguments passed to the script.
- If the count is not equal to 2 (`-ne 2`), it exits with an error message.

---

### **3. Using All Arguments with `$@` and `$*`**

Both **`$@`** and **`$*`** represent all arguments passed to the script. The difference is in how they treat quoted arguments:
- **`"$@"`**: Treats each argument separately (preserves spaces).
- **`"$*"`**: Treats all arguments as a single string.

#### **Example Task 3: Print All Arguments**

**Task:** Write a shell script that prints all the arguments passed to it.

**Script:**
```bash
#!/bin/bash
echo "All arguments with \$@:"
for arg in "$@"; do
    echo "$arg"
done

echo "All arguments with \$*:"
for arg in "$*"; do
    echo "$arg"
done
```

#### **Example Command:**
```bash
./script.sh "apple pie" banana cherry
```

#### **Example Output:**
```
All arguments with $@:
apple pie
banana
cherry
All arguments with $*:
apple pie banana cherry
```

**Explanation:**
- **`"$@"`** treats `"apple pie"` as one argument.
- **`"$*"`** treats all arguments as a single string.

---


### **4. Using Script Arguments in Real-World Scenarios**

#### **Example Task 5: Copy Files Passed as Arguments**

**Task:** Write a script that takes two arguments: a source file and a destination directory. It checks if the source file exists and then copies it to the destination.

**Script:**
```bash
#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_file> <destination_directory>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: $1 is not a file."
    exit 2
fi

if [ ! -d "$2" ]; then
    echo "Error: $2 is not a directory."
    exit 3
fi

cp "$1" "$2"
echo "File $1 copied to $2."
```

#### **Example Command 1 (with correct arguments):**
```bash
./script.sh /etc/passwd /tmp/
```

#### **Example Output 1:**
```
File /etc/passwd copied to /tmp/.
```

#### **Example Command 2 (with missing file):**
```bash
./script.sh /etc/missingfile /tmp/
```

#### **Example Output 2:**
```
Error: /etc/missingfile is not a file.
```

**Explanation:**
- **`$0`**: Refers to the script name, used in the usage message.
- **`$1`**: The source file.
- **`$2`**: The destination directory.
- The script checks if exactly two arguments are passed and verifies that the first argument is a file and the second is a directory.

---

### **5. Using `$?` for Command Success or Failure**

The special variable **`$?`** holds the exit status of the last command. `0` indicates success, and any other value indicates failure.

#### **Example Task 6: Check If a Command Succeeds**

**Task:** Write a script that takes a command as an argument, runs it, and checks if it succeeds.

**Script:**
```bash
#!/bin/bash
"$@"
if [ $? -eq 0 ]; then
    echo "Command succeeded."
else
    echo "Command failed."
fi
```

#### **Example Command 1 (successful command):**
```bash
./script.sh ls /tmp
```

#### **Example Output 1:**
```
Command succeeded.
```

#### **Example Command 2 (failing command):**
```bash
./script.sh ls /nonexistent
```

#### **Example Output 2:**
```
Command failed.
```

**Explanation:**
- **`"$@"`** runs the entire command passed to the script.
- **`$?`** checks the exit status of the command to determine if it succeeded.

---

### Summary of Skills for RHCSA Exam on Processing Script Inputs:
1. **Access positional parameters** using `$1`, `$2`, etc.
2. **Count arguments** with `$#` and validate input length.
3. **Handle all arguments** using `$@`, `$*`, and understand the differences.
4. **Check command success** using `$?` to handle error reporting.
