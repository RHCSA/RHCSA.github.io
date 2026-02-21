#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Add Firewall Service

IS_LAB=true
LAB_ID="firewall_add_service"

QUESTION="[LAB] Allow HTTP and HTTPS through the firewall"
HINT="Task 1: firewall-cmd --permanent --add-service=http; firewall-cmd --reload\nTask 2: firewall-cmd --permanent --add-service=https; firewall-cmd --reload"

LAB_TITLE="Add Firewall Service"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Allow HTTP service permanently" ;;
        1) echo "Allow HTTPS service permanently" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring firewall is running...${RESET}"
    systemctl start firewalld 2>/dev/null
    # Remove http and https if already present
    firewall-cmd --permanent --remove-service=http 2>/dev/null
    firewall-cmd --permanent --remove-service=https 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if http service is allowed
    if firewall-cmd --list-services 2>/dev/null | grep -q 'http'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if https service is allowed
    if firewall-cmd --list-services 2>/dev/null | grep -q 'https'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Removing firewall services...${RESET}"
    firewall-cmd --permanent --remove-service=http 2>/dev/null
    firewall-cmd --permanent --remove-service=https 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
