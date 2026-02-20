# Log In and Switch Users in Multiuser Targets

## Topic Overview
This topic covers logging into Linux systems, switching between user accounts using `su` and `sudo`, and understanding systemd targets (multiuser, graphical, rescue, emergency). These are fundamental skills for system administration and are essential for the RHCSA exam.

> **Note:** For accessing systems remotely via SSH, see Topic 04: Access Remote Systems Using SSH.

---

## Understanding Systemd Targets

### What are Systemd Targets?
Systemd targets are units that group together other systemd units for synchronization purposes. They replace the traditional SysV runlevels and define the system state.

### Common Systemd Targets

| Target | Purpose | Equivalent Runlevel |
|--------|---------|---------------------|
| `poweroff.target` | Shut down and power off the system | 0 |
| `rescue.target` | Single-user mode with basic system and mounts | 1 |
| `multi-user.target` | Multi-user, non-graphical (text mode) | 3 |
| `graphical.target` | Multi-user with graphical interface | 5 |
| `reboot.target` | Shut down and reboot the system | 6 |
| `emergency.target` | Emergency shell (minimal, read-only root) | - |

### Target Comparison

| Feature | multi-user.target | graphical.target | rescue.target | emergency.target |
|---------|-------------------|------------------|---------------|------------------|
| Network | Yes | Yes | Limited | No |
| File systems | All mounted | All mounted | All mounted | Root only (may be read-only) |
| Services | Full | Full + GUI | Minimal | None |
| Users | Multiple | Multiple | Single (root) | Single (root) |
| Display Manager | No | Yes | No | No |

---

## Switching Between Users

### The `su` Command (Substitute User)

The `su` command allows you to switch to another user account.

**Syntax:**
```bash
su [options] [-] [user [argument...]]
```

### Key `su` Options

| Option | Description |
|--------|-------------|
| `-` or `-l` or `--login` | Start a login shell (full environment) |
| `-c command` | Execute a single command as the user |
| `-s shell` | Use specified shell instead of default |
| `-m` or `-p` | Preserve current environment |
| (no option) | Switch user without login shell (partial environment) |

### Difference Between `su` and `su -`

| Aspect | `su username` | `su - username` |
|--------|---------------|-----------------|
| Working directory | Stays in current directory | Changes to user's home |
| Environment variables | Keeps most from current user | Loads target user's environment |
| PATH | Keeps current PATH | Loads target user's PATH |
| Shell initialization | Skips login scripts | Runs .bash_profile, .bashrc |

---

## The `sudo` Command

### What is sudo?
`sudo` (superuser do) allows a permitted user to execute commands as root or another user, as specified in the `/etc/sudoers` file.

**Syntax:**
```bash
sudo [options] command
```

### Key `sudo` Options

| Option | Description |
|--------|-------------|
| `-i` | Run login shell as root (simulate `su -`) |
| `-s` | Run shell as root (simulate `su`) |
| `-u user` | Run command as specified user |
| `-l` | List allowed (and forbidden) commands |
| `-k` | Reset cached credentials |
| `-v` | Update cached credentials without running command |
| `-b` | Run command in background |
| `-e` or `sudoedit` | Edit files (safe editing) |

### The wheel Group
In RHEL, members of the `wheel` group can use `sudo` to run commands as root. This is configured in `/etc/sudoers`.

---

## Configuring sudo with visudo

### The sudoers File
The `/etc/sudoers` file controls who can use sudo and what commands they can run.

**Always edit with:**
```bash
sudo visudo
```

### sudoers Syntax
```
user/group  hosts = (run_as_user) commands
```

### Common sudoers Entries

| Entry | Meaning |
|-------|---------|
| `%wheel ALL=(ALL) ALL` | wheel group members can run any command |
| `%wheel ALL=(ALL) NOPASSWD: ALL` | wheel group without password |
| `user1 ALL=(ALL) /usr/bin/systemctl` | user1 can only run systemctl |
| `user1 ALL=(ALL) NOPASSWD: /usr/bin/yum` | user1 can run yum without password |
| `user1 ALL=(ALL) NOPASSWD: /usr/bin/apt, PASSWD: /bin/kill` | Mixed: apt without password, kill with password |
| `user1 ALL=ALL, !/usr/bin/su` | user1 can run all commands except su |

---

## User Account Types

Linux has different types of user accounts:

| Account Type | UID Range | Description |
|--------------|-----------|-------------|
| **Root** | 0 | Superuser with unrestricted access |
| **System Accounts** | 1-999 | Created during OS installation for services (ssh, mail) |
| **Regular Users** | 1000+ | Normal user accounts for individuals |

### Viewing User Information

```bash
# Display current username
whoami

# Display user ID, group ID, and group memberships
id
id username

# View user account details
grep username /etc/passwd

# Display groups the current user belongs to
groups
groups username
```

### The `/etc/passwd` File Structure

Each line in `/etc/passwd` contains seven colon-separated fields:

```
username:x:UID:GID:comment:home_directory:shell
```

Example:
```bash
bob:x:1000:1000:Bob Smith:/home/bob:/bin/bash
```

---

## Monitoring User Sessions

### The `who` Command

Displays users currently logged in:

```bash
# Show logged in users
who

# Show additional details (idle time, PID)
who -a
```

### The `last` Command

Shows history of user logins and system reboots:

```bash
# Display login history
last

# Show last 10 logins
last -n 10

# Show reboot history
last reboot
```

---

## Disabling User Login

To prevent a user from logging in, set their shell to `/sbin/nologin`:

```bash
# Disable login for a user
sudo usermod -s /sbin/nologin username

# Verify the change
grep username /etc/passwd

# Re-enable login
sudo usermod -s /bin/bash username
```

---

## Real-World Exam Practice Questions

### Question 1: Switch to Root User with Login Shell
**Task:** Switch to the root user with a full login environment.

<details>
<summary>Solution</summary>

```bash
# Method 1: Using su with login option
su -

# Method 2: Explicit root user
su - root

# Enter root password when prompted

# Verify you are root
whoami
id
pwd    # Should be /root
```

**Note:** The `-` ensures you get root's full environment including PATH.
</details>

---

### Question 2: Switch to Another User Without Login Shell
**Task:** Switch to user `developer` without starting a login shell (keeping your current environment).

<details>
<summary>Solution</summary>

```bash
# Switch without login shell
su developer

# Enter developer's password when prompted

# Note: Your working directory stays the same
pwd

# Your PATH may still contain your original paths
echo $PATH
```
</details>

---

### Question 3: Execute Single Command as Another User
**Task:** Run the command `cat /home/admin/notes.txt` as user `admin` without fully switching to that account.

<details>
<summary>Solution</summary>

```bash
# Using su -c to run a single command
su - admin -c "cat /home/admin/notes.txt"

# Enter admin's password when prompted
# After command executes, you return to your original shell
```
</details>

---

### Question 4: Run Command as Root Using sudo
**Task:** Install the `httpd` package using sudo without switching to root.

<details>
<summary>Solution</summary>

```bash
# Run yum as root using sudo
sudo yum install httpd -y

# Enter YOUR password (not root's) when prompted
```
</details>

---

### Question 5: Get a Root Shell Using sudo
**Task:** Open a root shell using sudo with the full login environment.

<details>
<summary>Solution</summary>

```bash
# Method 1: Login shell as root (recommended)
sudo -i

# Method 2: Non-login shell as root
sudo -s

# Method 3: Explicitly run bash as root
sudo /bin/bash

# Verify
whoami
pwd
```

**Key difference:**
- `sudo -i` = like `su -` (login shell, changes to /root)
- `sudo -s` = like `su` (keeps current directory)
</details>

---

### Question 6: Run Command as Specific User with sudo
**Task:** Run the command `whoami` as user `webadmin` using sudo.

<details>
<summary>Solution</summary>

```bash
# Use -u to specify the user
sudo -u webadmin whoami

# Output should be: webadmin

# Run other commands as webadmin
sudo -u webadmin id
```
</details>

---

### Question 7: List Your sudo Privileges
**Task:** Check what commands you are allowed to run with sudo.

<details>
<summary>Solution</summary>

```bash
# List your sudo privileges
sudo -l

# Example output:
# User user1 may run the following commands on server1:
#     (ALL) ALL

# More verbose listing
sudo -ll
```
</details>

---

### Question 8: Add User to wheel Group for sudo Access
**Task:** Grant user `newadmin` the ability to use sudo by adding them to the wheel group.

<details>
<summary>Solution</summary>

```bash
# Add user to wheel group
sudo usermod -aG wheel newadmin

# Verify group membership
groups newadmin
id newadmin

# The user must log out and back in for group change to take effect
```
</details>

---

### Question 9: Configure User for Passwordless sudo
**Task:** Configure user `automation` to run all commands via sudo without requiring a password.

<details>
<summary>Solution</summary>

```bash
# Edit sudoers file
sudo visudo

# Add this line at the end:
automation ALL=(ALL) NOPASSWD: ALL

# Save and exit (:wq)

# Test as automation user
sudo -u automation sudo whoami
```

**Alternative using drop-in file:**
```bash
# Create a file in /etc/sudoers.d/
sudo visudo -f /etc/sudoers.d/automation

# Add:
automation ALL=(ALL) NOPASSWD: ALL
```
</details>

---

### Question 10: Grant Limited sudo Access
**Task:** Allow user `webdev` to only restart the httpd service using sudo, without a password.

<details>
<summary>Solution</summary>

```bash
# Edit sudoers
sudo visudo

# Add this line:
webdev ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart httpd

# Save and exit

# Test (as webdev)
sudo systemctl restart httpd    # Works
sudo systemctl stop httpd       # Permission denied
```
</details>

---

### Question 11: Check Current Target (Runlevel)
**Task:** Determine the current systemd target the system is running.

<details>
<summary>Solution</summary>

```bash
# Method 1: Get current target
systemctl get-default

# Method 2: List all active targets
systemctl list-units --type=target --state=active

# Method 3: Check current "runlevel" 
who -r

# Method 4: Using runlevel command
runlevel
```
</details>

---

### Question 12: Set Default Target to Multi-User (Text Mode)
**Task:** Configure the system to boot into multi-user (text) mode by default instead of graphical mode.

<details>
<summary>Solution</summary>

```bash
# Set default target to multi-user
sudo systemctl set-default multi-user.target

# Verify the change
systemctl get-default

# Output: multi-user.target

# This takes effect on next reboot
```
</details>

---

### Question 13: Set Default Target to Graphical Mode
**Task:** Configure the system to boot into graphical (GUI) mode by default.

<details>
<summary>Solution</summary>

```bash
# Set default target to graphical
sudo systemctl set-default graphical.target

# Verify
systemctl get-default

# Output: graphical.target
```
</details>

---

### Question 14: Switch to Different Target Immediately
**Task:** Switch the running system from graphical to multi-user target without rebooting.

<details>
<summary>Solution</summary>

```bash
# Isolate to multi-user target (stops graphical services)
sudo systemctl isolate multi-user.target

# To switch back to graphical
sudo systemctl isolate graphical.target

# Note: "isolate" starts the target and stops non-dependency units
```
</details>

---

### Question 15: Boot into Rescue Mode
**Task:** Switch the system to rescue mode for single-user maintenance.

<details>
<summary>Solution</summary>

```bash
# Method 1: From running system
sudo systemctl isolate rescue.target

# Method 2: From GRUB bootloader
# 1. Reboot and interrupt GRUB (press any key)
# 2. Press 'e' to edit boot entry
# 3. Find the line starting with 'linux'
# 4. Append: systemd.unit=rescue.target
# 5. Press Ctrl+X to boot

# In rescue mode, you'll be prompted for root password
```

**Note:** Rescue mode mounts all filesystems and starts minimal services.
</details>

---

### Question 16: Boot into Emergency Mode
**Task:** Access emergency mode when the system cannot boot normally.

<details>
<summary>Solution</summary>

```bash
# From GRUB bootloader:
# 1. Reboot and interrupt GRUB
# 2. Press 'e' to edit boot entry
# 3. Find the line starting with 'linux'
# 4. Append: systemd.unit=emergency.target
# 5. Press Ctrl+X to boot

# Emergency mode provides root shell with minimal environment
# Root filesystem may be mounted read-only
# To remount read-write:
mount -o remount,rw /
```

**Note:** Emergency mode is more minimal than rescue - no services, minimal mounts.
</details>

---

### Question 17: Reset Root Password Using Emergency Mode
**Task:** Reset the root password when you've forgotten it.

<details>
<summary>Solution</summary>

```bash
# 1. Reboot and interrupt GRUB
# 2. Press 'e' to edit boot entry
# 3. Find the line starting with 'linux'
# 4. Append: rd.break
# 5. Press Ctrl+X to boot

# At the switch_root prompt:
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
# Enter new password twice

# If SELinux is enabled:
touch /.autorelabel

# Exit chroot and reboot
exit
exit
```
</details>

---

### Question 18: Verify User Identity After Switching
**Task:** After switching to another user, verify your current identity and groups.

<details>
<summary>Solution</summary>

```bash
# Switch to user
su - testuser

# Verify username
whoami

# Show detailed user info
id

# Output example:
# uid=1001(testuser) gid=1001(testuser) groups=1001(testuser),10(wheel)

# Show groups only
groups

# Show logged in users
who
w
```
</details>

---

### Question 19: Check sudo Log Entries
**Task:** View recent sudo command usage on the system.

<details>
<summary>Solution</summary>

```bash
# View sudo logs in secure log
sudo grep sudo /var/log/secure

# View using journalctl
sudo journalctl -u sudo

# More specific search
sudo journalctl | grep sudo

# View authentication messages
sudo tail -f /var/log/secure
```
</details>

---

### Question 20: Lock/Invalidate sudo Credentials
**Task:** Force sudo to require re-authentication on next use (remove cached credentials).

<details>
<summary>Solution</summary>

```bash
# Remove cached credentials for current session
sudo -k

# Remove ALL cached credentials (all terminals/sessions)
sudo -K

# Next sudo command will require password
sudo whoami
# Password prompt appears
```
</details>

---

### Question 21: Create sudoers Drop-in Configuration
**Task:** Create a separate sudoers configuration file to grant the `dbadmins` group access to database-related commands.

<details>
<summary>Solution</summary>

```bash
# Create drop-in file (safer than editing main sudoers)
sudo visudo -f /etc/sudoers.d/dbadmins

# Add content:
%dbadmins ALL=(ALL) /usr/bin/systemctl * postgresql, /usr/bin/psql

# Set correct permissions
sudo chmod 440 /etc/sudoers.d/dbadmins

# Test syntax
sudo visudo -c
```
</details>

---

### Question 22: View Available Targets
**Task:** List all available systemd targets on the system.

<details>
<summary>Solution</summary>

```bash
# List all available targets
systemctl list-units --type=target --all

# List only active targets
systemctl list-units --type=target

# Show target dependencies
systemctl list-dependencies multi-user.target

# Show what default.target links to
ls -l /etc/systemd/system/default.target
```
</details>

---

### Question 23: Compare runlevel and systemctl Commands
**Task:** Demonstrate the relationship between legacy runlevel commands and systemctl.

<details>
<summary>Solution</summary>

| Legacy Command | systemctl Equivalent |
|----------------|---------------------|
| `init 0` | `systemctl poweroff` |
| `init 1` | `systemctl isolate rescue.target` |
| `init 3` | `systemctl isolate multi-user.target` |
| `init 5` | `systemctl isolate graphical.target` |
| `init 6` | `systemctl reboot` |
| `runlevel` | `systemctl get-default` |
| `telinit 3` | `systemctl isolate multi-user.target` |

```bash
# Check current runlevel (legacy)
runlevel

# Check current target (modern)
systemctl get-default

# Both show equivalent information
```
</details>

---

### Question 24: Execute Multiple Commands with su
**Task:** As user `operator`, run a series of commands to check disk space, memory, and running processes.

<details>
<summary>Solution</summary>

```bash
# Method 1: Using -c with quoted command string
su - operator -c "df -h; free -m; ps aux | head"

# Method 2: Start interactive shell and run commands
su - operator
df -h
free -m
ps aux | head
exit
```
</details>

---

### Question 25: Configure sudo to Log All Commands
**Task:** Ensure all sudo commands are logged to a specific file.

<details>
<summary>Solution</summary>

```bash
# Edit sudoers
sudo visudo

# Add these lines:
Defaults logfile="/var/log/sudo.log"
Defaults log_input, log_output
Defaults!/usr/bin/sudoreplay !log_output
Defaults!/usr/bin/reboot !log_output

# Save and exit

# Verify logging works
sudo ls /root
cat /var/log/sudo.log
```
</details>

---

## Quick Reference Tables

### User Switching Commands

| Task | Command |
|------|---------|
| Switch to root (login shell) | `su -` or `su - root` |
| Switch to root (non-login) | `su` |
| Switch to user (login shell) | `su - username` |
| Switch to user (non-login) | `su username` |
| Run single command as user | `su - username -c "command"` |
| sudo as root | `sudo command` |
| sudo login shell as root | `sudo -i` |
| sudo as specific user | `sudo -u username command` |
| List sudo privileges | `sudo -l` |

### Target Management Commands

| Task | Command |
|------|---------|
| Get default target | `systemctl get-default` |
| Set default to multi-user | `systemctl set-default multi-user.target` |
| Set default to graphical | `systemctl set-default graphical.target` |
| Switch to target now | `systemctl isolate target-name` |
| List active targets | `systemctl list-units --type=target` |
| Rescue mode (GRUB) | Append `systemd.unit=rescue.target` |
| Emergency mode (GRUB) | Append `systemd.unit=emergency.target` |
| Reset root password | Append `rd.break` to kernel line |

### sudoers Syntax Quick Reference

| Pattern | Meaning |
|---------|---------|
| `ALL` | All hosts, users, or commands |
| `%groupname` | Refers to a group |
| `NOPASSWD:` | No password required |
| `(ALL)` | Run as any user |
| `(root)` | Run as root only |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Switch users** using `su` and `su -` and understand the difference
2. **Use sudo** to execute commands as root or other users
3. **Configure sudo access** by editing `/etc/sudoers` with `visudo`
4. **Add users to wheel group** for sudo privileges
5. **Understand systemd targets** (multi-user, graphical, rescue, emergency)
6. **Change the default target** using `systemctl set-default`
7. **Switch targets at runtime** using `systemctl isolate`
8. **Boot into rescue/emergency mode** from GRUB
9. **Reset the root password** using `rd.break`
10. **Verify user identity** with `whoami`, `id`, and `groups`

### Key Commands Summary

| Command | Purpose |
|---------|---------|
| `su - username` | Switch to user with login shell |
| `sudo command` | Run command as root |
| `sudo -i` | Root login shell via sudo |
| `sudo -u user command` | Run as specific user |
| `sudo visudo` | Edit sudoers safely |
| `usermod -aG wheel user` | Add user to wheel group |
| `systemctl get-default` | Show default boot target |
| `systemctl set-default target` | Set default boot target |
| `systemctl isolate target` | Switch to target immediately |

### Key Files

| File | Purpose |
|------|---------|
| `/etc/sudoers` | Main sudo configuration |
| `/etc/sudoers.d/` | Drop-in sudo configuration files |
| `/etc/passwd` | User account information |
| `/etc/group` | Group membership |
| `/etc/systemd/system/default.target` | Symlink to default target |
| `/var/log/secure` | Authentication and sudo logs |
