#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Generate SSH Key Pairs

# This is a LAB exercise
IS_LAB=true
LAB_ID="ssh_keygen"

QUESTION="[LAB] Generate SSH key pairs using ssh-keygen"
HINT="Task 1: ssh-keygen -t ed25519 -f ~/.ssh/exam_key -C 'RHCSA Exam Key'
Task 2: ssh-keygen -t rsa -b 4096 -f ~/.ssh/backup_key"

# Lab configuration
LAB_TITLE="Generate SSH Key Pairs"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Generate an Ed25519 key pair saved as ~/.ssh/exam_key with comment 'RHCSA Exam Key'" ;;
        1) echo "Generate a 4096-bit RSA key pair saved as ~/.ssh/backup_key" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Ensuring .ssh directory exists...${RESET}"
    mkdir -p ~/.ssh 2>/dev/null
    chmod 700 ~/.ssh
    sleep 0.3
    
    echo -e "  ${DIM}• Removing existing lab keys...${RESET}"
    rm -f ~/.ssh/exam_key ~/.ssh/exam_key.pub 2>/dev/null
    rm -f ~/.ssh/backup_key ~/.ssh/backup_key.pub 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check exam_key (Ed25519) exists with correct comment
    if [[ -f ~/.ssh/exam_key ]] && [[ -f ~/.ssh/exam_key.pub ]]; then
        # Check permissions on private key
        local perms=$(stat -c %a ~/.ssh/exam_key 2>/dev/null)
        if [[ "$perms" == "600" ]] || [[ "$perms" == "400" ]]; then
            # Check it's an Ed25519 key
            if grep -q 'ssh-ed25519' ~/.ssh/exam_key.pub 2>/dev/null; then
                # Check for the comment
                if grep -q 'RHCSA Exam Key' ~/.ssh/exam_key.pub 2>/dev/null; then
                    TASK_STATUS[0]="true"
                else
                    TASK_STATUS[0]="false"
                fi
            else
                TASK_STATUS[0]="false"
            fi
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check backup_key (RSA 4096) exists
    if [[ -f ~/.ssh/backup_key ]] && [[ -f ~/.ssh/backup_key.pub ]]; then
        # Check permissions on private key
        local perms=$(stat -c %a ~/.ssh/backup_key 2>/dev/null)
        if [[ "$perms" == "600" ]] || [[ "$perms" == "400" ]]; then
            # Check it's an RSA key
            if grep -q 'ssh-rsa' ~/.ssh/backup_key.pub 2>/dev/null; then
                # Verify it's 4096 bits by checking key length
                local bits=$(ssh-keygen -l -f ~/.ssh/backup_key.pub 2>/dev/null | awk '{print $1}')
                if [[ "$bits" == "4096" ]]; then
                    TASK_STATUS[1]="true"
                else
                    TASK_STATUS[1]="false"
                fi
            else
                TASK_STATUS[1]="false"
            fi
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f ~/.ssh/exam_key ~/.ssh/exam_key.pub 2>/dev/null
    rm -f ~/.ssh/backup_key ~/.ssh/backup_key.pub 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
