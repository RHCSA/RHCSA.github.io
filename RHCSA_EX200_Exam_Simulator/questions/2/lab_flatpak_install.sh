#!/bin/bash
# Objective 2: Manage software
# LAB: Install Flatpak Package Manager

IS_LAB=true
LAB_ID="flatpak_install"

QUESTION="[LAB] Install Flatpak and verify installation"
HINT="Task 1: sudo dnf install flatpak -y\nTask 2: flatpak --version (verify installation)"

LAB_TITLE="Install Flatpak"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Install the flatpak package using dnf" ;;
        1) echo "Verify flatpak is installed by running flatpak --version" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Preparing environment...${RESET}"
    rm -f /tmp/flatpak-version.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if flatpak is installed
    if rpm -q flatpak &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if flatpak command works
    if flatpak --version &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Lab complete - flatpak left installed for other labs...${RESET}"
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
