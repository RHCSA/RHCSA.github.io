#!/bin/bash
# Objective 2: Manage software
# LAB: Search Flatpak Applications

IS_LAB=true
LAB_ID="flatpak_search"

QUESTION="[LAB] Search for Flatpak applications and list remotes"
HINT="Task 1: flatpak search firefox > /tmp/flatpak-search.txt\nTask 2: flatpak remotes --show-details > /tmp/remotes-details.txt"

LAB_TITLE="Search Flatpak Applications"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Search for 'firefox' in Flatpak and save to /tmp/flatpak-search.txt" ;;
        1) echo "Show remote details and save to /tmp/remotes-details.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring flatpak and flathub are configured...${RESET}"
    if ! rpm -q flatpak &>/dev/null; then
        sudo dnf install flatpak -y &>/dev/null
    fi
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &>/dev/null
    rm -f /tmp/flatpak-search.txt /tmp/remotes-details.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if flatpak-search.txt exists and contains firefox
    if [[ -f /tmp/flatpak-search.txt ]] && grep -qi 'firefox\|mozilla' /tmp/flatpak-search.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if remotes-details.txt exists and contains remote info
    if [[ -f /tmp/remotes-details.txt ]] && grep -qi 'flathub\|url\|remote' /tmp/remotes-details.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/flatpak-search.txt /tmp/remotes-details.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
