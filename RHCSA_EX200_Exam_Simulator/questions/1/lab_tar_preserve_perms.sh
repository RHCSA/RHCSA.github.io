#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create tar Archive with Preserved Permissions

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_preserve_perms"

QUESTION="[LAB] Create a tar archive preserving file permissions"
HINT="Task 1: tar -cvpf /tmp/etc_backup.tar /etc/ssh
(-p = preserve permissions)"

# Lab configuration
LAB_TITLE="tar with Preserved Permissions"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create a tar archive of /etc/ssh with preserved permissions, save as /tmp/etc_backup.tar" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing any existing etc_backup.tar...${RESET}"
    rm -f /tmp/etc_backup.tar 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if archive exists and contains ssh config
    if [[ -f /tmp/etc_backup.tar ]]; then
        if tar -tf /tmp/etc_backup.tar 2>/dev/null | grep -q 'ssh'; then
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
    rm -f /tmp/etc_backup.tar 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
