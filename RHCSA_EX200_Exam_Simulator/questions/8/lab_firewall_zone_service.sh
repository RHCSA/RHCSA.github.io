#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Add Service to Specific Zone

IS_LAB=true
LAB_ID="firewall_zone_service"

QUESTION="[LAB] Add SSH service to the internal zone"
HINT="Task 1: firewall-cmd --zone=internal --permanent --add-service=ssh\nTask 2: firewall-cmd --reload; firewall-cmd --zone=internal --list-services > /tmp/int-svc.txt"

LAB_TITLE="Add Service to Zone"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add SSH to internal zone permanently" ;;
        1) echo "List internal zone services to /tmp/int-svc.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring firewall is running...${RESET}"
    systemctl start firewalld 2>/dev/null
    firewall-cmd --zone=internal --permanent --remove-service=ssh 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    rm -f /tmp/int-svc.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if ssh is in internal zone
    if firewall-cmd --zone=internal --list-services 2>/dev/null | grep -q 'ssh'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if int-svc.txt exists
    if [[ -f /tmp/int-svc.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Removing SSH from internal zone...${RESET}"
    firewall-cmd --zone=internal --permanent --remove-service=ssh 2>/dev/null
    firewall-cmd --reload 2>/dev/null
    rm -f /tmp/int-svc.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
