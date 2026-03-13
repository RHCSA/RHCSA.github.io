#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Compress File with bzip2

# This is a LAB exercise
IS_LAB=true
LAB_ID="bzip2_compress"

QUESTION="Compress a file using bzip2 with maximum compression"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Compress /tmp/largefile.txt using bzip2 with maximum compression (-9)"
TASK_1_HINT="-9 = maximum compression"
TASK_1_COMMAND_1="bzip2 -9 /tmp/largefile.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test file for compression...${RESET}"
    rm -f /tmp/largefile.txt /tmp/largefile.txt.bz2 2>/dev/null
    
    # Create a larger test file
    for i in {1..100}; do
        echo "This is line $i of the test file for bzip2 compression demonstration."
    done > /tmp/largefile.txt
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if bz2 file exists and is valid
    if [[ -f /tmp/largefile.txt.bz2 ]]; then
        # Verify it's a valid bzip2 file
        if bzip2 -t /tmp/largefile.txt.bz2 2>/dev/null; then
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
    rm -f /tmp/largefile.txt /tmp/largefile.txt.bz2 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
