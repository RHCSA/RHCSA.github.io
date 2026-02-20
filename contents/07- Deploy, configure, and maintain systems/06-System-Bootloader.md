# Modify the System Bootloader

## RHCSA Exam Objective
> Modify the system bootloader

---

## Introduction

GRUB2 (GRand Unified Bootloader version 2) is the default bootloader in RHEL 9. The RHCSA exam tests your ability to modify boot parameters, set default kernels, and recover from boot problems.

---

## Key Commands

| Command | Description |
|---------|-------------|
| `grub2-mkconfig` | Regenerate GRUB configuration |
| `grubby` | Modify bootloader entries |
| `grub2-set-default` | Set default boot entry |
| `grub2-editenv` | View/modify GRUB environment |

---

## GRUB2 Configuration Files

| File | Description |
|------|-------------|
| `/etc/default/grub` | Main configuration |
| `/boot/grub2/grub.cfg` | Generated config (BIOS) |
| `/boot/efi/EFI/redhat/grub.cfg` | Generated config (UEFI) |
| `/etc/grub.d/` | Configuration scripts |

---

## Part 1: Viewing GRUB Configuration

### Question 1: View Current GRUB Settings
**Task:** Display current GRUB configuration.

<details>
<summary>Show Solution</summary>

```bash
cat /etc/default/grub
```

**Typical content:**
```
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M resume=/dev/mapper/rhel-swap rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
GRUB_ENABLE_BLSCFG=true
```
</details>

---

### Question 2: List Boot Entries
**Task:** Show available kernel boot entries.

<details>
<summary>Show Solution</summary>

```bash
grubby --info=ALL
```

**Or list just the menu entries:**
```bash
sudo grep -E "^menuentry|^submenu" /boot/grub2/grub.cfg
```

**RHEL 9 with BLS:**
```bash
ls /boot/loader/entries/
```
</details>

---

### Question 3: View Default Boot Entry
**Task:** Show which kernel boots by default.

<details>
<summary>Show Solution</summary>

```bash
grubby --default-kernel
```

**Or:**
```bash
grub2-editenv list
```
</details>

---

## Part 2: Modifying Boot Parameters

### Question 4: Add Persistent Kernel Parameter
**Task:** Add "net.ifnames=0" to all boot entries.

<details>
<summary>Show Solution</summary>

**Method 1: Edit /etc/default/grub**
```bash
sudo vi /etc/default/grub
```

**Modify GRUB_CMDLINE_LINUX line:**
```
GRUB_CMDLINE_LINUX="... existing parameters ... net.ifnames=0"
```

**Regenerate config:**
```bash
# For BIOS:
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# For UEFI:
sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```

**Method 2: Using grubby (RHEL 9 preferred):**
```bash
sudo grubby --update-kernel=ALL --args="net.ifnames=0"
```
</details>

---

### Question 5: Remove Kernel Parameter
**Task:** Remove "quiet" from boot parameters.

<details>
<summary>Show Solution</summary>

**Using grubby:**
```bash
sudo grubby --update-kernel=ALL --remove-args="quiet"
```

**Or edit /etc/default/grub and regenerate.**
</details>

---

### Question 6: Add Parameter to Specific Kernel
**Task:** Add debug parameter to the default kernel only.

<details>
<summary>Show Solution</summary>

```bash
sudo grubby --update-kernel=DEFAULT --args="debug"
```

**Or specify kernel path:**
```bash
sudo grubby --update-kernel=/boot/vmlinuz-5.14.0-70.el9.x86_64 --args="debug"
```
</details>

---

### Question 7: View Kernel Parameters
**Task:** Show the command line parameters for default kernel.

<details>
<summary>Show Solution</summary>

```bash
grubby --info=DEFAULT
```

**Or for running kernel:**
```bash
cat /proc/cmdline
```
</details>

---

## Part 3: Setting Default Boot Entry

### Question 8: Set Default Kernel
**Task:** Set a specific kernel as default.

<details>
<summary>Show Solution</summary>

```bash
sudo grubby --set-default /boot/vmlinuz-5.14.0-70.el9.x86_64
```

**Verify:**
```bash
grubby --default-kernel
```
</details>

---

### Question 9: Set Default by Index
**Task:** Set boot entry index 0 as default.

<details>
<summary>Show Solution</summary>

```bash
sudo grub2-set-default 0
```

**Note:** Indexes start at 0.
</details>

---

## Part 4: GRUB Timeout

### Question 10: Change Boot Timeout
**Task:** Set GRUB menu timeout to 10 seconds.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/default/grub
```

**Change:**
```
GRUB_TIMEOUT=10
```

**Regenerate:**
```bash
# BIOS:
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# UEFI:
sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```
</details>

---

### Question 11: Hide GRUB Menu
**Task:** Configure GRUB to boot immediately with no menu.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/default/grub
```

**Set:**
```
GRUB_TIMEOUT=0
```

**Regenerate configuration.**

**Note:** Hold Shift during boot to show menu.
</details>

---

## Part 5: Boot Troubleshooting

### Question 12: Boot into Rescue Mode from GRUB
**Task:** Access rescue mode at GRUB.

<details>
<summary>Show Solution</summary>

**At GRUB menu:**
1. Press `e` to edit selected entry
2. Find line starting with `linux`
3. Add at end: `systemd.unit=rescue.target`
4. Press `Ctrl+X` to boot
</details>

---

### Question 13: Boot into Emergency Mode from GRUB
**Task:** Boot to emergency mode for troubleshooting.

<details>
<summary>Show Solution</summary>

**At GRUB menu:**
1. Press `e` to edit
2. Find `linux` line
3. Add: `systemd.unit=emergency.target`
4. Press `Ctrl+X`

**Alternative - add rd.break:**
Add `rd.break` to boot into initramfs shell.
</details>

---

### Question 14: Reset Root Password
**Task:** Reset lost root password.

<details>
<summary>Show Solution</summary>

**Steps:**
1. At GRUB, press `e` to edit
2. Find `linux` line
3. Add at end: `rd.break`
4. Press `Ctrl+X`
5. At emergency prompt:

```bash
# Remount root filesystem
mount -o remount,rw /sysroot

# Change root
chroot /sysroot

# Change password
passwd root

# Create SELinux relabel file
touch /.autorelabel

# Exit and reboot
exit
exit
```

**The /.autorelabel triggers SELinux relabeling on boot.**
</details>

---

### Question 15: Boot Single User Mode
**Task:** Boot to single user mode.

<details>
<summary>Show Solution</summary>

**At GRUB:**
1. Press `e`
2. Add to linux line: `single` or `1` or `s`
3. Press `Ctrl+X`

**Or use:**
```
systemd.unit=rescue.target
```
</details>

---

## Part 6: GRUB Configuration Scripts

### Question 16: Understand GRUB Scripts
**Task:** View GRUB configuration directory.

<details>
<summary>Show Solution</summary>

```bash
ls /etc/grub.d/
```

**Files:**
- `00_header` - Basic GRUB settings
- `10_linux` - Linux kernel entries
- `40_custom` - Custom entries
- `README`

**Add custom entries to 40_custom:**
```bash
sudo vi /etc/grub.d/40_custom
```
</details>

---

### Question 17: Add Custom Boot Entry
**Task:** Add a custom boot entry.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/grub.d/40_custom
```

**Add:**
```
menuentry "Custom Boot Entry" {
    set root=(hd0,1)
    linux /vmlinuz-custom root=/dev/sda1
    initrd /initramfs-custom.img
}
```

**Regenerate:**
```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```
</details>

---

## Part 7: Kernel Management

### Question 18: List Installed Kernels
**Task:** Show installed kernel packages.

<details>
<summary>Show Solution</summary>

```bash
rpm -qa kernel
```

**Or:**
```bash
dnf list installed kernel
```
</details>

---

### Question 19: Remove Old Kernel
**Task:** Remove old kernel version.

<details>
<summary>Show Solution</summary>

```bash
sudo dnf remove kernel-5.14.0-70.el9.x86_64
```

**Never remove the currently running kernel!**

**Check running kernel:**
```bash
uname -r
```
</details>

---

## Part 8: Exam Scenarios

### Question 20: Exam Scenario - Add Boot Parameter
**Task:** Add "audit=1" permanently to boot parameters.

<details>
<summary>Show Solution</summary>

**Option 1 - grubby:**
```bash
sudo grubby --update-kernel=ALL --args="audit=1"
```

**Option 2 - Edit config:**
```bash
sudo vi /etc/default/grub
```

**Modify GRUB_CMDLINE_LINUX:**
```
GRUB_CMDLINE_LINUX="... audit=1"
```

**Regenerate:**
```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

**Verify:**
```bash
grubby --info=DEFAULT | grep args
```
</details>

---

### Question 21: Exam Scenario - Disable SELinux at Boot
**Task:** Add parameter to disable SELinux enforcement at boot.

<details>
<summary>Show Solution</summary>

```bash
sudo grubby --update-kernel=ALL --args="enforcing=0"
```

**Note:** This is temporary per boot. Use /etc/selinux/config for permanent.
</details>

---

### Question 22: Exam Scenario - Change Timeout
**Task:** Set GRUB timeout to 3 seconds.

<details>
<summary>Show Solution</summary>

```bash
sudo vi /etc/default/grub
```

**Set:**
```
GRUB_TIMEOUT=3
```

**Regenerate:**
```bash
# Check BIOS or UEFI system:
ls /sys/firmware/efi 2>/dev/null && echo "UEFI" || echo "BIOS"

# For BIOS:
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# For UEFI:
sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```
</details>

---

### Question 23: Exam Scenario - Remove rhgb quiet
**Task:** Remove "rhgb quiet" to see boot messages.

<details>
<summary>Show Solution</summary>

```bash
sudo grubby --update-kernel=ALL --remove-args="rhgb quiet"
```

**Verify:**
```bash
grubby --info=DEFAULT
```
</details>

---

## Quick Reference

### View Configuration
```bash
cat /etc/default/grub
grubby --info=ALL
grubby --default-kernel
cat /proc/cmdline
```

### Modify Parameters with grubby
```bash
# Add parameter to all kernels
grubby --update-kernel=ALL --args="parameter"

# Add to default kernel
grubby --update-kernel=DEFAULT --args="parameter"

# Remove parameter
grubby --update-kernel=ALL --remove-args="parameter"

# Set default kernel
grubby --set-default /boot/vmlinuz-VERSION
```

### Set Default and Timeout
```bash
# Set default entry
grub2-set-default 0

# Edit /etc/default/grub for timeout
GRUB_TIMEOUT=5
```

### Regenerate GRUB Config
```bash
# BIOS
grub2-mkconfig -o /boot/grub2/grub.cfg

# UEFI
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```

### Boot Parameters at GRUB
```
# Edit boot entry (press 'e')
# Add to linux line:
systemd.unit=rescue.target
systemd.unit=emergency.target
rd.break
```

### Reset Root Password
```
1. Add rd.break at GRUB
2. mount -o remount,rw /sysroot
3. chroot /sysroot  
4. passwd root
5. touch /.autorelabel
6. exit; exit
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Edit /etc/default/grub** to modify boot parameters
2. **Use grubby** to add/remove kernel parameters
3. **Regenerate GRUB config** with grub2-mkconfig
4. **Set default boot entry** using grubby or grub2-set-default
5. **Boot into rescue/emergency mode** from GRUB menu
6. **Reset root password** using rd.break
7. **Modify timeout** in GRUB configuration
