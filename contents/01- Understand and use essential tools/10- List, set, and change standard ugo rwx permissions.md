## 10- List, set, and change standard ugo rwx permissions

The RHCSA exam topic **"List, set, and change standard ugo/rwx permissions"** focuses on managing file and directory permissions using the **user-group-other (UGO)** model and **read-write-execute (RWX)** permissions. This topic is essential for controlling access to files and directories in a multi-user Linux environment.

---

### **What You Need to Know:**
1. **UGO (User, Group, Other)** refers to who can access a file:
   - **User (u)**: The owner of the file.
   - **Group (g)**: Members of the group associated with the file.
   - **Other (o)**: Everyone else.

2. **RWX (Read, Write, Execute)** defines what actions can be taken:
   - **Read (r)**: View the contents of a file or list the contents of a directory.
   - **Write (w)**: Modify the contents of a file or create/delete files in a directory.
   - **Execute (x)**: Run the file as a program or enter a directory.

3. Permissions can be modified using:
   - **Symbolic notation** (e.g., `u+r`, `g-w`).
   - **Numeric (octal) notation** (e.g., `755`, `644`).

---

### **1. List Permissions of Files and Directories**

You need to know how to display the current permissions of files and directories using the **`ls -l`** command.

#### **Example Task 1: List the Permissions of a File**

**Task:** List the permissions of the file `example.txt`.

**Command:**
```bash
ls -l example.txt
```

#### **Example Output:**
```bash
-rw-r--r-- 1 examuser examgroup 1024 Sep 25 12:34 example.txt
```

**Explanation:**
- `-rw-r--r--`:
  - **User (owner)**: `rw-` (read and write, no execute).
  - **Group**: `r--` (read-only).
  - **Other**: `r--` (read-only).
- The first character (`-`) indicates that this is a **regular file** (as opposed to a directory or special file).
- `examuser`: The file's owner.
- `examgroup`: The group that the file belongs to.

---

### **2. Set Permissions Using Symbolic Notation**

Symbolic notation allows you to modify permissions for **user (u)**, **group (g)**, or **other (o)**. You can add or remove specific permissions.

#### **Example Task 2: Grant Execute Permission to the User**

**Task:** Add execute (`x`) permission to the owner (`user`) of `example.sh`.

**Command:**
```bash
chmod u+x example.sh
```

**Explanation:**
- `chmod`: Command to change file permissions.
- `u+x`: Adds execute permission for the user (owner).

You can verify the change with:
```bash
ls -l example.sh
```

---

### **3. Remove Permissions Using Symbolic Notation**

You might need to remove permissions using symbolic notation as well.

#### **Example Task 3: Remove Write Permission from Group**

**Task:** Remove write (`w`) permission from the group for `example.txt`.

**Command:**
```bash
chmod g-w example.txt
```

**Explanation:**
- `g-w`: Removes write permission for the group.

---

### **4. Set Permissions Using Numeric (Octal) Notation**

Numeric notation is commonly used for setting multiple permissions at once. It uses three digits to represent **user**, **group**, and **other** permissions, where:
- `4` = Read (`r`),
- `2` = Write (`w`),
- `1` = Execute (`x`),
- You sum these values to get the permission setting.

For example:
- **`7`** = `rwx` (read, write, execute),
- **`6`** = `rw-` (read, write),
- **`5`** = `r-x` (read, execute),
- **`4`** = `r--` (read-only).

#### **Example Task 4: Set Permissions to `755` for a Script**

**Task:** Set the permissions of `script.sh` to `755` (user: `rwx`, group: `r-x`, other: `r-x`).

**Command:**
```bash
chmod 755 script.sh
```

**Explanation:**
- `7` for the user (rwx).
- `5` for the group (r-x).
- `5` for others (r-x).

You can verify the change with:
```bash
ls -l script.sh
```

#### **Example Output:**
```bash
-rwxr-xr-x 1 examuser examgroup 4096 Sep 25 14:05 script.sh
```

---

### **5. Set Directory Permissions**

Permissions for directories control access in the same way as files, but with some important differences:
- **Read (r)**: Allows the user to list the contents of the directory.
- **Write (w)**: Allows the user to create or delete files within the directory.
- **Execute (x)**: Allows the user to **enter** the directory.

#### **Example Task 5: Set Directory Permissions to `700`**

**Task:** Set the permissions of the directory `/home/examuser/private` to `700` (only the owner can access).

**Command:**
```bash
chmod 700 /home/examuser/private
```

**Explanation:**
- `7` for the owner (rwx).
- `0` for the group (no permissions).
- `0` for others (no permissions).

This ensures that only the owner can read, write, and execute (access) the directory.

---

### **6. Change Ownership of a File or Directory**

Ownership is also part of managing permissions. You may need to change the **owner** or **group** of a file using the `chown` command.

#### **Example Task 6: Change the Owner of a File**

**Task:** Change the owner of `example.txt` to `adminuser`.

**Command:**
```bash
sudo chown adminuser example.txt
```

**Explanation:**
- `chown`: Command to change file owner and/or group.
- `adminuser`: The new owner.

#### **Example Task 7: Change the Group of a File**

**Task:** Change the group of `example.txt` to `admingroup`.

**Command:**
```bash
sudo chown :admingroup example.txt
```

**Explanation:**
- `:admingroup`: Changes the group ownership of the file.

---

### **7. Set Special Permissions (Setuid, Setgid, Sticky Bit)**

In addition to standard **UGO/rwx** permissions, there are **special permissions**:
1. **Setuid (Set User ID)**: When set on an executable file, the process runs with the file owner’s privileges.
   - Represented as `s` in the user permission position.
   - Numeric equivalent: **`4xxx`**.

2. **Setgid (Set Group ID)**: Similar to Setuid, but for group permissions. When applied to directories, new files inherit the group of the directory.
   - Represented as `s` in the group permission position.
   - Numeric equivalent: **`2xxx`**.

3. **Sticky Bit**: When set on a directory, only the file's owner (or root) can delete or rename files in the directory.
   - Represented as `t` in the others' execute position.
   - Numeric equivalent: **`1xxx`**.

#### **Example Task 8: Set the Setuid Bit**

**Task:** Set the Setuid bit on the file `example.bin`.

**Command:**
```bash
chmod u+s example.bin
```

#### **Example Task 9: Set the Setgid Bit on a Directory**

**Task:** Set the Setgid bit on the directory `/shared`.

**Command:**
```bash
chmod g+s /shared
```

**Explanation:**
- When the Setgid bit is set on a directory, all newly created files will inherit the directory's group.

#### **Example Task 10: Set the Sticky Bit on a Directory**

**Task:** Set the Sticky Bit on the directory `/var/tmp`.

**Command:**
```bash
chmod +t /var/tmp
```

**Explanation:**
- Setting the Sticky Bit on a directory ensures that only the owner of a file can delete or modify it, even if other users have write access to the directory.

---

### Summary of Skills for RHCSA Exam on File Permissions:
1. **List file and directory permissions** using `ls -l`.
2. **Change permissions** using symbolic notation (e.g., `chmod u+x`).
3. **Set permissions** using numeric notation (e.g., `chmod 755`).
4. **Change file ownership** using `chown`.
5. **Understand and use special permissions** like Setuid, Setgid, and the Sticky Bit.
6. **Apply permissions** to both files and directories.
