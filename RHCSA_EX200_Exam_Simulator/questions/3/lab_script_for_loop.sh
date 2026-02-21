#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: For Loop Script

IS_LAB=true
LAB_ID="script_for_loop"

QUESTION="[LAB] Create a script with a for loop that creates numbered files"
HINT="Task 1: Create /tmp/makefiles.sh using for i in {1..5}; do ... done\nTask 2: Script should create /tmp/file1.txt through /tmp/file5.txt"

LAB_TITLE="For Loop Script"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/makefiles.sh with a for loop" ;;
        1) echo "Running script creates /tmp/file1.txt through /tmp/file5.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/makefiles.sh /tmp/file{1..5}.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script exists and contains for loop
    if [[ -f /tmp/makefiles.sh ]] && [[ -x /tmp/makefiles.sh ]] && grep -q 'for' /tmp/makefiles.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if all 5 files were created
    if [[ -f /tmp/file1.txt ]] && [[ -f /tmp/file2.txt ]] && [[ -f /tmp/file3.txt ]] && \
       [[ -f /tmp/file4.txt ]] && [[ -f /tmp/file5.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/makefiles.sh /tmp/file{1..5}.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
