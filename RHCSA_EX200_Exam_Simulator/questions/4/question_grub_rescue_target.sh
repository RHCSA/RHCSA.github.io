#!/bin/bash
# Objective 4: Operate running systems
# Question: Boot into a specific GRUB target (rescue.target)
# This is a plain question, not a lab. GRUB edits happen before the kernel
# starts, so a container has no boot phase to test this in (see
# lab_container_shutdown_schedule.sh header for the related container/init
# limits). No IS_LAB line, so both the CLI and the webui treat this as a
# plain Question/Answer entry (QUESTION + ANSWER only, no HINT needed).

QUESTION="At boot time, edit GRUB to boot into the rescue target."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"
ANSWER="1. At the GRUB menu, press the 'e' key to edit the boot entry.
2. Find the line that starts with 'linux' (or 'linuxefi').
3. Add this to the end of that line: systemd.unit=rescue.target
4. Press Ctrl+X to boot."
