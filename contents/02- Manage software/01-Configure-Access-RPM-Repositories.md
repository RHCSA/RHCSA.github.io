# Configure Access to RPM Repositories

## RHCSA Exam Objective
> Configure access to RPM repositories (local and remote)

---

## Introduction

RPM (Red Hat Package Manager) repositories are storage locations containing software packages for Red Hat Enterprise Linux. The RHCSA exam tests your ability to configure both local and remote (network-based) repositories. Understanding how to manage repository configuration is essential for installing, updating, and managing software on RHEL systems.

---

## Understanding Repository Configuration

### Repository Configuration Files

Repository configurations are stored in:
- **Main configuration**: `/etc/yum.conf` (legacy) or `/etc/dnf/dnf.conf`
- **Repository definitions**: `/etc/yum.repos.d/*.repo`

### Repository File Structure

A `.repo` file contains one or more repository definitions:

```ini
[repository-id]
name=Human Readable Repository Name
baseurl=protocol://path/to/repository
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
```

### Key Repository Parameters

| Parameter | Description | Values |
|-----------|-------------|--------|
| `[repo-id]` | Unique identifier (no spaces) | String |
| `name` | Human-readable description | String |
| `baseurl` | URL to repository (mutually exclusive with mirrorlist) | URL |
| `mirrorlist` | URL to list of mirrors | URL |
| `enabled` | Whether repository is active | 0 or 1 |
| `gpgcheck` | Verify package signatures | 0 or 1 |
| `gpgkey` | Path to GPG key for verification | file:// or http:// |

### Supported URL Protocols

| Protocol | Example | Use Case |
|----------|---------|----------|
| `http://` | `http://server/repo` | Remote HTTP server |
| `https://` | `https://server/repo` | Secure remote server |
| `ftp://` | `ftp://server/repo` | FTP server |
| `file://` | `file:///mnt/iso/repo` | Local filesystem |

---

## Practice Questions

### Question 1: View Current Repositories
**Task:** List all currently configured repositories and their status.

<details>
<summary>Show Solution</summary>

```bash
# List all repositories (enabled and disabled)
dnf repolist all

# List only enabled repositories
dnf repolist

# List only enabled repositories with verbose info
dnf repolist -v
```

**Expected Output:**
```
repo id                          repo name                       status
rhel-9-baseos-rpms               RHEL 9 BaseOS                   enabled
rhel-9-appstream-rpms            RHEL 9 AppStream                enabled
```
</details>

---

### Question 2: Configure a Remote HTTP Repository
**Task:** Configure a new repository called `custom-repo` that points to `http://content.example.com/rhel9/x86_64/`. Enable GPG checking with the key at `http://content.example.com/RPM-GPG-KEY`.

<details>
<summary>Show Solution</summary>

```bash
# Create repository file
sudo vi /etc/yum.repos.d/custom.repo
```

Add the following content:
```ini
[custom-repo]
name=Custom Repository
baseurl=http://content.example.com/rhel9/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://content.example.com/RPM-GPG-KEY
```

```bash
# Verify the repository is configured
dnf repolist

# Clean and refresh cache
dnf clean all
dnf makecache
```
</details>

---

### Question 3: Configure a Local Repository from ISO
**Task:** Mount the RHEL installation ISO at `/mnt/iso` and configure it as a local repository named `rhel-local`.

<details>
<summary>Show Solution</summary>

```bash
# Create mount point
sudo mkdir -p /mnt/iso

# Mount the ISO (assuming ISO is at /dev/sr0 or a file)
sudo mount /dev/sr0 /mnt/iso
# OR for an ISO file:
sudo mount -o loop /path/to/rhel.iso /mnt/iso

# Create repository file
sudo vi /etc/yum.repos.d/local.repo
```

Add the following content:
```ini
[rhel-local-baseos]
name=RHEL Local BaseOS
baseurl=file:///mnt/iso/BaseOS
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[rhel-local-appstream]
name=RHEL Local AppStream
baseurl=file:///mnt/iso/AppStream
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
```

```bash
# Verify the repository works
dnf repolist
dnf clean all
dnf makecache
```

**To make the mount persistent, add to `/etc/fstab`:**
```
/dev/sr0    /mnt/iso    iso9660    ro,loop    0 0
```
</details>

---

### Question 4: Disable a Repository Temporarily
**Task:** Disable the `custom-repo` repository temporarily without modifying the configuration file.

<details>
<summary>Show Solution</summary>

```bash
# Disable repository for a single command
dnf --disablerepo=custom-repo install package-name

# Disable repository using config-manager
sudo dnf config-manager --set-disabled custom-repo

# Verify
dnf repolist all | grep custom-repo
```

**To re-enable:**
```bash
sudo dnf config-manager --set-enabled custom-repo
```
</details>

---

### Question 5: Enable a Disabled Repository
**Task:** Enable the `codeready-builder-for-rhel-9-x86_64-rpms` repository.

<details>
<summary>Show Solution</summary>

```bash
# Enable using config-manager
sudo dnf config-manager --set-enabled codeready-builder-for-rhel-9-x86_64-rpms

# Verify it's enabled
dnf repolist | grep codeready

# Alternative: Enable subscription-manager managed repos
sudo subscription-manager repos --enable=codeready-builder-for-rhel-9-x86_64-rpms
```
</details>

---

### Question 6: Add Repository Using dnf config-manager
**Task:** Add a repository using the `dnf config-manager` command for `http://mirror.example.com/epel/`.

<details>
<summary>Show Solution</summary>

```bash
# Add repository using config-manager
sudo dnf config-manager --add-repo=http://mirror.example.com/epel/

# This creates a file in /etc/yum.repos.d/ automatically
ls /etc/yum.repos.d/

# Verify
dnf repolist
```

**Note:** This creates a basic repo file. You may need to edit it to add GPG key settings.
</details>

---

### Question 7: Configure Repository with No GPG Check
**Task:** Configure a test repository at `http://test.example.com/repo/` without GPG checking (for testing purposes only).

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/yum.repos.d/test.repo
```

```ini
[test-repo]
name=Test Repository
baseurl=http://test.example.com/repo/
enabled=1
gpgcheck=0
```

**Warning:** Disabling GPG check is a security risk and should only be done in test environments.

```bash
# Verify
dnf repolist
```
</details>

---

### Question 8: View Repository Information
**Task:** Display detailed information about the `rhel-9-baseos-rpms` repository.

<details>
<summary>Show Solution</summary>

```bash
# View repository info
dnf repoinfo rhel-9-baseos-rpms

# View all repo info
dnf repoinfo

# Alternative: Check the repo file directly
cat /etc/yum.repos.d/redhat.repo | grep -A 10 "rhel-9-baseos"
```

**Expected Output:**
```
Repo-id      : rhel-9-baseos-rpms
Repo-name    : Red Hat Enterprise Linux 9 for x86_64 - BaseOS (RPMs)
Repo-status  : enabled
Repo-baseurl : https://cdn.redhat.com/content/...
Repo-expire  : 86,400 second(s)
Repo-size    : 0
Repo-pkgs    : 0
```
</details>

---

### Question 9: Clean Repository Cache
**Task:** Clear all cached repository data and rebuild the cache.

<details>
<summary>Show Solution</summary>

```bash
# Clean all cached data
sudo dnf clean all

# Remove only package cache
sudo dnf clean packages

# Remove only metadata cache
sudo dnf clean metadata

# Rebuild the cache
sudo dnf makecache
```

**Cache location:** `/var/cache/dnf/`
</details>

---

### Question 10: Configure Multiple Baseurls
**Task:** Configure a repository with multiple mirror URLs.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/yum.repos.d/multi-mirror.repo
```

```ini
[multi-mirror-repo]
name=Repository with Multiple Mirrors
baseurl=http://mirror1.example.com/repo/
        http://mirror2.example.com/repo/
        http://mirror3.example.com/repo/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-example
```

**Note:** Multiple baseurls on separate lines (indented) provide fallback mirrors.
</details>

---

### Question 11: Exam Scenario - Complete Repository Setup
**Task:** You have been given access to a content server at `http://content.lab.example.com/rhel9/`. Configure your system to use this as a package repository. The server provides two repositories:
- BaseOS at `/BaseOS`
- AppStream at `/AppStream`

GPG checking should be disabled for this lab environment.

<details>
<summary>Show Solution</summary>

```bash
# Create repository configuration
sudo vi /etc/yum.repos.d/lab.repo
```

```ini
[lab-baseos]
name=Lab BaseOS Repository
baseurl=http://content.lab.example.com/rhel9/BaseOS
enabled=1
gpgcheck=0

[lab-appstream]
name=Lab AppStream Repository
baseurl=http://content.lab.example.com/rhel9/AppStream
enabled=1
gpgcheck=0
```

```bash
# Clean cache and verify
sudo dnf clean all
dnf repolist

# Test by searching for a package
dnf search httpd
```
</details>

---

### Question 12: Remove a Repository
**Task:** Remove the repository configuration for `test-repo`.

<details>
<summary>Show Solution</summary>

```bash
# Option 1: Delete the repo file
sudo rm /etc/yum.repos.d/test.repo

# Option 2: If repo is in a shared file, disable it
sudo dnf config-manager --set-disabled test-repo

# Verify removal
dnf repolist all | grep test-repo

# Clean up
sudo dnf clean all
```
</details>

---

## Repository URL Structure

Understanding standard RHEL repository structure:

```
http://server/path/
├── BaseOS/
│   └── Packages/
│   └── repodata/
├── AppStream/
│   └── Packages/
│   └── repodata/
```

The `repodata/` directory contains repository metadata and is essential for a valid repository.

---

## Quick Reference

### Common dnf Repository Commands

| Command | Description |
|---------|-------------|
| `dnf repolist` | List enabled repositories |
| `dnf repolist all` | List all repositories |
| `dnf repoinfo` | Show repository details |
| `dnf config-manager --add-repo URL` | Add repository from URL |
| `dnf config-manager --set-enabled REPO` | Enable repository |
| `dnf config-manager --set-disabled REPO` | Disable repository |
| `dnf clean all` | Clear all cache |
| `dnf makecache` | Rebuild cache |

### Repository File Template

```ini
[repo-id]
name=Repository Description
baseurl=http://server/path/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-name
```

---

## Key Files and Directories

| Path | Purpose |
|------|---------|
| `/etc/yum.repos.d/` | Repository configuration files |
| `/etc/dnf/dnf.conf` | DNF main configuration |
| `/var/cache/dnf/` | Repository cache |
| `/etc/pki/rpm-gpg/` | GPG keys for package verification |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Create repository files** in `/etc/yum.repos.d/`
2. **Configure both local and remote repositories**
3. **Use correct URL protocols** (http://, https://, file://)
4. **Enable and disable repositories** using `dnf config-manager`
5. **Manage repository cache** with `dnf clean` and `dnf makecache`
6. **Verify repository configuration** with `dnf repolist`
7. **Configure GPG checking** for package integrity
