## 08- Create, delete, copy, and move files and directories

The RHCSA exam topic **"Create, delete, copy, and move files and directories"** is essential because managing files and directories is a daily task for system administrators. You need to be proficient in using basic commands like `touch`, `mkdir`, `cp`, `mv`, and `rm` for file and directory operations.

---

### **What You Need to Know:**
1. **Creating files** using `touch`, text editors, or redirection.
2. **Creating directories** using `mkdir`.
3. **Copying files and directories** using `cp`.
4. **Moving or renaming files and directories** using `mv`.
5. **Deleting files and directories** using `rm` and `rmdir`.
6. **Using wildcards** to manipulate multiple files at once.
7. Understanding recursive options (e.g., `-r`) for directories.

---

### **1. Creating Files**

The simplest way to create an empty file is with the `touch` command. You can also create files using redirection or by using a text editor like `vim` or `nano`.

#### **Example Task 1: Create an Empty File**

**Task:** Create an empty file called `example.txt` in the `/home/examuser` directory.

**Command:**
```bash
touch /home/examuser/example.txt
```

**Explanation:**
- **`touch`** creates an empty file if it doesn’t already exist. If the file exists, it updates the file’s modification timestamp.

---

### **2. Creating Directories**

Use the `mkdir` command to create directories. You can also create nested directories using the `-p` option.

#### **Example Task 2: Create a Directory**

**Task:** Create a directory called `/home/examuser/mydir`.

**Command:**
```bash
mkdir /home/examuser/mydir
```

#### **Example Task 3: Create Nested Directories**

**Task:** Create nested directories `/home/examuser/project/subdir`.

**Command:**
```bash
mkdir -p /home/examuser/project/subdir
```

**Explanation:**
- **`-p`** ensures that all parent directories (`/project/`) are created if they do not already exist.

---

### **3. Copying Files**

The `cp` command copies files and directories. For directories, you need to use the `-r` (recursive) option.

#### **Example Task 4: Copy a File**

**Task:** Copy the file `/home/examuser/example.txt` to `/home/examuser/backup/`.

**Command:**
```bash
cp /home/examuser/example.txt /home/examuser/backup/
```

**Explanation:**
- This command copies `example.txt` to the `/home/examuser/backup/` directory.

#### **Example Task 5: Copy a Directory**

**Task:** Copy the directory `/home/examuser/mydir` and all its contents to `/home/examuser/backup/`.

**Command:**
```bash
cp -r /home/examuser/mydir /home/examuser/backup/
```

**Explanation:**
- **`-r`** allows for recursive copying, meaning it will copy all files and subdirectories within `/home/examuser/mydir`.

---

### **4. Moving or Renaming Files**

The `mv` command is used for both moving and renaming files or directories.

#### **Example Task 6: Move a File**

**Task:** Move the file `/home/examuser/example.txt` to `/home/examuser/docs/`.

**Command:**
```bash
mv /home/examuser/example.txt /home/examuser/docs/
```

**Explanation:**
- This command moves the file from `/home/examuser/` to the `/home/examuser/docs/` directory.

#### **Example Task 7: Rename a File**

**Task:** Rename the file `/home/examuser/docs/example.txt` to `example1.txt`.

**Command:**
```bash
mv /home/examuser/docs/example.txt /home/examuser/docs/example1.txt
```

**Explanation:**
- **`mv`** can also be used to rename files. In this case, it renames `example.txt` to `example1.txt`.

#### **Example Task 8: Move a Directory**

**Task:** Move the directory `/home/examuser/mydir` to `/home/examuser/docs/`.

**Command:**
```bash
mv /home/examuser/mydir /home/examuser/docs/
```

**Explanation:**
- This command moves the entire directory `/mydir` to the `/docs/` directory.

---

### **5. Deleting Files**

Use the `rm` command to delete files. Be careful with `rm`, especially when used with the `-r` option.

#### **Example Task 9: Delete a File**

**Task:** Delete the file `/home/examuser/docs/example1.txt`.

**Command:**
```bash
rm /home/examuser/docs/example1.txt
```

**Explanation:**
- This deletes the specified file.

#### **Example Task 10: Delete Multiple Files Using Wildcards**

**Task:** Delete all `.txt` files in the `/home/examuser/docs` directory.

**Command:**
```bash
rm /home/examuser/docs/*.txt
```

**Explanation:**
- The wildcard `*.txt` matches all files with the `.txt` extension in the directory.

---

### **6. Deleting Directories**

To delete directories, you need to use the `-r` (recursive) option. **`rmdir`** is used for removing empty directories.

#### **Example Task 11: Remove an Empty Directory**

**Task:** Remove the empty directory `/home/examuser/emptydir`.

**Command:**
```bash
rmdir /home/examuser/emptydir
```

**Explanation:**
- **`rmdir`** removes an empty directory. If the directory is not empty, it will fail.

#### **Example Task 12: Remove a Directory and Its Contents**

**Task:** Delete the directory `/home/examuser/backup` and all its contents.

**Command:**
```bash
rm -r /home/examuser/backup
```

**Explanation:**
- **`rm -r`** removes a directory and all its contents (files and subdirectories).

---

### **7. Combining Operations**

You may need to copy, move, or delete multiple files at once using **wildcards** or multiple commands.

#### **Example Task 13: Copy Multiple Files**

**Task:** Copy all `.log` and `.conf` files from `/var/log` to `/home/examuser/logbackup/`.

**Command:**
```bash
cp /var/log/*.log /var/log/*.conf /home/examuser/logbackup/
```

**Explanation:**
- Wildcards are used to select all `.log` and `.conf` files in `/var/log`.

---

### **Summary of Skills for RHCSA Exam on File/Directory Management:**
1. **Create files** using `touch` or by redirecting output.
2. **Create directories** using `mkdir` (and `-p` for nested directories).
3. **Copy files and directories** using `cp` (with `-r` for recursive copying).
4. **Move and rename files and directories** using `mv`.
5. **Delete files and directories** using `rm` and `rmdir` (with `-r` for recursive deletion).
6. **Use wildcards** to manipulate multiple files in one command.
7. Be aware of **recursive operations** to ensure you handle files and directories properly.
