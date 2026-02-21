#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Add Firewall Port

IS_LAB=true
LAB_ID="firewall_add_port"

QUESTION="[LAB] Allow TCP port 8080 through the firewall"
HINT="Task 1: firewall-cmd --permanent --add-port=8080/tcp\nTask 2: firewall-cmd --reload; firewall-cmd --list-ports > /tmp/fw-ports.txt"

LAB_TITLE="Add Firewall Port"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Allow TCP port 8080 permanently" ;;
        1) echo "List allowed ports to /tmp/fw-ports.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring firewall is running...${RESET}"
    systemctl start firewalld 2>/dev/null
    firewall-cmd --permanent --remove-port=8080/tcp 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    rm -f /tmp/fw-ports.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if port 8080/tcp is allowed
    if firewall-cmd --list-ports 2>/dev/null | grep -q '8080/tcp'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if fw-ports.txt exists
    if [[ -f /tmp/fw-ports.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Removing firewall port...${RESET}"
    firewall-cmd --permanent --remove-port=8080/tcp 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    rm -f /tmp/fw-ports.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
