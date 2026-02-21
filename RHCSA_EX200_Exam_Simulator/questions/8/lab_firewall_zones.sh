#!/bin/bash
# Objective 8: Manage basic networking
# LAB: View Firewall Zones

IS_LAB=true
LAB_ID="firewall_zones"

QUESTION="[LAB] View firewall zones and default zone"
HINT="Task 1: firewall-cmd --get-zones > /tmp/fw-zones.txt\nTask 2: firewall-cmd --get-default-zone > /tmp/fw-default-zone.txt"

LAB_TITLE="View Firewall Zones"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all zones to /tmp/fw-zones.txt" ;;
        1) echo "Get default zone to /tmp/fw-default-zone.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/fw-zones.txt /tmp/fw-default-zone.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if fw-zones.txt exists with zone list
    if [[ -f /tmp/fw-zones.txt ]] && grep -qiE 'public|trusted|drop|block' /tmp/fw-zones.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if fw-default-zone.txt exists
    if [[ -f /tmp/fw-default-zone.txt ]] && [[ -s /tmp/fw-default-zone.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/fw-zones.txt /tmp/fw-default-zone.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
