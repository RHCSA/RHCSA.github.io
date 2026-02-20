#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create bzip2 Compressed Archive

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_bzip2"

QUESTION="[LAB] Create a bzip2 compressed tar archive"
HINT="This lab has 1 task:\n\n1. Create bzip2 compressed archive:\n   tar -cvjf /tmp/etc_backup.tar.bz2 /etc/ssh\n\nOptions:\n  -c = create\n  -v = verbose\n  -j = bzip2 compression\n  -f = file (archive name)\n\nNote: bzip2 has better compression than gzip but is slower"

# Lab configuration
LAB_TITLE="Create bzip2 Compressed Archive"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create a bzip2 compressed tar archive named /tmp/etc_backup.tar.bz2 of the /etc/ssh directory" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing any existing etc_backup.tar.bz2...${RESET}"
    rm -f /tmp/etc_backup.tar.bz2 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if bzip2 archive exists and is valid
    if [[ -f /tmp/etc_backup.tar.bz2 ]]; then
        # Verify it's a valid bzip2 compressed tar archive containing ssh config
        if tar -tjf /tmp/etc_backup.tar.bz2 2>/dev/null | grep -q 'ssh'; then
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
    rm -f /tmp/etc_backup.tar.bz2 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
