# Configure Key-Based Authentication for SSH

## Overview

SSH key-based authentication provides a more secure alternative to password authentication. For the RHCSA exam, you must understand how to generate SSH key pairs, distribute public keys, and configure SSH for key-based authentication.

---

## SSH Key Concepts

### How SSH Key Authentication Works

1. **Key Pair Generation**: Client generates a public/private key pair
2. **Public Key Distribution**: Public key is copied to the server
3. **Authentication**: Server challenges client to prove possession of private key
4. **Access Granted**: Server grants access if challenge is successful

### Key Types

| Algorithm | Command Option | Security Level | Recommendation |
|-----------|---------------|----------------|----------------|
| RSA | `-t rsa` | Good (with 4096 bits) | Legacy compatible |
| ECDSA | `-t ecdsa` | Good | Modern, smaller keys |
| ED25519 | `-t ed25519` | Excellent | Recommended for new setups |

---

## Key Files and Locations

### Default File Locations

| File | Location | Purpose |
|------|----------|---------|
| Private key | `~/.ssh/id_rsa` (or id_ed25519) | SECRET - Never share |
| Public key | `~/.ssh/id_rsa.pub` | Safe to distribute |
| Authorized keys | `~/.ssh/authorized_keys` | Server-side public keys |
| Known hosts | `~/.ssh/known_hosts` | Server fingerprints |

### Required Permissions

```bash
# Directory permissions
chmod 700 ~/.ssh

# Private key permissions (CRITICAL)
chmod 600 ~/.ssh/id_rsa

# Public key permissions
chmod 644 ~/.ssh/id_rsa.pub

# Authorized keys permissions
chmod 600 ~/.ssh/authorized_keys
```

> **Important**: SSH will refuse to use keys with incorrect permissions!

---

## Generating SSH Keys

### Generate a Key Pair

```bash
# Generate ED25519 key (recommended)
ssh-keygen -t ed25519

# Generate RSA key with 4096 bits
ssh-keygen -t rsa -b 4096

# Generate with specific filename
ssh-keygen -t ed25519 -f ~/.ssh/my_custom_key

# Generate with comment (useful for identification)
ssh-keygen -t ed25519 -C "admin@server1"
```

### Interactive Key Generation

```
$ ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/user/.ssh/id_ed25519): [Press Enter]
Enter passphrase (empty for no passphrase): [Enter passphrase]
Enter same passphrase again: [Confirm passphrase]
Your identification has been saved in /home/user/.ssh/id_ed25519
Your public key has been saved in /home/user/.ssh/id_ed25519.pub
```

### Passphrase Considerations

| Option | Security | Convenience |
|--------|----------|-------------|
| With passphrase | High | Requires entry each use |
| Without passphrase | Lower | Seamless automation |
| With ssh-agent | High | Enter once per session |

---

## Distributing Public Keys

### Method 1: ssh-copy-id (Recommended)

```bash
# Copy public key to remote server
ssh-copy-id user@remote_server

# Copy specific key
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@remote_server

# Specify non-standard port
ssh-copy-id -p 2222 user@remote_server
```

### Method 2: Manual Copy

```bash
# Display public key
cat ~/.ssh/id_ed25519.pub

# Copy to remote server manually
ssh user@remote_server "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
ssh user@remote_server "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_ed25519.pub
ssh user@remote_server "chmod 600 ~/.ssh/authorized_keys"
```

### Method 3: Copy-Paste

1. Display local public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

2. On remote server:
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
vi ~/.ssh/authorized_keys
# Paste the public key
chmod 600 ~/.ssh/authorized_keys
```

---

## Testing SSH Key Authentication

### Basic Connection Test

```bash
# Connect using default key
ssh user@remote_server

# Connect using specific key
ssh -i ~/.ssh/my_custom_key user@remote_server

# Verbose mode for troubleshooting
ssh -v user@remote_server
```

### Verify Key is Being Used

```bash
# Very verbose output shows key negotiation
ssh -vv user@remote_server 2>&1 | grep -i "identity"
```

---

## SSH Server Configuration

### Important sshd_config Options

Location: `/etc/ssh/sshd_config`

```bash
# Enable public key authentication (default: yes)
PubkeyAuthentication yes

# Specify authorized keys file location
AuthorizedKeysFile .ssh/authorized_keys

# Disable password authentication (for key-only)
PasswordAuthentication no

# Disable root login with password
PermitRootLogin prohibit-password

# Or disable root login completely
PermitRootLogin no
```

### Apply Configuration Changes

```bash
# Validate configuration syntax
sudo sshd -t

# Restart SSH service
sudo systemctl restart sshd
```

> **Warning**: Always keep an active session open when changing SSH configuration!

---

## SSH Agent

### Using ssh-agent

```bash
# Start ssh-agent
eval $(ssh-agent)

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# List keys in agent
ssh-add -l

# Remove all keys from agent
ssh-add -D
```

### Persistent ssh-agent

Add to `~/.bashrc`:
```bash
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/id_ed25519
fi
```

---

## Practice Questions

### Question 1: Generate SSH Key Pair
Generate an ED25519 SSH key pair with the comment "rhcsa-exam" and save it as `~/.ssh/exam_key`.

<details>
<summary>Show Solution</summary>

```bash
# Generate the key pair
ssh-keygen -t ed25519 -C "rhcsa-exam" -f ~/.ssh/exam_key

# Verify files created
ls -la ~/.ssh/exam_key*

# View public key
cat ~/.ssh/exam_key.pub
```

**Output:**
```
-rw-------. 1 user user  411 Jan 15 10:00 /home/user/.ssh/exam_key
-rw-r--r--. 1 user user  101 Jan 15 10:00 /home/user/.ssh/exam_key.pub
```

</details>

---

### Question 2: Copy Public Key to Server
Copy your public key to the server `192.168.1.100` for user `admin`.

<details>
<summary>Show Solution</summary>

```bash
# Method 1: Using ssh-copy-id (recommended)
ssh-copy-id admin@192.168.1.100

# Method 2: Copy specific key
ssh-copy-id -i ~/.ssh/id_ed25519.pub admin@192.168.1.100

# Verify by connecting without password
ssh admin@192.168.1.100
```

</details>

---

### Question 3: Fix SSH Key Permissions
Your SSH key authentication is failing. The permissions on your `.ssh` directory are 755 and your private key is 644. Fix the permissions.

<details>
<summary>Show Solution</summary>

```bash
# Fix directory permissions
chmod 700 ~/.ssh

# Fix private key permissions
chmod 600 ~/.ssh/id_*

# Fix public key permissions (optional but good practice)
chmod 644 ~/.ssh/id_*.pub

# Fix authorized_keys if exists
chmod 600 ~/.ssh/authorized_keys

# Verify
ls -la ~/.ssh/
```

**Required permissions:**
```
drwx------. 2 user user 4096 .ssh/
-rw-------. 1 user user  411 id_ed25519
-rw-r--r--. 1 user user  101 id_ed25519.pub
-rw-------. 1 user user  400 authorized_keys
```

</details>

---

### Question 4: Configure Passwordless SSH for Root
Configure SSH so that root can log in using key-based authentication but not with a password.

<details>
<summary>Show Solution</summary>

```bash
# Generate key for root (if needed)
sudo ssh-keygen -t ed25519

# Copy public key to target server
sudo ssh-copy-id root@target_server

# On target server, edit sshd_config
sudo vi /etc/ssh/sshd_config

# Set these options:
PermitRootLogin prohibit-password
PubkeyAuthentication yes
PasswordAuthentication no  # For all users, or use Match block

# Restart SSH
sudo systemctl restart sshd

# Test
ssh root@target_server
```

</details>

---

### Question 5: Disable Password Authentication
Configure the SSH server to only allow key-based authentication (disable passwords).

<details>
<summary>Show Solution</summary>

```bash
# Edit SSH configuration
sudo vi /etc/ssh/sshd_config

# Change/add these lines:
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no

# Validate configuration
sudo sshd -t

# Restart SSH service
sudo systemctl restart sshd

# Verify (this should fail from a machine without keys)
# ssh user@thisserver  # Will get "Permission denied (publickey)"
```

> **Important**: Ensure you have working key authentication before disabling passwords!

</details>

---

### Question 6: Generate Key Without Passphrase
Generate an RSA key pair without a passphrase for automation purposes.

<details>
<summary>Show Solution</summary>

```bash
# Generate RSA key with no passphrase
ssh-keygen -t rsa -b 4096 -f ~/.ssh/automation_key -N ""

# -N "" sets an empty passphrase

# Verify
ls -la ~/.ssh/automation_key*

# Note: This is less secure but needed for automated scripts
```

</details>

---

### Question 7: SSH to Non-Standard Port
Connect to server `192.168.1.50` on port 2222 using a specific key file `~/.ssh/custom_key`.

<details>
<summary>Show Solution</summary>

```bash
# Connect with specific port and key
ssh -p 2222 -i ~/.ssh/custom_key user@192.168.1.50

# Or configure in ~/.ssh/config for easier access
vi ~/.ssh/config

# Add:
Host myserver
    HostName 192.168.1.50
    Port 2222
    User user
    IdentityFile ~/.ssh/custom_key

# Then simply:
ssh myserver
```

</details>

---

### Question 8: Troubleshoot SSH Key Authentication
SSH key authentication is not working. How do you troubleshoot?

<details>
<summary>Show Solution</summary>

```bash
# 1. Check verbose output
ssh -vvv user@server

# 2. Verify client-side permissions
ls -la ~/.ssh/
# Should be:
# drwx------ .ssh/
# -rw------- private key

# 3. Check server-side authorized_keys
ssh user@server "ls -la ~/.ssh/"
ssh user@server "cat ~/.ssh/authorized_keys"

# 4. Check SELinux context (on server)
ls -laZ ~/.ssh/

# 5. Restore SELinux context if needed
restorecon -Rv ~/.ssh/

# 6. Check SSH server logs
sudo journalctl -u sshd -f

# 7. Verify sshd_config settings
sudo grep -E "^(PubkeyAuthentication|AuthorizedKeysFile)" /etc/ssh/sshd_config
```

**Common issues:**
- Wrong permissions (must be 700 for .ssh, 600 for private key)
- SELinux context incorrect
- Public key not in authorized_keys
- PubkeyAuthentication disabled

</details>

---

### Question 9: Multiple Keys for Different Servers
Configure SSH to automatically use different keys for different servers.

<details>
<summary>Show Solution</summary>

```bash
# Create SSH config file
vi ~/.ssh/config

# Add configuration:
Host server1
    HostName 192.168.1.10
    User admin
    IdentityFile ~/.ssh/server1_key

Host server2
    HostName 192.168.1.20
    User developer
    IdentityFile ~/.ssh/server2_key

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_key

# Set permissions
chmod 600 ~/.ssh/config

# Now use simple commands:
ssh server1
ssh server2
git clone git@github.com:user/repo.git
```

</details>

---

### Question 10: Setup Key Authentication for Ansible
Configure SSH key-based authentication so user `ansible` can connect to `node1` and `node2` without a password.

<details>
<summary>Show Solution</summary>

```bash
# On control node, generate key for ansible user
sudo -u ansible ssh-keygen -t ed25519 -N ""

# Copy to managed nodes
sudo -u ansible ssh-copy-id ansible@node1
sudo -u ansible ssh-copy-id ansible@node2

# Verify connectivity
sudo -u ansible ssh node1 "hostname"
sudo -u ansible ssh node2 "hostname"

# Or using a loop:
for node in node1 node2; do
    sudo -u ansible ssh-copy-id ansible@$node
done
```

</details>

---

## Quick Reference

| Task | Command |
|------|---------|
| Generate ED25519 key | `ssh-keygen -t ed25519` |
| Generate RSA 4096 key | `ssh-keygen -t rsa -b 4096` |
| Copy public key | `ssh-copy-id user@server` |
| Connect with specific key | `ssh -i ~/.ssh/mykey user@server` |
| Start ssh-agent | `eval $(ssh-agent)` |
| Add key to agent | `ssh-add ~/.ssh/id_ed25519` |
| Debug connection | `ssh -vvv user@server` |

---

## Important Permissions Summary

| Item | Permission | Octal |
|------|------------|-------|
| ~/.ssh/ directory | drwx------ | 700 |
| Private key | -rw------- | 600 |
| Public key | -rw-r--r-- | 644 |
| authorized_keys | -rw------- | 600 |
| config | -rw------- | 600 |

---

## Summary

- Generate keys with `ssh-keygen` (prefer ED25519)
- Copy public key with `ssh-copy-id`
- **Critical permissions**: `.ssh` = 700, private key = 600
- Configure in `/etc/ssh/sshd_config` and restart `sshd`
- Use `ssh -vvv` for troubleshooting
- Consider `~/.ssh/config` for managing multiple servers
