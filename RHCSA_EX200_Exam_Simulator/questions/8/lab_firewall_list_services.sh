#!/bin/bash
# Objective 8: Manage basic networking
# LAB: List Firewall Services

IS_LAB=true
LAB_ID="firewall_list_services"

QUESTION="[LAB] List allowed and available firewall services"
HINT="Task 1: firewall-cmd --list-services > /tmp/fw-allowed.txt\nTask 2: firewall-cmd --get-services > /tmp/fw-available.txt"

LAB_TITLE="List Firewall Services"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List allowed services to /tmp/fw-allowed.txt" ;;
        1) echo "List all available services to /tmp/fw-available.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/fw-allowed.txt /tmp/fw-available.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if fw-allowed.txt exists
    if [[ -f /tmp/fw-allowed.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if fw-available.txt exists with services
    if [[ -f /tmp/fw-available.txt ]] && grep -qiE 'ssh|http|https|dns' /tmp/fw-available.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/fw-allowed.txt /tmp/fw-available.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
