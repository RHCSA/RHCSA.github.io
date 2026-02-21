#!/bin/bash
# Objective 10: Manage security
# LAB: Generate SSH Key Pair

IS_LAB=true
LAB_ID="ssh_keygen"

QUESTION="[LAB] Generate an SSH key pair"
HINT="Task 1: ssh-keygen -t ed25519 -f /tmp/lab_sshkey -N ''\nTask 2: ls -l /tmp/lab_sshkey* (verify both files created)"

LAB_TITLE="Generate SSH Key Pair"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Generate ED25519 key pair at /tmp/lab_sshkey" ;;
        1) echo "Verify both private and public keys exist" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous keys...${RESET}"
    rm -f /tmp/lab_sshkey /tmp/lab_sshkey.pub 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if private key exists
    if [[ -f /tmp/lab_sshkey ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if public key exists
    if [[ -f /tmp/lab_sshkey.pub ]] && grep -qE 'ssh-ed25519|ssh-rsa' /tmp/lab_sshkey.pub 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/lab_sshkey /tmp/lab_sshkey.pub 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
