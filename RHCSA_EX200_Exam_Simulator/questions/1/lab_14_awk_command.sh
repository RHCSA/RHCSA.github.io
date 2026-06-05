#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Awk Command - Extract Columns

# This is a LAB exercise
IS_LAB=true
LAB_ID="awk_command"

QUESTION="Use awk to extract specific columns from command output"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Extract only USER and PID columns from 'ps aux' and save to /tmp/ps-users.txt"
TASK_1_HINT="\$1 = USER, \$2 = PID in ps aux output"
TASK_1_COMMAND_1="ps aux | awk '{print \$1, \$2}' > /tmp/ps-users.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Removing existing file...${RESET}"
    rm -f /tmp/ps-users.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if file exists with only 2 columns (USER and PID)
    if [[ -f /tmp/ps-users.txt ]]; then
        # Check that file has content
        local line_count=$(wc -l < /tmp/ps-users.txt 2>/dev/null)
        if [[ $line_count -ge 5 ]]; then
            # Verify it contains USER/root and numeric PIDs
            if grep -qE "^(USER|root|[a-z_][a-z0-9_-]*) +[0-9]+" /tmp/ps-users.txt 2>/dev/null; then
                # Verify it does NOT contain full ps output (no %CPU, %MEM, COMMAND columns)
                # Full ps aux has columns like %CPU, TIME, COMMAND - check for absence of these patterns
                if ! grep -qE "%CPU|%MEM|[0-9]+:[0-9]{2}" /tmp/ps-users.txt 2>/dev/null; then
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
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    rm -f /tmp/ps-users.txt 2>/dev/null
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
