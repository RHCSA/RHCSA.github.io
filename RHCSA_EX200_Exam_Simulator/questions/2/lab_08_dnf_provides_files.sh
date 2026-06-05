#!/bin/bash
# Objective 2: Manage software
# LAB: Find which package provides files and commands
IS_LAB=true
LAB_ID="dnf_provides_files"
QUESTION="Use dnf provides to map files and commands to packages"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Find which package provides /usr/bin/ssh and save to /tmp/exam/provides-ssh.txt"
TASK_1_HINT="Use dnf provides /usr/bin/ssh"
TASK_1_COMMAND_1="dnf provides /usr/bin/ssh > /tmp/exam/provides-ssh.txt"
TASK_2_QUESTION="Find which package provides semanage and save to /tmp/exam/provides-semanage.txt"
TASK_2_HINT="Use dnf provides '*/semanage'"
TASK_2_COMMAND_1="dnf provides '*/semanage' > /tmp/exam/provides-semanage.txt"
TASK_3_QUESTION="Find which package provides /etc/chrony.conf and save to /tmp/exam/provides-chronyconf.txt"
TASK_3_HINT="Use dnf provides /etc/chrony.conf"
TASK_3_COMMAND_1="dnf provides /etc/chrony.conf > /tmp/exam/provides-chronyconf.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/provides-ssh.txt /tmp/exam/provides-semanage.txt /tmp/exam/provides-chronyconf.txt; }
check_tasks(){
 [[ -s /tmp/exam/provides-ssh.txt ]] && grep -Eqi 'openssh|ssh' /tmp/exam/provides-ssh.txt && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -s /tmp/exam/provides-semanage.txt ]] && grep -Eqi 'policycoreutils|semanage' /tmp/exam/provides-semanage.txt && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/provides-chronyconf.txt ]] && grep -Eqi 'chrony|chrony.conf' /tmp/exam/provides-chronyconf.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/provides-ssh.txt /tmp/exam/provides-semanage.txt /tmp/exam/provides-chronyconf.txt; }
