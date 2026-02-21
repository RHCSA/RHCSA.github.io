#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Add Firewall Port Range

IS_LAB=true
LAB_ID="firewall_port_range"

QUESTION="[LAB] Allow TCP port range 5000-5010 through the firewall"
HINT="Task 1: firewall-cmd --permanent --add-port=5000-5010/tcp\nTask 2: firewall-cmd --reload; verify with --list-ports"

LAB_TITLE="Add Port Range"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Allow TCP ports 5000-5010 permanently" ;;
        1) echo "Verify port range is in --list-ports output" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring firewall is running...${RESET}"
    systemctl start firewalld 2>/dev/null
    firewall-cmd --permanent --remove-port=5000-5010/tcp 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if port range is allowed
    if firewall-cmd --list-ports 2>/dev/null | grep -q '5000-5010/tcp'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check ports after reload (same check ensures reload happened)
    if firewall-cmd --query-port=5000-5010/tcp 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Removing firewall port range...${RESET}"
    firewall-cmd --permanent --remove-port=5000-5010/tcp 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
