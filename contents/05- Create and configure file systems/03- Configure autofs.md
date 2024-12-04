## 03- Configure autofs:

The RHCSA exam topic **"Configure autofs"** focuses on setting up **Autofs**, which is a service that automatically mounts file systems when they are accessed and unmounts them after a period of inactivity. This is useful for network file systems like **NFS** where you want to avoid keeping file systems mounted all the time but want them to be available when needed.

---

### **What You Need to Know:**
1. **Autofs Overview**: Autofs uses a master map file (`/etc/auto.master`) to point to other map files that define mount points. When a user accesses a directory, autofs mounts the required file system automatically, and after inactivity, it automatically unmounts it.
2. **Configure `autofs` using `/etc/auto.master`** and map files.
3. **Start and enable the `autofs` service** so it starts at boot.
4. **Testing and troubleshooting** to ensure the configuration works as expected.

---

### **1. Autofs Components**

- **`/etc/auto.master`**: The master configuration file that points to other map files or directly defines the directories where autofs will manage mounts.
- **Map files**: These files (e.g., `/etc/auto.misc`, `/etc/auto.nfs`) define the specific file systems and mount options.
- **Autofs service**: The `autofs` daemon must be running to manage automatic mounting.

---

### **2. Configuring Autofs to Mount an NFS Share**

In this example, you will configure `autofs` to automatically mount an NFS share when a user accesses the directory.

#### **Example Task 1: Configure Autofs to Mount an NFS Share**

**Task:** Automatically mount the NFS share **`/srv/nfs/shared`** from the server **`nfs-server.example.com`** to **`/mnt/nfs_shared`** whenever accessed.

1. **Install autofs** (if not already installed):
   ```bash
   sudo yum install autofs
   ```

2. **Edit the `/etc/auto.master` file** to configure the autofs master file:
   ```bash
   sudo nano /etc/auto.master
   ```

3. **Add a new entry** to the `/etc/auto.master` file:
   ```
   /mnt/nfs_shared  /etc/auto.nfs
   ```

   **Explanation**:
   - **`/mnt/nfs_shared`**: This is the directory where autofs will manage mounts.
   - **`/etc/auto.nfs`**: The map file that contains the specific NFS mount details.

4. **Create the map file `/etc/auto.nfs`**:
   ```bash
   sudo nano /etc/auto.nfs
   ```

5. **Add the NFS share to the map file**:
   ```
   shared  -rw,sync  nfs-server.example.com:/srv/nfs/shared
   ```

   **Explanation**:
   - **`shared`**: This is the name of the subdirectory inside `/mnt/nfs_shared` that will be created and mounted when accessed.
   - **`-rw,sync`**: Mount options (`rw` for read/write and `sync` for synchronous writes).
   - **`nfs-server.example.com:/srv/nfs/shared`**: The NFS server and exported directory to be mounted.

6. **Start and enable the autofs service**:
   ```bash
   sudo systemctl start autofs
   sudo systemctl enable autofs
   ```

7. **Verify the autofs service is running**:
   ```bash
   sudo systemctl status autofs
   ```

8. **Test the autofs setup** by accessing the directory:
   ```bash
   ls /mnt/nfs_shared/shared
   ```

   **Explanation**: When you list the contents of the **`/mnt/nfs_shared/shared`** directory, autofs automatically mounts the NFS share. After a period of inactivity, autofs will unmount it.

---

### **3. Making the Autofs Mount Persistent**

Autofs itself automatically manages mounts as needed, so once it's configured and enabled, it will persist across reboots. The autofs service ensures that the NFS shares are mounted when accessed and unmounted after they are no longer needed.

#### **Example Task 2: Verify the Autofs Mount Persistence**

**Task:** Reboot the system and confirm that autofs mounts the NFS share when accessed.

1. **Reboot the system**:
   ```bash
   sudo reboot
   ```

2. **After reboot, test the autofs mount again**:
   ```bash
   ls /mnt/nfs_shared/shared
   ```

   **Explanation**: After the reboot, autofs should still be active, and the NFS share should be automatically mounted when accessed.

---

### **4. Unmounting an Autofs-Managed File System**

Autofs automatically unmounts the file system after a period of inactivity (default is 5 minutes). However, you can manually force an unmount if needed.

#### **Example Task 3: Manually Unmount an Autofs-Managed File System**

**Task:** Manually unmount the autofs-managed NFS share if it’s currently mounted.

**Command**:
```bash
sudo umount /mnt/nfs_shared/shared
```

**Explanation**: Although autofs will unmount the share after inactivity, you can manually unmount it if necessary. The next time the directory is accessed, it will be mounted again automatically.

---

### **5. Advanced Autofs Configuration Options**

Autofs allows for more complex configurations, including automounting multiple NFS shares, using wildcards, or defining mount options for different shares.

#### **Example Task 4: Automount Multiple NFS Shares Using Autofs**

**Task:** Automount multiple NFS shares under the **`/mnt/nfs`** directory, with each share being mounted on demand.

1. **Edit the `/etc/auto.master` file**:
   ```bash
   sudo nano /etc/auto.master
   ```

2. **Add a new entry** to manage multiple NFS shares under `/mnt/nfs`:
   ```
   /mnt/nfs  /etc/auto.nfs_multi
   ```

3. **Create the map file `/etc/auto.nfs_multi`**:
   ```bash
   sudo nano /etc/auto.nfs_multi
   ```

4. **Add multiple NFS shares**:
   ```
   share1  -rw,sync  nfs-server.example.com:/srv/nfs/share1
   share2  -ro,sync  nfs-server.example.com:/srv/nfs/share2
   ```

5. **Restart the autofs service**:
   ```bash
   sudo systemctl restart autofs
   ```

6. **Test the mounts**:
   ```bash
   ls /mnt/nfs/share1
   ls /mnt/nfs/share2
   ```

   **Explanation**: Now, both **`/mnt/nfs/share1`** and **`/mnt/nfs/share2`** will be automatically mounted on demand when accessed.

---

### **6. Troubleshooting Autofs**

If autofs is not working as expected, you can troubleshoot by checking the autofs logs or the status of the service.

- **Check the autofs logs** in `/var/log/messages` or `/var/log/syslog`.
- **Ensure that the autofs service is running** with `systemctl status autofs`.
- **Use `journalctl`** to review any errors related to autofs.

---

### Summary of Skills for RHCSA Exam on Configuring Autofs:
1. **Configure autofs using `/etc/auto.master` and map files** to automatically mount NFS shares on demand.
2. **Ensure persistence** by enabling the autofs service to start at boot.
3. **Test autofs configuration** by accessing the mount point and ensuring the share is mounted automatically.
4. **Unmount shares automatically or manually** as needed.
5. **Troubleshoot autofs issues** using logs and service status.
