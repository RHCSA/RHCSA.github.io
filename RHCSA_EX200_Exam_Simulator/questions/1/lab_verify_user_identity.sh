#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Verify User Identity and Groups

# This is a LAB exercise
IS_LAB=true
LAB_ID="verify_user_identity"

QUESTION="[LAB] Verify user identity and group memberships"
HINT="Task 1: id sysadmin > /tmp/sysadmin_id.txt
Task 2: groups sysadmin > /tmp/sysadmin_groups.txt"

# Lab configuration
LAB_TITLE="Verify User Identity and Groups"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Run 'id sysadmin' and save output to /tmp/sysadmin_id.txt" ;;
        1) echo "Run 'groups sysadmin' and save output to /tmp/sysadmin_groups.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test user sysadmin...${RESET}"
    userdel -r sysadmin 2>/dev/null
    groupadd -f developers 2>/dev/null
    useradd -m -G wheel,developers sysadmin 2>/dev/null
    echo "sysadmin:password123" | chpasswd 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Removing existing output files...${RESET}"
    rm -f /tmp/sysadmin_id.txt /tmp/sysadmin_groups.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if sysadmin_id.txt exists with correct content
    if [[ -f /tmp/sysadmin_id.txt ]]; then
        # Should contain uid, gid, groups
        if grep -q 'uid=' /tmp/sysadmin_id.txt 2>/dev/null && \
           grep -q 'sysadmin' /tmp/sysadmin_id.txt 2>/dev/null; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if sysadmin_groups.txt exists with correct content
    if [[ -f /tmp/sysadmin_groups.txt ]]; then
        # Should contain sysadmin and wheel
        if grep -q 'sysadmin' /tmp/sysadmin_groups.txt 2>/dev/null && \
           grep -q 'wheel' /tmp/sysadmin_groups.txt 2>/dev/null; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r sysadmin 2>/dev/null
    groupdel developers 2>/dev/null
    rm -f /tmp/sysadmin_id.txt /tmp/sysadmin_groups.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
