#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Set User Password

IS_LAB=true
LAB_ID="set_password"

QUESTION="[LAB] Set password for a user account"
HINT="Task 1: echo 'password123' | passwd --stdin pwduser\nTask 2: passwd -S pwduser > /tmp/pwd-status.txt"

LAB_TITLE="Set User Password"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set password for user pwduser" ;;
        1) echo "Check password status to /tmp/pwd-status.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user...${RESET}"
    userdel -r pwduser 2>/dev/null
    useradd pwduser 2>/dev/null
    rm -f /tmp/pwd-status.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if password is set (PS status)
    if passwd -S pwduser 2>/dev/null | grep -qE '^pwduser PS'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if pwd-status.txt exists
    if [[ -f /tmp/pwd-status.txt ]] && grep -q 'pwduser' /tmp/pwd-status.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r pwduser 2>/dev/null
    rm -f /tmp/pwd-status.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
