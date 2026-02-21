#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Check Connection Autoconnect

IS_LAB=true
LAB_ID="check_autoconnect"

QUESTION="[LAB] Check and document network connection autoconnect settings"
HINT="Task 1: nmcli -f NAME,AUTOCONNECT connection show > /tmp/autoconnect.txt\nTask 2: nmcli con show [CONNECTION] | grep autoconnect > /tmp/con-auto.txt"

LAB_TITLE="Check Autoconnect"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all connections with autoconnect to /tmp/autoconnect.txt" ;;
        1) echo "Save autoconnect settings to /tmp/con-auto.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/autoconnect.txt /tmp/con-auto.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if autoconnect.txt exists with connection list
    if [[ -f /tmp/autoconnect.txt ]] && grep -qiE 'name|autoconnect' /tmp/autoconnect.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if con-auto.txt exists with autoconnect info
    if [[ -f /tmp/con-auto.txt ]] && grep -qi 'autoconnect' /tmp/con-auto.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/autoconnect.txt /tmp/con-auto.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
