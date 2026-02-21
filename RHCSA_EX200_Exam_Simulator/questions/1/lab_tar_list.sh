#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: List tar Archive Contents

# This is a LAB exercise
IS_LAB=true
LAB_ID="tar_list"

QUESTION="[LAB] List contents of a tar archive and save to file"
HINT="Task 1: tar -tvzf /tmp/archive.tar.gz > /tmp/archive_contents.txt
(-t = list contents)"

# Lab configuration
LAB_TITLE="List tar Archive Contents"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List the contents of /tmp/archive.tar.gz and save the output to /tmp/archive_contents.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test archive...${RESET}"
    rm -f /tmp/archive.tar.gz /tmp/archive_contents.txt 2>/dev/null
    
    # Create test directory structure
    mkdir -p /tmp/lab_archive/subdir
    echo "Main file" > /tmp/lab_archive/main.txt
    echo "Config" > /tmp/lab_archive/app.conf
    echo "Nested file" > /tmp/lab_archive/subdir/nested.txt
    
    # Create archive
    tar -czf /tmp/archive.tar.gz -C /tmp lab_archive
    rm -rf /tmp/lab_archive
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if contents file exists and has archive listing
    if [[ -f /tmp/archive_contents.txt ]]; then
        # Should contain file names from the archive
        if grep -qE 'main\.txt|app\.conf|nested\.txt' /tmp/archive_contents.txt 2>/dev/null; then
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
    rm -f /tmp/archive.tar.gz /tmp/archive_contents.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
