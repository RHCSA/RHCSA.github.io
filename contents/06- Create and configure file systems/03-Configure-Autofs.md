# Configure Autofs

## RHCSA Exam Objective
> Configure autofs

---

## Introduction

Autofs automatically mounts filesystems on demand and unmounts them after a period of inactivity. This is more efficient than static mounts in /etc/fstab, especially for network shares that aren't always needed. The RHCSA exam commonly tests autofs for NFS home directories and network shares.

---

## Key Components

| File/Command | Description |
|--------------|-------------|
| `/etc/auto.master` | Master map file (defines mount points) |
| `/etc/auto.*` | Map files (define what to mount) |
| `autofs.service` | Autofs systemd service |

---

## How Autofs Works

```
/etc/auto.master → Defines base directories
     ↓
/etc/auto.xxx   → Defines subdirectories and mount sources
     ↓
User accesses /base/subdir → Autofs mounts automatically
     ↓
Idle timeout → Autofs unmounts automatically
```

---

## Practice Questions

### Question 1: Install Autofs
**Task:** Install and enable the autofs service.

<details>
<summary>Show Solution</summary>

```bash
# Install autofs
sudo dnf install autofs -y

# Enable and start service
sudo systemctl enable --now autofs

# Verify
sudo systemctl status autofs
```
</details>

---

### Question 2: Understand auto.master Format
**Task:** Explain the format of /etc/auto.master.

<details>
<summary>Show Solution</summary>

**Format:**
```
/mount-point    /etc/auto.mapfile    options
```

**Example:**
```
/nfs    /etc/auto.nfs    --timeout=60
```

**Explanation:**
- `/nfs`: Parent directory for automounts
- `/etc/auto.nfs`: Map file defining subdirectories
- `--timeout=60`: Unmount after 60 seconds of inactivity
</details>

---

### Question 3: Understand Map File Format
**Task:** Explain the format of autofs map files.

<details>
<summary>Show Solution</summary>

**Format:**
```
key    options    source
```

**Example in /etc/auto.nfs:**
```
data    -rw,soft    server:/share/data
```

**Explanation:**
- `data`: Subdirectory name (creates /nfs/data)
- `-rw,soft`: Mount options
- `server:/share/data`: NFS source

**Access:**
```bash
cd /nfs/data    # Triggers automount
```
</details>

---

### Question 4: Configure Direct Map
**Task:** Configure autofs to mount NFS share /exports/data from server at /mnt/autodata.

<details>
<summary>Show Solution</summary>

**Step 1: Edit /etc/auto.master**
```bash
sudo vim /etc/auto.master
```

**Add line:**
```
/-    /etc/auto.direct
```

**Note:** `/-` indicates direct map (absolute path mounts).

**Step 2: Create /etc/auto.direct**
```bash
sudo vim /etc/auto.direct
```

**Add line:**
```
/mnt/autodata    -rw    server:/exports/data
```

**Step 3: Restart autofs**
```bash
sudo systemctl restart autofs
```

**Step 4: Test**
```bash
ls /mnt/autodata
```
</details>

---

### Question 5: Configure Indirect Map
**Task:** Configure autofs so that /nfs/projects mounts server:/share/projects automatically.

<details>
<summary>Show Solution</summary>

**Step 1: Edit /etc/auto.master**
```bash
sudo vim /etc/auto.master
```

**Add line:**
```
/nfs    /etc/auto.nfs
```

**Step 2: Create /etc/auto.nfs**
```bash
sudo vim /etc/auto.nfs
```

**Add line:**
```
projects    -rw    server:/share/projects
```

**Step 3: Restart autofs**
```bash
sudo systemctl restart autofs
```

**Step 4: Test**
```bash
cd /nfs/projects    # Triggers mount
df -h /nfs/projects
```
</details>

---

### Question 6: Configure Multiple Indirect Mounts
**Task:** Configure autofs for multiple NFS shares under /remote.

<details>
<summary>Show Solution</summary>

**Edit /etc/auto.master:**
```
/remote    /etc/auto.remote
```

**Create /etc/auto.remote:**
```
data      -rw,soft    server:/share/data
backup    -ro         server:/share/backup
projects  -rw         server:/share/projects
```

**Restart autofs:**
```bash
sudo systemctl restart autofs
```

**Access:**
```bash
cd /remote/data
cd /remote/backup
cd /remote/projects
```
</details>

---

### Question 7: Configure Autofs for Home Directories
**Task:** Configure autofs to mount user home directories from NFS server.

<details>
<summary>Show Solution</summary>

**Edit /etc/auto.master:**
```
/home/guests    /etc/auto.home
```

**Create /etc/auto.home:**
```
*    -rw    server:/home/&
```

**Explanation:**
- `*`: Match any key (username)
- `&`: Replaced with the matched key

**Restart autofs:**
```bash
sudo systemctl restart autofs
```

**Test:**
```bash
# When user 'john' accesses /home/guests/john
# It mounts server:/home/john automatically
cd /home/guests/john
```
</details>

---

### Question 8: Set Autofs Timeout
**Task:** Configure autofs to unmount after 5 minutes of inactivity.

<details>
<summary>Show Solution</summary>

**Edit /etc/auto.master:**
```
/nfs    /etc/auto.nfs    --timeout=300
```

**Or set global timeout in /etc/autofs.conf:**
```bash
sudo vim /etc/autofs.conf
```

```
timeout = 300
```

**Restart autofs:**
```bash
sudo systemctl restart autofs
```
</details>

---

### Question 9: Verify Autofs Configuration
**Task:** Check if autofs is working correctly.

<details>
<summary>Show Solution</summary>

```bash
# Check service status
sudo systemctl status autofs

# Check current automounts
mount | grep autofs

# Access a mount to trigger it
ls /nfs/data

# Verify mount appeared
df -h | grep nfs

# Check autofs debug
sudo automount -f -v
```
</details>

---

### Question 10: Troubleshoot Autofs
**Task:** Debug autofs mount issues.

<details>
<summary>Show Solution</summary>

```bash
# Stop autofs
sudo systemctl stop autofs

# Run in foreground with debug
sudo automount -f -v

# In another terminal, try accessing the mount
ls /nfs/data

# Check for errors in output

# After debugging, restart normally
sudo systemctl start autofs
```

**Check logs:**
```bash
sudo journalctl -u autofs
```
</details>

---

### Question 11: Exam Scenario - Indirect NFS Automount
**Task:** Configure autofs so that accessing /shares/public automatically mounts nfs.example.com:/public.

<details>
<summary>Show Solution</summary>

```bash
# Install autofs
sudo dnf install autofs -y

# Edit master file
sudo vim /etc/auto.master
```

**Add to auto.master:**
```
/shares    /etc/auto.shares
```

**Create map file:**
```bash
sudo vim /etc/auto.shares
```

**Add:**
```
public    -rw    nfs.example.com:/public
```

**Enable and start:**
```bash
sudo systemctl enable --now autofs
```

**Test:**
```bash
cd /shares/public
df -h /shares/public
```
</details>

---

### Question 12: Exam Scenario - Direct Mount
**Task:** Use autofs to mount server:/data directly at /autodata.

<details>
<summary>Show Solution</summary>

**Edit /etc/auto.master:**
```
/-    /etc/auto.direct
```

**Create /etc/auto.direct:**
```
/autodata    -rw,soft    server:/data
```

**Restart:**
```bash
sudo systemctl restart autofs
```

**Test:**
```bash
ls /autodata
```
</details>

---

### Question 13: Exam Scenario - Wildcard Home Directories
**Task:** Configure autofs for NFS home directories where /home/remote/* mounts from server:/export/home/*.

<details>
<summary>Show Solution</summary>

**Edit /etc/auto.master:**
```
/home/remote    /etc/auto.home
```

**Create /etc/auto.home:**
```
*    -rw    server:/export/home/&
```

**Restart:**
```bash
sudo systemctl restart autofs
```

**Test:**
```bash
cd /home/remote/user1
# Mounts server:/export/home/user1
```
</details>

---

### Question 14: Mount with Specific NFS Version
**Task:** Configure autofs mount using NFS version 4.

<details>
<summary>Show Solution</summary>

**In map file (/etc/auto.nfs):**
```
data    -rw,nfsvers=4    server:/share/data
```

**Or:**
```
data    -fstype=nfs4,rw    server:/share/data
```
</details>

---

### Question 15: Check Autofs Package
**Task:** Verify autofs is installed and check its files.

<details>
<summary>Show Solution</summary>

```bash
# Check if installed
rpm -q autofs

# List configuration files
rpm -qc autofs

# Install if missing
sudo dnf install autofs -y
```
</details>

---

## Quick Reference

### Master File (/etc/auto.master)
```bash
# Indirect map
/mountbase    /etc/auto.mapfile    --timeout=300

# Direct map
/-    /etc/auto.direct
```

### Map File Formats
```bash
# Indirect (/etc/auto.nfs)
key    -options    server:/path

# Direct (/etc/auto.direct)
/full/path    -options    server:/path

# Wildcard for home directories
*    -rw    server:/home/&
```

### Common Options
```bash
-rw              # Read-write
-ro              # Read-only
-soft            # Soft mount
-nfsvers=4       # NFS version 4
-fstype=nfs4     # Alternative for NFS4
```

### Service Management
```bash
# Install
dnf install autofs -y

# Enable and start
systemctl enable --now autofs

# Restart after config change
systemctl restart autofs

# Check status
systemctl status autofs
```

---

## Direct vs Indirect Maps

| Type | Master Entry | Map Entry | Use Case |
|------|--------------|-----------|----------|
| Indirect | `/base /etc/auto.map` | `key -opts server:/path` | Multiple mounts under one dir |
| Direct | `/- /etc/auto.direct` | `/full/path -opts server:/path` | Specific absolute paths |
| Wildcard | `/home/remote /etc/auto.home` | `* -rw server:/home/&` | User home directories |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Install and enable autofs** using `dnf` and `systemctl`
2. **Edit /etc/auto.master** to define mount points
3. **Create map files** with correct syntax
4. **Configure indirect mounts** for subdirectories
5. **Configure direct mounts** for absolute paths
6. **Use wildcard mounts** for home directories (`*` and `&`)
7. **Set timeout values** for automatic unmounting
8. **Restart autofs** after configuration changes
