#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Hard Link vs Soft Link - Target Deletion Test

# This is a LAB exercise
IS_LAB=true
LAB_ID="link_survival"

QUESTION="[LAB] Understand link behavior when original file is deleted"
HINT="Task 1: echo 'important data' > /tmp/source.txt
Task 2: ln /tmp/source.txt /tmp/hard.txt
Task 3: ln -s /tmp/source.txt /tmp/soft.txt
Task 4: rm /tmp/source.txt, test which link works, save 'hard' or 'soft' to /tmp/surviving_link.txt"

# Lab configuration
LAB_TITLE="Link Survival Test"
LAB_TASK_COUNT=4

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/source.txt with content 'important data'" ;;
        1) echo "Create hard link /tmp/hard.txt to /tmp/source.txt" ;;
        2) echo "Create soft link /tmp/soft.txt to /tmp/source.txt" ;;
        3) echo "Delete /tmp/source.txt and save which link survives ('hard' or 'soft') to /tmp/surviving_link.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Cleaning up any existing test files...${RESET}"
    rm -f /tmp/source.txt /tmp/hard.txt /tmp/soft.txt /tmp/surviving_link.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if source.txt exists with correct content (or was created then deleted)
    # We need to track if hard.txt has the content (meaning source was created properly)
    if [[ -f /tmp/source.txt ]]; then
        if grep -q "important data" /tmp/source.txt 2>/dev/null; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    elif [[ -f /tmp/hard.txt ]] && grep -q "important data" /tmp/hard.txt 2>/dev/null; then
        # Source was deleted but hard link proves it was created correctly
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if hard.txt exists and has same content
    if [[ -f /tmp/hard.txt ]]; then
        if grep -q "important data" /tmp/hard.txt 2>/dev/null; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check if soft.txt is a symlink pointing to source.txt
    if [[ -L /tmp/soft.txt ]]; then
        local target=$(readlink /tmp/soft.txt)
        if [[ "$target" == "/tmp/source.txt" ]]; then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check if source is deleted and surviving_link.txt says "hard"
    if [[ ! -f /tmp/source.txt ]] && [[ -f /tmp/surviving_link.txt ]]; then
        local answer=$(cat /tmp/surviving_link.txt | tr -d ' \n' | tr '[:upper:]' '[:lower:]')
        if [[ "$answer" == "hard" ]]; then
            TASK_STATUS[3]="true"
        else
            TASK_STATUS[3]="false"
        fi
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/source.txt /tmp/hard.txt /tmp/soft.txt /tmp/surviving_link.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
