#!/bin/bash
# Objective 2: Manage software
# LAB: Check package updates without applying them
IS_LAB=true
LAB_ID="dnf_update_security_check"
QUESTION="Check for package updates and save results without changing packages"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Run a general update check and save output to /tmp/exam/check-update.txt"
TASK_1_HINT="Use dnf check-update and allow non-zero exit code"
TASK_1_COMMAND_1="dnf check-update > /tmp/exam/check-update.txt 2>&1 || true"
TASK_2_QUESTION="List updates for bash only and save to /tmp/exam/bash-update.txt"
TASK_2_HINT="Use dnf check-update bash"
TASK_2_COMMAND_1="dnf check-update bash > /tmp/exam/bash-update.txt 2>&1 || true"
TASK_3_QUESTION="Save the currently installed bash package to /tmp/exam/current-bash.txt"
TASK_3_HINT="Use rpm -q bash"
TASK_3_COMMAND_1="rpm -q bash > /tmp/exam/current-bash.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/check-update.txt /tmp/exam/bash-update.txt /tmp/exam/current-bash.txt; }
check_tasks(){
 [[ -f /tmp/exam/check-update.txt ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /tmp/exam/bash-update.txt ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/current-bash.txt ]] && grep -q '^bash-' /tmp/exam/current-bash.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/check-update.txt /tmp/exam/bash-update.txt /tmp/exam/current-bash.txt; }
