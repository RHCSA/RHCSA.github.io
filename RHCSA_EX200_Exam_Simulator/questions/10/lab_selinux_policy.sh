#!/bin/bash
# Objective 10: Manage security
# LAB: SELinux Policy Types

IS_LAB=true
LAB_ID="selinux_policy"

QUESTION="[LAB] View SELinux policy information"
HINT="Task 1: sestatus | grep 'Policy version' > /tmp/policy-version.txt\nTask 2: seinfo 2>/dev/null || rpm -qa | grep selinux > /tmp/selinux-pkgs.txt"

LAB_TITLE="SELinux Policy Info"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save policy version to /tmp/policy-version.txt" ;;
        1) echo "List SELinux packages to /tmp/selinux-pkgs.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/policy-version.txt /tmp/selinux-pkgs.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if policy-version.txt exists
    if [[ -f /tmp/policy-version.txt ]] && [[ -s /tmp/policy-version.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if selinux-pkgs.txt exists
    if [[ -f /tmp/selinux-pkgs.txt ]] && [[ -s /tmp/selinux-pkgs.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/policy-version.txt /tmp/selinux-pkgs.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
