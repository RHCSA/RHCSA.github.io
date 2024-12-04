## 04- Access remote systems using SSH:

The RHCSA exam topic **"Access remote systems using SSH"** is fundamental for any system administrator, as it enables secure communication between hosts in a network. You’ll need to demonstrate proficiency in connecting to remote systems via SSH, configuring SSH for secure access, setting up key-based authentication, and troubleshooting basic SSH issues.


---

### **1. Basic SSH Connection**

The most basic SSH task is connecting to a remote system.

#### **Example Task:**
Access a remote server at `192.168.1.10` as the user `examuser`.

**Command:**
```bash
ssh examuser@192.168.1.10
```

**Explanation:**
- `ssh`: The SSH client command.
- `examuser@192.168.1.10`: Specifies the user (`examuser`) and the remote host (`192.168.1.10`).
  
**What to Know:**
- The SSH daemon (`sshd`) must be running on the remote system.
- The user must exist on the remote system.
- The default port for SSH is `22` unless configured otherwise.

---

### **2. SSH to a Non-Standard Port**

Sometimes, the SSH service might be running on a port other than the default port (22).

#### **Example Task:**
Access a remote server at `192.168.1.10` as the user `examuser` on port `2222`.

**Command:**
```bash
ssh -p 2222 examuser@192.168.1.10
```

**Explanation:**
- `-p 2222`: Specifies the custom port (`2222`) on which the SSH service is running.

---

### **3. Use SSH Key-Based Authentication**

Key-based authentication is more secure than password-based authentication and is frequently used in SSH setups. In the RHCSA exam, you might be asked to set up key-based authentication between two systems.

#### **Example Task:**
Set up key-based authentication for `examuser` on `192.168.1.10` so that you can SSH without a password.

**Steps:**
1. **Generate SSH Key Pair (on the local system):**
   ```bash
   ssh-keygen -t rsa
   ```
   - Follow the prompts and press `Enter` to accept defaults.

2. **Copy the Public Key to the Remote Server:**
   ```bash
   ssh-copy-id examuser@192.168.1.10
   ```
   - This copies the public key to the remote server, allowing passwordless login.

3. **Log in to Remote System Without Password:**
   ```bash
   ssh examuser@192.168.1.10
   ```

**What to Know:**
- SSH key pairs consist of a **private key** (kept on the local system) and a **public key** (stored on the remote server in `~/.ssh/authorized_keys`).
- The `ssh-copy-id` command automates copying the public key to the remote system.
- By default, RSA and ED25519 keys are the most commonly used.

---

### **4. Disable Password Authentication (Enforce Key-Based Authentication)**

For better security, you may be required to disable password-based authentication and enforce key-based authentication only.

#### **Example Task:**
Configure the SSH server on `192.168.1.10` to disable password authentication and allow only key-based logins.

**Steps:**
1. **Edit the SSH Daemon Configuration:**
   ```bash
   sudo vim /etc/ssh/sshd_config
   ```

2. **Update the Following Parameters:**
   ```
   PasswordAuthentication no
   PubkeyAuthentication yes
   ```

3. **Restart the SSH Service:**
   ```bash
   sudo systemctl restart sshd
   ```

**What to Know:**
- Changes to the SSH configuration file require root or sudo privileges.
- After updating the configuration, restarting the `sshd` service applies the changes.
- Always test key-based access before disabling password authentication to avoid getting locked out.

---

### **5. Use SSH Agent for Key Management**

The `ssh-agent` command allows you to store the private key in memory, so you don’t need to enter the passphrase every time you use SSH.

#### **Example Task:**
Use `ssh-agent` to manage SSH keys and avoid re-entering passphrases.

**Steps:**
1. **Start the SSH Agent:**
   ```bash
   eval $(ssh-agent)
   ```

2. **Add Your Private Key to the Agent:**
   ```bash
   ssh-add ~/.ssh/id_rsa
   ```

3. **SSH to the Remote System Without Entering the Passphrase:**
   ```bash
   ssh examuser@192.168.1.10
   ```

**What to Know:**
- The SSH agent holds private keys in memory, making key management easier.
- You may need to re-add the key after each login session.

---

### **6. Use SSH for File Transfer with `scp`**

SSH can also be used for secure file transfer between systems using the `scp` command (secure copy).

#### **Example Task:**
Copy the file `example.txt` from your local system to the `/home/examuser/` directory on the remote server `192.168.1.10`.

**Command:**
```bash
scp example.txt examuser@192.168.1.10:/home/examuser/
```

**Explanation:**
- `scp`: The secure copy command.
- `example.txt`: The file to transfer.
- `examuser@192.168.1.10:/home/examuser/`: The remote destination where the file will be copied.

---


### **7. Configure SSH Access for a Different Identity File**

You might need to specify a non-default private key to access a remote server.

#### **Example Task:**
SSH to the server `192.168.1.10` as `examuser` using the private key located at `/home/user/.ssh/exam_key`.

**Command:**
```bash
ssh -i /home/user/.ssh/exam_key examuser@192.168.1.10
```

**Explanation:**
- `-i /home/user/.ssh/exam_key`: Specifies the path to the private key to be used for authentication.

---

### **8. Restrict SSH Access to a Specific User**

In some cases, you may be asked to restrict SSH access so that only certain users can log in.

#### **Example Task:**
Allow only the user `examuser` to SSH into the remote server `192.168.1.10`.

**Steps:**
1. **Edit the SSH Configuration File:**
   ```bash
   sudo vim /etc/ssh/sshd_config
   ```

2. **Add the Following Line:**
   ```
   AllowUsers examuser
   ```

3. **Restart the SSH Service:**
   ```bash
   sudo systemctl restart sshd
   ```

**Explanation:**
- The `AllowUsers` directive restricts SSH access to the specified user(s).
  
**What to Know:**
- Multiple users can be specified with space-separated usernames, e.g., `AllowUsers user1 user2`.

---

### **9. Troubleshooting SSH Connection Issues**

During the RHCSA exam, you might encounter SSH-related issues that need troubleshooting. Knowing the common SSH configuration files and how to interpret error messages is crucial.

#### **Example Task:**
Troubleshoot why SSH access is failing for `examuser` on the remote server `192.168.1.10`.

**Steps:**
1. **Check SSH Service Status on the Remote Host:**
   ```bash
   sudo systemctl status sshd
   ```

2. **Examine SSH Configuration for Errors:**
   ```bash
   sudo vim /etc/ssh/sshd_config
   ```

3. **Verify the Firewall Allows SSH:**
   ```bash
   sudo firewall-cmd --list-all
   ```

   If SSH is not listed, allow it:
   ```bash
   sudo firewall-cmd --add-service=ssh --permanent
   sudo firewall-cmd --reload
   ```

4. **Check SELinux:**
   ```bash
   getenforce
   ```

   If SELinux is in `enforcing` mode and blocking SSH, you may need to check the context or adjust the policy.

**What to Know:**
- **Common SSH error messages** like "Permission denied" often indicate issues with incorrect keys, permissions, or firewall/SELinux settings.
- Logs on the remote system (e.g., `/var/log/secure` or `/var/log/auth.log`) can help pinpoint the issue.

---

### **Summary of Key SSH Skills for RHCSA:**
1. **Basic SSH login** using password-based and key-based authentication.
2. **Configure SSH for secure access**, including disabling password-based authentication.
3. **File transfer** using `scp`.
4. **SSH tunneling** for forwarding ports.
5. **Specify different SSH identity files** when needed.
6. **Troubleshoot SSH issues** using `systemctl`, firewall commands, and SELinux.
7. **Restrict SSH access** to specific users or groups.

