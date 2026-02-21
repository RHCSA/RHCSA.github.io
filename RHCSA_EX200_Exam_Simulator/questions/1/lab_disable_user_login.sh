#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Disable User Login

# This is a LAB exercise
IS_LAB=true
LAB_ID="disable_user_login"

QUESTION="[LAB] Disable login for a user account"
HINT="Task 1: usermod -s /sbin/nologin testuser (prevents interactive login)"

# Lab configuration
LAB_TITLE="Disable User Login"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Disable login for user 'testuser' by setting shell to /sbin/nologin" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test user with bash shell...${RESET}"
    userdel -r testuser 2>/dev/null
    useradd -s /bin/bash testuser 2>/dev/null
    echo "testuser:password123" | chpasswd 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Verifying initial shell...${RESET}"
    grep testuser /etc/passwd | cut -d: -f7
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if testuser has /sbin/nologin shell
    local user_shell=$(grep '^testuser:' /etc/passwd 2>/dev/null | cut -d: -f7)
    if [[ "$user_shell" == "/sbin/nologin" ]] || [[ "$user_shell" == "/usr/sbin/nologin" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r testuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
