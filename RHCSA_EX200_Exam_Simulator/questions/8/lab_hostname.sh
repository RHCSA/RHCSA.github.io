#!/bin/bash
# Objective 7: Networking
# LAB: Hostname Configuration

# This is a LAB exercise
IS_LAB=true
LAB_ID="hostname"

QUESTION="[LAB] Set the system hostname to server1.rhcsa.github.io"
ANSWER="Use: hostnamectl set-hostname server1.rhcsa.github.io"
HINT="This lab has two tasks:\n\n1. Set hostname: Use 'hostnamectl set-hostname server1.rhcsa.github.io' to set the hostname persistently.\n\n2. Update /etc/hosts: Edit the file with 'sudo vi /etc/hosts' or 'sudo nano /etc/hosts' and add a line like:\n   127.0.0.1   server1.rhcsa.github.io server1\n\nTip: After setting hostname, verify with 'hostname' or 'hostnamectl status'.\nThe /etc/hosts entry helps with local name resolution."

# Lab configuration
LAB_TITLE="Hostname Configuration"
LAB_TASK_COUNT=2

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set the system hostname to server1.rhcsa.github.io" ;;
        1) echo "Add server1.rhcsa.github.io to /etc/hosts" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    local target_hostname="server1.rhcsa.github.io"
    local random_hostname="random.host.name"
    
    # Step 1: Change hostname to random value
    echo -e "  ${DIM}• Resetting hostname...${RESET}"
    if command -v hostnamectl &>/dev/null; then
        hostnamectl set-hostname "$random_hostname" 2>/dev/null
    else
        hostname "$random_hostname" 2>/dev/null
    fi
    sleep 0.3
    
    # Step 2: Remove target hostname from /etc/hosts if present
    echo -e "  ${DIM}• Cleaning /etc/hosts...${RESET}"
    if grep -q "$target_hostname" /etc/hosts 2>/dev/null; then
        sed -i "/$target_hostname/d" /etc/hosts 2>/dev/null
    fi
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local target_hostname="server1.rhcsa.github.io"
    
    # Task 0: Check hostname
    if [[ "$(hostname 2>/dev/null)" == "$target_hostname" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check /etc/hosts
    if grep -q "$target_hostname" /etc/hosts 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    local target_hostname="server1.rhcsa.github.io"
    local original_hostname="server_support_test_ec2..nbc-ged.lan"
    
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    
    # Restore original hostname
    echo -e "  ${DIM}• Restoring hostname...${RESET}"
    if command -v hostnamectl &>/dev/null; then
        hostnamectl set-hostname "$original_hostname" 2>/dev/null
    else
        hostname "$original_hostname" 2>/dev/null
    fi
    
    # Remove target hostname from /etc/hosts
    echo -e "  ${DIM}• Cleaning /etc/hosts...${RESET}"
    if grep -q "$target_hostname" /etc/hosts 2>/dev/null; then
        sed -i "/$target_hostname/d" /etc/hosts 2>/dev/null
    fi
    
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
