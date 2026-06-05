#!/bin/bash
# Objective 2: Manage software
# LAB: Remove an installed RPM package safely
IS_LAB=true
LAB_ID="dnf_remove_dependency_safe"
QUESTION="Remove a test package and prove it is no longer installed"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Install package nano"
TASK_1_HINT="Use dnf install -y nano"
TASK_1_COMMAND_1="dnf install -y nano"
TASK_2_QUESTION="Remove package nano"
TASK_2_HINT="Use dnf remove -y nano"
TASK_2_COMMAND_1="dnf remove -y nano"
TASK_3_QUESTION="Save the rpm query result for nano to /tmp/exam/nano-removed.txt"
TASK_3_HINT="rpm -q returns a not installed message after removal"
TASK_3_COMMAND_1="rpm -q nano > /tmp/exam/nano-removed.txt 2>&1 || true"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/nano-removed.txt; dnf remove -y nano &>/dev/null || true; }
check_tasks(){
 [[ ! -f /tmp/exam/nano-removed.txt && $(rpm -q nano &>/dev/null; echo $?) -eq 0 ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 ! rpm -q nano &>/dev/null && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -f /tmp/exam/nano-removed.txt ]] && grep -Eqi 'not installed|is not installed' /tmp/exam/nano-removed.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ dnf remove -y nano &>/dev/null || true; rm -f /tmp/exam/nano-removed.txt; }
