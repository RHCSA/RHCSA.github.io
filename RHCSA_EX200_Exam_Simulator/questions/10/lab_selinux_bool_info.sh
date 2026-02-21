#!/bin/bash
# Objective 10: Manage security
# LAB: Display SELinux Boolean Info

IS_LAB=true
LAB_ID="selinux_bool_info"

QUESTION="[LAB] Display detailed SELinux boolean information"
HINT="Task 1: semanage boolean -l | head -20 > /tmp/bool-details.txt\nTask 2: semanage boolean -l | grep httpd_can_network > /tmp/httpd-bool-details.txt"

LAB_TITLE="Boolean Info Details"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List boolean details to /tmp/bool-details.txt" ;;
        1) echo "List httpd network booleans to /tmp/httpd-bool-details.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/bool-details.txt /tmp/httpd-bool-details.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if bool-details.txt exists with detailed info
    if [[ -f /tmp/bool-details.txt ]] && grep -qE 'on|off' /tmp/bool-details.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if httpd-bool-details.txt exists
    if [[ -f /tmp/httpd-bool-details.txt ]] && grep -qi 'httpd_can_network' /tmp/httpd-bool-details.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/bool-details.txt /tmp/httpd-bool-details.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
