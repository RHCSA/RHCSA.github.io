# Access Remote Systems Using SSH

## Topic Overview
SSH (Secure Shell) is the primary protocol for securely accessing remote Linux systems. This topic covers connecting to remote systems, configuring passwordless authentication using SSH key pairs, secure file transfers, and executing remote commands - all essential skills for the RHCSA exam.

> **Note:** For switching users locally with `su` and `sudo`, see Topic 05: Log In and Switch Users.

---

## SSH Core Concepts

### What is SSH?
SSH is a cryptographic network protocol that provides:
- **Encrypted communication** between two hosts over an insecure network
- **Remote terminal access** to execute commands
- **Secure file transfers** using SCP and SFTP
- **Port forwarding** and tunneling capabilities
- **Public key authentication** for passwordless login

### SSH Components

| Component | Description |
|-----------|-------------|
| `ssh` | SSH client program for connecting to remote hosts |
| `sshd` | SSH server daemon that accepts connections |
| `ssh-keygen` | Utility to generate SSH key pairs |
| `ssh-copy-id` | Copies public key to remote host's authorized_keys |
| `ssh-agent` | Holds private keys for single sign-on |
| `scp` | Secure copy - file transfer with RCP-like interface |
| `sftp` | Secure FTP - interactive file transfer |

---

## SSH Command Syntax and Options

### Basic Syntax
```bash
ssh [options] [user@]hostname [command]
```

### Essential SSH Options

| Option | Description | Example |
|--------|-------------|---------|
| `-l user` | Specify login username | `ssh -l admin server1` |
| `-p port` | Connect to non-standard port | `ssh -p 2222 server1` |
| `-i keyfile` | Use specific identity file | `ssh -i ~/.ssh/custom_key server1` |
| `-v` | Verbose mode (debugging) | `ssh -v server1` |
| `-X` | Enable X11 forwarding | `ssh -X server1` |
| `-Y` | Enable trusted X11 forwarding | `ssh -Y server1` |
| `-o option` | Set SSH option | `ssh -o StrictHostKeyChecking=no server1` |
| `-A` | Enable agent forwarding | `ssh -A server1` |
| `-N` | No remote command (port forwarding only) | `ssh -N -L 8080:localhost:80 server1` |
| `-f` | Run SSH in background | `ssh -f server1 sleep 10` |
| `-t` | Force pseudo-terminal allocation | `ssh -t server1 sudo command` |
| `-C` | Enable compression | `ssh -C server1` |
| `-4` | Force IPv4 only | `ssh -4 server1` |
| `-6` | Force IPv6 only | `ssh -6 server1` |
| `-q` | Quiet mode (suppress warnings) | `ssh -q server1` |

---

## SSH Key-Based Authentication

### Understanding SSH Keys

| Key Type | File Location | Description |
|----------|---------------|-------------|
| Private Key | `~/.ssh/id_rsa` or `~/.ssh/id_ed25519` | Secret key (never share!) |
| Public Key | `~/.ssh/id_rsa.pub` or `~/.ssh/id_ed25519.pub` | Shared with remote hosts |
| Authorized Keys | `~/.ssh/authorized_keys` | Contains trusted public keys |
| Known Hosts | `~/.ssh/known_hosts` | Host keys of connected servers |

### Key Algorithms

| Algorithm | Command | Recommendation |
|-----------|---------|----------------|
| RSA (4096-bit) | `ssh-keygen -t rsa -b 4096` | Good compatibility |
| Ed25519 | `ssh-keygen -t ed25519` | Modern, faster, more secure |
| ECDSA | `ssh-keygen -t ecdsa -b 521` | Elliptic curve |

### SSH Directory and File Permissions

| Path | Permission | Owner | Description |
|------|------------|-------|-------------|
| `~/.ssh/` | `700` (drwx------) | user | SSH configuration directory |
| `~/.ssh/id_rsa` | `600` (-rw-------) | user | Private key |
| `~/.ssh/id_rsa.pub` | `644` (-rw-r--r--) | user | Public key |
| `~/.ssh/authorized_keys` | `600` (-rw-------) | user | Authorized public keys |
| `~/.ssh/known_hosts` | `644` (-rw-r--r--) | user | Known host keys |
| `~/.ssh/config` | `600` (-rw-------) | user | Client configuration |

---

## SSH Server Configuration

### Important sshd_config Options

File: `/etc/ssh/sshd_config`

| Option | Values | Description |
|--------|--------|-------------|
| `Port` | `22` (default) | SSH listening port |
| `PermitRootLogin` | `yes/no/prohibit-password` | Allow root SSH access |
| `PubkeyAuthentication` | `yes/no` | Enable public key auth |
| `PasswordAuthentication` | `yes/no` | Enable password auth |
| `PermitEmptyPasswords` | `yes/no` | Allow empty passwords |
| `X11Forwarding` | `yes/no` | Enable X11 forwarding |
| `AllowUsers` | `user1 user2` | Whitelist specific users |
| `DenyUsers` | `user1 user2` | Blacklist specific users |
| `MaxAuthTries` | `6` (default) | Max authentication attempts |
| `ClientAliveInterval` | `0` (default) | Keepalive interval in seconds |

---

## Secure File Transfer

### SCP (Secure Copy)

```bash
scp [options] source destination
```

| Option | Description |
|--------|-------------|
| `-r` | Recursive (copy directories) |
| `-P port` | Specify port (note: uppercase P) |
| `-p` | Preserve timestamps and permissions |
| `-C` | Enable compression |
| `-i keyfile` | Use specific identity file |
| `-v` | Verbose mode |
| `-q` | Quiet mode |

### SFTP (SSH File Transfer Protocol)

Interactive mode commands:

| Command | Description |
|---------|-------------|
| `get file` | Download file from remote |
| `put file` | Upload file to remote |
| `ls` | List remote directory |
| `lls` | List local directory |
| `cd dir` | Change remote directory |
| `lcd dir` | Change local directory |
| `mkdir dir` | Create remote directory |
| `rm file` | Delete remote file |
| `bye` / `exit` | Quit SFTP session |

---

## Real-World Exam Practice Questions

### Question 1: Basic SSH Connection
**Task:** Connect to server `node1.example.com` as user `admin` and verify the connection.

<details>
<summary>Solution</summary>

```bash
# Connect to remote server
ssh admin@node1.example.com

# Alternative syntax
ssh -l admin node1.example.com

# Verify connection by checking hostname
hostname
whoami
exit
```
</details>

---

### Question 2: Generate SSH Key Pair
**Task:** Generate an RSA key pair with 4096 bits and save it with the default name.

<details>
<summary>Solution</summary>

```bash
# Generate RSA key pair (4096 bits)
ssh-keygen -t rsa -b 4096

# When prompted:
# - Press Enter for default location (~/.ssh/id_rsa)
# - Enter passphrase (or leave empty for no passphrase)
# - Confirm passphrase

# Verify keys were created
ls -la ~/.ssh/id_rsa*
```

**Expected output:**
```
-rw------- 1 user user 3381 Mar 15 10:00 /home/user/.ssh/id_rsa
-rw-r--r-- 1 user user  741 Mar 15 10:00 /home/user/.ssh/id_rsa.pub
```
</details>

---

### Question 3: Generate Ed25519 Key with Custom Name
**Task:** Generate an Ed25519 key pair saved as `~/.ssh/exam_key` with the comment "RHCSA Exam Key".

<details>
<summary>Solution</summary>

```bash
# Generate Ed25519 key with custom filename and comment
ssh-keygen -t ed25519 -f ~/.ssh/exam_key -C "RHCSA Exam Key"

# Verify the key
ls -la ~/.ssh/exam_key*
cat ~/.ssh/exam_key.pub
```
</details>

---

### Question 4: Configure Passwordless SSH Authentication
**Task:** Set up passwordless SSH login from your local machine to `server2.example.com` as user `developer`.

<details>
<summary>Solution</summary>

```bash
# Step 1: Generate key pair (if not already done)
ssh-keygen -t ed25519

# Step 2: Copy public key to remote server
ssh-copy-id developer@server2.example.com

# Step 3: Test passwordless login
ssh developer@server2.example.com

# You should log in without password prompt
```

**Manual method (if ssh-copy-id is unavailable):**
```bash
# View your public key
cat ~/.ssh/id_ed25519.pub

# On the remote server, add the key to authorized_keys
ssh developer@server2.example.com
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "your-public-key-content" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
exit
```
</details>

---

### Question 5: Fix SSH Permission Issues
**Task:** User `testuser` cannot connect via SSH key. Their home directory has incorrect permissions. Fix the SSH directory permissions.

<details>
<summary>Solution</summary>

```bash
# Switch to testuser or use sudo
sudo -i -u testuser

# Fix SSH directory permissions
chmod 700 ~/.ssh

# Fix authorized_keys permissions
chmod 600 ~/.ssh/authorized_keys

# Fix private key permissions (if applicable)
chmod 600 ~/.ssh/id_rsa

# Ensure home directory is not world-writable
chmod 755 ~

# Verify ownership
ls -la ~/.ssh/
```
</details>

---

### Question 6: Connect on Non-Standard Port
**Task:** SSH is configured on port 2222 on `secure.example.com`. Connect as user `sysadmin`.

<details>
<summary>Solution</summary>

```bash
# Connect specifying the custom port
ssh -p 2222 sysadmin@secure.example.com

# Alternative with -l flag
ssh -p 2222 -l sysadmin secure.example.com
```
</details>

---

### Question 7: Execute Remote Command Without Login
**Task:** Check the disk usage on `webserver.example.com` without starting an interactive session.

<details>
<summary>Solution</summary>

```bash
# Execute df -h remotely and return to local shell
ssh webserver.example.com df -h

# Execute multiple commands
ssh webserver.example.com "df -h && free -m"

# Check uptime remotely
ssh webserver.example.com uptime
```
</details>

---

### Question 8: Copy File to Remote Server with SCP
**Task:** Copy the file `/etc/hosts` from your local machine to `/tmp/` on `backup.example.com`.

<details>
<summary>Solution</summary>

```bash
# Copy file to remote server
scp /etc/hosts backup.example.com:/tmp/

# Copy as specific user
scp /etc/hosts admin@backup.example.com:/tmp/

# Copy with custom port
scp -P 2222 /etc/hosts admin@backup.example.com:/tmp/
```
</details>

---

### Question 9: Copy Directory Recursively with SCP
**Task:** Copy the entire directory `/var/log/httpd/` from `webserver.example.com` to your local `/tmp/logs/` directory.

<details>
<summary>Solution</summary>

```bash
# Create local destination directory
mkdir -p /tmp/logs

# Copy directory recursively from remote to local
scp -r webserver.example.com:/var/log/httpd/ /tmp/logs/

# Copy with preserved timestamps and permissions
scp -rp webserver.example.com:/var/log/httpd/ /tmp/logs/
```
</details>

---

### Question 10: Interactive File Transfer with SFTP
**Task:** Connect to `fileserver.example.com` using SFTP, download `/var/data/report.txt`, and upload your local `notes.txt`.

<details>
<summary>Solution</summary>

```bash
# Start SFTP session
sftp fileserver.example.com

# At sftp prompt:
sftp> cd /var/data
sftp> get report.txt
sftp> lcd /home/user/
sftp> put notes.txt
sftp> bye
```

**Non-interactive download:**
```bash
sftp fileserver.example.com:/var/data/report.txt /tmp/
```
</details>

---

### Question 11: Disable Password Authentication on SSH Server
**Task:** Configure the SSH server on `node1` to only allow key-based authentication (disable password authentication).

<details>
<summary>Solution</summary>

```bash
# Edit sshd configuration
sudo vi /etc/ssh/sshd_config

# Find and modify these lines:
PasswordAuthentication no
PubkeyAuthentication yes

# Restart SSH service
sudo systemctl restart sshd

# Verify the service is running
sudo systemctl status sshd
```

**Important:** Ensure you have working key-based authentication before disabling passwords!
</details>

---

### Question 12: Disable Root SSH Login
**Task:** Configure the SSH server to prevent direct root login while allowing other users to connect.

<details>
<summary>Solution</summary>

```bash
# Edit sshd configuration
sudo vi /etc/ssh/sshd_config

# Find and set:
PermitRootLogin no

# Restart SSH service
sudo systemctl restart sshd

# Verify configuration
sudo sshd -t
```

**Alternative - allow root only with key:**
```bash
PermitRootLogin prohibit-password
```
</details>

---

### Question 13: Configure SSH Client Defaults
**Task:** Create an SSH client configuration to automatically use user `admin`, port `2222`, and a specific key when connecting to hosts in the `*.lab.example.com` domain.

<details>
<summary>Solution</summary>

```bash
# Create or edit SSH client config
vi ~/.ssh/config

# Add the following:
Host *.lab.example.com
    User admin
    Port 2222
    IdentityFile ~/.ssh/lab_key
    
# Set proper permissions
chmod 600 ~/.ssh/config

# Test connection
ssh server1.lab.example.com
```
</details>

---

### Question 14: Debug SSH Connection Issues
**Task:** You cannot connect to `troubled.example.com`. Use verbose mode to diagnose the connection issue.

<details>
<summary>Solution</summary>

```bash
# Single verbose level
ssh -v troubled.example.com

# Maximum verbosity (3 levels)
ssh -vvv troubled.example.com

# Common issues to look for in output:
# - "Connection refused" - SSH service not running or firewall blocking
# - "Permission denied" - Authentication failure
# - "Host key verification failed" - Host key changed
# - "No route to host" - Network connectivity issue
```
</details>

---

### Question 15: Remove Known Host Entry
**Task:** After rebuilding `server5.example.com`, SSH complains about host key mismatch. Remove the old host key and reconnect.

<details>
<summary>Solution</summary>

```bash
# Method 1: Use ssh-keygen to remove specific host
ssh-keygen -R server5.example.com

# Method 2: Manually edit known_hosts
vi ~/.ssh/known_hosts
# Find and delete the line containing server5.example.com

# Method 3: Remove by IP address if needed
ssh-keygen -R 192.168.1.100

# Reconnect (will prompt to accept new key)
ssh server5.example.com
```
</details>

---

### Question 16: Use SSH with Sudo Commands
**Task:** Run `yum update -y` as root on `remote.example.com` using sudo via SSH.

<details>
<summary>Solution</summary>

```bash
# Force TTY allocation for sudo
ssh -t remote.example.com "sudo yum update -y"

# Multiple sudo commands
ssh -t remote.example.com "sudo bash -c 'yum update -y && systemctl restart httpd'"
```

**Note:** The `-t` flag is required because sudo needs a TTY for password prompt.
</details>

---

### Question 17: Configure SSH to Allow Specific Users Only
**Task:** Configure sshd to only allow users `admin` and `developer` to connect via SSH.

<details>
<summary>Solution</summary>

```bash
# Edit sshd configuration
sudo vi /etc/ssh/sshd_config

# Add this line (space-separated list):
AllowUsers admin developer

# Validate configuration syntax
sudo sshd -t

# Restart SSH service
sudo systemctl restart sshd
```

**Alternative - deny specific users:**
```bash
DenyUsers baduser1 baduser2
```
</details>

---

### Question 18: Transfer Files Between Two Remote Servers
**Task:** Copy `/var/log/messages` from `server1.example.com` to `/tmp/` on `server2.example.com` using your local machine as a relay.

<details>
<summary>Solution</summary>

```bash
# Method 1: Download then upload
scp server1.example.com:/var/log/messages /tmp/
scp /tmp/messages server2.example.com:/tmp/

# Method 2: Direct transfer through local machine (ProxyJump style)
scp -3 server1.example.com:/var/log/messages server2.example.com:/tmp/

# Method 3: If servers can reach each other, SSH to source and scp
ssh server1.example.com "scp /var/log/messages server2.example.com:/tmp/"
```
</details>

---

### Question 19: Change SSH Listening Port
**Task:** Configure the SSH server to listen on port 2222 instead of the default port 22.

<details>
<summary>Solution</summary>

```bash
# Edit sshd configuration
sudo vi /etc/ssh/sshd_config

# Change or add:
Port 2222

# If SELinux is enabled, allow the new port
sudo semanage port -a -t ssh_port_t -p tcp 2222

# Update firewall
sudo firewall-cmd --permanent --add-port=2222/tcp
sudo firewall-cmd --reload

# Restart SSH
sudo systemctl restart sshd

# Test connection
ssh -p 2222 localhost
```
</details>

---

### Question 20: Verify SSH Host Key Fingerprint
**Task:** Verify the SSH host key fingerprint of `newserver.example.com` before connecting.

<details>
<summary>Solution</summary>

```bash
# On the server (if you have console access), display fingerprint
ssh-keygen -l -f /etc/ssh/ssh_host_ed25519_key.pub
ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key.pub

# When connecting for first time, compare fingerprint shown with expected
ssh newserver.example.com
# Output will show:
# The authenticity of host 'newserver.example.com' can't be established.
# ED25519 key fingerprint is SHA256:xxxxxxxxxxxxxxxxxxx
# Are you sure you want to continue connecting (yes/no)?

# View fingerprints in known_hosts
ssh-keygen -l -f ~/.ssh/known_hosts
```
</details>

---

### Question 21: Use SSH Key with Passphrase and SSH Agent
**Task:** Generate a key with a passphrase, then configure ssh-agent so you don't have to enter the passphrase repeatedly.

<details>
<summary>Solution</summary>

```bash
# Generate key with passphrase
ssh-keygen -t ed25519 -f ~/.ssh/secure_key
# Enter a strong passphrase when prompted

# Start ssh-agent
eval $(ssh-agent)

# Add key to agent (enter passphrase once)
ssh-add ~/.ssh/secure_key

# Verify key is loaded
ssh-add -l

# Now connect without passphrase prompt
ssh -i ~/.ssh/secure_key server.example.com
```
</details>

---

### Question 22: Copy Multiple Files with SCP
**Task:** Copy files `config.txt`, `data.csv`, and `script.sh` from the current directory to `/opt/backup/` on `backup.example.com`.

<details>
<summary>Solution</summary>

```bash
# Copy multiple files
scp config.txt data.csv script.sh backup.example.com:/opt/backup/

# Using brace expansion
scp {config.txt,data.csv,script.sh} backup.example.com:/opt/backup/

# Copy all .conf files
scp *.conf backup.example.com:/opt/backup/
```
</details>

---

### Question 23: Manage SSH Service
**Task:** Check the status of the SSH service, ensure it starts on boot, and view recent SSH authentication logs.

<details>
<summary>Solution</summary>

```bash
# Check SSH service status
sudo systemctl status sshd

# Enable SSH to start on boot
sudo systemctl enable sshd

# Start/restart SSH service
sudo systemctl restart sshd

# View SSH authentication logs
sudo journalctl -u sshd
sudo journalctl -u sshd -f  # Follow live

# Alternative: check auth log
sudo tail -f /var/log/secure

# View failed SSH attempts
sudo grep "Failed password" /var/log/secure
```
</details>

---

### Question 24: Configure SSH Idle Timeout
**Task:** Configure the SSH server to disconnect idle clients after 5 minutes of inactivity.

<details>
<summary>Solution</summary>

```bash
# Edit sshd configuration
sudo vi /etc/ssh/sshd_config

# Add or modify:
ClientAliveInterval 300
ClientAliveCountMax 0

# ClientAliveInterval 300 = send keepalive every 300 seconds (5 minutes)
# ClientAliveCountMax 0 = disconnect immediately if no response

# Restart SSH
sudo systemctl restart sshd
```
</details>

---

### Question 25: Use Jump Host (Bastion)
**Task:** Connect to `internal.example.com` which is only accessible through bastion host `jump.example.com`.

<details>
<summary>Solution</summary>

```bash
# Method 1: Using -J flag (ProxyJump)
ssh -J jump.example.com internal.example.com

# Method 2: With specific users
ssh -J user1@jump.example.com user2@internal.example.com

# Method 3: Configure in ~/.ssh/config
cat >> ~/.ssh/config << EOF
Host internal.example.com
    ProxyJump jump.example.com
    User admin
EOF

# Then simply:
ssh internal.example.com
```
</details>

---

## Quick Reference Tables

### SSH Key Generation Commands

| Command | Description |
|---------|-------------|
| `ssh-keygen -t rsa -b 4096` | Generate 4096-bit RSA key |
| `ssh-keygen -t ed25519` | Generate Ed25519 key (recommended) |
| `ssh-keygen -t ed25519 -C "comment"` | Generate key with comment |
| `ssh-keygen -f ~/.ssh/custom` | Generate key with custom name |
| `ssh-keygen -p -f ~/.ssh/id_rsa` | Change passphrase on existing key |
| `ssh-keygen -l -f ~/.ssh/id_rsa.pub` | Display key fingerprint |
| `ssh-keygen -R hostname` | Remove host from known_hosts |

### Common SSH Connection Patterns

| Pattern | Command |
|---------|---------|
| Basic connection | `ssh hostname` |
| Connect as specific user | `ssh user@hostname` |
| Connect on custom port | `ssh -p 2222 hostname` |
| Connect with specific key | `ssh -i ~/.ssh/mykey hostname` |
| Execute remote command | `ssh hostname "command"` |
| Enable X11 forwarding | `ssh -X hostname` |
| Verbose debugging | `ssh -vvv hostname` |
| Through jump host | `ssh -J jumphost targethost` |

### File Transfer Commands

| Task | SCP Command | SFTP Command |
|------|-------------|--------------|
| Upload file | `scp file host:/path/` | `sftp host` → `put file` |
| Download file | `scp host:/path/file .` | `sftp host` → `get file` |
| Upload directory | `scp -r dir/ host:/path/` | `sftp host` → `put -r dir` |
| Download directory | `scp -r host:/path/dir/ .` | `sftp host` → `get -r dir` |
| Custom port | `scp -P 2222 file host:/` | `sftp -P 2222 host` |

### Troubleshooting Checklist

| Issue | Check | Solution |
|-------|-------|----------|
| Permission denied | `ls -la ~/.ssh/` | `chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys` |
| Connection refused | `systemctl status sshd` | `systemctl start sshd` |
| Host key changed | Warning message | `ssh-keygen -R hostname` |
| Key not accepted | Key in authorized_keys? | `ssh-copy-id user@host` |
| Firewall blocking | `firewall-cmd --list-all` | `firewall-cmd --add-service=ssh --permanent` |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Connect to remote systems** using various ssh options (`-p`, `-l`, `-i`)
2. **Generate SSH key pairs** using `ssh-keygen` (RSA and Ed25519)
3. **Configure passwordless authentication** using `ssh-copy-id`
4. **Set correct permissions** on SSH directories and files (700, 600)
5. **Transfer files securely** using `scp` and `sftp`
6. **Execute remote commands** without interactive login
7. **Configure sshd** settings (PermitRootLogin, PasswordAuthentication)
8. **Manage the SSH service** using systemctl
9. **Troubleshoot SSH issues** using verbose mode and log files
10. **Configure SSH client** using `~/.ssh/config`

### Key Files to Remember

| File | Purpose |
|------|---------|
| `~/.ssh/id_rsa` / `~/.ssh/id_ed25519` | Private key |
| `~/.ssh/id_rsa.pub` / `~/.ssh/id_ed25519.pub` | Public key |
| `~/.ssh/authorized_keys` | Accepted public keys for login |
| `~/.ssh/known_hosts` | Previously connected hosts |
| `~/.ssh/config` | Client configuration |
| `/etc/ssh/sshd_config` | Server configuration |
| `/etc/ssh/ssh_config` | System-wide client configuration |
