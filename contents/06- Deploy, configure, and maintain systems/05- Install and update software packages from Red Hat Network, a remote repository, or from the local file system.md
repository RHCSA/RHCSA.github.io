## 05- Install and update software packages from Red Hat Network, a remote repository, or from the local file system:

The RHCSA exam topic **"Install and update software packages from Red Hat Network, a remote repository, or from the local file system"** involves managing software on a RHEL system using the **`yum`** or **`dnf`** package manager. You need to know how to install, update, and manage software packages from different sources like the Red Hat repositories, third-party repositories, or local package files.

---

### **What You Need to Know:**
1. **Using `yum` or `dnf`**: Both package managers (they are almost identical, but **dnf** is the default on RHEL 8) are used to install, update, and remove packages.
2. **Red Hat Subscription Management**: Connect your system to **Red Hat Network** (RHN) for access to official repositories.
3. **Installing packages from a remote repository**: Install packages from configured repositories or add new ones.
4. **Installing packages from local files**: Install RPM packages directly from local files when network access is unavailable.
5. **Updating and searching for packages**: Learn how to update packages and search for specific ones.

---

### **1. Installing and Managing Software Packages from Red Hat Network (RHN)**

To install or update software from the Red Hat repositories, your system must be registered with **Red Hat Subscription Management (RHSM)**.

#### **Example Task 1: Register a System with Red Hat Subscription Management**

**Task:** Register your system with Red Hat to get access to official Red Hat repositories.

1. **Register the system**:
   ```bash
   sudo subscription-manager register --username <RedHatUsername> --password <RedHatPassword>
   ```

2. **Attach a subscription**:
   ```bash
   sudo subscription-manager attach --auto
   ```

   **Explanation**:
   - This registers your system to Red Hat's subscription service using your credentials, enabling access to official Red Hat repositories.

3. **Enable repositories** (optional):
   - You can list available repositories:
     ```bash
     sudo subscription-manager repos --list
     ```

   - Enable specific repositories (for example, AppStream):
     ```bash
     sudo subscription-manager repos --enable rhel-8-for-x86_64-appstream-rpms
     ```

---

### **2. Installing Software from Remote Repositories**

Once the system is registered, you can install software packages from Red Hat's official repositories or third-party repositories using **`dnf`**.

#### **Example Task 2: Install a Package from a Remote Repository**

**Task:** Install the **`httpd`** web server package from the Red Hat repository.

**Command:**
```bash
sudo dnf install httpd
```

#### **Example Output:**
```
Installed:
  httpd.x86_64 2.4.37-30.module+el8.2.0+5125+9c69cfa1
  ...
Complete!
```

**Explanation**:
- **`dnf install httpd`** downloads and installs the Apache web server package from the remote repository.
- **`dnf`** automatically resolves dependencies, downloading and installing any required packages.

---

### **3. Installing Packages from a Local File System (RPM Files)**

In some cases, you may need to install packages from a local RPM file, such as when the server is not connected to the internet. You can do this using the **`rpm`** or **`dnf`** command.

#### **Example Task 3: Install a Package from a Local RPM File**

**Task:** Install the **`vim-enhanced`** package from a local RPM file.

1. **Download the RPM file** to a local directory (e.g., `/tmp`):
   ```bash
   cd /tmp
   wget http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/vim-enhanced-8.0.1763-13.el8.x86_64.rpm
   ```

2. **Install the RPM package**:
   ```bash
   sudo dnf install /tmp/vim-enhanced-8.0.1763-13.el8.x86_64.rpm
   ```

#### **Example Output:**
```
Dependencies resolved.
=======================================================================
 Package               Arch   Version           Repository       Size
=======================================================================
Installing:
 vim-enhanced          x86_64 8.0.1763-13.el8   @commandline     1.4 M

Transaction Summary
=======================================================================
Install  1 Package

Complete!
```

**Explanation**:
- **`dnf install /path/to/package.rpm`** installs an RPM package from the local file system, resolving any dependencies by fetching them from the configured repositories.

---

### **4. Installing Packages from a Third-Party Repository**

You can configure additional repositories (for example, EPEL or a custom remote repository) and install software from them.

#### **Example Task 4: Install Software from the EPEL Repository**

**Task:** Add the EPEL repository to the system and install the **`htop`** package.

1. **Install the EPEL repository**:
   ```bash
   sudo dnf install epel-release
   ```

2. **Install the `htop` package** from the EPEL repository:
   ```bash
   sudo dnf install htop
   ```

#### **Example Output:**
```
Dependencies resolved.
=======================================================================
 Package               Arch   Version           Repository       Size
=======================================================================
Installing:
 htop                  x86_64 2.2.0-3.el8       epel             112 k

Transaction Summary
=======================================================================
Install  1 Package

Complete!
```

**Explanation**:
- The **`epel-release`** package enables the EPEL repository on the system, allowing access to additional software not included in the default Red Hat repositories.
- After enabling the EPEL repository, **`dnf install htop`** installs the **`htop`** package.

---

### **5. Updating and Searching for Packages**

Updating packages is critical to ensure that you have the latest security patches and features. You can also search for specific packages by name.

#### **Example Task 5: Update All Installed Packages**

**Task:** Update all installed packages on the system.

**Command:**
```bash
sudo dnf update
```

#### **Example Output:**
```
Upgraded:
  httpd.x86_64 2.4.37-30.module+el8.3.0+7034+7309e77b
  mariadb-libs.x86_64 3:10.3.17-1.module+el8.3.0+7559+2d9a2d2a
  ...
Complete!
```

**Explanation**:
- **`dnf update`** updates all installed packages to their latest versions available in the configured repositories.

---

#### **Example Task 6: Search for a Package**

**Task:** Search for the **`wget`** package to see if it’s available in the repositories.

**Command:**
```bash
sudo dnf search wget
```

#### **Example Output:**
```
Last metadata expiration check: 0:45:12 ago on Fri 24 Sep 2024 12:34:56 PM UTC.
========================= Name & Summary Matched: wget =========================
wget.x86_64 : A utility for retrieving files using the HTTP or FTP protocols
```

**Explanation**:
- **`dnf search`** searches the available repositories for packages that match the specified keyword (in this case, `wget`).

---

### **6. Removing Packages**

You may need to remove packages that are no longer needed or to resolve conflicts.

#### **Example Task 7: Remove a Package**

**Task:** Remove the **`httpd`** package from the system.

**Command:**
```bash
sudo dnf remove httpd
```

#### **Example Output:**
```
Removed:
  httpd.x86_64 2.4.37-30.module+el8.2.0+5125+9c69cfa1
  ...
Complete!
```

**Explanation**:
- **`dnf remove`** removes the specified package and its dependencies that are no longer needed.

---

### **7. Persistent Configuration of Repositories**

Repositories are configured persistently through files located in the `/etc/yum.repos.d/` directory. For example, when you install **epel-release**, it creates a repo file at `/etc/yum.repos.d/epel.repo` that will be used every time you run **`dnf`**.

#### **Example Task 8: Create a Custom Repository**

**Task:** Create a custom repository file to add a remote repository.

1. **Create a new repo file**:
   ```bash
   sudo nano /etc/yum.repos.d/custom.repo
   ```

2. **Add the following content**:
   ```
   [custom-repo]
   name=Custom Repository
   baseurl=http://mycustomrepo.example.com/repo/
   enabled=1
   gpgcheck=0
   ```

3. **Verify the new repository**:
   ```bash
   sudo dnf repolist
   ```

**Explanation**:
- **`baseurl`** points to the URL of the repository.
- **`enabled=1`** ensures the repository is active.
- This configuration is persistent and remains after reboots.

---

### Summary of Skills for RHCSA Exam on Installing and Updating Software:
1. **Install packages from Red Hat Network** using `dnf` after registering with RHSM.
2. **Install packages from a remote repository** by adding additional repositories (e.g., EPEL or custom repos).
3. **Install RPM packages from a local file system** using `dnf install /path/to/package.rpm`.
4. **Update installed packages** using `dnf update`.
5. **Search for available packages** using `dnf search` and remove packages using `dnf remove`.
6. **Create custom repository configuration files** in `/etc/yum.repos.d/`.
