#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Add Firewall Rich Rule

IS_LAB=true
LAB_ID="firewall_rich_rule"

QUESTION="[LAB] Add a rich rule to allow traffic from specific IP"
HINT="Task 1: firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=192.168.1.100 accept'\nTask 2: firewall-cmd --reload; firewall-cmd --list-rich-rules > /tmp/rich-rules.txt"

LAB_TITLE="Add Rich Rule"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add rich rule to accept traffic from 192.168.1.100" ;;
        1) echo "List rich rules to /tmp/rich-rules.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring firewall is running...${RESET}"
    systemctl start firewalld 2>/dev/null
    firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="192.168.1.100" accept' 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    rm -f /tmp/rich-rules.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if rich rule exists
    if firewall-cmd --list-rich-rules 2>/dev/null | grep -q '192.168.1.100'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if rich-rules.txt exists
    if [[ -f /tmp/rich-rules.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Removing rich rule...${RESET}"
    firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="192.168.1.100" accept' 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    rm -f /tmp/rich-rules.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
