#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create sudoers Drop-in Configuration

# This is a LAB exercise
IS_LAB=true
LAB_ID="sudoers_dropin"

QUESTION="[LAB] Create a sudoers drop-in configuration file for a group"
HINT="Task 1: Add to /etc/sudoers.d/developers:
%developers ALL=(ALL) NOPASSWD: /usr/bin/ping"

# Lab configuration
LAB_TITLE="Create sudoers Drop-in File"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /etc/sudoers.d/developers granting developers group passwordless sudo access to /usr/bin/ping" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing configuration...${RESET}"
    rm -f /etc/sudoers.d/developers 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating developers group...${RESET}"
    groupadd -f developers 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if /etc/sudoers.d/developers exists with correct content
    if [[ -f /etc/sudoers.d/developers ]]; then
        # Should contain %developers and NOPASSWD: /usr/bin/ping
        if grep -qE '^%developers' /etc/sudoers.d/developers 2>/dev/null && \
           grep -qE 'NOPASSWD:.*ping' /etc/sudoers.d/developers 2>/dev/null; then
            # Verify syntax is correct
            if visudo -c 2>/dev/null | grep -q 'parsed OK'; then
                TASK_STATUS[0]="true"
            else
                TASK_STATUS[0]="false"
            fi
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
    rm -f /etc/sudoers.d/developers 2>/dev/null
    groupdel developers 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
