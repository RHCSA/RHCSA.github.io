#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Compress File with gzip

# This is a LAB exercise
IS_LAB=true
LAB_ID="gzip_compress"

QUESTION="[LAB] Compress a file using gzip while keeping the original"
HINT="This lab has 1 task:\n\n1. Compress file keeping original:\n   gzip -k /tmp/testfile.txt\n\nAlternative using stdout:\n   gzip -c /tmp/testfile.txt > /tmp/testfile.txt.gz\n\nOptions:\n  -k = keep original file\n  -c = write to stdout"

# Lab configuration
LAB_TITLE="gzip Compression"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Compress /tmp/testfile.txt using gzip, keeping the original file (both files should exist)" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test file for compression...${RESET}"
    rm -f /tmp/testfile.txt /tmp/testfile.txt.gz 2>/dev/null
    
    # Create a test file with content
    cat > /tmp/testfile.txt << 'EOF'
This is a test file for gzip compression.
It contains multiple lines of text.
The purpose is to demonstrate gzip usage.
After compression, both the original and .gz should exist.
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if both original and compressed files exist
    if [[ -f /tmp/testfile.txt ]] && [[ -f /tmp/testfile.txt.gz ]]; then
        # Verify the .gz file is valid
        if gzip -t /tmp/testfile.txt.gz 2>/dev/null; then
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
    rm -f /tmp/testfile.txt /tmp/testfile.txt.gz 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
