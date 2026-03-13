#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create tar Archive

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_create"

QUESTION="Create an uncompressed tar archive"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an uncompressed tar archive named /tmp/backup.tar containing all files in /etc/sysconfig/"
TASK_1_HINT="Use tar -cvf to create archive: -c=create, -v=verbose, -f=file"
TASK_1_COMMAND_1="tar -cvf /tmp/backup.tar /etc/sysconfig/"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing any existing backup.tar...${RESET}"
    rm -f /tmp/backup.tar 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if archive exists and contains sysconfig files
    if [[ -f /tmp/backup.tar ]]; then
        if tar -tf /tmp/backup.tar 2>/dev/null | grep -q 'sysconfig'; then
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
    rm -f /tmp/backup.tar 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
