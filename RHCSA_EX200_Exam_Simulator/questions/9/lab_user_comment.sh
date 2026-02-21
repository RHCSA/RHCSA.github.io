#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Create User with Comment

IS_LAB=true
LAB_ID="create_user_comment"

QUESTION="[LAB] Create a user with a full name comment"
HINT="Task 1: useradd -c 'John Smith' jsmith\nTask 2: getent passwd jsmith > /tmp/jsmith.txt"

LAB_TITLE="Create User with Comment"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create user jsmith with comment 'John Smith'" ;;
        1) echo "Save user info to /tmp/jsmith.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab data...${RESET}"
    userdel -r jsmith 2>/dev/null
    rm -f /tmp/jsmith.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user exists with comment
    if getent passwd jsmith 2>/dev/null | grep -qi 'john smith'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if jsmith.txt exists
    if [[ -f /tmp/jsmith.txt ]] && grep -q 'jsmith' /tmp/jsmith.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r jsmith 2>/dev/null
    rm -f /tmp/jsmith.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
