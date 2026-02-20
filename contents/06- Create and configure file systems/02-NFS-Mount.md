# Mount and Unmount Network File Systems Using NFS

## RHCSA Exam Objective
> Mount and unmount network file systems using NFS

---

## Introduction

NFS (Network File System) allows mounting remote directories over the network. The RHCSA exam tests your ability to mount NFS shares manually and persistently. You need to know how to discover available shares and configure appropriate mount options.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `showmount -e` | Show NFS exports from server |
| `mount -t nfs` | Mount NFS share |
| `umount` | Unmount NFS share |
| `mount` | List mounted filesystems |

---

## Practice Questions

### Question 1: Show Available NFS Exports
**Task:** List NFS shares available from server 192.168.1.100.

<details>
<summary>Show Solution</summary>

```bash
showmount -e 192.168.1.100
```

**Output example:**
```
Export list for 192.168.1.100:
/share/data    *
/share/public  192.168.1.0/24
```

**Note:** The server must allow NFS traffic through firewall.
</details>

---

### Question 2: Mount NFS Share Manually
**Task:** Mount NFS share /share/data from 192.168.1.100 to /mnt/nfsdata.

<details>
<summary>Show Solution</summary>

```bash
# Create mount point
sudo mkdir -p /mnt/nfsdata

# Mount NFS share
sudo mount -t nfs 192.168.1.100:/share/data /mnt/nfsdata

# Verify
df -h /mnt/nfsdata
```
</details>

---

### Question 3: Mount NFS with Options
**Task:** Mount NFS share as read-only.

<details>
<summary>Show Solution</summary>

```bash
sudo mount -t nfs -o ro 192.168.1.100:/share/data /mnt/nfsdata
```

**Common NFS mount options:**
| Option | Description |
|--------|-------------|
| `ro` | Read-only |
| `rw` | Read-write (default) |
| `soft` | Return error if server unavailable |
| `hard` | Keep retrying if server unavailable |
| `intr` | Allow interruption of NFS requests |
| `nfsvers=4` | Use NFS version 4 |
| `sync` | Synchronous writes |
</details>

---

### Question 4: Mount NFS Version 4
**Task:** Mount NFS share using NFS version 4.

<details>
<summary>Show Solution</summary>

```bash
sudo mount -t nfs -o nfsvers=4 192.168.1.100:/share/data /mnt/nfsdata
```

**Or:**
```bash
sudo mount -t nfs4 192.168.1.100:/share/data /mnt/nfsdata
```
</details>

---

### Question 5: Unmount NFS Share
**Task:** Unmount /mnt/nfsdata.

<details>
<summary>Show Solution</summary>

```bash
sudo umount /mnt/nfsdata
```

**Force unmount if stuck:**
```bash
sudo umount -f /mnt/nfsdata
```

**Lazy unmount:**
```bash
sudo umount -l /mnt/nfsdata
```
</details>

---

### Question 6: Configure Persistent NFS Mount
**Task:** Configure /share/data from server 192.168.1.100 to mount at /data at boot.

<details>
<summary>Show Solution</summary>

**Step 1: Create mount point**
```bash
sudo mkdir -p /data
```

**Step 2: Edit /etc/fstab**
```bash
sudo vim /etc/fstab
```

**Add line:**
```
192.168.1.100:/share/data  /data  nfs  defaults  0 0
```

**Step 3: Test the fstab entry**
```bash
sudo mount -a
```

**Step 4: Verify**
```bash
df -h /data
```
</details>

---

### Question 7: Persistent NFS with Options
**Task:** Configure NFS mount that won't block boot if server is unavailable.

<details>
<summary>Show Solution</summary>

**Edit /etc/fstab:**
```
192.168.1.100:/share/data  /data  nfs  defaults,_netdev,nofail  0 0
```

**Important options for network mounts:**
| Option | Description |
|--------|-------------|
| `_netdev` | Wait for network before mounting |
| `nofail` | Don't fail boot if mount fails |
| `soft` | Return error instead of hanging |
| `timeo=14` | Timeout in tenths of seconds |
| `retrans=3` | Number of retries |
</details>

---

### Question 8: Mount NFS with soft Option
**Task:** Configure NFS mount that returns errors instead of hanging.

<details>
<summary>Show Solution</summary>

**Fstab entry:**
```
192.168.1.100:/share/data  /data  nfs  soft,timeo=30,retrans=3,_netdev  0 0
```

**Explanation:**
- `soft`: Return error after retries exhausted
- `timeo=30`: 3-second timeout
- `retrans=3`: Retry 3 times
</details>

---

### Question 9: Verify NFS Mount
**Task:** Confirm NFS share is mounted and working.

<details>
<summary>Show Solution</summary>

```bash
# Check mount
df -h /mnt/nfsdata

# Check mount type
mount | grep nfs

# Test access
ls -la /mnt/nfsdata

# Check detailed mount info
findmnt /mnt/nfsdata
```
</details>

---

### Question 10: Troubleshoot NFS Connection
**Task:** Diagnose NFS mount issues.

<details>
<summary>Show Solution</summary>

```bash
# Check if NFS server is reachable
ping 192.168.1.100

# Check if NFS service is available
showmount -e 192.168.1.100

# Check firewall allows NFS
sudo firewall-cmd --list-all

# Check if nfs-utils is installed
rpm -q nfs-utils

# View NFS mount errors
dmesg | grep -i nfs
```
</details>

---

### Question 11: Exam Scenario - Basic NFS Mount
**Task:** Mount NFS share /exports/projects from server nfs.example.com to /projects and make it persistent.

<details>
<summary>Show Solution</summary>

```bash
# Create mount point
sudo mkdir /projects

# Test manual mount first
sudo mount -t nfs nfs.example.com:/exports/projects /projects

# Verify it works
df -h /projects
ls /projects

# Make persistent - add to fstab
echo "nfs.example.com:/exports/projects  /projects  nfs  defaults,_netdev  0 0" | sudo tee -a /etc/fstab

# Unmount and test fstab
sudo umount /projects
sudo mount -a

# Verify
df -h /projects
```
</details>

---

### Question 12: Exam Scenario - Read-Only NFS
**Task:** Mount NFS share /share/docs from 192.168.1.50 as read-only to /docs, persistent.

<details>
<summary>Show Solution</summary>

```bash
# Create mount point
sudo mkdir /docs

# Add to fstab
sudo vim /etc/fstab
```

**Fstab entry:**
```
192.168.1.50:/share/docs  /docs  nfs  ro,_netdev,nofail  0 0
```

```bash
# Mount and verify
sudo mount -a
df -h /docs
touch /docs/test    # Should fail (read-only)
```
</details>

---

### Question 13: Check NFS Client Packages
**Task:** Ensure NFS client utilities are installed.

<details>
<summary>Show Solution</summary>

```bash
# Check if installed
rpm -q nfs-utils

# Install if needed
sudo dnf install nfs-utils -y
```
</details>

---

### Question 14: Mount NFS Using Hostname
**Task:** Mount NFS share using server hostname instead of IP.

<details>
<summary>Show Solution</summary>

```bash
# Ensure hostname resolves
ping nfsserver.example.com

# Mount using hostname
sudo mount -t nfs nfsserver.example.com:/share/data /mnt/data
```

**Fstab entry:**
```
nfsserver.example.com:/share/data  /mnt/data  nfs  defaults,_netdev  0 0
```
</details>

---

### Question 15: Handle NFS Mount at Boot
**Task:** Ensure NFS mounts work correctly at system boot.

<details>
<summary>Show Solution</summary>

**Use these fstab options for reliable boot:**
```
server:/share  /mnt/nfs  nfs  defaults,_netdev,nofail,x-systemd.automount  0 0
```

**Key options:**
- `_netdev`: Requires network to be up
- `nofail`: Don't fail boot if mount fails
- `x-systemd.automount`: Mount on first access (optional)

**Test boot behavior:**
```bash
sudo mount -a
```
</details>

---

## Quick Reference

### View Available NFS Shares
```bash
showmount -e SERVER
```

### Mount NFS
```bash
# Basic mount
mount -t nfs server:/share /mountpoint

# With options
mount -t nfs -o ro,nfsvers=4 server:/share /mountpoint
```

### Unmount NFS
```bash
umount /mountpoint
umount -f /mountpoint    # Force
umount -l /mountpoint    # Lazy
```

### Persistent NFS in /etc/fstab
```bash
# Basic
server:/share  /mountpoint  nfs  defaults  0 0

# With network options
server:/share  /mountpoint  nfs  defaults,_netdev,nofail  0 0

# Read-only
server:/share  /mountpoint  nfs  ro,_netdev  0 0
```

### Common Mount Options
| Option | Description |
|--------|-------------|
| `defaults` | Standard options |
| `_netdev` | Network device (wait for network) |
| `nofail` | Don't fail boot if mount fails |
| `ro` | Read-only |
| `rw` | Read-write |
| `soft` | Return error on timeout |
| `hard` | Retry indefinitely |
| `nfsvers=4` | Use NFS version 4 |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Discover NFS exports** using `showmount -e server`
2. **Mount NFS shares** using `mount -t nfs`
3. **Unmount NFS shares** using `umount`
4. **Configure persistent mounts** in `/etc/fstab`
5. **Use `_netdev` option** for network mounts
6. **Use `nofail` option** to prevent boot failures
7. **Verify NFS mounts** using `df -h` and `mount`
