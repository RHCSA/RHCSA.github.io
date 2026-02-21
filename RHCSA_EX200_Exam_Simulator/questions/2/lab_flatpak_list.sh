#!/bin/bash
# Objective 2: Manage software
# LAB: List Flatpak Applications and Runtimes

IS_LAB=true
LAB_ID="flatpak_list"

QUESTION="[LAB] List Flatpak applications and runtimes separately"
HINT="Task 1: flatpak list --app > /tmp/flatpak-apps.txt\nTask 2: flatpak list --runtime > /tmp/flatpak-runtimes.txt"

LAB_TITLE="List Flatpak Apps and Runtimes"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List installed Flatpak apps and save to /tmp/flatpak-apps.txt" ;;
        1) echo "List installed Flatpak runtimes and save to /tmp/flatpak-runtimes.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring flatpak is installed...${RESET}"
    if ! rpm -q flatpak &>/dev/null; then
        sudo dnf install flatpak -y &>/dev/null
    fi
    rm -f /tmp/flatpak-apps.txt /tmp/flatpak-runtimes.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if flatpak-apps.txt was created
    if [[ -f /tmp/flatpak-apps.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if flatpak-runtimes.txt was created
    if [[ -f /tmp/flatpak-runtimes.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/flatpak-apps.txt /tmp/flatpak-runtimes.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
