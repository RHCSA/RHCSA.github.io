## 03- Configure key-based authentication for SSH:

### **RHCSA Exam Topic: Configure Key-Based Authentication for SSH**

In the RHCSA exam, you need to know how to set up **key-based authentication for SSH** to allow users to connect to a remote system without requiring a password. This method is more secure than password-based login, and it is widely used in environments where secure and automated connections are required.

---

### **1. Overview of Key-Based Authentication for SSH**

- **SSH (Secure Shell)** provides a secure method to log into remote systems.
- **Key-based authentication** uses a pair of cryptographic keys (public and private) to authenticate users.
  - The **private key** stays with the user, while the **public key** is copied to the remote server.
  - When the user connects, the server verifies the private key without the need for a password.

---

### **2. Steps to Configure Key-Based Authentication for SSH**

#### **Example Task: Configure SSH Key-Based Authentication Between Two Machines**

The steps for configuring key-based authentication involve generating an SSH key pair, copying the public key to the remote server, and testing the setup.

#### **Step-by-Step Instructions**

---

### **Step 1: Generate SSH Key Pair on the Client**

The first step is to generate the SSH key pair (public and private keys) on the client machine.

1. **Generate the SSH key pair**:
   ```bash
   ssh-keygen -t rsa -b 4096
   ```

   - `-t rsa`: Specifies the type of key (RSA).
   - `-b 4096`: Specifies the key size (4096 bits).

2. **Save the key in the default location (`~/.ssh/id_rsa`)** or specify a different location if needed. Press **Enter** to accept the default path.

3. **Optionally add a passphrase** for additional security (or press **Enter** to skip it).

#### **Expected Output**:
```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/user/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/user/.ssh/id_rsa.
Your public key has been saved in /home/user/.ssh/id_rsa.pub.
```

- **Private key**: `~/.ssh/id_rsa`
- **Public key**: `~/.ssh/id_rsa.pub`

---

### **Step 2: Copy the Public Key to the Remote Server**

Now that the key pair is generated, you need to copy the public key to the remote server. The public key will be added to the **`~/.ssh/authorized_keys`** file on the remote server.

1. **Copy the public key to the remote server** using `ssh-copy-id`:
   ```bash
   ssh-copy-id username@remote_server_ip
   ```

   - Replace `username` with your username on the remote server.
   - Replace `remote_server_ip` with the IP address or hostname of the remote server.

2. **Enter the password** for the remote server when prompted. This is the last time you’ll need to use a password after setting up key-based authentication.

#### **Expected Output**:
```
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/user/.ssh/id_rsa.pub"
Number of key(s) added: 1
Now try logging into the machine, with:   "ssh 'username@remote_server_ip'"
```

---

### **Step 3: Verify SSH Key-Based Authentication**

After copying the public key, test the connection to the remote server to ensure that the key-based authentication is working.

1. **Connect to the remote server**:
   ```bash
   ssh username@remote_server_ip
   ```

2. **Check if you are logged in without being prompted for a password**.

#### **Expected Result**:
You should be able to log into the remote server without being asked for a password, meaning the key-based authentication is successfully configured.

---

### **Step 4: Make the Changes Persistent**

To ensure that the SSH configuration changes are persistent across reboots and sessions, check the following:

1. **Permissions for the `.ssh` directory and files**:
   - The `.ssh` directory and files should have the correct permissions to ensure security.
   - On the remote server:
     ```bash
     chmod 700 ~/.ssh
     chmod 600 ~/.ssh/authorized_keys
     ```

2. **Ensure SSH service is running and enabled** to start on boot:
   ```bash
   sudo systemctl enable sshd
   sudo systemctl start sshd
   ```

---

### **3. Example RHCSA-Style Questions and Answers**

Here are sample RHCSA-style questions based on configuring SSH key-based authentication.

#### **Question 1: Generate an SSH Key Pair**

**Task:** On a RHEL 9 machine, generate a 4096-bit RSA key pair and store the private key in the default location (`~/.ssh/id_rsa`).

**Answer:**

```bash
ssh-keygen -t rsa -b 4096
```
- Accept the default path and press **Enter**.

---

#### **Question 2: Copy the Public Key to the Remote Server**

**Task:** Copy the public key from your RHEL 9 client machine to the remote server **192.168.1.10** using the username **admin**.

**Answer:**

```bash
ssh-copy-id admin@192.168.1.10
```

---

#### **Question 3: Test SSH Key-Based Authentication**

**Task:** Verify that SSH key-based authentication works by connecting to the remote server **192.168.1.10** as the user **admin**.

**Answer:**

```bash
ssh admin@192.168.1.10
```

---

#### **Question 4: Configure the Permissions of the `.ssh` Directory**

**Task:** Set the correct permissions for the `.ssh` directory and the `authorized_keys` file on the remote server to secure SSH key-based authentication.

**Answer:**

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

### **4. Additional Considerations**

- **Disable Password Authentication (Optional)**: For added security, you can disable password-based authentication in the SSH server configuration.
  1. **Edit the SSH server config file**:
     ```bash
     sudo vi /etc/ssh/sshd_config
     ```
  2. **Set the following**:
     ```bash
     PasswordAuthentication no
     ```
  3. **Restart the SSH service**:
     ```bash
     sudo systemctl restart sshd
     ```

- **Security Best Practices**: Always secure the **private key** and ensure that your **public key** is placed correctly in the remote server's **`authorized_keys`** file.

---

### **Summary of RHCSA Skills for Key-Based SSH Authentication**

1. **Generate SSH Key Pair**: Using `ssh-keygen` to create a public/private key pair.
2. **Copy Public Key to Server**: Using `ssh-copy-id` to add the public key to the remote server.
3. **Verify SSH Key-Based Authentication**: Testing by logging in without a password.
4. **Secure Permissions**: Ensuring correct permissions for the `.ssh` directory and `authorized_keys` file.
5. **Make Configuration Persistent**: Ensuring the SSH service is enabled to start on boot.
