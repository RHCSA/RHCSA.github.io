#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Set Default Systemd Target

# This is a LAB exercise
IS_LAB=true
LAB_ID="systemd_default_target"

QUESTION="[LAB] Set the default systemd boot target"
HINT="Task 1: systemctl set-default multi-user.target (text mode = runlevel 3)"

# Lab configuration
LAB_TITLE="Set Default Systemd Target"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set the default boot target to multi-user.target (text mode)" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Saving current default target...${RESET}"
    systemctl get-default > /tmp/.lab_original_target 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Setting initial target to graphical...${RESET}"
    systemctl set-default graphical.target 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if default target is multi-user.target
    local current_target=$(systemctl get-default 2>/dev/null)
    if [[ "$current_target" == "multi-user.target" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    # Restore original target
    if [[ -f /tmp/.lab_original_target ]]; then
        local original=$(cat /tmp/.lab_original_target)
        systemctl set-default "$original" 2>/dev/null
        rm -f /tmp/.lab_original_target
    fi
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
