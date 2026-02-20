#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Decompress gzip File

# This is a LAB exercise
IS_LAB=true
LAB_ID="gzip_decompress"

QUESTION="[LAB] Decompress a gzip file"
HINT="This lab has 1 task:\n\n1. Decompress gzip file:\n   gunzip /tmp/data.gz\n\nAlternative:\n   gzip -d /tmp/data.gz\n\nNote: gunzip and gzip -d are equivalent\nThe .gz file is replaced with the uncompressed file"

# Lab configuration
LAB_TITLE="gzip Decompression"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Decompress /tmp/data.gz to its original form (/tmp/data)" ;;
    esac
}

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
