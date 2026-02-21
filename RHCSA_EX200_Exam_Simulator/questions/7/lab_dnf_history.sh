#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: DNF History

IS_LAB=true
LAB_ID="dnf_history"

QUESTION="[LAB] View DNF transaction history"
HINT="Task 1: dnf history > /tmp/dnf-history.txt\nTask 2: dnf history info last > /tmp/dnf-history-last.txt"

LAB_TITLE="DNF History"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save dnf history to /tmp/dnf-history.txt" ;;
        1) echo "Save last transaction info to /tmp/dnf-history-last.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/dnf-history.txt /tmp/dnf-history-last.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if dnf-history.txt exists
    if [[ -f /tmp/dnf-history.txt ]] && grep -qE '[0-9]+.*|.*user' /tmp/dnf-history.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if dnf-history-last.txt exists
    if [[ -f /tmp/dnf-history-last.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/dnf-history.txt /tmp/dnf-history-last.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
