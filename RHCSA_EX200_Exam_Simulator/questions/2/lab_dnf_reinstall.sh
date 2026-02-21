#!/bin/bash
# Objective 2: Manage software
# LAB: Reinstall Package with DNF

IS_LAB=true
LAB_ID="dnf_reinstall"

QUESTION="[LAB] Reinstall a package to restore corrupted files"
HINT="Task 1: sudo rm /usr/bin/tree (simulate corruption)\nTask 2: sudo dnf reinstall tree -y"

LAB_TITLE="Reinstall Package with DNF"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Simulate file corruption by deleting /usr/bin/tree" ;;
        1) echo "Reinstall tree package to restore the deleted file" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Installing tree package...${RESET}"
    sudo dnf install tree -y &>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0 & 1: Both complete when tree binary exists again
    # (User deleted it as Task 0, then reinstalled as Task 1)
    if [[ -x /usr/bin/tree ]] && rpm -V tree &>/dev/null; then
        TASK_STATUS[0]="true"
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    sudo dnf remove tree -y &>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
