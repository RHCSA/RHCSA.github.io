#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Change Default Boot Target

IS_LAB=true
LAB_ID="set_default_target"

QUESTION="[LAB] Change the default boot target"
HINT="Task 1: systemctl get-default > /tmp/original-target.txt\nTask 2: systemctl set-default multi-user.target (then verify)"

LAB_TITLE="Change Default Target"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save original default target to /tmp/original-target.txt" ;;
        1) echo "Set default target to multi-user.target" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Saving current default target...${RESET}"
    systemctl get-default > /tmp/.lab_original_target 2>/dev/null
    rm -f /tmp/original-target.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if original-target.txt exists
    if [[ -f /tmp/original-target.txt ]] && grep -q '\.target' /tmp/original-target.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if default target is multi-user.target
    local current_target=$(systemctl get-default 2>/dev/null)
    if [[ "$current_target" == "multi-user.target" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Restoring original default target...${RESET}"
    if [[ -f /tmp/.lab_original_target ]]; then
        local orig_target=$(cat /tmp/.lab_original_target)
        systemctl set-default "$orig_target" 2>/dev/null
    fi
    rm -f /tmp/original-target.txt /tmp/.lab_original_target 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
