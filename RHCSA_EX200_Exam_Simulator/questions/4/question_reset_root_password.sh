#!/bin/bash
# Objective 4: Operate running systems
# Question: Reset the root password (critical exam topic)
# This is a plain question, not a lab. Resetting the root password needs a
# real reboot into rd.break, which a container cannot do (see
# question_grub_rescue_target.sh header for the same container/boot limit).
# No IS_LAB line, so both the CLI and the webui treat this as a plain
# Question/Answer entry (QUESTION + ANSWER only, no HINT needed).

QUESTION="You forgot the root password. Reset it without reinstalling the system."
ANSWER="1. Reboot the system.
2. At the GRUB menu, press the 'e' key to edit the default entry.
3. Find the line that starts with 'linux' (or 'linuxefi' on UEFI systems).
4. Go to the end of that line and add: rd.break
5. Press Ctrl+X to boot.
6. Remount sysroot as read-write: mount -o remount,rw /sysroot
7. Change root into sysroot: chroot /sysroot
8. Change the root password: passwd root
9. Create the SELinux relabel file: touch /.autorelabel
10. Exit the chroot: exit
11. Exit initramfs, the system reboots: exit

The /.autorelabel file forces SELinux to relabel all files on the next boot. This step is required after you change the password."
