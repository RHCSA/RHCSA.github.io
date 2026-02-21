#!/bin/bash
# Objective 4: Operate running systems
# LAB: Journal Time Filter

IS_LAB=true
LAB_ID="journal_time_filter"

QUESTION="[LAB] Filter journal logs by time using --since"
HINT="Task 1: journalctl --since today > /tmp/today-logs.txt\nTask 2: journalctl --since '1 hour ago' > /tmp/recent-logs.txt"

LAB_TITLE="Journal Time Filter"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save today's journal logs to /tmp/today-logs.txt" ;;
        1) echo "Save last hour's logs to /tmp/recent-logs.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/today-logs.txt /tmp/recent-logs.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if today-logs.txt exists
    if [[ -f /tmp/today-logs.txt ]] && [[ -s /tmp/today-logs.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if recent-logs.txt exists
    if [[ -f /tmp/recent-logs.txt ]] && [[ -s /tmp/recent-logs.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/today-logs.txt /tmp/recent-logs.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
