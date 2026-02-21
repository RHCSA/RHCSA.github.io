#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Create Basic User

IS_LAB=true
LAB_ID="create_user_basic"

QUESTION="[LAB] Create a new user account"
HINT="Task 1: useradd labuser1\nTask 2: id labuser1 > /tmp/user-info.txt"

LAB_TITLE="Create Basic User"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create user labuser1" ;;
        1) echo "Verify user and save to /tmp/user-info.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab data...${RESET}"
    userdel -r labuser1 2>/dev/null
    rm -f /tmp/user-info.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user exists
    if id labuser1 &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if user-info.txt exists with user info
    if [[ -f /tmp/user-info.txt ]] && grep -q 'labuser1' /tmp/user-info.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r labuser1 2>/dev/null
    rm -f /tmp/user-info.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
