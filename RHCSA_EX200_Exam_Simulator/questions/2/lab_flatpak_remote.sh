#!/bin/bash
# Objective 2: Manage software
# LAB: Add Flatpak Remote Repository

IS_LAB=true
LAB_ID="flatpak_remote"

QUESTION="[LAB] Add and verify Flathub Flatpak remote repository"
HINT="Task 1: sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo\nTask 2: flatpak remotes (verify flathub is listed)"

LAB_TITLE="Add Flatpak Remote"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add the Flathub remote repository (system-wide)" ;;
        1) echo "Verify Flathub remote is listed in flatpak remotes" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring flatpak is installed...${RESET}"
    if ! rpm -q flatpak &>/dev/null; then
        sudo dnf install flatpak -y &>/dev/null
    fi
    sleep 0.3
}

check_tasks() {
    # Task 0 & 1: Check if flathub remote exists
    if flatpak remotes 2>/dev/null | grep -qi 'flathub'; then
        TASK_STATUS[0]="true"
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    sudo flatpak remote-delete flathub --force &>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
