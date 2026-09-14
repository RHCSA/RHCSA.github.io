#!/bin/bash
# Objective 4: Operate running systems
# Question: Fix a bad /etc/fstab entry from emergency mode
# This is a plain question, not a lab - same container/boot limit as
# question_grub_rescue_target.sh (GRUB edits happen before a container's
# kernel is even running). No IS_LAB line, so both the CLI and the webui
# treat this as a plain Question/Answer entry (QUESTION + ANSWER only, no
# HINT needed).

QUESTION="A bad /etc/fstab entry for /data is stopping the system from booting. Fix it from emergency mode."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"
ANSWER="1. At the GRUB menu, press the 'e' key to edit the entry.
2. Find the line that starts with 'linux'.
3. Add this to the end of the line: systemd.unit=emergency.target
4. Press Ctrl+X to boot.
5. Enter the root password when prompted.
6. The root filesystem is read-only. Remount it as read-write: mount -o remount,rw /
7. Open /etc/fstab and remove or fix the bad entry for /data.
8. Reboot the system: systemctl reboot"
