#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Configure Passwordless sudo for User

# This is a LAB exercise
IS_LAB=true
LAB_ID="sudo_nopasswd"

QUESTION="[LAB] Configure passwordless sudo for a user"
HINT="Task 1: Add to /etc/sudoers.d/automation:
automation ALL=(ALL) NOPASSWD: ALL"

# Lab configuration
LAB_TITLE="Configure Passwordless sudo"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Configure user 'automation' to run all sudo commands without password" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing configuration...${RESET}"
    rm -f /etc/sudoers.d/automation 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating test user automation...${RESET}"
    userdel -r automation 2>/dev/null
    useradd automation 2>/dev/null
    echo "automation:password123" | chpasswd 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if automation user has NOPASSWD sudo access
    # Check both /etc/sudoers.d/automation and /etc/sudoers
    local found="false"
    
    # Check drop-in file first
    if [[ -f /etc/sudoers.d/automation ]]; then
        if grep -qE '^automation[[:space:]]+.*NOPASSWD:[[:space:]]*ALL' /etc/sudoers.d/automation 2>/dev/null; then
            found="true"
        fi
    fi
    
    # Also check main sudoers file
    if grep -qE '^automation[[:space:]]+.*NOPASSWD:[[:space:]]*ALL' /etc/sudoers 2>/dev/null; then
        found="true"
    fi
    
    # Verify syntax is correct if found
    if [[ "$found" == "true" ]]; then
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
    rm -f /etc/sudoers.d/automation 2>/dev/null
    # Remove entry from /etc/sudoers if added there
    sed -i '/^automation[[:space:]].*NOPASSWD/d' /etc/sudoers 2>/dev/null
    userdel -r automation 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
