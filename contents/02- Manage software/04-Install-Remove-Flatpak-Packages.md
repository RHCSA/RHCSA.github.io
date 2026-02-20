# Install and Remove Flatpak Software Packages

## RHCSA Exam Objective
> Install and remove software packages (Flatpak)

---

## Introduction

After configuring Flatpak remotes, you need to know how to install, update, and remove Flatpak applications. Flatpak applications are identified by their Application ID (e.g., `org.mozilla.firefox`) and can be installed system-wide or per-user. The RHCSA exam tests your ability to manage Flatpak applications effectively.

---

## Flatpak Application Identifiers

Flatpak uses reverse DNS notation for application IDs:
- Format: `domain.organization.appname`
- Example: `org.mozilla.firefox`, `org.gimp.GIMP`, `org.videolan.VLC`

**Note:** Application IDs are case-sensitive.

---

## Practice Questions

### Question 1: Search for an Application
**Task:** Search for the GIMP image editor in configured remotes.

<details>
<summary>Show Solution</summary>

```bash
# Search for application
flatpak search gimp
```

**Output Example:**
```
Name        Description                    Application ID          Version     Branch    Remotes
GIMP        Create images and edit...      org.gimp.GIMP           2.10.34     stable    flathub
```
</details>

---

### Question 2: Install an Application
**Task:** Install Firefox from Flathub.

<details>
<summary>Show Solution</summary>

```bash
# Install application (system-wide)
sudo flatpak install flathub org.mozilla.firefox

# Install without confirmation
sudo flatpak install flathub org.mozilla.firefox -y

# Install using just the app ID (auto-detects remote)
sudo flatpak install org.mozilla.firefox -y
```

**Note:** Flatpak will automatically install required runtimes.
</details>

---

### Question 3: Install Application for Current User Only
**Task:** Install VLC media player for the current user only.

<details>
<summary>Show Solution</summary>

```bash
# User-level installation (no sudo needed)
flatpak install --user flathub org.videolan.VLC -y

# Verify user installation
flatpak list --user
```

**Note:** User installations don't require root privileges and are stored in `~/.local/share/flatpak/`.
</details>

---

### Question 4: List Installed Applications
**Task:** Display all installed Flatpak applications.

<details>
<summary>Show Solution</summary>

```bash
# List all installed (apps and runtimes)
flatpak list

# List only applications
flatpak list --app

# List only runtimes
flatpak list --runtime

# List with full details
flatpak list --app --columns=all
```
</details>

---

### Question 5: List User vs System Applications
**Task:** Show installed applications by installation scope.

<details>
<summary>Show Solution</summary>

```bash
# List system-wide applications
flatpak list --system --app

# List user applications
flatpak list --user --app
```
</details>

---

### Question 6: Get Application Information
**Task:** Display detailed information about an installed Flatpak application.

<details>
<summary>Show Solution</summary>

```bash
# Show application info
flatpak info org.mozilla.firefox
```

**Output includes:**
- ID, Ref, Arch, Branch
- Version, License
- Origin (remote)
- Installation path
- Installed size
- Runtime used
</details>

---

### Question 7: Run a Flatpak Application
**Task:** Launch the GIMP application installed via Flatpak.

<details>
<summary>Show Solution</summary>

```bash
# Run application
flatpak run org.gimp.GIMP

# Run with specific command
flatpak run --command=gimp-2.10 org.gimp.GIMP
```

**Note:** Flatpak applications typically also create desktop entries for GUI launching.
</details>

---

### Question 8: Update a Specific Application
**Task:** Update Firefox to the latest version.

<details>
<summary>Show Solution</summary>

```bash
# Update specific application
sudo flatpak update org.mozilla.firefox -y

# Update user application
flatpak update --user org.mozilla.firefox -y
```
</details>

---

### Question 9: Update All Applications
**Task:** Update all installed Flatpak applications and runtimes.

<details>
<summary>Show Solution</summary>

```bash
# Update everything
sudo flatpak update -y

# Update only applications (not runtimes)
sudo flatpak update --app -y

# Check what would be updated
flatpak update --no-deploy
```
</details>

---

### Question 10: Remove an Application
**Task:** Remove the GIMP application.

<details>
<summary>Show Solution</summary>

```bash
# Remove system application
sudo flatpak uninstall org.gimp.GIMP -y

# Remove user application
flatpak uninstall --user org.gimp.GIMP -y
```
</details>

---

### Question 11: Remove Unused Runtimes
**Task:** Remove runtimes and extensions that are no longer needed.

<details>
<summary>Show Solution</summary>

```bash
# Remove unused components
sudo flatpak uninstall --unused -y
```

**Note:** This removes runtimes that no installed applications depend on anymore.
</details>

---

### Question 12: Remove All Flatpak Applications
**Task:** Remove all Flatpak applications from the system.

<details>
<summary>Show Solution</summary>

```bash
# Remove all installed flatpaks
sudo flatpak uninstall --all -y

# Remove and delete application data
sudo flatpak uninstall --all --delete-data -y
```

**Warning:** The `--delete-data` flag removes user data stored by the applications.
</details>

---

### Question 13: View Application Permissions
**Task:** Display the permissions granted to an application.

<details>
<summary>Show Solution</summary>

```bash
# Show permissions
flatpak info --show-permissions org.mozilla.firefox
```

**Common Permissions:**
- `--filesystem=home`: Access to home directory
- `--share=network`: Network access
- `--socket=x11`: X11 display access
- `--device=dri`: GPU access
</details>

---

### Question 14: Override Application Permissions
**Task:** Grant an application access to a specific directory.

<details>
<summary>Show Solution</summary>

```bash
# Allow access to a directory
sudo flatpak override --filesystem=/media org.mozilla.firefox

# Allow access to home directory
sudo flatpak override --filesystem=home org.mozilla.firefox

# View current overrides
sudo flatpak override --show org.mozilla.firefox

# Reset overrides to defaults
sudo flatpak override --reset org.mozilla.firefox
```
</details>

---

### Question 15: Check Application History
**Task:** View the installation and update history for Flatpak.

<details>
<summary>Show Solution</summary>

```bash
# View history
flatpak history

# View history with more details
flatpak history --columns=all
```
</details>

---

### Question 16: Install Specific Version/Branch
**Task:** Install a specific branch of an application.

<details>
<summary>Show Solution</summary>

```bash
# List available branches
flatpak remote-ls flathub --app | grep firefox

# Install specific branch
sudo flatpak install flathub org.mozilla.firefox//stable -y
```

**Common Branches:**
- `stable`: Production releases
- `beta`: Beta versions
- `master`: Development versions
</details>

---

### Question 17: Downgrade an Application
**Task:** Revert to a previous version of an application.

<details>
<summary>Show Solution</summary>

```bash
# List previous versions
flatpak remote-info --log flathub org.mozilla.firefox

# Update to specific commit
sudo flatpak update --commit=COMMIT_HASH org.mozilla.firefox
```
</details>

---

### Question 18: Repair Flatpak Installation
**Task:** Repair a corrupted Flatpak installation.

<details>
<summary>Show Solution</summary>

```bash
# Repair system installation
sudo flatpak repair

# Repair user installation
flatpak repair --user
```
</details>

---

### Question 19: Create Application Launcher Entry
**Task:** Export desktop file for a Flatpak application.

<details>
<summary>Show Solution</summary>

```bash
# Desktop files are automatically created in:
# System: /var/lib/flatpak/exports/share/applications/
# User: ~/.local/share/flatpak/exports/share/applications/

# List desktop files
ls /var/lib/flatpak/exports/share/applications/
```

**Note:** Desktop entries are created automatically on installation.
</details>

---

### Question 20: Exam Scenario - Complete Flatpak Management
**Task:**
1. Search for the VLC media player
2. Install it system-wide
3. Verify the installation
4. Check its permissions
5. Run the application to verify it works
6. Remove the application

<details>
<summary>Show Solution</summary>

```bash
# 1. Search for VLC
flatpak search vlc

# 2. Install system-wide
sudo flatpak install flathub org.videolan.VLC -y

# 3. Verify installation
flatpak list --app | grep -i vlc
flatpak info org.videolan.VLC

# 4. Check permissions
flatpak info --show-permissions org.videolan.VLC

# 5. Run the application
flatpak run org.videolan.VLC &

# 6. Remove the application
sudo flatpak uninstall org.videolan.VLC -y

# Clean up unused runtimes
sudo flatpak uninstall --unused -y
```
</details>

---

### Question 21: Mask an Application
**Task:** Prevent a specific application from being installed.

<details>
<summary>Show Solution</summary>

```bash
# Mask an application
sudo flatpak mask org.example.badapp

# List masked patterns
flatpak mask

# Unmask
sudo flatpak mask --remove org.example.badapp
```
</details>

---

### Question 22: Export Application Data
**Task:** Understand where Flatpak stores application data.

<details>
<summary>Show Solution</summary>

Flatpak application data is stored in:

| Location | Description |
|----------|-------------|
| `~/.var/app/APP_ID/` | User application data |
| `~/.var/app/APP_ID/data/` | Application data files |
| `~/.var/app/APP_ID/config/` | Application configuration |
| `~/.var/app/APP_ID/cache/` | Application cache |

```bash
# View application data location
ls ~/.var/app/org.mozilla.firefox/
```
</details>

---

## Quick Reference

### Installation Commands

| Command | Description |
|---------|-------------|
| `flatpak install REMOTE APP_ID` | Install application |
| `flatpak install --user APP_ID` | Install for current user |
| `flatpak uninstall APP_ID` | Remove application |
| `flatpak uninstall --unused` | Remove unused runtimes |
| `flatpak update` | Update all applications |
| `flatpak update APP_ID` | Update specific app |

### Query Commands

| Command | Description |
|---------|-------------|
| `flatpak list` | List all installed |
| `flatpak list --app` | List only applications |
| `flatpak list --runtime` | List only runtimes |
| `flatpak info APP_ID` | Show application details |
| `flatpak search TERM` | Search for applications |
| `flatpak history` | Show transaction history |

### Runtime Commands

| Command | Description |
|---------|-------------|
| `flatpak run APP_ID` | Run application |
| `flatpak override APP_ID` | Modify permissions |
| `flatpak repair` | Repair installation |
| `flatpak mask APP_ID` | Block installation |

---

## Key Directories

| Location | Description |
|----------|-------------|
| `/var/lib/flatpak/` | System-wide installations |
| `/var/lib/flatpak/app/` | System applications |
| `/var/lib/flatpak/runtime/` | System runtimes |
| `~/.local/share/flatpak/` | User installations |
| `~/.var/app/` | Application user data |
| `/var/lib/flatpak/exports/share/applications/` | System desktop files |

---

## Summary

For the RHCSA exam, ensure you can:

1. **Search for applications** using `flatpak search`
2. **Install applications** using `flatpak install`
3. **Install user-level** with the `--user` flag
4. **List installed** using `flatpak list`
5. **Get application info** using `flatpak info`
6. **Update applications** using `flatpak update`
7. **Remove applications** using `flatpak uninstall`
8. **Clean up unused** runtimes with `--unused`
9. **Run applications** using `flatpak run`
10. **Understand data locations** in `~/.var/app/`
