## 02- Manage default file permissions:

The RHCSA exam topic **"Manage default file permissions"** focuses on how to control the default permissions assigned to files and directories when they are created. This is handled primarily through the **umask** setting, which dictates the default permissions given to new files and directories. Understanding and configuring default file permissions ensures proper security and access control in a RHEL system.

### **What You Need to Know for the RHCSA Exam:**
1. **File and Directory Permissions Basics**: Understanding the `rwx` (read, write, execute) permissions.
2. **Umask**: How the **umask** value controls default permissions for new files and directories.
3. **Setting Umask for Users**: How to permanently set a **umask** value for users.
4. **Testing and Verifying Umask**: How to create files and directories to verify the configured permissions.
5. **Special Permissions**: Brief knowledge of setuid, setgid, and sticky bit, though not deeply covered for default permissions.

---

### **1. Understanding File and Directory Permissions**

In Linux, files and directories have three types of permissions: **read (r)**, **write (w)**, and **execute (x)**. These permissions are assigned to three groups: **user (owner)**, **group**, and **others**.

- Files typically need **read** and **write** permissions for the owner and group, and sometimes **read** for others.
- Directories need **execute** permission for the owner, group, and others to allow access.

#### **Common Permission Values**:
- `rwx` = Read, Write, Execute (7)
- `rw-` = Read, Write (6)
- `r--` = Read only (4)
- `---` = No permissions (0)

---

### **2. Umask Overview**

The **umask** (user file creation mask) controls the default permissions given to new files and directories. **Umask** subtracts permissions from the maximum possible permissions when a file or directory is created.

- The default permissions for files are **666** (`rw-rw-rw-`), meaning everyone can read and write.
- The default permissions for directories are **777** (`rwxrwxrwx`), meaning everyone can read, write, and execute.

**Umask** removes permission bits from these defaults. For example:
- If umask is `0022`, files will be created with **644** (`rw-r--r--`) and directories with **755** (`rwxr-xr-x`).

#### **Example Task 1: View Current Umask Setting**

**Task:** Check the current umask value.

1. **View the umask value**:
   ```bash
   umask
   ```

#### **Example Output**:
```
0022
```

**Explanation**:
- The umask value **0022** results in files being created with **644** permissions and directories with **755** permissions.
  - **Files**: `666 - 022 = 644`
  - **Directories**: `777 - 022 = 755`

---

### **3. Setting Umask Temporarily**

You can set the **umask** value temporarily in a shell session by running the **`umask`** command. This change will only affect the current session.

#### **Example Task 2: Set Umask Temporarily to 027**

**Task:** Temporarily set the umask value to `0027`, ensuring new files are created with **640** permissions and directories with **750** permissions.

1. **Set umask to 027**:
   ```bash
   umask 0027
   ```

2. **Verify the new umask value**:
   ```bash
   umask
   ```

3. **Create a new file and directory to test**:
   ```bash
   touch testfile
   mkdir testdir
   ```

4. **Check the permissions of the new file and directory**:
   ```bash
   ls -l testfile testdir
   ```

#### **Expected Output**:
```
-rw-r----- 1 user user 0 Sep 29 10:10 testfile
drwxr-x--- 2 user user 6 Sep 29 10:10 testdir
```

**Explanation**:
- A umask of `0027` results in **640** permissions for files (`rw-r-----`) and **750** for directories (`rwxr-x---`).
  - **Files**: `666 - 027 = 640`
  - **Directories**: `777 - 027 = 750`

---

### **4. Making Umask Changes Persistent**

To make **umask** changes persistent, you must set it in the user’s shell configuration files (such as **`~/.bashrc`** or **`/etc/profile`** for global settings).

#### **Example Task 3: Permanently Set Umask to 007 for All Users**

**Task:** Configure the **umask** to **007** globally, ensuring new files have **660** permissions and new directories have **770** permissions for all users.

1. **Open the global profile file**:
   ```bash
   sudo vi /etc/profile
   ```

2. **Add or modify the umask setting**:
   ```bash
   umask 0007
   ```

3. **Save and exit**.

4. **Log out and log back in to apply the change**.

5. **Verify the new umask value**:
   ```bash
   umask
   ```

6. **Create a test file and directory to check permissions**:
   ```bash
   touch testfile2
   mkdir testdir2
   ls -l testfile2 testdir2
   ```

#### **Expected Output**:
```
-rw-rw---- 1 user user 0 Sep 29 10:15 testfile2
drwxrwx--- 2 user user 6 Sep 29 10:15 testdir2
```

**Explanation**:
- A **umask** of `0007` results in **660** permissions for files and **770** permissions for directories.
  - **Files**: `666 - 007 = 660`
  - **Directories**: `777 - 007 = 770`

---

### **5. Verifying and Troubleshooting**

After configuring **umask**, you should always verify the changes by creating test files and directories. Use the **`ls -l`** command to check the permissions of the newly created items.

#### **Example Task 4: Verify Default Permissions**

**Task:** Create a new file and directory and verify the default permissions are as expected based on the **umask** setting.

1. **Create a new file**:
   ```bash
   touch newfile
   ```

2. **Create a new directory**:
   ```bash
   mkdir newdir
   ```

3. **Check permissions**:
   ```bash
   ls -l newfile newdir
   ```

#### **Expected Output (for a `umask` of 0027)**:
```
-rw-r----- 1 user user 0 Sep 29 10:20 newfile
drwxr-x--- 2 user user 6 Sep 29 10:20 newdir
```

---

### **6. Special Considerations: Special Permissions**

For the RHCSA exam, while not explicitly required for **umask**, it's useful to have a brief understanding of **special permissions**:
1. **Setuid**: Set on an executable file so that the file runs with the permissions of the file owner.
2. **Setgid**: Set on a directory to ensure that files created within inherit the group ownership of the directory.
3. **Sticky Bit**: Set on a directory to restrict file deletion; only the file owner or root can delete files.

---

### **Summary of Skills for RHCSA Exam on Managing Default File Permissions**:
1. **View and understand the current umask** using the `umask` command.
2. **Temporarily set a new umask** for the current session to control default file and directory permissions.
3. **Permanently set umask** by editing the user’s shell configuration file or the global `/etc/profile` file.
4. **Test the umask settings** by creating new files and directories to verify the default permissions.
5. **Understand basic file permissions** and how **umask** subtracts from the default values (666 for files, 777 for directories).