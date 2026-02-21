#!/bin/bash
# Objective 2: Manage software
# LAB: Configure Local Repository

IS_LAB=true
LAB_ID="local_repo"

QUESTION="[LAB] Configure a local file-based repository from mounted ISO"
HINT="Task 1: Create /etc/yum.repos.d/local.repo with [local-baseos] section\nTask 2: Set baseurl=file:///mnt/iso/BaseOS and enabled=1, gpgcheck=0"

LAB_TITLE="Configure Local Repository"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /etc/yum.repos.d/local.repo with [local-baseos] section" ;;
        1) echo "Set baseurl to file:///mnt/iso/BaseOS with enabled=1" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating mount point directory...${RESET}"
    sudo mkdir -p /mnt/iso/BaseOS 2>/dev/null
    sudo rm -f /etc/yum.repos.d/local.repo 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if local.repo exists with local-baseos section
    if [[ -f /etc/yum.repos.d/local.repo ]] && grep -q '^\[local-baseos\]' /etc/yum.repos.d/local.repo 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check baseurl and enabled settings
    if grep -qi 'baseurl=file:///mnt/iso/BaseOS' /etc/yum.repos.d/local.repo 2>/dev/null && \
       grep -qi 'enabled=1' /etc/yum.repos.d/local.repo 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    sudo rm -f /etc/yum.repos.d/local.repo 2>/dev/null
    sudo rmdir /mnt/iso/BaseOS /mnt/iso 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
