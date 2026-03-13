#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Configure SSH Daemon (sshd) Settings

# This is a LAB exercise
IS_LAB=true
LAB_ID="sshd_config"

QUESTION="Modify SSH daemon configuration with security settings"

# Lab configuration
LAB_TASK_COUNT=5

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set PermitRootLogin to 'yes' in /etc/ssh/sshd_config"
TASK_1_HINT="Edit /etc/ssh/sshd_config and add/modify PermitRootLogin directive"
TASK_1_COMMAND_1="vim /etc/ssh/sshd_config"

# Task 2
TASK_2_QUESTION="Configure AllowUsers to permit only: root, admin, developer"
TASK_2_HINT="AllowUsers directive accepts space-separated list of usernames"
TASK_2_COMMAND_1="AllowUsers root admin developer"

# Task 3
TASK_3_QUESTION="Set MaxAuthTries to 3"
TASK_3_HINT="MaxAuthTries limits authentication attempts per connection"
TASK_3_COMMAND_1="MaxAuthTries 3"

# Task 4
TASK_4_QUESTION="Disable X11 forwarding (X11Forwarding no)"
TASK_4_HINT="X11Forwarding controls graphical application forwarding over SSH"
TASK_4_COMMAND_1="X11Forwarding no"

# Task 5
TASK_5_QUESTION="Disable empty passwords (PermitEmptyPasswords no)"
TASK_5_HINT="PermitEmptyPasswords controls login for accounts without passwords"
TASK_5_COMMAND_1="PermitEmptyPasswords no"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Backing up original sshd_config...${RESET}"
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.lab_backup 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Ensuring default settings for lab...${RESET}"
    # Comment out any existing settings we want to test
    sed -i 's/^PermitRootLogin/#PermitRootLogin/' /etc/ssh/sshd_config 2>/dev/null
    sed -i 's/^AllowUsers/#AllowUsers/' /etc/ssh/sshd_config 2>/dev/null
    sed -i 's/^MaxAuthTries/#MaxAuthTries/' /etc/ssh/sshd_config 2>/dev/null
    sed -i 's/^X11Forwarding/#X11Forwarding/' /etc/ssh/sshd_config 2>/dev/null
    sed -i 's/^PermitEmptyPasswords/#PermitEmptyPasswords/' /etc/ssh/sshd_config 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating test users...${RESET}"
    for user in admin developer; do
        userdel -r $user 2>/dev/null
        useradd $user 2>/dev/null
        echo "$user:password123" | chpasswd 2>/dev/null
    done
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local sshd_config="/etc/ssh/sshd_config"
    
    # First verify sshd config syntax is valid
    if ! sshd -t 2>/dev/null; then
        # If syntax is invalid, mark all tasks as false
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        TASK_STATUS[2]="false"
        TASK_STATUS[3]="false"
        TASK_STATUS[4]="false"
        return
    fi
    
    # Task 0: Check PermitRootLogin yes
    if grep -qE '^PermitRootLogin[[:space:]]+yes' "$sshd_config" 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check AllowUsers contains root, admin, developer
    if grep -qE '^AllowUsers[[:space:]]' "$sshd_config" 2>/dev/null; then
        local allow_line=$(grep -E '^AllowUsers[[:space:]]' "$sshd_config")
        if echo "$allow_line" | grep -qw 'root' && \
           echo "$allow_line" | grep -qw 'admin' && \
           echo "$allow_line" | grep -qw 'developer'; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check MaxAuthTries 3
    if grep -qE '^MaxAuthTries[[:space:]]+3' "$sshd_config" 2>/dev/null; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
    
    # Task 3: Check X11Forwarding no
    if grep -qE '^X11Forwarding[[:space:]]+no' "$sshd_config" 2>/dev/null; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
    
    # Task 4: Check PermitEmptyPasswords no
    if grep -qE '^PermitEmptyPasswords[[:space:]]+no' "$sshd_config" 2>/dev/null; then
        TASK_STATUS[4]="true"
    else
        TASK_STATUS[4]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Restoring original sshd_config...${RESET}"
    if [[ -f /etc/ssh/sshd_config.lab_backup ]]; then
        cp /etc/ssh/sshd_config.lab_backup /etc/ssh/sshd_config 2>/dev/null
        rm -f /etc/ssh/sshd_config.lab_backup 2>/dev/null
        systemctl reload sshd 2>/dev/null
    fi
    
    echo -e "  ${DIM}• Removing test users...${RESET}"
    for user in admin developer; do
        userdel -r $user 2>/dev/null
    done
    
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
