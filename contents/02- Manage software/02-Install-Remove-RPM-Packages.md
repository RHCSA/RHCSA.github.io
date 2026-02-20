# Install and Remove RPM Software Packages

## RHCSA Exam Objective
> Install and remove software packages using RPM and DNF

---

## Introduction

Managing software packages is a core system administration task. The RHCSA exam tests your ability to install, remove, update, and query software packages using `dnf` (the default package manager in RHEL 9) and `rpm` (the low-level package tool). Understanding both tools and when to use each is essential.

---

## DNF vs RPM

| Feature | DNF | RPM |
|---------|-----|-----|
| Dependency resolution | Yes | No |
| Repository support | Yes | No |
| Install from URL/repo | Yes | No |
| Install local .rpm file | Yes | Yes |
| Query package database | Yes | Yes |
| Primary use | Package management | Query and local install |

**Key Point:** Use `dnf` for most operations. Use `rpm` for querying and when you need to work with individual `.rpm` files without dependency resolution.

---

## Practice Questions

### Question 1: Install a Package
**Task:** Install the `httpd` (Apache web server) package.

<details>
<summary>Show Solution</summary>

```bash
# Install package
sudo dnf install httpd

# Install without confirmation prompt
sudo dnf install httpd -y
```

**Note:** DNF automatically resolves and installs dependencies.
</details>

---

### Question 2: Remove a Package
**Task:** Remove the `httpd` package from the system.

<details>
<summary>Show Solution</summary>

```bash
# Remove package
sudo dnf remove httpd

# Remove without confirmation
sudo dnf remove httpd -y

# Alternative command (same as remove)
sudo dnf erase httpd
```

**Note:** This also removes packages that depend on httpd (orphaned dependencies).
</details>

---

### Question 3: Install Multiple Packages
**Task:** Install `vim`, `wget`, and `curl` in a single command.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf install vim wget curl -y
```
</details>

---

### Question 4: Search for a Package
**Task:** Find packages related to "web server".

<details>
<summary>Show Solution</summary>

```bash
# Search in package names and descriptions
dnf search "web server"

# Search only in package names
dnf search --names "httpd"

# Search for exact match
dnf search all httpd
```
</details>

---

### Question 5: Get Package Information
**Task:** Display detailed information about the `httpd` package.

<details>
<summary>Show Solution</summary>

```bash
# Show package information
dnf info httpd

# Show info for installed and available versions
dnf info --all httpd
```

**Example Output:**
```
Name         : httpd
Version      : 2.4.53
Release      : 7.el9
Architecture : x86_64
Size         : 59 k
Source       : httpd-2.4.53-7.el9.src.rpm
Repository   : rhel-9-appstream-rpms
Summary      : Apache HTTP Server
```
</details>

---

### Question 6: List Installed Packages
**Task:** List all packages currently installed on the system.

<details>
<summary>Show Solution</summary>

```bash
# List all installed packages
dnf list installed

# List installed packages matching a pattern
dnf list installed "http*"

# Count installed packages
dnf list installed | wc -l
```
</details>

---

### Question 7: List Available Packages
**Task:** List all packages available for installation.

<details>
<summary>Show Solution</summary>

```bash
# List all available packages
dnf list available

# List available packages matching pattern
dnf list available "python*"
```
</details>

---

### Question 8: Check for Updates
**Task:** Check if any installed packages have updates available.

<details>
<summary>Show Solution</summary>

```bash
# Check for updates
dnf check-update

# List upgradable packages
dnf list updates
```
</details>

---

### Question 9: Update a Specific Package
**Task:** Update only the `kernel` package to the latest version.

<details>
<summary>Show Solution</summary>

```bash
# Update specific package
sudo dnf update kernel -y

# Update with info about what will change
sudo dnf update kernel --assumeno
```
</details>

---

### Question 10: Update All Packages
**Task:** Update all packages on the system.

<details>
<summary>Show Solution</summary>

```bash
# Update all packages
sudo dnf update -y

# Alternative (same as update)
sudo dnf upgrade -y
```
</details>

---

### Question 11: Install a Local RPM File
**Task:** Install a package from a local RPM file `/tmp/custom-package-1.0.rpm`.

<details>
<summary>Show Solution</summary>

```bash
# Using dnf (resolves dependencies from repos)
sudo dnf install /tmp/custom-package-1.0.rpm -y

# Using rpm directly (no dependency resolution)
sudo rpm -ivh /tmp/custom-package-1.0.rpm
```

**rpm options:**
- `-i`: Install
- `-v`: Verbose
- `-h`: Show hash progress bar
</details>

---

### Question 12: Reinstall a Package
**Task:** Reinstall the `bash` package (useful if files are corrupted).

<details>
<summary>Show Solution</summary>

```bash
sudo dnf reinstall bash -y
```
</details>

---

### Question 13: Downgrade a Package
**Task:** Downgrade the `httpd` package to a previous version.

<details>
<summary>Show Solution</summary>

```bash
# List available versions
dnf list httpd --showduplicates

# Downgrade to specific version
sudo dnf downgrade httpd-2.4.51-7.el9 -y

# Downgrade to previous version
sudo dnf downgrade httpd -y
```
</details>

---

### Question 14: Find Which Package Provides a File
**Task:** Find which package provides the `/etc/httpd/conf/httpd.conf` file.

<details>
<summary>Show Solution</summary>

```bash
# Using dnf
dnf provides /etc/httpd/conf/httpd.conf

# Using rpm for installed files
rpm -qf /etc/httpd/conf/httpd.conf

# Find package providing a command
dnf provides /usr/bin/vim
dnf provides "*/vim"
```
</details>

---

### Question 15: List Files in a Package
**Task:** List all files that the `httpd` package installs.

<details>
<summary>Show Solution</summary>

```bash
# For installed package using rpm
rpm -ql httpd

# For package not yet installed (query from repo)
dnf repoquery -l httpd

# List only configuration files
rpm -qc httpd

# List only documentation files
rpm -qd httpd
```
</details>

---

### Question 16: Query Package Information with RPM
**Task:** Display detailed information about the installed `bash` package using rpm.

<details>
<summary>Show Solution</summary>

```bash
# Query package info
rpm -qi bash

# Query all packages
rpm -qa

# Query packages matching pattern
rpm -qa "http*"
```

**Common rpm query options:**
- `-q`: Query mode
- `-i`: Information
- `-l`: List files
- `-c`: Configuration files
- `-d`: Documentation files
- `-a`: All packages
- `-f FILE`: Which package owns file
</details>

---

### Question 17: Verify Package Integrity
**Task:** Verify that all files from the `bash` package are intact.

<details>
<summary>Show Solution</summary>

```bash
rpm -V bash
```

**Verification output codes:**
- `S`: Size differs
- `M`: Mode differs (permissions)
- `5`: MD5 sum differs
- `D`: Device major/minor differs
- `L`: Symlink path differs
- `U`: User ownership differs
- `G`: Group ownership differs
- `T`: Modification time differs

**No output = all files are intact.**
</details>

---

### Question 18: Install a Package Group
**Task:** Install the "Development Tools" package group.

<details>
<summary>Show Solution</summary>

```bash
# List available groups
dnf group list

# Show group contents
dnf group info "Development Tools"

# Install group
sudo dnf group install "Development Tools" -y

# Alternative syntax
sudo dnf groupinstall "Development Tools" -y
```
</details>

---

### Question 19: Remove a Package Group
**Task:** Remove the "Development Tools" package group.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf group remove "Development Tools" -y
```
</details>

---

### Question 20: List Package Dependencies
**Task:** Show what packages `httpd` depends on.

<details>
<summary>Show Solution</summary>

```bash
# Using dnf
dnf repoquery --requires httpd

# Show recursive dependencies
dnf repoquery --requires --resolve httpd

# Using rpm (for installed packages)
rpm -qR httpd
```
</details>

---

### Question 21: Show Package History
**Task:** View the history of dnf transactions on the system.

<details>
<summary>Show Solution</summary>

```bash
# Show transaction history
dnf history

# Show details of a specific transaction
dnf history info 5

# Undo a transaction
sudo dnf history undo 5
```
</details>

---

### Question 22: Download Package Without Installing
**Task:** Download the `httpd` package to the current directory without installing it.

<details>
<summary>Show Solution</summary>

```bash
# Download package
dnf download httpd

# Download with dependencies
dnf download httpd --resolve

# Download to specific directory
dnf download httpd --destdir=/tmp/packages/
```
</details>

---

### Question 23: Install Package from URL
**Task:** Install a package directly from a URL.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf install http://example.com/packages/custom-1.0.rpm -y
```
</details>

---

### Question 24: Check Package Scriptlets
**Task:** View the pre-install and post-install scripts in a package.

<details>
<summary>Show Solution</summary>

```bash
rpm -q --scripts httpd
```
</details>

---

### Question 25: Exam Scenario - Full Package Management
**Task:** 
1. Search for packages related to "network file system"
2. Install the `nfs-utils` package
3. Verify the package is installed
4. List the configuration files the package provides
5. Find what package provides the `mount.nfs` command

<details>
<summary>Show Solution</summary>

```bash
# 1. Search for packages
dnf search "network file system"
dnf search nfs

# 2. Install the package
sudo dnf install nfs-utils -y

# 3. Verify installation
rpm -q nfs-utils
dnf list installed nfs-utils

# 4. List configuration files
rpm -qc nfs-utils

# 5. Find package providing command
rpm -qf /usr/sbin/mount.nfs
dnf provides "*/mount.nfs"
```
</details>

---

### Question 26: Remove Package and Keep Configuration
**Task:** Remove the `httpd` package but understand what happens to config files.

<details>
<summary>Show Solution</summary>

```bash
# Remove package
sudo dnf remove httpd -y
```

**Note:** By default, configuration files that have been modified are preserved with `.rpmsave` extension. Original unmodified config files are removed.
</details>

---

### Question 27: Extract Files from RPM Without Installing
**Task:** Extract the contents of an RPM package to examine its files.

<details>
<summary>Show Solution</summary>

```bash
# Download the package first
dnf download httpd

# Extract contents using rpm2cpio and cpio
rpm2cpio httpd-*.rpm | cpio -idmv

# Or extract to specific directory
mkdir extracted
cd extracted
rpm2cpio ../httpd-*.rpm | cpio -idmv
```
</details>

---

## Quick Reference

### DNF Commands

| Command | Description |
|---------|-------------|
| `dnf install PACKAGE` | Install package |
| `dnf remove PACKAGE` | Remove package |
| `dnf update` | Update all packages |
| `dnf update PACKAGE` | Update specific package |
| `dnf search TERM` | Search for packages |
| `dnf info PACKAGE` | Show package details |
| `dnf list installed` | List installed packages |
| `dnf list available` | List available packages |
| `dnf provides FILE` | Find package owning file |
| `dnf download PACKAGE` | Download without installing |
| `dnf reinstall PACKAGE` | Reinstall package |
| `dnf downgrade PACKAGE` | Downgrade package |
| `dnf history` | View transaction history |
| `dnf group list` | List package groups |
| `dnf group install GROUP` | Install package group |

### RPM Query Commands

| Command | Description |
|---------|-------------|
| `rpm -qa` | List all installed packages |
| `rpm -qi PACKAGE` | Show package information |
| `rpm -ql PACKAGE` | List package files |
| `rpm -qc PACKAGE` | List config files |
| `rpm -qd PACKAGE` | List documentation files |
| `rpm -qf FILE` | Find package owning file |
| `rpm -q --scripts PACKAGE` | Show package scripts |
| `rpm -V PACKAGE` | Verify package integrity |

### RPM Install/Remove Commands

| Command | Description |
|---------|-------------|
| `rpm -ivh FILE.rpm` | Install RPM file |
| `rpm -Uvh FILE.rpm` | Upgrade (or install) RPM |
| `rpm -e PACKAGE` | Remove package |
| `rpm -e --nodeps PACKAGE` | Remove ignoring dependencies |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Install packages** using `dnf install`
2. **Remove packages** using `dnf remove`
3. **Search for packages** using `dnf search`
4. **Query package information** using `dnf info` and `rpm -qi`
5. **Find which package provides a file** using `dnf provides` or `rpm -qf`
6. **List files in a package** using `rpm -ql`
7. **Install local RPM files** using `dnf install /path/file.rpm`
8. **Manage package groups** using `dnf group install/remove`
9. **Update packages** using `dnf update`
10. **Verify package integrity** using `rpm -V`
