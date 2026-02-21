#!/bin/bash
# Objective 8: Manage basic networking
# LAB: View Connection Details

IS_LAB=true
LAB_ID="nmcli_show_details"

QUESTION="[LAB] View detailed settings for a network connection"
HINT="Task 1: nmcli con show [CONNECTION] > /tmp/con-details.txt\nTask 2: nmcli con show [CONNECTION] | grep ipv4 > /tmp/con-ipv4.txt"

LAB_TITLE="View Connection Details"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save connection details to /tmp/con-details.txt" ;;
        1) echo "Save IPv4 settings to /tmp/con-ipv4.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/con-details.txt /tmp/con-ipv4.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if con-details.txt exists with connection details
    if [[ -f /tmp/con-details.txt ]] && grep -qiE 'connection\.|ipv4\.|ipv6\.' /tmp/con-details.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if con-ipv4.txt exists with ipv4 settings
    if [[ -f /tmp/con-ipv4.txt ]] && grep -qi 'ipv4' /tmp/con-ipv4.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/con-details.txt /tmp/con-ipv4.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
