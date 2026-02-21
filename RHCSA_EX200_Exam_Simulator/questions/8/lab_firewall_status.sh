#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Check Firewall Status

IS_LAB=true
LAB_ID="firewall_status"

QUESTION="[LAB] Check firewalld status and view current configuration"
HINT="Task 1: firewall-cmd --state > /tmp/fw-state.txt\nTask 2: firewall-cmd --list-all > /tmp/fw-config.txt"

LAB_TITLE="Check Firewall Status"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save firewall state to /tmp/fw-state.txt" ;;
        1) echo "Save firewall configuration to /tmp/fw-config.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/fw-state.txt /tmp/fw-config.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if fw-state.txt exists with state
    if [[ -f /tmp/fw-state.txt ]] && grep -qE 'running|not running' /tmp/fw-state.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if fw-config.txt exists with firewall config
    if [[ -f /tmp/fw-config.txt ]] && grep -qiE 'services|ports|zone' /tmp/fw-config.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/fw-state.txt /tmp/fw-config.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
