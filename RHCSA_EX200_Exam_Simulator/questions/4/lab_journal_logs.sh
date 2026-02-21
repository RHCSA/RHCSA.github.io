#!/bin/bash
# Objective 4: Operate running systems
# LAB: View Journal Logs

IS_LAB=true
LAB_ID="journal_logs"

QUESTION="[LAB] View and filter journal logs using journalctl"
HINT="Task 1: journalctl -n 50 > /tmp/recent-logs.txt\nTask 2: journalctl -p err > /tmp/error-logs.txt"

LAB_TITLE="View Journal Logs"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save last 50 journal entries to /tmp/recent-logs.txt" ;;
        1) echo "Save error priority logs to /tmp/error-logs.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/recent-logs.txt /tmp/error-logs.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if recent-logs.txt exists with log entries
    if [[ -f /tmp/recent-logs.txt ]] && [[ -s /tmp/recent-logs.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if error-logs.txt exists (can be empty if no errors)
    if [[ -f /tmp/error-logs.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/recent-logs.txt /tmp/error-logs.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
