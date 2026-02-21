#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Cut Command - Extract Fields

# This is a LAB exercise
IS_LAB=true
LAB_ID="cut_command"

QUESTION="[LAB] Use cut to extract specific fields from text"
HINT="Task 1: cat /etc/passwd | cut -d':' -f 6 > /tmp/home.txt
(-d = delimiter, -f = field number, field 6 = home directory)"

# Lab configuration
LAB_TITLE="Cut Command - Extract Fields"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Extract the home directory of all users from /etc/passwd and save to /tmp/home.txt" ;;
    esac
}

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
