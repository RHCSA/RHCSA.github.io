#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: List all systemd targets

# This is a LAB exercise
IS_LAB=true
LAB_ID="list_targets"

QUESTION="[LAB] Write a list of all systemd targets to a file"
HINT="This lab has 1 task:\n\n1. List all targets and save to file:\n   systemctl list-units --type=target > /tmp/all-targets.txt\n\nAlternative:\n   systemctl list-units -t target > /tmp/all-targets.txt"

# Lab configuration
LAB_TITLE="List Systemd Targets"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Write the list of all available targets on this host to /tmp/all-targets.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing target list file...${RESET}"
    rm -f /tmp/all-targets.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if file exists and contains target information
    if [[ -f /tmp/all-targets.txt ]]; then
        # Check if file contains target entries (looking for .target in the output)
        if grep -qE '\.target' /tmp/all-targets.txt 2>/dev/null; then
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
    rm -f /tmp/all-targets.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
