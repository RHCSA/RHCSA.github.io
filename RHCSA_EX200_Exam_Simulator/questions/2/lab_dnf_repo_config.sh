#!/bin/bash
# Objective 2: Manage software
# LAB: Configure DNF Repository

IS_LAB=true
LAB_ID="dnf_repo_config"

QUESTION="[LAB] Create a custom DNF repository configuration file"
HINT="Task 1: Create /etc/yum.repos.d/custom.repo with [custom-repo] section\nTask 2: Set baseurl=http://content.example.com/rhel9/x86_64/ and enabled=1"

LAB_TITLE="Configure DNF Repository"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create repository file /etc/yum.repos.d/custom.repo with [custom-repo]" ;;
        1) echo "Configure baseurl and enable the repository (enabled=1, gpgcheck=0)" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring clean repo directory...${RESET}"
    sudo rm -f /etc/yum.repos.d/custom.repo 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if repo file exists with correct section name
    if [[ -f /etc/yum.repos.d/custom.repo ]] && grep -q '^\[custom-repo\]' /etc/yum.repos.d/custom.repo 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check baseurl and enabled settings
    if grep -qi 'baseurl=http://content.example.com/rhel9/x86_64' /etc/yum.repos.d/custom.repo 2>/dev/null && \
       grep -qi 'enabled=1' /etc/yum.repos.d/custom.repo 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    sudo rm -f /etc/yum.repos.d/custom.repo 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
