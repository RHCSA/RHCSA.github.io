#!/bin/bash
# Objective 4: Operate running systems
# LAB: Tuned Recommended Profile

IS_LAB=true
LAB_ID="tuned_recommend"

QUESTION="[LAB] Get tuned recommendation and save profile info"
HINT="Task 1: tuned-adm recommend > /tmp/recommended.txt\nTask 2: tuned-adm profile \$(tuned-adm recommend) to apply"

LAB_TITLE="Tuned Recommendation"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save tuned recommended profile to /tmp/recommended.txt" ;;
        1) echo "Apply the recommended profile (check with tuned-adm active)" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring tuned service is available...${RESET}"
    rm -f /tmp/recommended.txt 2>/dev/null
    systemctl start tuned 2>/dev/null
    # Store original profile
    tuned-adm active | awk '{print $NF}' > /tmp/.original_profile 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if recommended.txt exists
    if [[ -f /tmp/recommended.txt ]] && [[ -s /tmp/recommended.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if current profile matches recommended
    local recommended=$(cat /tmp/recommended.txt 2>/dev/null | tr -d '[:space:]')
    local active=$(tuned-adm active 2>/dev/null | awk '{print $NF}')
    if [[ -n "$recommended" ]] && [[ "$active" == *"$recommended"* ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    # Restore original profile if stored
    if [[ -f /tmp/.original_profile ]]; then
        local orig=$(cat /tmp/.original_profile)
        tuned-adm profile "$orig" 2>/dev/null
    fi
    rm -f /tmp/recommended.txt /tmp/.original_profile 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
