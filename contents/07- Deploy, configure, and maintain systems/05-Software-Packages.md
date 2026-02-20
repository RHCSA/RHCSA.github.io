# Install and Update Software Packages

## RHCSA Exam Objective
> Install and update software packages from Red Hat Network, a remote repository, or from the local file system

---

## Introduction

Package management is a core RHCSA skill. RHEL 9 uses `dnf` (Dandified YUM) as the default package manager. You must be able to install, update, remove packages, and configure repositories.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `dnf install` | Install package(s) |
| `dnf remove` | Remove package(s) |
| `dnf update` | Update package(s) |
| `dnf search` | Search for packages |
| `dnf info` | Display package info |
| `dnf list` | List packages |
| `dnf provides` | Find package providing file |
| `dnf repolist` | List repositories |

---

## Part 1: Installing Packages

### Question 1: Install a Package
**Task:** Install the httpd package.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf install httpd
```

**Auto-confirm:**
```bash
sudo dnf install -y httpd
```
</details>

---

### Question 2: Install Multiple Packages
**Task:** Install vim, wget, and curl.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf install -y vim wget curl
```
</details>

---

### Question 3: Install Package Group
**Task:** Install "Development Tools" group.

<details>
<summary>Show Solution</summary>

**List available groups:**
```bash
dnf group list
```

**Install group:**
```bash
sudo dnf group install "Development Tools"
```

**Or:**
```bash
sudo dnf groupinstall "Development Tools"
```
</details>

---

### Question 4: Install from Local RPM
**Task:** Install package from local RPM file.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf install ./package-name.rpm
```

**Or using rpm directly:**
```bash
sudo rpm -ivh package-name.rpm
```

**Note:** dnf handles dependencies; rpm does not.
</details>

---

### Question 5: Install Specific Version
**Task:** Install a specific version of a package.

<details>
<summary>Show Solution</summary>

**List available versions:**
```bash
dnf list --showduplicates httpd
```

**Install specific version:**
```bash
sudo dnf install httpd-2.4.51-7.el9
```
</details>

---

## Part 2: Removing Packages

### Question 6: Remove a Package
**Task:** Remove the httpd package.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf remove httpd
```

**This also removes dependent packages.**
</details>

---

### Question 7: Remove Package Group
**Task:** Remove "Development Tools" group.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf group remove "Development Tools"
```
</details>

---

### Question 8: Autoremove Unused Dependencies
**Task:** Remove packages that were installed as dependencies but are no longer needed.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf autoremove
```
</details>

---

## Part 3: Updating Packages

### Question 9: Update All Packages
**Task:** Update all installed packages.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf update
```

**Or:**
```bash
sudo dnf upgrade
```

**Note:** `update` and `upgrade` are equivalent in dnf.
</details>

---

### Question 10: Update Specific Package
**Task:** Update only the httpd package.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf update httpd
```
</details>

---

### Question 11: Check for Updates
**Task:** List packages that have updates available.

<details>
<summary>Show Solution</summary>

```bash
dnf check-update
```

**Returns exit code 100 if updates available, 0 if not.**
</details>

---

## Part 4: Searching and Querying

### Question 12: Search for Packages
**Task:** Search for packages related to "web server".

<details>
<summary>Show Solution</summary>

```bash
dnf search "web server"
```

**Search in names only:**
```bash
dnf search --name "http"
```
</details>

---

### Question 13: Display Package Information
**Task:** Show details about httpd package.

<details>
<summary>Show Solution</summary>

```bash
dnf info httpd
```

**Shows:**
- Name, version, release
- Size
- Repository
- Description
</details>

---

### Question 14: List Installed Packages
**Task:** Show all installed packages.

<details>
<summary>Show Solution</summary>

```bash
dnf list installed
```

**Filter:**
```bash
dnf list installed | grep http
```
</details>

---

### Question 15: List Available Packages
**Task:** Show packages available in repositories.

<details>
<summary>Show Solution</summary>

```bash
dnf list available
```

**Search for specific:**
```bash
dnf list available httpd*
```
</details>

---

### Question 16: Find Package Providing File
**Task:** Find which package provides /etc/httpd/conf/httpd.conf.

<details>
<summary>Show Solution</summary>

```bash
dnf provides /etc/httpd/conf/httpd.conf
```

**Or for commands:**
```bash
dnf provides */vim
```
</details>

---

### Question 17: List Package Files
**Task:** List all files installed by httpd package.

<details>
<summary>Show Solution</summary>

```bash
rpm -ql httpd
```

**Or:**
```bash
dnf repoquery -l httpd
```
</details>

---

## Part 5: Repository Management

### Question 18: List Enabled Repositories
**Task:** Show all enabled repositories.

<details>
<summary>Show Solution</summary>

```bash
dnf repolist
```

**List all (including disabled):**
```bash
dnf repolist all
```
</details>

---

### Question 19: View Repository Information
**Task:** Show detailed info about repositories.

<details>
<summary>Show Solution</summary>

```bash
dnf repoinfo
```
</details>

---

### Question 20: Enable a Repository
**Task:** Enable the PowerTools/CRB repository.

<details>
<summary>Show Solution</summary>

**RHEL 9:**
```bash
sudo dnf config-manager --enable crb
```

**Verify:**
```bash
dnf repolist
```
</details>

---

### Question 21: Disable a Repository
**Task:** Disable a repository.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf config-manager --disable repo-name
```
</details>

---

### Question 22: Add New Repository
**Task:** Add a repository from a URL.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf config-manager --add-repo https://example.com/repo/example.repo
```
</details>

---

### Question 23: Create Repository File Manually
**Task:** Create a custom repository configuration.

<details>
<summary>Show Solution</summary>

**Create file in /etc/yum.repos.d/:**
```bash
sudo vi /etc/yum.repos.d/custom.repo
```

**Content:**
```ini
[custom-repo]
name=Custom Repository
baseurl=http://server.example.com/repo/
enabled=1
gpgcheck=0
```

**With GPG:**
```ini
[custom-repo]
name=Custom Repository
baseurl=http://server.example.com/repo/
enabled=1
gpgcheck=1
gpgkey=http://server.example.com/RPM-GPG-KEY
```

**Clear cache:**
```bash
sudo dnf clean all
```
</details>

---

### Question 24: Configure Local Repository
**Task:** Configure repository from local directory.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/yum.repos.d/local.repo
```

**Content:**
```ini
[local-repo]
name=Local Repository
baseurl=file:///mnt/repo/
enabled=1
gpgcheck=0
```
</details>

---

### Question 25: Configure ISO as Repository
**Task:** Use RHEL ISO as package source.

<details>
<summary>Show Solution</summary>

**Mount ISO:**
```bash
sudo mount -o loop /path/to/rhel.iso /mnt/iso
```

**Create repo file:**
```bash
sudo vi /etc/yum.repos.d/iso.repo
```

**Content:**
```ini
[iso-baseos]
name=RHEL BaseOS from ISO
baseurl=file:///mnt/iso/BaseOS/
enabled=1
gpgcheck=0

[iso-appstream]
name=RHEL AppStream from ISO
baseurl=file:///mnt/iso/AppStream/
enabled=1
gpgcheck=0
```
</details>

---

## Part 6: Package History and Undo

### Question 26: View DNF History
**Task:** Show dnf transaction history.

<details>
<summary>Show Solution</summary>

```bash
dnf history
```

**View specific transaction:**
```bash
dnf history info 5
```
</details>

---

### Question 27: Undo Transaction
**Task:** Undo the last dnf transaction.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf history undo last
```

**Undo specific transaction:**
```bash
sudo dnf history undo 5
```
</details>

---

## Part 7: RPM Commands

### Question 28: Query Installed Package
**Task:** Check if httpd is installed.

<details>
<summary>Show Solution</summary>

```bash
rpm -q httpd
```

**Query all:**
```bash
rpm -qa | grep httpd
```
</details>

---

### Question 29: List Package Files with RPM
**Task:** List files in installed package.

<details>
<summary>Show Solution</summary>

```bash
rpm -ql httpd
```
</details>

---

### Question 30: Show Package Info with RPM
**Task:** Display package information.

<details>
<summary>Show Solution</summary>

```bash
rpm -qi httpd
```

**For RPM file (not installed):**
```bash
rpm -qip package.rpm
```
</details>

---

### Question 31: Find Package Owning File
**Task:** Find which package owns /usr/bin/vim.

<details>
<summary>Show Solution</summary>

```bash
rpm -qf /usr/bin/vim
```
</details>

---

## Part 8: Exam Scenarios

### Question 32: Exam Scenario - Install from Repository
**Task:** Install the nginx package.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf install -y nginx
```
</details>

---

### Question 33: Exam Scenario - Configure Repository
**Task:** Configure a repository with:
- Name: exam-repo
- URL: http://server.example.com/rpms
- GPG check disabled

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/yum.repos.d/exam.repo
```

**Content:**
```ini
[exam-repo]
name=Exam Repository
baseurl=http://server.example.com/rpms
enabled=1
gpgcheck=0
```

**Verify:**
```bash
dnf repolist
```
</details>

---

### Question 34: Exam Scenario - Find and Install
**Task:** Find what package provides /usr/sbin/semanage and install it.

<details>
<summary>Show Solution</summary>

```bash
dnf provides /usr/sbin/semanage
```

**Install:**
```bash
sudo dnf install -y policycoreutils-python-utils
```
</details>

---

## Quick Reference

### Package Management
```bash
# Install
dnf install PACKAGE
dnf install -y PACKAGE
dnf install ./file.rpm

# Remove
dnf remove PACKAGE
dnf autoremove

# Update
dnf update
dnf update PACKAGE

# Search
dnf search KEYWORD
dnf provides FILE
dnf info PACKAGE
dnf list installed
```

### Repository Management
```bash
# List repos
dnf repolist
dnf repolist all

# Enable/disable
dnf config-manager --enable REPO
dnf config-manager --disable REPO
dnf config-manager --add-repo URL

# Clear cache
dnf clean all
```

### Repository File Format
```ini
[repo-id]
name=Repository Name
baseurl=http://server.com/repo/
enabled=1
gpgcheck=1
gpgkey=http://server.com/RPM-GPG-KEY
```

### RPM Commands
```bash
rpm -q PACKAGE          # Query if installed
rpm -qa                 # List all installed
rpm -ql PACKAGE         # List files
rpm -qi PACKAGE         # Show info
rpm -qf FILE            # Find owner
rpm -ivh file.rpm       # Install
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Install packages** using `dnf install`
2. **Remove packages** using `dnf remove`
3. **Update packages** using `dnf update`
4. **Search for packages** using `dnf search` and `dnf provides`
5. **Configure repositories** in /etc/yum.repos.d/
6. **Enable/disable repositories** using `dnf config-manager`
7. **Use rpm commands** for querying packages
