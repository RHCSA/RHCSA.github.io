#!/bin/bash
# Objective 10: Manage security
# LAB: Set SELinux Mode Temporarily

IS_LAB=true
LAB_ID="selinux_mode_temp"

QUESTION="[LAB] Set SELinux mode temporarily"
HINT="Task 1: setenforce 0 (set to permissive); getenforce\nTask 2: setenforce 1 (set back to enforcing); getenforce > /tmp/selinux-final.txt"

LAB_TITLE="Set SELinux Mode"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set SELinux to permissive mode temporarily" ;;
        1) echo "Set SELinux back to enforcing mode, save to /tmp/selinux-final.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/selinux-final.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if SELinux is currently enforcing (user should have set it back)
    local current_mode=$(getenforce 2>/dev/null)
    # This task is about the exercise, we check final state
    if [[ "$current_mode" == "Enforcing" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if selinux-final.txt exists with Enforcing
    if [[ -f /tmp/selinux-final.txt ]] && grep -qi 'enforcing' /tmp/selinux-final.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Ensuring SELinux is enforcing...${RESET}"
    setenforce 1 2>/dev/null
    rm -f /tmp/selinux-final.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
