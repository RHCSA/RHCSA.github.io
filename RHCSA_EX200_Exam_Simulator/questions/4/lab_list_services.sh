#!/bin/bash
# Objective 4: Operate running systems
# LAB: List All Services

IS_LAB=true
LAB_ID="list_services"

QUESTION="[LAB] List systemd services and their states"
HINT="Task 1: systemctl list-units --type=service > /tmp/services.txt\nTask 2: systemctl list-unit-files --type=service > /tmp/service-files.txt"

LAB_TITLE="List All Services"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save list of running services to /tmp/services.txt" ;;
        1) echo "Save list of service unit files to /tmp/service-files.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/services.txt /tmp/service-files.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if services.txt exists with service list
    if [[ -f /tmp/services.txt ]] && grep -q '\.service' /tmp/services.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if service-files.txt exists with unit files
    if [[ -f /tmp/service-files.txt ]] && grep -qE 'enabled|disabled|static' /tmp/service-files.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/services.txt /tmp/service-files.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
