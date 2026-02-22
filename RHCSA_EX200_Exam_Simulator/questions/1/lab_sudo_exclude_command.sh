#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Configure sudo with Command Exclusion

# This is a LAB exercise
IS_LAB=true
LAB_ID="sudo_exclude_command"

QUESTION="[LAB] Configure sudo to allow all commands except specific ones"
HINT="Task 1: Add to /etc/sudoers.d/restricteduser:
restricteduser ALL=(ALL) ALL, !/usr/bin/su"

# Lab configuration
LAB_TITLE="sudo with Command Exclusion"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Allow 'restricteduser' to run all sudo commands EXCEPT /usr/bin/su" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing configuration...${RESET}"
    rm -f /etc/sudoers.d/restricteduser 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating test user restricteduser...${RESET}"
    userdel -r restricteduser 2>/dev/null
    useradd restricteduser 2>/dev/null
    echo "restricteduser:password123" | chpasswd 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if restricteduser has ALL except su
    local found_all="false"
    local found_deny_su="false"
    
    # Check drop-in file first
    if [[ -f /etc/sudoers.d/restricteduser ]]; then
        if grep -qE '^restricteduser[[:space:]]+.*ALL' /etc/sudoers.d/restricteduser 2>/dev/null; then
            found_all="true"
        fi
        if grep -qE '^restricteduser[[:space:]]+.*!/usr/bin/su' /etc/sudoers.d/restricteduser 2>/dev/null; then
            found_deny_su="true"
        fi
    fi
    
    # Also check main sudoers file
    if grep -qE '^restricteduser[[:space:]]+.*ALL' /etc/sudoers 2>/dev/null; then
        found_all="true"
    fi
    if grep -qE '^restricteduser[[:space:]]+.*!/usr/bin/su' /etc/sudoers 2>/dev/null; then
        found_deny_su="true"
    fi
    
    # Verify both conditions and syntax is correct
    if [[ "$found_all" == "true" ]] && [[ "$found_deny_su" == "true" ]]; then
        if visudo -c 2>/dev/null | grep -q 'parsed OK'; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /etc/sudoers.d/restricteduser 2>/dev/null
    # Remove entry from /etc/sudoers if added there
    sed -i '/^restricteduser[[:space:]]/d' /etc/sudoers 2>/dev/null
    userdel -r restricteduser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
