## 03- Create, delete, and modify local groups and group memberships:

The RHCSA exam topic **"Create, delete, and modify local groups and group memberships"** involves managing local groups and assigning users to these groups in **RHEL 9**. Managing groups is essential for setting file permissions, access control, and organizing users in a Linux system. You need to know how to create new groups, delete groups, modify group memberships, and ensure all changes are persistent.

---

### **What You Need to Know:**
1. **Creating local groups** using the `groupadd` command.
2. **Modifying group memberships** using `usermod`, `gpasswd`, or directly modifying group files.
3. **Deleting groups** using `groupdel`.
4. **Understanding `/etc/group` and `/etc/gshadow`** for managing groups.
5. **Ensuring persistence**: Group changes should be persistent across reboots.

---

### **1. Creating Local Groups**

The **`groupadd`** command is used to create new local groups. Groups help manage and organize users and provide a way to set shared permissions on files and directories.

#### **Example Task 1: Create a New Group**

**Task:** Create a new group named **`developers`**.

1. **Create the `developers` group**:
   ```bash
   sudo groupadd developers
   ```

2. **Verify the group is created** by checking `/etc/group`:
   ```bash
   grep developers /etc/group
   ```

#### **Example Output**:
```
developers:x:1001:
```

**Explanation**:
- **`groupadd developers`** creates the group with the next available group ID (GID), which is listed in `/etc/group`.
- **`grep developers /etc/group`** shows the group entry in the `/etc/group` file, confirming the group exists.

---

### **2. Modifying Group Memberships**

You can assign users to groups in Linux to control permissions and access to resources. A user can be part of multiple groups, and you can modify group memberships using **`usermod`**, **`gpasswd`**, or by editing `/etc/group` directly.

#### **Example Task 2: Add a User to a Secondary Group**

**Task:** Add the user **`jdoe`** to the group **`developers`** as a secondary group.

1. **Add the user to the `developers` group**:
   ```bash
   sudo usermod -aG developers jdoe
   ```

2. **Verify the user’s group membership**:
   ```bash
   groups jdoe
   ```

#### **Example Output**:
```
jdoe : jdoe developers
```

**Explanation**:
- **`usermod -aG developers jdoe`** adds **`jdoe`** to the **`developers`** group without removing the user from any other groups (the `-aG` flag is essential for appending to the list of groups).
- **`groups jdoe`** shows the groups to which the user **`jdoe`** belongs, confirming membership in the **`developers`** group.

---

### **3. Changing a User’s Primary Group**

Each user has a **primary group** that is used when they create files or directories. You can change a user’s primary group using the `usermod` command.

#### **Example Task 3: Change a User’s Primary Group**

**Task:** Change the primary group of **`jdoe`** to **`developers`**.

1. **Change the primary group**:
   ```bash
   sudo usermod -g developers jdoe
   ```

2. **Verify the change** by checking `/etc/passwd`:
   ```bash
   grep jdoe /etc/passwd
   ```

#### **Example Output**:
```
jdoe:x:1001:1001::/home/jdoe:/bin/bash
```

**Explanation**:
- **`usermod -g developers jdoe`** changes the primary group for **`jdoe`** to **`developers`**.
- The output in **`/etc/passwd`** shows the user ID and group ID (`1001:1001` in this case), confirming the primary group.

---

### **4. Removing Users from Groups**

To remove a user from a group, you can edit their secondary groups using the `gpasswd` command or by modifying `/etc/group` directly.

#### **Example Task 4: Remove a User from a Secondary Group**

**Task:** Remove **`jdoe`** from the **`developers`** group.

1. **Remove the user from the `developers` group**:
   ```bash
   sudo gpasswd -d jdoe developers
   ```

2. **Verify the user is no longer in the group**:
   ```bash
   groups jdoe
   ```

#### **Example Output**:
```
jdoe : jdoe
```

**Explanation**:
- **`gpasswd -d jdoe developers`** removes **`jdoe`** from the **`developers`** group.
- **`groups jdoe`** confirms that the user is no longer a member of the **`developers`** group.

---

### **5. Deleting Local Groups**

The **`groupdel`** command is used to delete local groups. This does not affect the users; it just removes the group from the system.

#### **Example Task 5: Delete a Group**

**Task:** Delete the **`developers`** group.

1. **Delete the group**:
   ```bash
   sudo groupdel developers
   ```

2. **Verify the group is deleted**:
   ```bash
   grep developers /etc/group
   ```

#### **Example Output**:
```
(no output)
```

**Explanation**:
- **`groupdel developers`** deletes the **`developers`** group from the system.
- **`grep developers /etc/group`** shows no output, confirming that the group no longer exists in **`/etc/group`**.

---

### **6. Listing Group Memberships**

You can list the groups a user belongs to using the **`groups`** command or by checking the `/etc/group` file directly.

#### **Example Task 6: List Groups for a User**

**Task:** List all groups the user **`jdoe`** belongs to.

1. **Check the user’s group memberships**:
   ```bash
   groups jdoe
   ```

#### **Example Output**:
```
jdoe : jdoe wheel
```

**Explanation**:
- **`groups jdoe`** shows the primary and secondary groups to which **`jdoe`** belongs. In this case, **`jdoe`** is part of the **`wheel`** group, which gives administrative privileges.

---

### **7. Understanding `/etc/group` and `/etc/gshadow`**

- **`/etc/group`**: Stores group information. Each line represents a group, with fields for the group name, password (if any), GID, and members.
  
  Example entry:
  ```
  developers:x:1001:jdoe,webadmin
  ```

- **`/etc/gshadow`**: Stores secure group information such as group passwords (rarely used) and group administrators.

---

### **8. Modifying Groups by Editing `/etc/group`**

You can manually modify groups by directly editing the **`/etc/group`** file. This approach is less common but can be useful in certain scenarios.

#### **Example Task 7: Add Multiple Users to a Group by Editing `/etc/group`**

**Task:** Add **`jdoe`** and **`webadmin`** to the **`developers`** group by directly editing the `/etc/group` file.

1. **Edit the `/etc/group` file**:
   ```bash
   sudo nano /etc/group
   ```

2. **Modify the `developers` group line**:
   ```
   developers:x:1001:jdoe,webadmin
   ```

3. **Save the file and verify the changes**:
   ```bash
   grep developers /etc/group
   ```

#### **Example Output**:
```
developers:x:1001:jdoe,webadmin
```

**Explanation**:
- Editing the **`/etc/group`** file directly allows you to manually add users to groups. In this case, both **`jdoe`** and **`webadmin`** are added to the **`developers`** group.

---

### **9. Ensuring Group Changes are Persistent**

All changes made using **`groupadd`**, **`groupdel`**, **`usermod`**, **`gpasswd`**, or by editing **`/etc/group`** directly are persistent across reboots because they modify the underlying system configuration files (`/etc/group` and `/etc/gshadow`).

---

### Summary of Skills for RHCSA Exam on Managing Local Groups and Group Memberships:
1. **Create local groups** using `groupadd`.
2. **Add users to groups** as primary or secondary group members using `usermod` or `gpasswd`.
3. **Change primary groups** using `usermod -g`.
4. **Remove users from groups** using `gpasswd -d`.
5. **Delete groups** using `groupdel`.
6. **List groups for a user** using `groups` or by inspecting `/etc/group`.
7. **Manually modify groups** by editing `/etc/group` when necessary.

