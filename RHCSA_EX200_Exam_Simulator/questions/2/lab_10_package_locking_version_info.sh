#!/bin/bash
# Objective 2: Manage software
# LAB: Compare installed and available package versions
IS_LAB=true
LAB_ID="package_locking_version_info"
QUESTION="Inspect package versions using rpm and dnf"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Save installed version of systemd to /tmp/exam/systemd-installed.txt"
TASK_1_HINT="Use rpm -q systemd"
TASK_1_COMMAND_1="rpm -q systemd > /tmp/exam/systemd-installed.txt"
TASK_2_QUESTION="Save all available systemd packages to /tmp/exam/systemd-available.txt"
TASK_2_HINT="Use dnf list systemd --showduplicates"
TASK_2_COMMAND_1="dnf list systemd --showduplicates > /tmp/exam/systemd-available.txt"
TASK_3_QUESTION="Save detailed package metadata for systemd to /tmp/exam/systemd-info.txt"
TASK_3_HINT="Use dnf info systemd"
TASK_3_COMMAND_1="dnf info systemd > /tmp/exam/systemd-info.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/systemd-installed.txt /tmp/exam/systemd-available.txt /tmp/exam/systemd-info.txt; }
check_tasks(){
 [[ -s /tmp/exam/systemd-installed.txt ]] && grep -q '^systemd-' /tmp/exam/systemd-installed.txt && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -s /tmp/exam/systemd-available.txt ]] && grep -qi 'systemd' /tmp/exam/systemd-available.txt && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/systemd-info.txt ]] && grep -Eqi '^Name *: *systemd|Name *: systemd|^Name[[:space:]]+: systemd' /tmp/exam/systemd-info.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /tmp/exam/systemd-installed.txt /tmp/exam/systemd-available.txt /tmp/exam/systemd-info.txt; }
