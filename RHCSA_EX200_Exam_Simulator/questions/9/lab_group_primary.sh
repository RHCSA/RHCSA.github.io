#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Change Primary Group

IS_LAB=true
LAB_ID="change_primary_group"

QUESTION="[LAB] Change a user's primary group"
HINT="Task 1: usermod -g newprimary primuser\nTask 2: id primuser (verify primary group)"

LAB_TITLE="Change Primary Group"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Change primuser's primary group to newprimary" ;;
        1) echo "Verify primary group is newprimary" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user and group...${RESET}"
    userdel -r primuser 2>/dev/null
    groupdel newprimary 2>/dev/null
    groupadd newprimary 2>/dev/null
    useradd primuser 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if primary group is newprimary
    local prim_grp=$(id -gn primuser 2>/dev/null)
    if [[ "$prim_grp" == "newprimary" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Same check
    if [[ "$prim_grp" == "newprimary" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r primuser 2>/dev/null
    groupdel newprimary 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
