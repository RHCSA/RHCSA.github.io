#!/bin/bash
# Objective 4: Operate running systems
# Question: Reset the root password (alternative method, init=/bin/bash)
# This is a plain question, not a lab - see question_reset_root_password.sh
# for the rd.break method and the container/boot limit note. No IS_LAB
# line, so both the CLI and the webui treat this as a plain Question/Answer
# entry (QUESTION + ANSWER only, no HINT needed).

QUESTION="Reset the root password using the init=/bin/bash method."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"
ANSWER="1. At the GRUB menu, press the 'e' key to edit the entry.
2. Find the line that starts with 'linux'.
3. Replace ro with rw, and add this to the end of the line: init=/bin/bash
4. Press Ctrl+X to boot.
5. The system boots directly to a bash shell. The filesystem should already be read-write.
6. Change the root password: passwd root
7. Force an SELinux relabel: touch /.autorelabel
8. Reboot the system: exec /sbin/init"
