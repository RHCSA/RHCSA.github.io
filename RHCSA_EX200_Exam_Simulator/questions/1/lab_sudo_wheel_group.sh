#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Add User to wheel Group for sudo Access

# This is a LAB exercise
IS_LAB=true
LAB_ID="sudo_wheel_group"

QUESTION="Add user to wheel group for sudo access"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Add user 'labuser' to the wheel group to grant sudo access"
TASK_1_HINT="Use -a to append and -G to specify supplementary group"
TASK_1_COMMAND_1="usermod -aG wheel labuser"


# Auto-generate HINT from commands
HINT=$(_build_hint)
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
