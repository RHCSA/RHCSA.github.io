#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: List DNF Repositories

IS_LAB=true
LAB_ID="dnf_repolist"

QUESTION="[LAB] List configured DNF repositories"
HINT="Task 1: dnf repolist > /tmp/repolist.txt\nTask 2: dnf repolist all > /tmp/repolist-all.txt"

LAB_TITLE="List DNF Repositories"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List enabled repos to /tmp/repolist.txt" ;;
        1) echo "List all repos to /tmp/repolist-all.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/repolist.txt /tmp/repolist-all.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if repolist.txt exists with repo info
    if [[ -f /tmp/repolist.txt ]] && grep -qiE 'repo|id|name' /tmp/repolist.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if repolist-all.txt exists
    if [[ -f /tmp/repolist-all.txt ]] && [[ -s /tmp/repolist-all.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/repolist.txt /tmp/repolist-all.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
