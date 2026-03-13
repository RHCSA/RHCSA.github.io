#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Create gzip Compressed Archive

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_gzip"

QUESTION="Create a gzip compressed tar archive"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create a gzip compressed tar archive named /tmp/logs.tar.gz containing all .log files in /var/log/"
TASK_1_HINT="-z = gzip compression"
TASK_1_COMMAND_1="tar -cvzf /tmp/logs.tar.gz /var/log/*.log"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing any existing logs.tar.gz...${RESET}"
    rm -f /tmp/logs.tar.gz 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if gzip archive exists and contains .log files
    if [[ -f /tmp/logs.tar.gz ]]; then
        # Verify it's a valid gzip compressed tar archive AND contains .log files
        if tar -tzf /tmp/logs.tar.gz 2>/dev/null | grep -qE '\.log$'; then
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
    rm -f /tmp/logs.tar.gz 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
