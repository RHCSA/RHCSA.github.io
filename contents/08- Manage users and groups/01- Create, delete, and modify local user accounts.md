## 01- Create, delete, and modify local user accounts:

The RHCSA exam topic **"Create, delete, and modify local user accounts"** focuses on managing local user accounts on a **RHEL 9** system. You need to know how to create new users, modify user attributes, set passwords, delete users, and ensure that every change is persistent across reboots.

---

### **What You Need to Know:**
1. **Creating user accounts** using the `useradd` command and setting default parameters.
2. **Modifying user accounts** using `usermod` to change user information such as home directory, shell, or group memberships.
3. **Setting passwords** using the `passwd` command.
4. **Deleting user accounts** using `userdel`, including managing user home directories and files during deletion.
5. **Understanding `/etc/passwd`, `/etc/shadow`, `/etc/group`, and `/etc/skel`** for managing users.
6. **Ensuring changes are persistent** and verifying them across reboots.

---

### **1. Creating Local User Accounts**

The **`useradd`** command is used to create new local user accounts. You can define attributes like the home directory, default shell, and the user's initial group membership.

#### **Example Task 1: Create a New User**

**Task:** Create a new user **`jdoe`** with a default home directory and set a password.

1. **Create the user**:
   ```bash
   sudo useradd jdoe
   ```

2. **Set a password for the user**:
   ```bash
   sudo passwd jdoe
   ```

3. **Verify the user is created** by checking `/etc/passwd`:
   ```bash
   grep jdoe /etc/passwd
   ```

#### **Example Output**:
```
jdoe:x:1001:1001::/home/jdoe:/bin/bash
```

**Explanation**:
- **`useradd jdoe`** creates a new user with the default home directory `/home/jdoe`, default shell `/bin/bash`, and creates a corresponding entry in `/etc/passwd`.
- **`passwd jdoe`** sets the user's password, which is stored in an encrypted format in `/etc/shadow`.

---

### **2. Creating Users with Custom Options**

You can customize the user creation process by specifying additional options such as custom home directories, shells, or user IDs.

#### **Example Task 2: Create a User with a Custom Home Directory and Default Shell**

**Task:** Create the user **`webadmin`** with a home directory **`/webadmin`** and set **`/bin/sh`** as the default shell.

1. **Create the user with a custom home directory and shell**:
   ```bash
   sudo useradd -m -d /webadmin -s /bin/sh webadmin
   ```

2. **Set a password for the user**:
   ```bash
   sudo passwd webadmin
   ```

3. **Verify the user’s details**:
   ```bash
   grep webadmin /etc/passwd
   ```

#### **Example Output**:
```
webadmin:x:1002:1002::/webadmin:/bin/sh
```

**Explanation**:
- **`-m`**: Creates the home directory if it doesn’t exist.
- **`-d /webadmin`**: Sets the home directory to `/webadmin`.
- **`-s /bin/sh`**: Sets the default shell to `/bin/sh`.
- The **`grep`** command confirms the correct details are stored in `/etc/passwd`.

---

### **3. Modifying User Accounts**

The **`usermod`** command is used to modify an existing user’s properties, such as their home directory, shell, or group memberships.

#### **Example Task 3: Modify an Existing User’s Home Directory and Shell**

**Task:** Change the user **`jdoe`**'s home directory to **`/home/dev/jdoe`** and the shell to **`/bin/zsh`**.

1. **Modify the user's home directory and shell**:
   ```bash
   sudo usermod -d /home/dev/jdoe -m -s /bin/zsh jdoe
   ```

2. **Verify the changes**:
   ```bash
   grep jdoe /etc/passwd
   ```

#### **Example Output**:
```
jdoe:x:1001:1001::/home/dev/jdoe:/bin/zsh
```

**Explanation**:
- **`-d /home/dev/jdoe`**: Changes the home directory to `/home/dev/jdoe`.
- **`-m`**: Moves the content of the old home directory to the new one.
- **`-s /bin/zsh`**: Changes the default shell to `/bin/zsh`.
- The **`grep`** command confirms the new home directory and shell are updated in `/etc/passwd`.

---

### **4. Managing User Passwords**

The **`passwd`** command is used to set or update user passwords. You can also enforce password expiration and aging policies.

#### **Example Task 4: Set Password Expiration for a User**

**Task:** Set the password for **`webadmin`** to expire every **90 days**.

1. **Set the password expiration policy**:
   ```bash
   sudo chage -M 90 webadmin
   ```

2. **Verify the password expiration policy**:
   ```bash
   sudo chage -l webadmin
   ```

#### **Example Output**:
```
Last password change                                    : Sep 25, 2024
Password expires                                        : Dec 24, 2024
Password inactive                                       : never
Account expires                                         : never
```

**Explanation**:
- **`chage -M 90 webadmin`** sets the maximum number of days before the password must be changed to 90 days.
- **`chage -l webadmin`** lists the password aging details for the user.

---

### **5. Deleting Local User Accounts**

To delete a user account, use the **`userdel`** command. You can choose to delete the user’s home directory and mail spool as well.

#### **Example Task 5: Delete a User and Their Home Directory**

**Task:** Delete the user **`jdoe`** and remove their home directory.

1. **Delete the user and their home directory**:
   ```bash
   sudo userdel -r jdoe
   ```

2. **Verify the user is deleted**:
   ```bash
   grep jdoe /etc/passwd
   ```

#### **Example Output**:
```
(no output)
```

**Explanation**:
- **`userdel -r jdoe`** deletes the **`jdoe`** user account and removes the home directory `/home/jdoe`.
- The absence of the **`jdoe`** entry in **`/etc/passwd`** confirms the user is deleted.

---

### **6. Listing and Verifying User Accounts**

You can use the following commands to list and verify user accounts on the system.

- **List all users on the system** (from `/etc/passwd`):
  ```bash
  cut -d: -f1 /etc/passwd
  ```

- **View user information** (from `/etc/passwd`):
  ```bash
  getent passwd jdoe
  ```

---

### **7. Understanding Important Files**

#### **`/etc/passwd`**
- Stores basic user account information (username, user ID, home directory, shell).
- Example entry: 
  ```
  jdoe:x:1001:1001::/home/jdoe:/bin/bash
  ```

#### **`/etc/shadow`**
- Stores encrypted passwords and password aging information.
- Example entry:
  ```
  jdoe:$6$1wrj...:19025:0:99999:7:::
  ```

#### **`/etc/group`**
- Defines user groups and group memberships.
- Example entry:
  ```
  wheel:x:10:root,jdoe
  ```

#### **`/etc/skel`**
- Contains default files copied to a user’s home directory when a new account is created.

---

### **8. Ensuring Changes are Persistent**

All changes to user accounts (e.g., creation, modification, deletion) are stored in the system configuration files (`/etc/passwd`, `/etc/shadow`, etc.) and are persistent across reboots by default.

---

### Summary of Skills for RHCSA Exam on Managing Local User Accounts:
1. **Create new user accounts** with custom home directories, shells, and other options using `useradd`.
2. **Modify existing user accounts** using `usermod` to change properties like home directories, shells, and group memberships.
3. **Set and manage passwords** using `passwd` and `chage` to enforce password policies and expiration rules.
4. **Delete user accounts** using `userdel`, including removing their home directories and files.
5. **Verify user accounts** by inspecting the `/etc/passwd`, `/etc/shadow`, and `/etc/group` files.
