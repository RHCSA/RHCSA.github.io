# Interrupt the Boot Process to Gain Access to a System

## RHCSA Exam Objective
> Interrupt the boot process in order to gain access to a system

---

## Introduction

When you lose the root password or need to perform emergency system maintenance, you must know how to interrupt the boot process and gain access. The RHCSA exam specifically tests your ability to reset a forgotten root password by booting into a special mode.

---

## Password Reset Procedure Overview

1. Reboot the system
2. Interrupt GRUB boot menu
3. Edit the boot entry
4. Add `rd.break` to kernel line
5. Boot into initramfs
6. Remount root filesystem read-write
7. Change root password
8. Relabel SELinux contexts
9. Exit and reboot

---

## Practice Questions

### Question 1: Reset Root Password (CRITICAL EXAM TOPIC)
**Task:** You have forgotten the root password. Reset it without reinstalling.

<details>
<summary>Show Solution</summary>

**Step 1: Interrupt Boot**
1. Reboot the system
2. At GRUB menu, press `e` to edit the default entry

**Step 2: Edit Kernel Line**
3. Find the line starting with `linux` (or `linuxefi` on UEFI systems)
4. Move to the end of that line
5. Add: `rd.break`
6. Press `Ctrl+X` to boot

**Step 3: Remount and Change Password**
```bash
# Remount sysroot as read-write
mount -o remount,rw /sysroot

# Change root into sysroot
chroot /sysroot

# Change the root password
passwd root

# Create SELinux relabel file
touch /.autorelabel

# Exit chroot
exit

# Exit initramfs (system will reboot)
exit
```

**Note:** The `/.autorelabel` file forces SELinux to relabel all files on next boot, which is required after changing the password.
</details>

---

### Question 2: Alternative Method Using init=/bin/bash
**Task:** Reset root password using init=/bin/bash method.

<details>
<summary>Show Solution</summary>

**Step 1: Interrupt Boot**
1. At GRUB menu, press `e`
2. Find the `linux` line
3. Replace `ro` with `rw` and add `init=/bin/bash`
4. Press `Ctrl+X`

**Step 2: Change Password**
```bash
# System boots directly to bash
# Filesystem should already be read-write

# Change password
passwd root

# Force SELinux relabel
touch /.autorelabel

# Reboot
exec /sbin/init
```

**Alternative reboot:**
```bash
/sbin/reboot -f
```
</details>

---

### Question 3: Boot into Emergency Mode via GRUB
**Task:** Boot into emergency mode by modifying GRUB.

<details>
<summary>Show Solution</summary>

1. At GRUB menu, press `e`
2. Find the `linux` line
3. Add at the end: `systemd.unit=emergency.target`
4. Press `Ctrl+X`

**Once in emergency mode:**
```bash
# Enter root password when prompted

# Root filesystem is read-only, remount it
mount -o remount,rw /

# Perform maintenance tasks
# ...

# Reboot
systemctl reboot
```
</details>

---

### Question 4: Boot into Rescue Mode via GRUB
**Task:** Boot into rescue mode by modifying GRUB.

<details>
<summary>Show Solution</summary>

1. At GRUB menu, press `e`
2. Find the `linux` line
3. Add at the end: `systemd.unit=rescue.target`
4. Press `Ctrl+X`
5. Enter root password when prompted

**Note:** Rescue mode mounts all filesystems and starts more services than emergency mode.
</details>

---

### Question 5: Understanding rd.break
**Task:** Explain what `rd.break` does.

<details>
<summary>Show Solution</summary>

`rd.break` interrupts the boot process just before the system switches from the initramfs to the actual root filesystem.

Key points:
- The root filesystem is mounted at `/sysroot` (not `/`)
- The filesystem is mounted read-only by default
- You need to `chroot /sysroot` to access the real system
- SELinux context must be fixed after password change
</details>

---

### Question 6: Why is SELinux Relabeling Required?
**Task:** Explain why `touch /.autorelabel` is necessary.

<details>
<summary>Show Solution</summary>

When you change the root password using `rd.break`:
- SELinux is not running in the initramfs environment
- The new password file (`/etc/shadow`) gets incorrect SELinux context
- Without correct context, SELinux will deny login attempts
- `/.autorelabel` forces a full filesystem relabel on next boot

**Alternative (faster) method:**
```bash
# After passwd command, before exit
restorecon /etc/shadow
```

This only relabels `/etc/shadow` instead of the entire filesystem.
</details>

---

### Question 7: Verify SELinux Context After Password Reset
**Task:** Check if `/etc/shadow` has correct SELinux context.

<details>
<summary>Show Solution</summary>

```bash
ls -Z /etc/shadow
```

**Correct context:**
```
system_u:object_r:shadow_t:s0 /etc/shadow
```

**Fix if incorrect:**
```bash
restorecon -v /etc/shadow
```
</details>

---

### Question 8: Faster Password Reset Without Full Relabel
**Task:** Reset password with minimal SELinux impact.

<details>
<summary>Show Solution</summary>

Follow the standard `rd.break` procedure but replace `touch /.autorelabel` with:

```bash
# After changing password
restorecon /etc/shadow
```

Then use `load_policy -i` if available, or:

```bash
# Exit chroot
exit

# Exit to reboot
exit
```

**Note:** This method is faster as it doesn't require full filesystem relabeling.
</details>

---

### Question 9: Troubleshoot Boot Issues
**Task:** System won't boot. How do you access it for troubleshooting?

<details>
<summary>Show Solution</summary>

**Option 1: Emergency Mode**
1. At GRUB, press `e`
2. Add `systemd.unit=emergency.target` to linux line
3. Boot and enter root password

**Option 2: rd.break**
1. At GRUB, press `e`
2. Add `rd.break` to linux line
3. Boot into initramfs

**Option 3: Single User Mode**
1. At GRUB, press `e`
2. Add `single` or `1` to linux line
3. Boot into single-user mode
</details>

---

### Question 10: GRUB Keyboard Shortcuts
**Task:** List the important GRUB keyboard shortcuts.

<details>
<summary>Show Solution</summary>

| Key | Action |
|-----|--------|
| `e` | Edit selected boot entry |
| `c` | Open GRUB command line |
| `Ctrl+X` | Boot with current configuration |
| `Ctrl+C` | Open GRUB command line |
| `Esc` | Return to menu or cancel |

</details>

---

### Question 11: Exam Scenario - Complete Password Reset
**Task:** You cannot log into a RHEL 9 system as root. Recover access.

<details>
<summary>Show Solution</summary>

**Complete step-by-step procedure:**

1. **Reboot system** and wait for GRUB menu

2. **Press `e`** to edit the default entry

3. **Find the `linux` line** (starts with `linux` or `linuxefi`)

4. **Go to end of line** and add:
   ```
   rd.break
   ```

5. **Press `Ctrl+X`** to boot

6. **At the switch_root prompt:**
   ```bash
   mount -o remount,rw /sysroot
   chroot /sysroot
   passwd root
   touch /.autorelabel
   exit
   exit
   ```

7. **Wait** for system to reboot and relabel (may take several minutes)

8. **Log in** with new root password
</details>

---

## Key Boot Parameters

| Parameter | Description |
|-----------|-------------|
| `rd.break` | Break before switching to root filesystem |
| `init=/bin/bash` | Start bash instead of init |
| `systemd.unit=rescue.target` | Boot to rescue mode |
| `systemd.unit=emergency.target` | Boot to emergency mode |
| `single` or `1` | Single-user mode |
| `ro` | Mount root read-only |
| `rw` | Mount root read-write |

---

## Quick Reference

### Password Reset Procedure
```bash
# 1. At GRUB, press 'e', add rd.break, press Ctrl+X

# 2. In initramfs:
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
touch /.autorelabel
exit
exit
```

### Emergency Access
```bash
# Add to kernel line at GRUB:
systemd.unit=emergency.target

# Once booted:
mount -o remount,rw /
```

---

## Summary

For the RHCSA exam, ensure you can:

1. **Interrupt boot** at the GRUB menu
2. **Edit GRUB entries** using `e` key
3. **Add `rd.break`** to kernel parameters
4. **Remount `/sysroot`** as read-write
5. **Use `chroot`** to access real root filesystem
6. **Reset root password** using `passwd`
7. **Handle SELinux** with `touch /.autorelabel` or `restorecon`
8. **Reboot** from initramfs environment
