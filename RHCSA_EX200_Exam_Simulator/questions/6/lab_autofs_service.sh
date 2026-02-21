#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Check Autofs Service

IS_LAB=true
LAB_ID="autofs_service"

QUESTION="[LAB] Enable and verify autofs service status"
HINT="Task 1: systemctl enable autofs\nTask 2: systemctl start autofs && systemctl status autofs > /tmp/autofs-status.txt"

LAB_TITLE="Check Autofs Service"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Enable autofs service to start at boot" ;;
        1) echo "Start autofs and save status to /tmp/autofs-status.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/autofs-status.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if autofs is enabled
    if systemctl is-enabled autofs &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if status file exists with autofs info
    if [[ -f /tmp/autofs-status.txt ]] && grep -qi 'autofs' /tmp/autofs-status.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/autofs-status.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
