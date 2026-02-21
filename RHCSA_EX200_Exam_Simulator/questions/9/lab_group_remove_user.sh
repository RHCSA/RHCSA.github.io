#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Remove User from Group

IS_LAB=true
LAB_ID="remove_user_group"

QUESTION="[LAB] Remove a user from a group"
HINT="Task 1: gpasswd -d removeme targetgrp\nTask 2: groups removeme (verify not in targetgrp)"

LAB_TITLE="Remove User from Group"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Remove removeme from targetgrp" ;;
        1) echo "Verify user is not in targetgrp" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user and group...${RESET}"
    userdel -r removeme 2>/dev/null
    groupdel targetgrp 2>/dev/null
    groupadd targetgrp 2>/dev/null
    useradd removeme 2>/dev/null
    usermod -aG targetgrp removeme 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if user is NOT in group
    if ! groups removeme 2>/dev/null | grep -q 'targetgrp'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Same check
    if ! id -Gn removeme 2>/dev/null | grep -q 'targetgrp'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r removeme 2>/dev/null
    groupdel targetgrp 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
