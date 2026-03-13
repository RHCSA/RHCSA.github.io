#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Cut Command - Extract Fields

# This is a LAB exercise
IS_LAB=true
LAB_ID="cut_command"

QUESTION="Use cut to extract specific fields from text"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Extract the home directory of all users from /etc/passwd and save to /tmp/home.txt"
TASK_1_HINT="-d = delimiter, -f = field number, field 6 = home directory"
TASK_1_COMMAND_1="cat /etc/passwd | cut -d':' -f 6 > /tmp/home.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Removing existing file...${RESET}"
    rm -f /tmp/home.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if file exists and contains home directories (paths like /home/user or /root)
    if [[ -f /tmp/home.txt ]] && grep -qE "^(/root|/home/|/var|/sbin|/bin|/usr)" /tmp/home.txt 2>/dev/null; then
        # Also verify it has multiple lines (extracted from passwd, not manually created)
        local line_count=$(wc -l < /tmp/home.txt 2>/dev/null)
        if [[ $line_count -ge 5 ]]; then
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
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    rm -f /tmp/home.txt 2>/dev/null
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
