#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Add User to Group

IS_LAB=true
LAB_ID="add_user_group"

QUESTION="[LAB] Add a user to a supplementary group"
HINT="Task 1: usermod -aG testgroup member1\nTask 2: groups member1 (verify testgroup membership)"

LAB_TITLE="Add User to Group"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add member1 to group testgroup" ;;
        1) echo "Verify member1 is in testgroup" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user and group...${RESET}"
    userdel -r member1 2>/dev/null
    groupdel testgroup 2>/dev/null
    groupadd testgroup 2>/dev/null
    useradd member1 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user is in group
    if groups member1 2>/dev/null | grep -q 'testgroup'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Same check
    if id -Gn member1 2>/dev/null | grep -q 'testgroup'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r member1 2>/dev/null
    groupdel testgroup 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
