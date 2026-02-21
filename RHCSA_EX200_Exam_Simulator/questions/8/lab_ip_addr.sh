#!/bin/bash
# Objective 8: Manage basic networking
# LAB: View IP Addresses

IS_LAB=true
LAB_ID="view_ip_addr"

QUESTION="[LAB] View and save network interface IP addresses"
HINT="Task 1: ip addr > /tmp/ip-addr.txt (show all interfaces)\nTask 2: ip -4 addr > /tmp/ipv4-addr.txt (show only IPv4)"

LAB_TITLE="View IP Addresses"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save ip addr output to /tmp/ip-addr.txt" ;;
        1) echo "Save IPv4 addresses only to /tmp/ipv4-addr.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/ip-addr.txt /tmp/ipv4-addr.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if ip-addr.txt exists with interface info
    if [[ -f /tmp/ip-addr.txt ]] && grep -qE 'inet|link/' /tmp/ip-addr.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if ipv4-addr.txt exists with IPv4 info
    if [[ -f /tmp/ipv4-addr.txt ]] && grep -qE 'inet ' /tmp/ipv4-addr.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/ip-addr.txt /tmp/ipv4-addr.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
