#!/bin/bash
# Objective 10: Manage security
# LAB: Generate RSA SSH Key

IS_LAB=true
LAB_ID="ssh_keygen_rsa"

QUESTION="[LAB] Generate an RSA SSH key pair with 4096 bits"
HINT="Task 1: ssh-keygen -t rsa -b 4096 -f /tmp/lab_rsa_key -N ''\nTask 2: ssh-keygen -l -f /tmp/lab_rsa_key > /tmp/rsa-fingerprint.txt"

LAB_TITLE="Generate RSA Key"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Generate 4096-bit RSA key at /tmp/lab_rsa_key" ;;
        1) echo "Save fingerprint to /tmp/rsa-fingerprint.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous keys...${RESET}"
    rm -f /tmp/lab_rsa_key /tmp/lab_rsa_key.pub /tmp/rsa-fingerprint.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if RSA key exists
    if [[ -f /tmp/lab_rsa_key ]] && [[ -f /tmp/lab_rsa_key.pub ]] && grep -q 'ssh-rsa' /tmp/lab_rsa_key.pub 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if fingerprint file exists
    if [[ -f /tmp/rsa-fingerprint.txt ]] && grep -qE 'RSA|SHA256' /tmp/rsa-fingerprint.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/lab_rsa_key /tmp/lab_rsa_key.pub /tmp/rsa-fingerprint.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
