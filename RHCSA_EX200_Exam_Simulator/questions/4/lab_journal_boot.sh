#!/bin/bash
# Objective 4: Operate running systems
# LAB: Journal Boot Logs

IS_LAB=true
LAB_ID="journal_boot_logs"

QUESTION="[LAB] View boot logs and list available boots"
HINT="Task 1: journalctl -b > /tmp/boot-logs.txt\nTask 2: journalctl --list-boots > /tmp/boots-list.txt"

LAB_TITLE="Journal Boot Logs"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save current boot logs to /tmp/boot-logs.txt" ;;
        1) echo "Save list of available boots to /tmp/boots-list.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/boot-logs.txt /tmp/boots-list.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if boot-logs.txt exists with content
    if [[ -f /tmp/boot-logs.txt ]] && [[ -s /tmp/boot-logs.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if boots-list.txt exists
    if [[ -f /tmp/boots-list.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/boot-logs.txt /tmp/boots-list.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
