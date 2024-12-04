## 05- Create and configure set-GID directories for collaboration:

The RHCSA exam topic **"Create and configure set-GID directories for collaboration"** focuses on creating directories where multiple users can collaborate by sharing files. When the **set-GID** (Set Group ID) permission is applied to a directory, files created within that directory inherit the group ownership of the directory itself, rather than the primary group of the user who creates the file.

This feature is especially useful in shared or collaborative environments where users from the same group need to work together and access each other's files easily.

---

### **What You Need to Know:**
1. **Group Ownership**: Files and directories can have group ownership, and setting the **set-GID** bit ensures that all files created in a directory inherit the directory's group ownership.
2. **Permissions and Ownership**: You need to know how to use `chmod` to set the GID bit and `chgrp` to assign group ownership.
3. **Collaboration setup**: Set up a shared directory where all users in a specific group can read, write, and execute files, and the group ownership is inherited automatically for collaboration.
4. **Make sure changes are persistent**, meaning permissions and group ownership survive across reboots and are correctly inherited.

---

### **1. Create a Shared Group**

Before creating the set-GID directory, you need a **group** that users can share. You can create a group and add users to it.

#### **Example Task 1: Create a Group and Add Users**

**Task:** Create a new group called **`projectgroup`** and add users **`alice`** and **`bob`** to it.

1. **Create the group**:
   ```bash
   sudo groupadd projectgroup
   ```

2. **Add users to the group**:
   ```bash
   sudo usermod -aG projectgroup alice
   sudo usermod -aG projectgroup bob
   ```

3. **Verify the group memberships**:
   ```bash
   groups alice
   groups bob
   ```

**Explanation**:
- **`groupadd projectgroup`**: Creates the group **`projectgroup`**.
- **`usermod -aG`**: Adds users **`alice`** and **`bob`** to the group **`projectgroup`**.
- **`groups`**: Verifies that the users are members of the group.

---

### **2. Create a Set-GID Directory**

Next, create a directory that will be shared by the group. This directory will be configured with the **set-GID** permission so that any files or subdirectories created inside it will automatically inherit the group ownership of the directory.

#### **Example Task 2: Create and Configure a Set-GID Directory**

**Task:** Create a directory **`/shared/project`** for the **`projectgroup`** group, set the GID bit, and ensure all files created inside inherit the group ownership.

1. **Create the directory**:
   ```bash
   sudo mkdir -p /shared/project
   ```

2. **Change the group ownership of the directory** to **`projectgroup`**:
   ```bash
   sudo chgrp projectgroup /shared/project
   ```

3. **Set the permissions so that group members can read, write, and execute files**:
   ```bash
   sudo chmod 2775 /shared/project
   ```

4. **Verify the directory permissions**:
   ```bash
   ls -ld /shared/project
   ```

#### **Example Output**:
```
drwxrwsr-x 2 root projectgroup 4096 Sep 25 10:32 /shared/project
```

**Explanation**:
- **`mkdir -p /shared/project`**: Creates the **`/shared/project`** directory.
- **`chgrp projectgroup /shared/project`**: Changes the group ownership of the directory to **`projectgroup`**.
- **`chmod 2775 /shared/project`**: Sets the **set-GID** bit (`2`) and sets the permissions to **rwxrwsr-x** (group members can read, write, and execute files).
  - The **`2`** in **`2775`** indicates the set-GID bit is set.
- **`ls -ld`** confirms the permissions, showing **`s`** in the group field, meaning the set-GID bit is active.

---

### **3. Test the Set-GID Directory Behavior**

Now that the set-GID directory is created, you should test whether files created inside the directory inherit the group ownership of the directory.

#### **Example Task 3: Test File Creation and Group Ownership Inheritance**

**Task:** As users **`alice`** and **`bob`**, create files in the **`/shared/project`** directory and verify that the group ownership is set to **`projectgroup`**.

1. **Switch to user `alice`** and create a file:
   ```bash
   sudo su - alice
   touch /shared/project/alicefile
   ls -l /shared/project/alicefile
   ```

   **Expected Output**:
   ```
   -rw-rw-r-- 1 alice projectgroup 0 Sep 25 10:45 /shared/project/alicefile
   ```

2. **Switch to user `bob`** and create a file:
   ```bash
   sudo su - bob
   touch /shared/project/bobfile
   ls -l /shared/project/bobfile
   ```

   **Expected Output**:
   ```
   -rw-rw-r-- 1 bob projectgroup 0 Sep 25 10:46 /shared/project/bobfile
   ```

**Explanation**:
- Both files created by **`alice`** and **`bob`** inherit the **`projectgroup`** group ownership, even though **`alice`** and **`bob`** have different primary groups. This ensures that files are accessible to all members of the **`projectgroup`**.

---

### **4. Ensure Persistent Configuration**

The set-GID configuration is persistent across reboots, as it’s tied to the directory’s file system permissions. However, ensure that all group members retain their permissions.

- The **set-GID** and permissions applied to the directory remain persistent because they are part of the file system.
- **Verify user memberships**: Make sure that users are persistently assigned to the **`projectgroup`** group:
  ```bash
  id alice
  id bob
  ```

---

### **5. Troubleshooting Permissions**

If files inside the set-GID directory do not have the correct group ownership or permissions, check the following:

- Ensure the directory has the correct **set-GID** bit using `ls -ld`.
- Check the **umask** for users, which controls default permissions for new files. Ensure it's set correctly, e.g., `umask 002` for group read/write permissions.

---

### Summary of Skills for RHCSA Exam on Set-GID Directories for Collaboration:
1. **Create and configure a directory** for group collaboration using the **set-GID** bit with `chmod 2775`.
2. **Assign group ownership** of the directory to ensure files inherit the group ownership using `chgrp`.
3. **Test the configuration** by creating files as different users and verifying that group ownership is inherited.
4. **Ensure persistence** by checking user group memberships and verifying that permissions remain across reboots.
