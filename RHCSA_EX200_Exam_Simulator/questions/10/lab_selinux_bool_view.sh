#!/bin/bash
# Objective 10: Manage security
# LAB: View SELinux Booleans

IS_LAB=true
LAB_ID="selinux_bool_view"

QUESTION="[LAB] View SELinux boolean settings"
HINT="Task 1: getsebool -a > /tmp/all-booleans.txt\nTask 2: getsebool -a | grep httpd > /tmp/httpd-booleans.txt"

LAB_TITLE="View SELinux Booleans"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all booleans to /tmp/all-booleans.txt" ;;
        1) echo "List httpd booleans to /tmp/httpd-booleans.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/all-booleans.txt /tmp/httpd-booleans.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if all-booleans.txt exists with boolean info
    if [[ -f /tmp/all-booleans.txt ]] && grep -qE '\-\->' /tmp/all-booleans.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if httpd-booleans.txt exists with httpd booleans
    if [[ -f /tmp/httpd-booleans.txt ]] && grep -qi 'httpd' /tmp/httpd-booleans.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/all-booleans.txt /tmp/httpd-booleans.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
