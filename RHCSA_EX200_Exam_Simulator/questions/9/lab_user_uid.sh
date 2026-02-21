#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Create User with Specific UID

IS_LAB=true
LAB_ID="create_user_uid"

QUESTION="[LAB] Create a user with a specific UID"
HINT="Task 1: useradd -u 2500 labuser2\nTask 2: id labuser2 (should show uid=2500)"

LAB_TITLE="Create User with UID"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create user labuser2 with UID 2500" ;;
        1) echo "Verify UID is 2500" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab data...${RESET}"
    userdel -r labuser2 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user exists
    if id labuser2 &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if UID is 2500
    local user_uid=$(id -u labuser2 2>/dev/null)
    if [[ "$user_uid" == "2500" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r labuser2 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
