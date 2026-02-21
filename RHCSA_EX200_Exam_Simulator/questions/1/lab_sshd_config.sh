#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Configure SSH Daemon (sshd) Settings

# This is a LAB exercise
IS_LAB=true
LAB_ID="sshd_config"

QUESTION="[LAB] Modify SSH daemon configuration with security settings"
HINT="Task 1: PermitRootLogin yes (in /etc/ssh/sshd_config)
Task 2: AllowUsers root admin developer
Task 3: MaxAuthTries 3
Task 4: X11Forwarding no
Task 5: PermitEmptyPasswords no
After editing: systemctl reload sshd"

# Lab configuration
LAB_TITLE="SSH Daemon Configuration"
LAB_TASK_COUNT=5

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set PermitRootLogin to 'yes' in /etc/ssh/sshd_config" ;;
        1) echo "Configure AllowUsers to permit only: root, admin, developer" ;;
        2) echo "Set MaxAuthTries to 3" ;;
        3) echo "Disable X11 forwarding (X11Forwarding no)" ;;
        4) echo "Disable empty passwords (PermitEmptyPasswords no)" ;;
    esac
}

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
