#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Change Default Firewall Zone

IS_LAB=true
LAB_ID="firewall_set_zone"

QUESTION="[LAB] Change the default firewall zone"
HINT="Task 1: firewall-cmd --get-default-zone > /tmp/orig-zone.txt\nTask 2: firewall-cmd --set-default-zone=internal"

LAB_TITLE="Change Default Zone"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save original default zone to /tmp/orig-zone.txt" ;;
        1) echo "Set default zone to internal" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Saving current default zone...${RESET}"
    firewall-cmd --get-default-zone > /tmp/.lab_orig_zone 2>/dev/null
    rm -f /tmp/orig-zone.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if orig-zone.txt exists
    if [[ -f /tmp/orig-zone.txt ]] && [[ -s /tmp/orig-zone.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if default zone is internal
    local current_zone=$(firewall-cmd --get-default-zone 2>/dev/null)
    if [[ "$current_zone" == "internal" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Restoring original default zone...${RESET}"
    if [[ -f /tmp/.lab_orig_zone ]]; then
        local orig_zone=$(cat /tmp/.lab_orig_zone)
        firewall-cmd --set-default-zone="$orig_zone" 2>/dev/null
    fi
    rm -f /tmp/orig-zone.txt /tmp/.lab_orig_zone 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
