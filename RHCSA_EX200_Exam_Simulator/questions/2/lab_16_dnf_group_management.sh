#!/bin/bash
# Objective 2: Manage software
# LAB: Work with package groups
IS_LAB=true
LAB_ID="dnf_group_management"
QUESTION="List, inspect and install a package group"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Save all available and installed groups to /tmp/exam/groups.txt"
TASK_1_HINT="Use dnf group list"
TASK_1_COMMAND_1="dnf group list > /tmp/exam/groups.txt"
TASK_2_QUESTION="Save information about the Minimal Install group to /tmp/exam/group-minimal.txt"
TASK_2_HINT="Use dnf group info 'Minimal Install'"
TASK_2_COMMAND_1="dnf group info 'Minimal Install' > /tmp/exam/group-minimal.txt"
TASK_3_QUESTION="Install the Development Tools group"
TASK_3_HINT="Use dnf group install -y 'Development Tools'"
TASK_3_COMMAND_1="dnf group install -y 'Development Tools'"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/groups.txt /tmp/exam/group-minimal.txt; }
check_tasks(){
 [[ -s /tmp/exam/groups.txt ]] && grep -Eqi 'Available|Installed|Environment|Groups' /tmp/exam/groups.txt && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -s /tmp/exam/group-minimal.txt ]] && grep -Eqi 'Minimal|Group|Description' /tmp/exam/group-minimal.txt && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 dnf group list --installed 2>/dev/null | grep -Eqi 'Development Tools|C Development Tools' && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/groups.txt /tmp/exam/group-minimal.txt; }
