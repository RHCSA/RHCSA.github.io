#!/bin/bash
# Objective 4: Operate running systems
# LAB: Tuned Profile Management

IS_LAB=true
LAB_ID="tuned_profile"

QUESTION="[LAB] View tuned profiles and check active profile"
HINT="Task 1: tuned-adm list > /tmp/tuned-profiles.txt\nTask 2: tuned-adm active > /tmp/active-profile.txt"

LAB_TITLE="Tuned Profile Management"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List all available tuned profiles to /tmp/tuned-profiles.txt" ;;
        1) echo "Save active profile to /tmp/active-profile.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring tuned service is available...${RESET}"
    rm -f /tmp/tuned-profiles.txt /tmp/active-profile.txt 2>/dev/null
    systemctl start tuned 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if tuned-profiles.txt exists with profile list
    if [[ -f /tmp/tuned-profiles.txt ]] && grep -qiE 'profile|balanced|throughput' /tmp/tuned-profiles.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if active-profile.txt exists with active profile
    if [[ -f /tmp/active-profile.txt ]] && grep -qiE 'active|current|profile' /tmp/active-profile.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/tuned-profiles.txt /tmp/active-profile.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
