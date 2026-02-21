#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Add User to Multiple Groups

IS_LAB=true
LAB_ID="add_user_multigroup"

QUESTION="[LAB] Add a user to multiple groups at once"
HINT="Task 1: usermod -aG group1,group2 multiuser\nTask 2: id multiuser (verify both groups)"

LAB_TITLE="Add to Multiple Groups"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add multiuser to group1 and group2" ;;
        1) echo "Verify membership in both groups" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user and groups...${RESET}"
    userdel -r multiuser 2>/dev/null
    groupdel group1 2>/dev/null
    groupdel group2 2>/dev/null
    groupadd group1 2>/dev/null
    groupadd group2 2>/dev/null
    useradd multiuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user is in group1
    if groups multiuser 2>/dev/null | grep -q 'group1'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if user is in group2
    if groups multiuser 2>/dev/null | grep -q 'group2'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r multiuser 2>/dev/null
    groupdel group1 2>/dev/null
    groupdel group2 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
