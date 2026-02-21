#!/bin/bash
# Objective 2: Manage software
# LAB: View DNF Transaction History

IS_LAB=true
LAB_ID="dnf_history"

QUESTION="[LAB] View and analyze DNF transaction history"
HINT="Task 1: dnf history > /tmp/dnf-history.txt\nTask 2: dnf history info last > /tmp/last-transaction.txt"

LAB_TITLE="DNF Transaction History"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save dnf transaction history to /tmp/dnf-history.txt" ;;
        1) echo "Save details of last transaction to /tmp/last-transaction.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/dnf-history.txt /tmp/last-transaction.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if dnf-history.txt exists and contains history
    if [[ -f /tmp/dnf-history.txt ]] && grep -qi 'id\|command\|action\|date' /tmp/dnf-history.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if last-transaction.txt exists and contains transaction info
    if [[ -f /tmp/last-transaction.txt ]] && grep -qi 'transaction\|command\|packages\|begin' /tmp/last-transaction.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/dnf-history.txt /tmp/last-transaction.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
