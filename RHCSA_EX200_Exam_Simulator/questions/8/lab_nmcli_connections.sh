#!/bin/bash
# Objective 8: Manage basic networking
# LAB: View NetworkManager Connections

IS_LAB=true
LAB_ID="nmcli_connections"

QUESTION="[LAB] List NetworkManager connections and device status"
HINT="Task 1: nmcli connection show > /tmp/nmcli-con.txt\nTask 2: nmcli device status > /tmp/nmcli-dev.txt"

LAB_TITLE="NetworkManager Connections"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all connections to /tmp/nmcli-con.txt" ;;
        1) echo "List device status to /tmp/nmcli-dev.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/nmcli-con.txt /tmp/nmcli-dev.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if nmcli-con.txt exists with connection info
    if [[ -f /tmp/nmcli-con.txt ]] && grep -qiE 'name|uuid|type' /tmp/nmcli-con.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if nmcli-dev.txt exists with device info
    if [[ -f /tmp/nmcli-dev.txt ]] && grep -qiE 'device|type|state' /tmp/nmcli-dev.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/nmcli-con.txt /tmp/nmcli-dev.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
