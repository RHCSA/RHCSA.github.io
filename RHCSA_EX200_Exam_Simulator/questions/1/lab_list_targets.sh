#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: List all systemd targets

# This is a LAB exercise
IS_LAB=true
LAB_ID="list_targets"

QUESTION="Write a list of all systemd targets to a file"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Write the list of all available targets on this host to /tmp/all-targets.txt"
TASK_1_HINT="Use systemctl list-units with --type=target (or -t target)"
TASK_1_COMMAND_1="systemctl list-units --type=target > /tmp/all-targets.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
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
