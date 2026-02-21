#!/bin/bash
# Objective 2: Manage software
# LAB: Remove Package with DNF

IS_LAB=true
LAB_ID="dnf_remove_package"

QUESTION="[LAB] Remove a software package using dnf"
HINT="Task 1: dnf remove cowsay -y\nTask 2: Verify with rpm -q cowsay (should show not installed)"

LAB_TITLE="Remove Package with DNF"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Remove the 'cowsay' package using dnf" ;;
        1) echo "Verify cowsay is no longer installed" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Installing cowsay package for removal...${RESET}"
    sudo dnf install cowsay -y &>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0 & 1: Check if cowsay package is removed
    if ! rpm -q cowsay &>/dev/null; then
        TASK_STATUS[0]="true"
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    sudo dnf remove cowsay -y &>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
