## 04- Configure superuser access:

The RHCSA exam topic **"Configure superuser access"** involves managing **root** (superuser) access and configuring **sudo** privileges for users on **RHEL 9**. Superuser access is crucial for performing administrative tasks on a Linux system, and this access should be carefully controlled and granted to trusted users via **`sudo`**.

---

### **What You Need to Know:**
1. **Root user and superuser access**: The root user has unrestricted access to the system. Regular users can gain superuser access through **`sudo`**.
2. **Configuring `sudo` privileges**: How to grant and manage `sudo` access using the `/etc/sudoers` file and **`visudo`** for secure edits.
3. **Adding users to the `wheel` group**: On RHEL, users in the **`wheel`** group are granted `sudo` access by default.
4. **Ensuring persistence**: All changes to superuser access should persist across reboots.
5. **Using `sudo` safely**: How to test and verify that `sudo` privileges work correctly for users.

---

### **1. The Root User and Superuser Access**

The **root** user has full control over the system. While you can log in as root, it’s a best practice to avoid doing so directly and instead use **`sudo`** to grant temporary elevated privileges to regular users.

---

### **2. Granting Superuser Access via the `wheel` Group**

On RHEL, users in the **`wheel`** group have `sudo` privileges by default. You can manage superuser access by adding or removing users from the **`wheel`** group.

#### **Example Task 1: Grant a User Superuser Access by Adding Them to the `wheel` Group**

**Task:** Add the user **`jdoe`** to the **`wheel`** group to grant `sudo` access.

1. **Add the user to the `wheel` group**:
   ```bash
   sudo usermod -aG wheel jdoe
   ```

2. **Verify the user is in the `wheel` group**:
   ```bash
   groups jdoe
   ```

#### **Example Output**:
```
jdoe : jdoe wheel
```

**Explanation**:
- **`usermod -aG wheel jdoe`** adds **`jdoe`** to the **`wheel`** group, granting them `sudo` privileges.
- **`groups jdoe`** lists the groups **`jdoe`** belongs to, verifying that **`jdoe`** is now part of the **`wheel`** group.

---

### **3. Using `visudo` to Edit the `/etc/sudoers` File**

The **`/etc/sudoers`** file controls which users have **`sudo`** access and under what conditions. You should always use the **`visudo`** command to safely edit this file to prevent syntax errors that could break `sudo`.

#### **Example Task 2: Grant `sudo` Access to a Specific User**

**Task:** Allow the user **`webadmin`** to use `sudo` without adding them to the `wheel` group.

1. **Open the `/etc/sudoers` file** for editing using `visudo`:
   ```bash
   sudo visudo
   ```

2. **Add the following line** to grant `sudo` privileges to **`webadmin`**:
   ```
   webadmin ALL=(ALL) ALL
   ```

3. **Save and exit**.

#### **Explanation**:
- **`webadmin ALL=(ALL) ALL`** grants **`webadmin`** the ability to run all commands as any user on any host. The format is:
  - **User**: `webadmin`
  - **Host**: `ALL` (applies to any host)
  - **User to run as**: `(ALL)` (can run commands as any user, including root)
  - **Commands**: `ALL` (can run all commands)

4. **Verify `sudo` access** for `webadmin`:
   ```bash
   sudo -l -U webadmin
   ```

---

### **4. Granting Passwordless `sudo` Access**

In some cases, you may want to allow a user to use `sudo` without entering their password. This can be configured by modifying the `/etc/sudoers` file.

#### **Example Task 3: Configure Passwordless `sudo` Access for a User**

**Task:** Allow **`jdoe`** to run `sudo` commands without being prompted for a password.

1. **Open the `/etc/sudoers` file**:
   ```bash
   sudo visudo
   ```

2. **Add the following line**:
   ```
   jdoe ALL=(ALL) NOPASSWD: ALL
   ```

3. **Save and exit**.

#### **Explanation**:
- **`jdoe ALL=(ALL) NOPASSWD: ALL`** allows **`jdoe`** to run `sudo` commands without being prompted for a password.
- This setting is useful for automation or special use cases where frequent password prompts are undesirable.

4. **Verify passwordless `sudo`** by running a command as `jdoe`:
   ```bash
   sudo -u jdoe whoami
   ```

---

### **5. Restricting `sudo` Access to Specific Commands**

You can restrict a user’s `sudo` privileges to specific commands, limiting what they can do with superuser access.

#### **Example Task 4: Restrict a User to Running Specific Commands with `sudo`**

**Task:** Allow the user **`jdoe`** to only run the `systemctl` and `yum` commands with `sudo`.

1. **Open the `/etc/sudoers` file**:
   ```bash
   sudo visudo
   ```

2. **Add the following line**:
   ```
   jdoe ALL=(ALL) /usr/bin/systemctl, /usr/bin/yum
   ```

3. **Save and exit**.

#### **Explanation**:
- **`jdoe ALL=(ALL) /usr/bin/systemctl, /usr/bin/yum`** allows **`jdoe`** to run only the `systemctl` and `yum` commands as root, but no others.
- **`/usr/bin/systemctl`** and **`/usr/bin/yum`** are the full paths to the commands the user is allowed to run with `sudo`.

4. **Test the restricted `sudo` privileges**:
   ```bash
   sudo -u jdoe systemctl status sshd
   sudo -u jdoe yum update
   ```

---

### **6. Testing and Verifying `sudo` Access**

It’s essential to test `sudo` access after making changes to ensure that users can successfully run privileged commands and that the restrictions you set are working as expected.

#### **Example Task 5: Test a User’s `sudo` Privileges**

**Task:** Verify that **`webadmin`** can use `sudo` by listing their privileges and running a test command.

1. **List `sudo` privileges for `webadmin`**:
   ```bash
   sudo -l -U webadmin
   ```

2. **Run a test command** using `sudo`:
   ```bash
   sudo -u webadmin whoami
   ```

#### **Expected Output**:
```
root
```

**Explanation**:
- **`sudo -l -U webadmin`** lists the commands that **`webadmin`** can run with `sudo`.
- **`sudo -u webadmin whoami`** verifies that **`webadmin`** can use `sudo` to run commands as root.

---

### **7. Removing `sudo` Access**

If you need to remove a user’s `sudo` privileges, you can do so by either removing them from the **`wheel`** group or deleting their entry in the **`/etc/sudoers`** file.

#### **Example Task 6: Remove `sudo` Access from a User**

**Task:** Remove **`jdoe`** from the `wheel` group to revoke `sudo` access.

1. **Remove the user from the `wheel` group**:
   ```bash
   sudo gpasswd -d jdoe wheel
   ```

2. **Verify that `jdoe` no longer has `sudo` access**:
   ```bash
   sudo -l -U jdoe
   ```

#### **Example Output**:
```
User jdoe is not allowed to run sudo on this system.
```

**Explanation**:
- **`gpasswd -d jdoe wheel`** removes **`jdoe`** from the `wheel` group, revoking their `sudo` privileges.
- **`sudo -l -U jdoe`** confirms that **`jdoe`** no longer has `sudo` access.

---

### **8. Ensuring Persistence of `sudo` Access**

All changes made to user privileges via the **`/etc/sudoers`** file or by modifying group memberships (like the `wheel` group) are persistent across reboots because they modify system configuration files that are reloaded at boot.

---

### Summary of Skills for RHCSA Exam on Configuring Superuser Access:
1. **Grant `sudo` access** by adding users to the `wheel` group using `usermod -aG wheel`.
2. **Edit the `/etc/sudoers` file** using `visudo` to securely configure specific `sudo` privileges.
3. **Grant passwordless `sudo` access** to users by adding `NOPASSWD` in `/etc/sudoers`.
4. **Restrict `sudo` access** to specific commands by modifying the `/etc/sudoers` file.
5. **Remove `sudo` access** by removing users from the `wheel` group or deleting entries from `/etc/sudoers`.
6. **Test `sudo` access** using `sudo -l` and running test commands to verify privileges.
