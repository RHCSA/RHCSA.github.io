#!/bin/bash
# Objective 2: Manage software
# LAB: View Repository Information

IS_LAB=true
LAB_ID="dnf_repolist"

QUESTION="[LAB] List and analyze configured repositories"
HINT="Task 1: dnf repolist all > /tmp/repolist.txt\nTask 2: dnf repolist -v > /tmp/repo-verbose.txt"

LAB_TITLE="View Repository Information"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all repos (enabled/disabled) save to /tmp/repolist.txt" ;;
        1) echo "List repos with verbose info and save to /tmp/repo-verbose.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/repolist.txt /tmp/repo-verbose.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if repolist.txt exists and contains repo info
    if [[ -f /tmp/repolist.txt ]] && grep -qi 'repo\|enabled\|disabled' /tmp/repolist.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if repo-verbose.txt exists and contains verbose info
    if [[ -f /tmp/repo-verbose.txt ]] && grep -qi 'repo\|baseurl\|name' /tmp/repo-verbose.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/repolist.txt /tmp/repo-verbose.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
