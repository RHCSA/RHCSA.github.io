#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Configure Chrony NTP

IS_LAB=true
LAB_ID="chrony_config"

QUESTION="[LAB] View and understand chrony NTP configuration"
HINT="Task 1: cat /etc/chrony.conf > /tmp/chrony-config.txt\nTask 2: chronyc sources > /tmp/chrony-sources.txt"

LAB_TITLE="Configure Chrony NTP"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Copy chrony config to /tmp/chrony-config.txt" ;;
        1) echo "Save chrony sources to /tmp/chrony-sources.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/chrony-config.txt /tmp/chrony-sources.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if chrony-config.txt exists with config
    if [[ -f /tmp/chrony-config.txt ]] && grep -qiE 'server|pool|ntp' /tmp/chrony-config.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if chrony-sources.txt exists
    if [[ -f /tmp/chrony-sources.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/chrony-config.txt /tmp/chrony-sources.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
