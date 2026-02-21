#!/bin/bash
# Objective 8: Manage basic networking
# LAB: View Routing Table

IS_LAB=true
LAB_ID="ip_route"

QUESTION="[LAB] View the system routing table"
HINT="Task 1: ip route > /tmp/ip-route.txt\nTask 2: ip route show default > /tmp/default-route.txt"

LAB_TITLE="View Routing Table"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save routing table to /tmp/ip-route.txt" ;;
        1) echo "Save default route to /tmp/default-route.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/ip-route.txt /tmp/default-route.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if ip-route.txt exists with route info
    if [[ -f /tmp/ip-route.txt ]] && grep -qE 'via|dev|scope' /tmp/ip-route.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if default-route.txt exists
    if [[ -f /tmp/default-route.txt ]] && [[ -s /tmp/default-route.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/ip-route.txt /tmp/default-route.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
