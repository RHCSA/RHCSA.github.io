#!/bin/bash
# Objective 2: Manage software
# LAB: Clean and Rebuild DNF Cache

IS_LAB=true
LAB_ID="dnf_clean_cache"

QUESTION="[LAB] Clean DNF cache and rebuild metadata"
HINT="Task 1: sudo dnf clean all\nTask 2: sudo dnf makecache"

LAB_TITLE="Clean and Rebuild DNF Cache"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Clean all DNF cached data" ;;
        1) echo "Rebuild the DNF metadata cache" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating cache marker file...${RESET}"
    touch /tmp/.dnf_cache_clean_marker
    sleep 0.3
}

check_tasks() {
    # For this lab, we check if dnf cache was recently updated
    # Task 0: Check if cache directory was cleaned (we verify by checking makecache was run after)
    local cache_time
    if [[ -d /var/cache/dnf ]]; then
        cache_time=$(find /var/cache/dnf -name 'repomd.xml' -mmin -5 2>/dev/null | head -1)
        if [[ -n "$cache_time" ]] && [[ -f /tmp/.dnf_cache_clean_marker ]]; then
            TASK_STATUS[0]="true"
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[0]="false"
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/.dnf_cache_clean_marker 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
