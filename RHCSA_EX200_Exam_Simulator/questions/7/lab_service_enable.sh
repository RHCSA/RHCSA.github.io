#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Enable Service at Boot

IS_LAB=true
LAB_ID="service_enable"

QUESTION="[LAB] Enable and disable services to start at boot"
HINT="Task 1: systemctl enable chronyd; systemctl is-enabled chronyd > /tmp/chronyd-enabled.txt\nTask 2: systemctl list-unit-files --type=service | head -30 > /tmp/service-list.txt"

LAB_TITLE="Enable Service at Boot"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Check if chronyd is enabled, save to /tmp/chronyd-enabled.txt" ;;
        1) echo "List service unit files to /tmp/service-list.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/chronyd-enabled.txt /tmp/service-list.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if chronyd-enabled.txt exists with status
    if [[ -f /tmp/chronyd-enabled.txt ]] && grep -qE 'enabled|disabled|static' /tmp/chronyd-enabled.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if service-list.txt exists with service info
    if [[ -f /tmp/service-list.txt ]] && grep -q '\.service' /tmp/service-list.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/chronyd-enabled.txt /tmp/service-list.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
