#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Set System Hostname

IS_LAB=true
LAB_ID="set_hostname"

QUESTION="[LAB] View and set the system hostname"
HINT="Task 1: hostnamectl > /tmp/hostname-info.txt\nTask 2: hostnamectl set-hostname labserver.example.com"

LAB_TITLE="Set System Hostname"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save hostnamectl output to /tmp/hostname-info.txt" ;;
        1) echo "Set hostname to labserver.example.com" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Saving original hostname...${RESET}"
    hostnamectl hostname > /tmp/.lab_original_hostname 2>/dev/null
    rm -f /tmp/hostname-info.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if hostname-info.txt exists with hostname info
    if [[ -f /tmp/hostname-info.txt ]] && grep -qiE 'hostname|operating' /tmp/hostname-info.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if hostname is set to labserver.example.com
    local current_hostname=$(hostnamectl hostname 2>/dev/null)
    if [[ "$current_hostname" == "labserver.example.com" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Restoring original hostname...${RESET}"
    if [[ -f /tmp/.lab_original_hostname ]]; then
        local orig_hostname=$(cat /tmp/.lab_original_hostname)
        hostnamectl set-hostname "$orig_hostname" 2>/dev/null
    fi
    rm -f /tmp/hostname-info.txt /tmp/.lab_original_hostname 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
