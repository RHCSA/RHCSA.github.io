#!/bin/bash
# Objective 8: Manage basic networking
# LAB: View Network Interfaces

IS_LAB=true
LAB_ID="ip_link"

QUESTION="[LAB] View network interface link information"
HINT="Task 1: ip link show > /tmp/ip-link.txt\nTask 2: ip -s link > /tmp/ip-link-stats.txt"

LAB_TITLE="View Network Interfaces"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Show interface links to /tmp/ip-link.txt" ;;
        1) echo "Show interface statistics to /tmp/ip-link-stats.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/ip-link.txt /tmp/ip-link-stats.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if ip-link.txt exists with interface info
    if [[ -f /tmp/ip-link.txt ]] && grep -qE 'lo|eth|enp|state' /tmp/ip-link.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if ip-link-stats.txt exists with statistics
    if [[ -f /tmp/ip-link-stats.txt ]] && grep -qiE 'RX|TX|bytes|packets' /tmp/ip-link-stats.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/ip-link.txt /tmp/ip-link-stats.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
