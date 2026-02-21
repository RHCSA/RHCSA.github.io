#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Check Failed Services

IS_LAB=true
LAB_ID="service_failed"

QUESTION="[LAB] Check for failed services and view logs"
HINT="Task 1: systemctl --failed > /tmp/failed-services.txt\nTask 2: systemctl list-units --type=service --state=running > /tmp/running-services.txt"

LAB_TITLE="Check Failed Services"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List failed services to /tmp/failed-services.txt" ;;
        1) echo "List running services to /tmp/running-services.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/failed-services.txt /tmp/running-services.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if failed-services.txt exists
    if [[ -f /tmp/failed-services.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if running-services.txt exists with services
    if [[ -f /tmp/running-services.txt ]] && grep -q 'running' /tmp/running-services.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/failed-services.txt /tmp/running-services.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
