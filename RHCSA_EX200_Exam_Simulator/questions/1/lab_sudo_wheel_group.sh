#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Add User to wheel Group for sudo Access

# This is a LAB exercise
IS_LAB=true
LAB_ID="sudo_wheel_group"

QUESTION="[LAB] Add user to wheel group for sudo access"
HINT="Task 1: usermod -aG wheel labuser (-a append, -G supplementary group)"

# Lab configuration
LAB_TITLE="Add User to wheel Group"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add user 'labuser' to the wheel group to grant sudo access" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test user labuser...${RESET}"
    userdel -r labuser 2>/dev/null
    useradd labuser 2>/dev/null
    echo "labuser:password123" | chpasswd 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if labuser is in wheel group
    if id labuser 2>/dev/null | grep -q 'wheel'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r labuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
