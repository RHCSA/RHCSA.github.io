## 09- Create hard and soft links

The RHCSA exam topic **"hard links"** is important because it tests your understanding of file management, linking, and inode structure in Linux. **Hard links** allow multiple filenames to refer to the same file content (inode). Unlike symbolic links, hard links are direct references to the file's inode, and they share the same data, metadata, and permissions.

### What You Need to Know:
- **Hard links** create additional names for the same file content.
- **All hard links share the same inode number** (which identifies the actual data on disk).
- Deleting a hard link **does not affect the file** until all links to the file are deleted.
- Hard links **cannot span different file systems** or partitions and **cannot link to directories** (except for root directories).

### **1. Create a Hard Link Using `ln`**

#### **Example Task 1: Create a Hard Link**

**Task:** Create a hard link for the file `/home/examuser/original.txt` in the `/home/examuser/docs/` directory, naming the hard link `link.txt`.

**Command:**
```bash
ln /home/examuser/original.txt /home/examuser/docs/link.txt
```

**Explanation:**
- `ln` is the command to create a hard link.
- `/home/examuser/original.txt` is the source file.
- `/home/examuser/docs/link.txt` is the new hard link being created.

After this, both `original.txt` and `link.txt` refer to the same inode on disk. Changes to either file will be reflected in both since they share the same data.

---

### **2. Verify the Hard Link**

You may be asked to verify whether a file has hard links. This is done by checking the **inode number** and the **link count** of a file using `ls` or `stat`.

#### **Example Task 2: Verify a Hard Link**

**Task:** Verify that `link.txt` and `original.txt` point to the same inode.

**Commands:**
```bash
ls -li /home/examuser/original.txt /home/examuser/docs/link.txt
```

**Explanation:**
- `-l`: Shows detailed information about the file.
- `-i`: Displays the **inode number**.

Both files should display the same inode number. The inode number is the unique identifier for the file’s data on disk. If the inode numbers match, it means both files are hard links to the same inode.

#### **Example Output:**
```bash
123456 -rw-r--r-- 2 examuser examgroup  1234 Sep 21 14:35 /home/examuser/original.txt
123456 -rw-r--r-- 2 examuser examgroup  1234 Sep 21 14:35 /home/examuser/docs/link.txt
```

- The `123456` indicates that both files share the same inode.
- The number `2` (in the second column) shows the **link count**, meaning there are two links pointing to the same file.

---

### **3. Delete a Hard Link**

When you delete a hard link, the actual data is not removed from the disk until all hard links to that inode are deleted. Each hard link is treated as a regular file, and the data persists as long as there is at least one link left.

#### **Example Task 3: Delete a Hard Link**

**Task:** Delete the hard link `link.txt` and check if the file content is still accessible through `original.txt`.

**Commands:**
```bash
rm /home/examuser/docs/link.txt
cat /home/examuser/original.txt
```

**Explanation:**
- `rm` removes the hard link `link.txt`.
- `cat` is used to display the contents of `original.txt`. Even after deleting `link.txt`, the content of the file is still available through `original.txt` because the file's data on disk remains intact until the last hard link is removed.

---

### **4. Check the Number of Hard Links Using `stat`**

The **`stat`** command provides detailed information about a file, including the number of hard links to it.

#### **Example Task 4: Check the Number of Hard Links**

**Task:** Display the number of hard links for the file `/home/examuser/original.txt`.

**Command:**
```bash
stat /home/examuser/original.txt
```

**Explanation:**
- `stat` gives detailed information about a file, including its inode number, permissions, owner, size, and the **number of links** (hard links) pointing to it.

#### **Example Output:**
```bash
  File: /home/examuser/original.txt
  Size: 1234       Blocks: 8          IO Block: 4096   regular file
Device: 803h/2051d Inode: 123456      Links: 1
```

- The **`Links`** field shows the number of hard links. If the file has multiple hard links, this number will increase.

---

### **5. Create Multiple Hard Links**

#### **Example Task 5: Create Multiple Hard Links**

**Task:** Create two additional hard links for `/home/examuser/original.txt` named `link1.txt` and `link2.txt` in the `/home/examuser/docs/` directory.

**Command:**
```bash
ln /home/examuser/original.txt /home/examuser/docs/link1.txt
ln /home/examuser/original.txt /home/examuser/docs/link2.txt
```

**Explanation:**
- Both `link1.txt` and `link2.txt` will refer to the same inode as `original.txt`.
- Use `ls -li` or `stat` to verify that all three files have the same inode number and link count.

---

### **6. Hard Links and File Deletion**

#### **Example Task 6: Delete the Original File and Access Data from the Hard Link**

**Task:** Delete `original.txt` and verify that the file content is still accessible through `link1.txt`.

**Commands:**
```bash
rm /home/examuser/original.txt
cat /home/examuser/docs/link1.txt
```

**Explanation:**
- **Deleting `original.txt`** does not delete the file content, as the data is still referenced by `link1.txt`.
- The data will remain available as long as there is at least one hard link pointing to it.

---

### Key Differences Between Hard Links and Symbolic (Soft) Links:
- **Hard links** point directly to the inode, meaning they share the same data, metadata, and permissions as the original file.
- **Symbolic (soft) links** are just pointers to the original file’s path and do not share the inode. If the original file is deleted, symbolic links become **broken**.
- **Hard links cannot be created for directories** or across different filesystems, while **symbolic links can**.
- **Symbolic links** are easier to identify, as their `ls -l` output shows the link pointing to the original file.

---

### Summary of Skills for Hard Links on the RHCSA Exam:
1. **Create hard links** using the `ln` command.
2. **Verify hard links** using `ls -li` and `stat` to check inode numbers and link counts.
3. **Delete hard links** and understand how file data persists as long as one hard link remains.
4. **Check the number of hard links** using the `stat` command.
5. **Understand the difference** between hard links and symbolic links.


-----------


The RHCSA exam topic **"soft links"** (also known as symbolic links or symlinks) is an important part of file management on Linux. Soft links are pointers to another file or directory, allowing you to create shortcuts to files and directories without duplicating their data. Understanding how to create, use, and manage soft links is essential for the RHCSA exam.

---

### What You Need to Know:
- **Soft links (symbolic links)** are special files that point to another file or directory.
- Unlike **hard links**, soft links:
  - Can point to **directories**.
  - Can point to files across **different filesystems** or partitions.
  - **Do not share the same inode** as the target file.
  - Become **broken** if the target file is deleted.
- Soft links can be created using the `ln -s` command.

---

### **1. Create a Soft Link to a File**

Creating a soft link is done using the `ln` command with the `-s` option to specify that you are creating a symbolic link.

#### **Example Task 1: Create a Soft Link to a File**

**Task:** Create a symbolic link to the file `/home/examuser/original.txt` in the `/home/examuser/docs/` directory, naming the link `softlink.txt`.

**Command:**
```bash
ln -s /home/examuser/original.txt /home/examuser/docs/softlink.txt
```

**Explanation:**
- `ln -s`: Creates a symbolic (soft) link.
- `/home/examuser/original.txt`: The target file you are linking to.
- `/home/examuser/docs/softlink.txt`: The name and location of the soft link.

After creating the soft link, `/home/examuser/docs/softlink.txt` will point to `/home/examuser/original.txt`.

---

### **2. Verify a Soft Link**

You can verify that a soft link has been created correctly using the `ls -l` command. This command will show the symbolic link and the file it points to.

#### **Example Task 2: Verify a Soft Link**

**Task:** Verify that `softlink.txt` points to `original.txt`.

**Command:**
```bash
ls -l /home/examuser/docs/softlink.txt
```

**Explanation:**
- `-l`: Lists files in long format, showing detailed information about the file.

#### **Example Output:**
```bash
lrwxrwxrwx 1 examuser examgroup 25 Sep 21 14:35 /home/examuser/docs/softlink.txt -> /home/examuser/original.txt
```

- `l` at the beginning of the permissions (`lrwxrwxrwx`) indicates it’s a symbolic link.
- `->` shows that `softlink.txt` points to `/home/examuser/original.txt`.

---

### **3. Create a Soft Link to a Directory**

Unlike hard links, soft links can point to directories. This is commonly used to create shortcuts to frequently accessed directories.

#### **Example Task 3: Create a Soft Link to a Directory**

**Task:** Create a symbolic link to the `/var/log` directory in `/home/examuser/`, naming the link `logdir`.

**Command:**
```bash
ln -s /var/log /home/examuser/logdir
```

**Explanation:**
- `ln -s /var/log /home/examuser/logdir`: Creates a symbolic link called `logdir` in `/home/examuser/`, which points to the `/var/log` directory.

You can now access `/var/log` by navigating to `/home/examuser/logdir`.

---

### **4. Access a File or Directory Through a Soft Link**

Once a soft link is created, you can use it to access the target file or directory as if you were accessing the original.

#### **Example Task 4: Access a File Through a Soft Link**

**Task:** Display the contents of the file `softlink.txt`, which points to `original.txt`.

**Command:**
```bash
cat /home/examuser/docs/softlink.txt
```

**Explanation:**
- Since `softlink.txt` points to `original.txt`, the `cat` command will display the contents of the original file through the symbolic link.

---

### **5. Delete a Soft Link**

Deleting a symbolic link does not delete the target file or directory; it only removes the link itself.

#### **Example Task 5: Delete a Soft Link**

**Task:** Remove the symbolic link `/home/examuser/docs/softlink.txt`.

**Command:**
```bash
rm /home/examuser/docs/softlink.txt
```

**Explanation:**
- This deletes the soft link `softlink.txt` without affecting the original file `/home/examuser/original.txt`.

---

### **6. Create a Broken Soft Link**

If the target file or directory that a soft link points to is removed or moved, the symbolic link becomes **broken**.

#### **Example Task 6: Create a Broken Soft Link**

**Task:** Create a soft link to `/home/examuser/tempfile.txt`, then delete `tempfile.txt` and verify that the link is broken.

**Steps:**

1. **Create the soft link:**
   ```bash
   ln -s /home/examuser/tempfile.txt /home/examuser/docs/brokenlink.txt
   ```

2. **Delete the target file:**
   ```bash
   rm /home/examuser/tempfile.txt
   ```

3. **Verify that the link is broken:**
   ```bash
   ls -l /home/examuser/docs/brokenlink.txt
   ```

**Explanation:**
- After deleting `tempfile.txt`, the symbolic link `brokenlink.txt` will still exist but will point to a non-existent file, making it broken.

#### **Example Output:**
```bash
lrwxrwxrwx 1 examuser examgroup 25 Sep 21 14:35 /home/examuser/docs/brokenlink.txt -> /home/examuser/tempfile.txt
```

- Notice that the link still exists, but the target file (`tempfile.txt`) no longer does.

---

### **7. List All Symbolic Links in a Directory**

You may be asked to list all symbolic links in a given directory. You can do this using the `find` command.

#### **Example Task 8: Find All Symbolic Links in `/home/examuser/docs/`**

**Task:** List all symbolic links in the `/home/examuser/docs/` directory.

**Command:**
```bash
find /home/examuser/docs/ -type l
```

**Explanation:**
- `find /home/examuser/docs/`: Searches the `/home/examuser/docs/` directory.
- `-type l`: Limits the search to symbolic links.

This command will list all symbolic links in the specified directory.

---

### **8. Create a Relative Soft Link**

When creating a symbolic link, you can either use an **absolute path** or a **relative path**. A **relative soft link** points to a file relative to the link's location, which can be useful when moving linked files around.

#### **Example Task 9: Create a Relative Soft Link**

**Task:** Create a relative symbolic link to `original.txt` from the `/home/examuser/docs/` directory.

**Command:**
```bash
ln -s ../original.txt /home/examuser/docs/relativelink.txt
```

**Explanation:**
- `..` refers to the parent directory of `/home/examuser/docs/`.
- `../original.txt`: Points to `original.txt` using a relative path.

In this example, `relativelink.txt` is a symbolic link that points to `../original.txt`, relative to the `/home/examuser/docs/` directory.

---

### Summary of Skills for Soft Links on the RHCSA Exam:
1. **Create soft links** using `ln -s` for both files and directories.
2. **Verify symbolic links** using `ls -l` to check the link and target.
3. **Delete soft links** and understand that deleting a soft link does not affect the original file.
4. **Recognize and fix broken soft links** if the target file or directory is moved or deleted.
5. **Use the `find` command** to search for symbolic links within a directory.
6. **Create relative soft links** to allow for flexibility when moving linked files or directories.