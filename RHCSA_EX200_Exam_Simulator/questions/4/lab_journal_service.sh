#!/bin/bash
# Objective 4: Operate running systems
# LAB: Journal Service Logs

IS_LAB=true
LAB_ID="journal_service_logs"

QUESTION="[LAB] View logs for a specific service using journalctl"
HINT="Task 1: journalctl -u sshd -n 20 > /tmp/sshd-logs.txt\nTask 2: journalctl -u crond > /tmp/cron-logs.txt"

LAB_TITLE="Journal Service Logs"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save sshd service logs to /tmp/sshd-logs.txt" ;;
        1) echo "Save crond service logs to /tmp/cron-logs.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/sshd-logs.txt /tmp/cron-logs.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if sshd-logs.txt exists
    if [[ -f /tmp/sshd-logs.txt ]] && [[ -s /tmp/sshd-logs.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if cron-logs.txt exists
    if [[ -f /tmp/cron-logs.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/sshd-logs.txt /tmp/cron-logs.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
