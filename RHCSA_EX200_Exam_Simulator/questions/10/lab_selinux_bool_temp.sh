#!/bin/bash
# Objective 10: Manage security
# LAB: Set SELinux Boolean Temporarily

IS_LAB=true
LAB_ID="selinux_bool_temp"

QUESTION="[LAB] Set an SELinux boolean temporarily"
HINT="Task 1: setsebool httpd_can_network_connect on\nTask 2: getsebool httpd_can_network_connect > /tmp/bool-status.txt"

LAB_TITLE="Set Boolean Temp"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Enable httpd_can_network_connect boolean" ;;
        1) echo "Verify and save status to /tmp/bool-status.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring boolean is off initially...${RESET}"
    setsebool httpd_can_network_connect off 2>/dev/null
    rm -f /tmp/bool-status.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if boolean is on
    if getsebool httpd_can_network_connect 2>/dev/null | grep -q '\-\-> on'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if bool-status.txt exists with on status
    if [[ -f /tmp/bool-status.txt ]] && grep -q 'on' /tmp/bool-status.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Resetting boolean...${RESET}"
    setsebool httpd_can_network_connect off 2>/dev/null
    rm -f /tmp/bool-status.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
