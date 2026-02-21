#!/bin/bash
# Objective 2: Manage software
# LAB: List Installed and Available Packages

IS_LAB=true
LAB_ID="dnf_list_packages"

QUESTION="[LAB] List installed packages and count them"
HINT="Task 1: dnf list installed > /tmp/installed.txt\nTask 2: dnf list installed | wc -l > /tmp/pkg-count.txt"

LAB_TITLE="List Packages with DNF"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all installed packages and save to /tmp/installed.txt" ;;
        1) echo "Count installed packages and save number to /tmp/pkg-count.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/installed.txt /tmp/pkg-count.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if installed.txt exists and contains package list
    if [[ -f /tmp/installed.txt ]] && grep -q '\.' /tmp/installed.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if pkg-count.txt exists and contains a number
    if [[ -f /tmp/pkg-count.txt ]] && grep -qE '^[0-9]+$' /tmp/pkg-count.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/installed.txt /tmp/pkg-count.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
