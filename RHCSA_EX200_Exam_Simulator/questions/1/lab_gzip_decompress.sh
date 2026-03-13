#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Decompress gzip File

# This is a LAB exercise
IS_LAB=true
LAB_ID="gzip_decompress"

QUESTION="Decompress a gzip file"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Decompress /tmp/data.gz to its original form (/tmp/data)"
TASK_1_HINT="Alternative: gzip -d /tmp/data.gz"
TASK_1_COMMAND_1="gunzip /tmp/data.gz"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating compressed test file...${RESET}"
    rm -f /tmp/data /tmp/data.gz 2>/dev/null
    
    # Create a file and compress it
    echo "This is the original data content." > /tmp/data
    echo "Line 2 of the data file." >> /tmp/data
    echo "Line 3 of the data file." >> /tmp/data
    gzip /tmp/data
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if decompressed file exists
    if [[ -f /tmp/data ]]; then
        # Verify content is correct
        if grep -q "original data content" /tmp/data 2>/dev/null; then
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
    rm -f /tmp/data /tmp/data.gz 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
