#!/bin/bash
# Objective 2: Manage software
# LAB: Check Package Dependencies

IS_LAB=true
LAB_ID="dnf_dependencies"

QUESTION="[LAB] Query and analyze package dependencies"
HINT="Task 1: dnf repoquery --requires httpd > /tmp/httpd-deps.txt\nTask 2: rpm -qR bash > /tmp/bash-deps.txt"

LAB_TITLE="Check Package Dependencies"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List httpd dependencies and save to /tmp/httpd-deps.txt" ;;
        1) echo "List bash dependencies using rpm and save to /tmp/bash-deps.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/httpd-deps.txt /tmp/bash-deps.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if httpd-deps.txt exists and contains dependencies
    if [[ -f /tmp/httpd-deps.txt ]] && [[ -s /tmp/httpd-deps.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if bash-deps.txt exists and contains dependencies
    if [[ -f /tmp/bash-deps.txt ]] && grep -qi 'lib\|rpmlib' /tmp/bash-deps.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/httpd-deps.txt /tmp/bash-deps.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
