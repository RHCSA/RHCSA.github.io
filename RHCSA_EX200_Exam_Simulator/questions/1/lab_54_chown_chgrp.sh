#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Change File Ownership with chown and chgrp

# This is a LAB exercise
IS_LAB=true
LAB_ID="chown_chgrp"

QUESTION="Change file ownership using chown and chgrp"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Change owner of /tmp/file1.txt to 'nobody'"
TASK_1_HINT="Use chown with just the username to change owner"
TASK_1_COMMAND_1="chown nobody /tmp/file1.txt"

# Task 2
TASK_2_QUESTION="Change owner to 'nobody' AND group to 'nobody' on /tmp/file2.txt"
TASK_2_HINT="Use chown with user:group syntax to change both owner and group"
TASK_2_COMMAND_1="chown nobody:nobody /tmp/file2.txt"

# Task 3
TASK_3_QUESTION="Change ONLY the group of /tmp/file3.txt to 'nobody'"
TASK_3_HINT="Use chgrp to change only the group, or chown :group syntax"
TASK_3_COMMAND_1="chgrp nobody /tmp/file3.txt"

# Task 4
TASK_4_QUESTION="Recursively change owner to 'nobody' and group to 'nobody' on /tmp/project/"
TASK_4_HINT="Use chown -R for recursive ownership change on directories"
TASK_4_COMMAND_1="chown -R nobody:nobody /tmp/project/"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

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
