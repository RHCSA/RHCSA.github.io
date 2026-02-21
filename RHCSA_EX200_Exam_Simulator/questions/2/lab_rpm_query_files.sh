#!/bin/bash
# Objective 2: Manage software
# LAB: Query Package Files with RPM

IS_LAB=true
LAB_ID="rpm_query_files"

QUESTION="[LAB] Use rpm to query package files and save output"
HINT="Task 1: rpm -ql bash > /tmp/bash-files.txt\nTask 2: rpm -qc bash > /tmp/bash-config.txt"

LAB_TITLE="Query Package Files with RPM"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all files in bash package and save to /tmp/bash-files.txt" ;;
        1) echo "List config files in bash package and save to /tmp/bash-config.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/bash-files.txt /tmp/bash-config.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if bash-files.txt exists and contains bash files
    if [[ -f /tmp/bash-files.txt ]] && grep -q '/bin/bash' /tmp/bash-files.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if bash-config.txt exists and contains config paths
    if [[ -f /tmp/bash-config.txt ]] && grep -q '/etc' /tmp/bash-config.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/bash-files.txt /tmp/bash-config.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
