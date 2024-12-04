## 02- Mount and unmount network file systems using NFS:

The RHCSA exam topic **"Mount and unmount network file systems using NFS"** tests your ability to set up and manage **Network File System (NFS)** mounts. NFS allows a system to share directories and files with others over a network, making it easy to access shared resources.

Here’s what you need to know at the RHCSA exam level, with **examples similar to real-world tasks** you might encounter during the exam.

---

### **What You Need to Know:**
1. **What is NFS**: NFS is a distributed file system protocol that allows you to mount remote directories on your local machine over a network.
2. **Client-side configuration**: How to mount NFS shares on the client machine, both temporarily and persistently using `/etc/fstab`.
3. **NFS server-side**: Though this task focuses on the client, knowing how the NFS server exports directories is helpful (using `/etc/exports`).
4. **Testing and troubleshooting**: Ensure the NFS mounts are working and persistent across reboots.
5. **Managing NFS mounts**: Temporarily mount and unmount NFS shares as needed.

---

### **1. Temporary NFS Mounting**

You can mount an NFS share temporarily using the **`mount`** command. This type of mount will not persist across reboots.

#### **Example Task 1: Mount an NFS Share Temporarily**

**Task:** Mount the NFS share **`/srv/nfs/shared`** from the server **`nfs-server.example.com`** to the local directory **`/mnt/nfs_shared`**.

**Command:**
```bash
sudo mount -t nfs nfs-server.example.com:/srv/nfs/shared /mnt/nfs_shared
```

**Explanation**:
- **`-t nfs`**: Specifies that the file system type is NFS.
- **`nfs-server.example.com:/srv/nfs/shared`**: This is the NFS server and the exported directory.
- **`/mnt/nfs_shared`**: This is the local mount point where the NFS share will be available.
  
You can now access the contents of **`/srv/nfs/shared`** on the server through **`/mnt/nfs_shared`** on the client machine.

#### **Verify the Mount**:
```bash
df -h /mnt/nfs_shared
```

---

### **2. Persistent NFS Mounting Using `/etc/fstab`**

To ensure that the NFS share is mounted automatically after each reboot, you must add the entry to `/etc/fstab`.

#### **Example Task 2: Mount an NFS Share Persistently Using `/etc/fstab`**

**Task:** Ensure the NFS share **`/srv/nfs/shared`** from the server **`nfs-server.example.com`** is mounted persistently at **`/mnt/nfs_shared`**.

1. **Edit `/etc/fstab`**:
   ```bash
   sudo nano /etc/fstab
   ```

2. **Add the following entry** to `/etc/fstab`:
   ```
   nfs-server.example.com:/srv/nfs/shared  /mnt/nfs_shared  nfs  defaults  0  0
   ```

3. **Test the `/etc/fstab` entry**:
   ```bash
   sudo mount -a
   ```

4. **Verify the mount**:
   ```bash
   df -h /mnt/nfs_shared
   ```

**Explanation**:
- **`nfs-server.example.com:/srv/nfs/shared`**: The NFS server and exported directory.
- **`/mnt/nfs_shared`**: The local directory where the NFS share will be mounted.
- **`nfs`**: Specifies that this is an NFS file system.
- **`defaults`**: The default mount options.
- **`0 0`**: Specifies that the file system should not be backed up or checked by `fsck`.

---

### **3. Unmounting NFS Shares**

You can unmount an NFS share when it is no longer needed. This will unmount the share temporarily. To permanently prevent the share from mounting, remove it from `/etc/fstab`.

#### **Example Task 3: Unmount an NFS Share**

**Task:** Unmount the NFS share mounted at **`/mnt/nfs_shared`**.

**Command:**
```bash
sudo umount /mnt/nfs_shared
```

**Explanation**:
- **`umount /mnt/nfs_shared`** unmounts the NFS share, making the content unavailable from the local directory.

---

### **4. Mounting NFS Shares with Additional Options**

NFS mounts can be customized using different options like **`noatime`** (to reduce I/O), **`rsize`** and **`wsize`** (to set read/write buffer sizes), and **`hard`** or **`soft`** mounts (determining how the client handles server failures).

#### **Example Task 4: Mount an NFS Share with Custom Options**

**Task:** Mount the NFS share **`/srv/nfs/shared`** persistently with additional options like `rsize=8192`, `wsize=8192`, and `noatime`.

1. **Edit `/etc/fstab`**:
   ```bash
   sudo nano /etc/fstab
   ```

2. **Add the following entry**:
   ```
   nfs-server.example.com:/srv/nfs/shared  /mnt/nfs_shared  nfs  defaults,rsize=8192,wsize=8192,noatime  0  0
   ```

3. **Test the mount**:
   ```bash
   sudo mount -a
   ```

**Explanation**:
- **`rsize=8192, wsize=8192`**: Sets the read and write buffer sizes to 8192 bytes for better performance.
- **`noatime`**: Prevents updating the file's access time, improving performance in some cases.

---

### **5. NFS Server Export Configuration (For Reference)**

Although the focus is on client-side NFS mounting, understanding how the server exports directories helps you understand the setup. On the NFS server, the `/etc/exports` file controls which directories are shared and which clients can access them.

#### **Example NFS Export Configuration on the Server**

**Task:** Share **`/srv/nfs/shared`** from the NFS server to the client **`client.example.com`**.

1. **Edit `/etc/exports`** on the NFS server:
   ```bash
   sudo nano /etc/exports
   ```

2. **Add the following line**:
   ```
   /srv/nfs/shared  client.example.com(rw,sync,no_root_squash)
   ```

3. **Export the NFS shares**:
   ```bash
   sudo exportfs -r
   ```

**Explanation**:
- **`/srv/nfs/shared`**: Directory being shared.
- **`client.example.com`**: The client that can access this NFS share.
- **`rw`**: Allows read and write access.
- **`sync`**: Ensures changes are written to disk before the server responds.
- **`no_root_squash`**: Allows the root user on the client to act as root on the server (not recommended for all setups).

---

### **6. Testing the NFS Mount**

After configuring the NFS mount, it's important to test it to ensure that it's mounted correctly and persistently across reboots.

#### **Example Task 5: Verify and Test the NFS Mount**

**Task:** Verify the NFS mount is working and persists after a reboot.

1. **Test the mount**:
   ```bash
   df -h /mnt/nfs_shared
   ```

   This shows the mounted NFS share.

2. **Reboot the system** and ensure the NFS share is still mounted:
   ```bash
   sudo reboot
   ```

3. **After reboot, check if the NFS share is mounted**:
   ```bash
   df -h /mnt/nfs_shared
   ```

---

### Summary of Skills for RHCSA Exam on NFS Mounting:
1. **Mount NFS shares temporarily** using `mount -t nfs` and verify with `df -h`.
2. **Mount NFS shares persistently** by adding entries to `/etc/fstab` with the correct options.
3. **Unmount NFS shares** using `umount` when they are no longer needed.
4. **Use advanced mount options** (e.g., `rsize`, `wsize`, `noatime`) to optimize NFS performance.
5. **Verify mounts persist** across reboots by testing with `mount -a` and checking after a reboot.

These examples reflect real-world tasks similar to what you might encounter during the RHCSA exam. Practice these steps to ensure you're comfortable mounting and unmounting NFS shares, both temporarily and persistently.