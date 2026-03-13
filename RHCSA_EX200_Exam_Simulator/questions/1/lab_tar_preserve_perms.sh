#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create tar Archive with Preserved Permissions

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_preserve_perms"

QUESTION="Create a tar archive preserving file permissions"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create a tar archive of /etc/ssh with preserved permissions, save as /tmp/etc_backup.tar"
TASK_1_HINT="-p = preserve permissions"
TASK_1_COMMAND_1="tar -cvpf /tmp/etc_backup.tar /etc/ssh"


# Auto-generate HINT from commands
HINT=$(_build_hint)
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
