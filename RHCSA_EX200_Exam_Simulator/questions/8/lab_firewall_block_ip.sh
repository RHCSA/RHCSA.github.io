#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Block IP with Rich Rule

IS_LAB=true
LAB_ID="firewall_block_ip"

QUESTION="[LAB] Block traffic from a specific IP using rich rules"
HINT="Task 1: firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=10.0.0.50 reject'\nTask 2: firewall-cmd --reload; verify with --list-rich-rules"

LAB_TITLE="Block IP with Rich Rule"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add rich rule to reject traffic from 10.0.0.50" ;;
        1) echo "Reload and verify rich rule is active" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring firewall is running...${RESET}"
    systemctl start firewalld 2>/dev/null
    firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="10.0.0.50" reject' 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if reject rule exists
    if firewall-cmd --list-rich-rules 2>/dev/null | grep -qE '10\.0\.0\.50.*reject'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Verify rule is in permanent config
    if firewall-cmd --permanent --list-rich-rules 2>/dev/null | grep -qE '10\.0\.0\.50.*reject'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Removing rich rule...${RESET}"
    firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="10.0.0.50" reject' 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
