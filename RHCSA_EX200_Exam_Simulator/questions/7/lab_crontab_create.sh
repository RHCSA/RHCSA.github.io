#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Create User Crontab

IS_LAB=true
LAB_ID="create_crontab"

QUESTION="[LAB] Create a user crontab entry to run every minute"
HINT="Task 1: crontab -e, add '* * * * * date >> /tmp/cron-test.log'\nTask 2: crontab -l > /tmp/crontab-list.txt"

LAB_TITLE="Create User Crontab"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add crontab entry that runs date every minute" ;;
        1) echo "List crontab entries to /tmp/crontab-list.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Backing up existing crontab...${RESET}"
    crontab -l > /tmp/.crontab_backup 2>/dev/null || true
    rm -f /tmp/cron-test.log /tmp/crontab-list.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if crontab has an entry with date command
    if crontab -l 2>/dev/null | grep -qE '\* \* \* \* \*.*date'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if crontab-list.txt exists
    if [[ -f /tmp/crontab-list.txt ]] && [[ -s /tmp/crontab-list.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Restoring original crontab...${RESET}"
    if [[ -f /tmp/.crontab_backup ]] && [[ -s /tmp/.crontab_backup ]]; then
        crontab /tmp/.crontab_backup 2>/dev/null
    else
        crontab -r 2>/dev/null
    fi
    rm -f /tmp/.crontab_backup /tmp/cron-test.log /tmp/crontab-list.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
