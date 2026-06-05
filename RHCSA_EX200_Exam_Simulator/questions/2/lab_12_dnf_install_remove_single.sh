#!/bin/bash
# Objective 2: Manage software
# LAB: Install and remove a single RPM package
IS_LAB=true
LAB_ID="dnf_install_remove_single"
QUESTION="Install, verify and remove the tree package"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Install the package tree"
TASK_1_HINT="Use dnf install -y tree"
TASK_1_COMMAND_1="dnf install -y tree"
TASK_2_QUESTION="Save package verification output to /tmp/exam/tree-rpm.txt"
TASK_2_HINT="Use rpm -q tree"
TASK_2_COMMAND_1="rpm -q tree > /tmp/exam/tree-rpm.txt"
TASK_3_QUESTION="Remove the package tree"
TASK_3_HINT="Use dnf remove -y tree"
TASK_3_COMMAND_1="dnf remove -y tree"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/tree-rpm.txt; dnf remove -y tree &>/dev/null || true; }
check_tasks(){
 if [[ -f /tmp/exam/tree-rpm.txt ]] && grep -q '^tree-' /tmp/exam/tree-rpm.txt 2>/dev/null; then TASK_STATUS[0]="true"; TASK_STATUS[1]="true"; else TASK_STATUS[0]="false"; TASK_STATUS[1]="false"; fi
 if ! rpm -q tree &>/dev/null; then TASK_STATUS[2]="true"; else TASK_STATUS[2]="false"; fi
}
cleanup_lab(){ dnf remove -y tree &>/dev/null || true; rm -f /tmp/exam/tree-rpm.txt; }
