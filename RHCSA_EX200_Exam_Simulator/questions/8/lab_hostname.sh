#!/bin/bash
# Objective 7: Networking
# LAB: Hostname Configuration

# This is a LAB exercise
IS_LAB=true
LAB_ID="hostname"

QUESTION="Set the system hostname to server1.rhcsa.github.io"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set the system hostname to server1.rhcsa.github.io"
TASK_1_HINT="Use hostnamectl to set the hostname persistently"
TASK_1_COMMAND_1="hostnamectl set-hostname server1.rhcsa.github.io"

# Task 2
TASK_2_QUESTION="Add server1.rhcsa.github.io to /etc/hosts"
TASK_2_HINT="Add an entry mapping 127.0.0.1 to the hostname in /etc/hosts"
TASK_2_COMMAND_1="echo '127.0.0.1   server1.rhcsa.github.io server1' >> /etc/hosts"


# Auto-generate HINT from commands
HINT=$(_build_hint)
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
