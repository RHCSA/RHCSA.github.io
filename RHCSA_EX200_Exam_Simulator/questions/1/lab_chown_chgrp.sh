#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Change File Ownership with chown and chgrp

# This is a LAB exercise
IS_LAB=true
LAB_ID="chown_chgrp"

QUESTION="[LAB] Change file ownership using chown and chgrp"
HINT="This lab has 4 tasks:\n\n1. Change owner only:\n   chown nobody /tmp/file1.txt\n\n2. Change owner and group:\n   chown nobody:nobody /tmp/file2.txt\n\n3. Change only group (two methods):\n   chown :nobody /tmp/file3.txt\n   Or: chgrp nobody /tmp/file3.txt\n\n4. Recursive ownership change:\n   chown -R nobody:nobody /tmp/project/\n\nTip: Use chown user:group for both, chgrp for group only"

# Lab configuration
LAB_TITLE="chown and chgrp"
LAB_TASK_COUNT=4

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Change owner of /tmp/file1.txt to 'nobody'" ;;
        1) echo "Change owner to 'nobody' AND group to 'nobody' on /tmp/file2.txt" ;;
        2) echo "Change ONLY the group of /tmp/file3.txt to 'nobody'" ;;
        3) echo "Recursively change owner to 'nobody' and group to 'nobody' on /tmp/project/" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test files and directories...${RESET}"
    rm -rf /tmp/file1.txt /tmp/file2.txt /tmp/file3.txt /tmp/project 2>/dev/null
    
    touch /tmp/file1.txt /tmp/file2.txt /tmp/file3.txt
    mkdir -p /tmp/project/subdir
    touch /tmp/project/app.py /tmp/project/subdir/module.py
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check file1.txt owner is nobody
    local owner=$(stat -c %U /tmp/file1.txt 2>/dev/null)
    if [[ "$owner" == "nobody" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check file2.txt owner is nobody AND group is nobody
    owner=$(stat -c %U /tmp/file2.txt 2>/dev/null)
    local group=$(stat -c %G /tmp/file2.txt 2>/dev/null)
    if [[ "$owner" == "nobody" ]] && [[ "$group" == "nobody" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check file3.txt group is nobody
    group=$(stat -c %G /tmp/file3.txt 2>/dev/null)
    if [[ "$group" == "nobody" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check project/ and all contents have nobody:nobody
    local all_correct=true
    for file in /tmp/project /tmp/project/app.py /tmp/project/subdir /tmp/project/subdir/module.py; do
        owner=$(stat -c %U "$file" 2>/dev/null)
        group=$(stat -c %G "$file" 2>/dev/null)
        if [[ "$owner" != "nobody" ]] || [[ "$group" != "nobody" ]]; then
            all_correct=false
            break
        fi
    done
    if [[ "$all_correct" == "true" ]]; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/file1.txt /tmp/file2.txt /tmp/file3.txt /tmp/project 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
