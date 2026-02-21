#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create tar Archive Excluding Files

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_exclude"

QUESTION="[LAB] Create a tar archive excluding certain file types"
HINT="Task 1: tar -cvzf /tmp/var_backup.tar.gz --exclude='*.log' /var/log
(--exclude='pattern' to exclude files)"

# Lab configuration
LAB_TITLE="tar with Exclusions"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/var_backup.tar.gz of /var/log excluding all .log files" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing any existing var_backup.tar.gz...${RESET}"
    rm -f /tmp/var_backup.tar.gz 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if archive exists and does NOT contain .log files
    if [[ -f /tmp/var_backup.tar.gz ]]; then
        # Verify it's a valid archive and doesn't contain .log files
        if tar -tzf /tmp/var_backup.tar.gz >/dev/null 2>&1; then
            # Check that no .log files are in the archive
            if ! tar -tzf /tmp/var_backup.tar.gz 2>/dev/null | grep -qE '\.log$'; then
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
    rm -f /tmp/var_backup.tar.gz 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
