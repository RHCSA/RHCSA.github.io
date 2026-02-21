#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Memory Info Script

IS_LAB=true
LAB_ID="script_memory_info"

QUESTION="[LAB] Create a script that captures and displays available memory"
HINT="Task 1: Create /tmp/meminfo.sh using FREE=\$(free -m | awk 'NR==2{print \$4}')\nTask 2: Script saves 'Available: NMB' to /tmp/meminfo.txt"

LAB_TITLE="Memory Info Script"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/meminfo.sh using free command with substitution" ;;
        1) echo "Script saves available memory to /tmp/meminfo.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/meminfo.sh /tmp/meminfo.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses free command
    if [[ -f /tmp/meminfo.sh ]] && [[ -x /tmp/meminfo.sh ]] && \
       grep -q 'free' /tmp/meminfo.sh 2>/dev/null && grep -qE '\$\(' /tmp/meminfo.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run script and check output file
    /tmp/meminfo.sh 2>/dev/null
    if [[ -f /tmp/meminfo.txt ]] && grep -qE '[0-9]+' /tmp/meminfo.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/meminfo.sh /tmp/meminfo.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
