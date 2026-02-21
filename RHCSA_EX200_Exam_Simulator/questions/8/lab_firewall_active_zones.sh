#!/bin/bash
# Objective 8: Manage basic networking
# LAB: View Active Firewall Zones

IS_LAB=true
LAB_ID="firewall_active_zones"

QUESTION="[LAB] View active firewall zones and their interfaces"
HINT="Task 1: firewall-cmd --get-active-zones > /tmp/active-zones.txt\nTask 2: firewall-cmd --zone=public --list-all > /tmp/public-zone.txt"

LAB_TITLE="View Active Zones"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List active zones to /tmp/active-zones.txt" ;;
        1) echo "Show public zone details to /tmp/public-zone.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/active-zones.txt /tmp/public-zone.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if active-zones.txt exists
    if [[ -f /tmp/active-zones.txt ]] && [[ -s /tmp/active-zones.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if public-zone.txt exists with zone info
    if [[ -f /tmp/public-zone.txt ]] && grep -qiE 'public|services|ports' /tmp/public-zone.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/active-zones.txt /tmp/public-zone.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
