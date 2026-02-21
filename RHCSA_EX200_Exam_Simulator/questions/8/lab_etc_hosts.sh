#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Configure /etc/hosts

IS_LAB=true
LAB_ID="etc_hosts"

QUESTION="[LAB] Add static host entries to /etc/hosts"
HINT="Task 1: echo '192.168.1.10 web.example.com web' >> /etc/hosts\nTask 2: echo '192.168.1.20 db.example.com db' >> /etc/hosts"

LAB_TITLE="Configure /etc/hosts"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add entry: 192.168.1.10 web.example.com web" ;;
        1) echo "Add entry: 192.168.1.20 db.example.com db" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Backing up /etc/hosts...${RESET}"
    cp /etc/hosts /tmp/.lab_hosts_backup 2>/dev/null
    # Remove any existing lab entries
    sed -i '/web\.example\.com/d' /etc/hosts 2>/dev/null
    sed -i '/db\.example\.com/d' /etc/hosts 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if web.example.com entry exists
    if grep -qE '^192\.168\.1\.10\s+web\.example\.com' /etc/hosts 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if db.example.com entry exists
    if grep -qE '^192\.168\.1\.20\s+db\.example\.com' /etc/hosts 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Restoring /etc/hosts...${RESET}"
    if [[ -f /tmp/.lab_hosts_backup ]]; then
        cp /tmp/.lab_hosts_backup /etc/hosts 2>/dev/null
    fi
    rm -f /tmp/.lab_hosts_backup 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
