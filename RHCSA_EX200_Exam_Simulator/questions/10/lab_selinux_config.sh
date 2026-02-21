#!/bin/bash
# Objective 10: Manage security
# LAB: View SELinux Config File

IS_LAB=true
LAB_ID="selinux_config"

QUESTION="[LAB] View SELinux configuration file"
HINT="Task 1: cat /etc/selinux/config > /tmp/selinux-config.txt\nTask 2: grep ^SELINUX= /etc/selinux/config > /tmp/selinux-setting.txt"

LAB_TITLE="View SELinux Config"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Copy SELinux config to /tmp/selinux-config.txt" ;;
        1) echo "Extract SELINUX= line to /tmp/selinux-setting.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/selinux-config.txt /tmp/selinux-setting.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if selinux-config.txt exists with config
    if [[ -f /tmp/selinux-config.txt ]] && grep -qE 'SELINUX=|SELINUXTYPE=' /tmp/selinux-config.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if selinux-setting.txt exists with SELINUX line
    if [[ -f /tmp/selinux-setting.txt ]] && grep -qE '^SELINUX=' /tmp/selinux-setting.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/selinux-config.txt /tmp/selinux-setting.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
