#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create xz Compressed Archive

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_xz"

QUESTION="[LAB] Create an xz compressed tar archive"
HINT="This lab has 1 task:\n\n1. Create xz compressed archive:\n   tar -cvJf /tmp/config_backup.tar.xz /etc/ssh /etc/pam.d\n\nOptions:\n  -c = create\n  -v = verbose\n  -J = xz compression (uppercase J)\n  -f = file\n\nNote: xz has best compression but is slowest"

# Lab configuration
LAB_TITLE="Create xz Compressed Archive"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create xz compressed archive /tmp/config_backup.tar.xz containing /etc/ssh and /etc/pam.d" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing any existing config_backup.tar.xz...${RESET}"
    rm -f /tmp/config_backup.tar.xz 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if xz archive exists and contains both directories
    if [[ -f /tmp/config_backup.tar.xz ]]; then
        # Verify it's a valid xz compressed tar archive
        local contents=$(tar -tJf /tmp/config_backup.tar.xz 2>/dev/null)
        if echo "$contents" | grep -q 'ssh' && echo "$contents" | grep -q 'pam.d'; then
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
    rm -f /tmp/config_backup.tar.xz 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
