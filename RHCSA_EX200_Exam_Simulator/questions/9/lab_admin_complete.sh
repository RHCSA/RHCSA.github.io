#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Create Admin User Complete

IS_LAB=true
LAB_ID="create_admin_complete"

QUESTION="[LAB] Create a complete admin user with sudo access"
HINT="Task 1: useradd -c 'Admin User' adminuser; passwd adminuser\nTask 2: usermod -aG wheel adminuser; verify with groups"

LAB_TITLE="Create Admin User"
LAB_TASK_COUNT=3

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create user adminuser with comment 'Admin User'" ;;
        1) echo "Set password for adminuser" ;;
        2) echo "Add adminuser to wheel group for sudo" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab data...${RESET}"
    userdel -r adminuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user exists with comment
    if getent passwd adminuser 2>/dev/null | grep -qi 'admin'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if password is set
    if passwd -S adminuser 2>/dev/null | grep -qE '^adminuser PS'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check if in wheel group
    if groups adminuser 2>/dev/null | grep -q 'wheel'; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r adminuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
