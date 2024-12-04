## 05- Log in and switch users in multiuser targets:

The topic **"Log in and switch users in multiuser targets"** is crucial for the RHCSA exam. It covers how to work with user accounts in a **multiuser environment**, including switching users, understanding multiuser targets, and managing root access. Mastering these skills ensures that you can manage user sessions, switch between users, and control access to system resources effectively.


---

### **1. Understanding Multiuser Targets in Linux**

A **target** in Linux (especially in Red Hat-based systems like RHEL) is a collection of services or system states. A **multiuser target** refers to the system being in a state where multiple users can log in, and essential services like networking are available.

- The **multi-user.target** in `systemd` is similar to **runlevel 3** from the traditional SysV init system, where the system is fully operational in text mode, but without a graphical interface.
- The **graphical.target** (similar to runlevel 5) includes the graphical interface along with multiuser capabilities.

You must be able to work in **multiuser.target** mode, where the system allows multiple users to access it, typically through terminals or SSH.

#### **Commands to Check and Switch Between Targets:**
- **Check current target:**
  ```bash
  systemctl get-default
  ```

- **Switch to multi-user.target:**
  ```bash
  sudo systemctl isolate multi-user.target
  ```

- **Make multi-user.target the default:**
  ```bash
  sudo systemctl set-default multi-user.target
  ```

**What to Know:**
- **`multi-user.target`** is a text-based mode where multiple users can log in, either locally (via terminals) or remotely (e.g., via SSH).
- Switching targets is essential when you want to bring the system into different operational states, such as multi-user mode without GUI or single-user mode for maintenance tasks.

---

### **2. Log In as a User in Multiuser Target**

In multiuser mode, users can log in either locally (using the console) or remotely (using SSH). Logging in with your credentials and managing access is essential for handling multi-user environments.

#### **Example Task:**
Log in as the user `examuser` on a system that is in multi-user mode (without a graphical interface).

**Command:**
```bash
ssh examuser@<hostname or IP address>
```

Or, if you're at the local terminal:
- Enter your **username** at the login prompt.
- Enter your **password** when prompted.

**What to Know:**
- Ensure that the **SSH service** (`sshd`) is running on the system if you're logging in remotely.
- You should understand how to check and ensure that multi-user mode is active using `systemctl`.

---

### **3. Switch to Another User with `su`**

The **`su` (substitute user)** command allows you to switch from your current user to another user, including root, without logging out. This is useful for performing tasks with different permissions.

#### **Example Task:**
Switch to the user `examuser` while logged in as `root`.

**Command:**
```bash
su - examuser
```

**Explanation:**
- **`su - examuser`** starts a new session as `examuser` and loads the environment variables and login shell of that user (because of the `-` flag).
- You’ll be prompted for the password of the `examuser`.

#### **Example Task:**
Switch to the `root` user from a standard user session.

**Command:**
```bash
su -
```

**What to Know:**
- Switching to another user’s account will require their password, except when switching to `root` (if you know the `root` password).
- The `-` option ensures that the user’s environment (such as `PATH`, shell, and home directory) is loaded.

---

### **4. Switch Users Using `sudo`**

The **`sudo`** command allows you to run commands as another user (typically `root`) without switching to that user’s shell. The user must be configured in the **`/etc/sudoers`** file or be part of the **wheel** group to have `sudo` privileges.

#### **Example Task:**
Run a command as the `root` user using `sudo`.

**Command:**
```bash
sudo <command>
```

Example:
```bash
sudo systemctl restart sshd
```

This command restarts the `sshd` service as the `root` user without switching to the `root` shell.

#### **Example Task:**
Switch to the `root` shell using `sudo`.

**Command:**
```bash
sudo -i
```

**Explanation:**
- The `-i` option gives you an interactive shell as the `root` user, with the root user’s environment.

---

### **5. Modify User Switching Permissions Using the `sudoers` File**

The **`/etc/sudoers`** file defines which users can run commands as `root` or other users using `sudo`. Modifying this file allows you to control access.

#### **Example Task:**
Grant `examuser` permission to switch to `root` using `sudo`.

**Steps:**
1. **Open the `sudoers` file for editing:**
   ```bash
   sudo visudo
   ```

2. **Add the following line to give `examuser` `sudo` privileges:**
   ```
   examuser ALL=(ALL) ALL
   ```

3. **Save and exit the file.**

**Explanation:**
- This line gives `examuser` permission to run any command as any user.

**What to Know:**
- Always use `visudo` to edit the `sudoers` file, as it prevents syntax errors.
- You can give users more restricted access by limiting which commands they can run with `sudo`.

---

### **6. Lock and Unlock User Accounts**

Managing user accounts by locking and unlocking them is part of maintaining a multiuser environment. A **locked account** cannot be used to log in.

#### **Example Task:**
Lock the user account `examuser`.

**Command:**
```bash
sudo passwd -l examuser
```

#### **Example Task:**
Unlock the user account `examuser`.

**Command:**
```bash
sudo passwd -u examuser
```

**What to Know:**
- **Locking an account** prevents the user from logging in by disabling their password.
- **Unlocking an account** allows the user to log in again.

---

### **7. Manage `root` Access in Multiuser Targets**

Access to the `root` user must be controlled in a multiuser environment. You must know how to configure `root` access, enable or disable direct root login over SSH, and switch to the `root` user when needed.

#### **Example Task:**
Disable direct `root` login via SSH.

**Steps:**
1. **Edit the SSH daemon configuration file:**
   ```bash
   sudo vim /etc/ssh/sshd_config
   ```

2. **Find and modify the line:**
   ```
   PermitRootLogin no
   ```

3. **Restart the SSH service:**
   ```bash
   sudo systemctl restart sshd
   ```

**What to Know:**
- Disabling direct `root` login forces users to log in with a standard user and escalate privileges using `sudo`, which enhances security.

---

### **8. View Logged-In Users**

In a multiuser environment, you can monitor the logged-in users and their activities.

#### **Example Task:**
Display a list of users currently logged into the system.

**Command:**
```bash
who
```

Or use:
```bash
w
```

**Explanation:**
- **`who`** shows who is logged into the system.
- **`w`** shows who is logged in and what they are doing.

---

### **9. Switching Between Virtual Terminals**

In multiuser environments, especially in text-mode `multi-user.target`, you can switch between **virtual terminals** (consoles). Each console provides a separate login session.

#### **Example Task:**
Switch to **virtual terminal 2**.

**Command:**
Press `Ctrl + Alt + F2`.

To switch back to the graphical environment (if it is enabled):
```bash
Ctrl + Alt + F1 (or F7 depending on your system)
```

**What to Know:**
- Virtual terminals (`tty1`, `tty2`, etc.) provide independent login environments for multiple users.

---

### **10. Log Out of a Session**

Once you’ve finished your session, it’s important to log out, especially in multiuser environments.

#### **Example Task:**
Log out from the current shell session.

**Command:**
```bash
exit
```

Or:
```bash
logout
```

**What to Know:**
- The `exit` or `logout` commands terminate your current shell session and log you out.

---

### Summary of Key Skills for Logging In and Switching Users in RHCSA:
1. **Understand multi-user targets** and switch between different `systemd` targets.
2. **Log in** to the system in multi-user mode, both locally and via SSH.
3. **Switch users** using `su` and `sudo`, with and without logging into the root shell.
4. **Configure `sudo` permissions** in the `/etc/sudoers` file.
5. **Lock and unlock user accounts** as necessary for access control.
6. **Restrict direct root login** to improve security.
7. **Monitor active sessions** and users using tools like `who` and `w`.
8. **Switch between virtual terminals** in text-based multiuser environments.
9. **Log out of sessions** to free up resources and secure access.
