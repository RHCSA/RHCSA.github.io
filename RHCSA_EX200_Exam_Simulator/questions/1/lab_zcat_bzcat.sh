#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: View Compressed File Without Decompressing

# This is a LAB exercise
IS_LAB=true
LAB_ID="zcat_bzcat"

QUESTION="[LAB] View compressed file contents without decompressing"
HINT="Task 1: zcat /tmp/readme.gz > /tmp/readme_content.txt
Task 2: bzcat /tmp/notes.bz2 > /tmp/notes_content.txt"

# Lab configuration
LAB_TITLE="View Compressed Files"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "View /tmp/readme.gz contents and save to /tmp/readme_content.txt (don't decompress original)" ;;
        1) echo "View /tmp/notes.bz2 contents and save to /tmp/notes_content.txt (don't decompress original)" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating compressed test files...${RESET}"
    rm -f /tmp/readme.gz /tmp/notes.bz2 2>/dev/null
    rm -f /tmp/readme_content.txt /tmp/notes_content.txt 2>/dev/null
    
    # Create gzip file
    echo "This is the README file content." > /tmp/readme
    echo "It contains important information." >> /tmp/readme
    gzip /tmp/readme
    
    # Create bzip2 file
    echo "These are the notes file contents." > /tmp/notes
    echo "Very important notes here." >> /tmp/notes
    bzip2 /tmp/notes
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if readme content was extracted and original .gz still exists
    if [[ -f /tmp/readme.gz ]] && [[ -f /tmp/readme_content.txt ]]; then
        if grep -q "README file content" /tmp/readme_content.txt 2>/dev/null; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if notes content was extracted and original .bz2 still exists
    if [[ -f /tmp/notes.bz2 ]] && [[ -f /tmp/notes_content.txt ]]; then
        if grep -q "notes file contents" /tmp/notes_content.txt 2>/dev/null; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/readme.gz /tmp/notes.bz2 2>/dev/null
    rm -f /tmp/readme_content.txt /tmp/notes_content.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
