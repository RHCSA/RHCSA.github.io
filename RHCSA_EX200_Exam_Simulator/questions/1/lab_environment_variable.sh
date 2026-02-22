#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Set Environment Variable

# This is a LAB exercise
IS_LAB=true
LAB_ID="environment_variable"

QUESTION="[LAB] Create a persistent environment variable COMPANY with value 'RedHat' for all users"
HINT="Task 1: echo 'export COMPANY=RedHat' > /etc/profile.d/company.sh
(Alternative: echo 'COMPANY=RedHat' >> /etc/environment)"

# Lab configuration
LAB_TITLE="Set Environment Variable"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set COMPANY=RedHat persistently for all users" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing COMPANY variable configurations...${RESET}"
    
    # Remove from /etc/profile.d/
    rm -f /etc/profile.d/company.sh 2>/dev/null
    rm -f /etc/profile.d/*company*.sh 2>/dev/null
    
    # Remove from /etc/environment
    sed -i '/^COMPANY=/d' /etc/environment 2>/dev/null
    
    # Remove from /etc/profile
    sed -i '/COMPANY.*=.*RedHat/d' /etc/profile 2>/dev/null
    sed -i '/export.*COMPANY/d' /etc/profile 2>/dev/null
    
    # Remove from /etc/bashrc
    sed -i '/COMPANY.*=.*RedHat/d' /etc/bashrc 2>/dev/null
    sed -i '/export.*COMPANY/d' /etc/bashrc 2>/dev/null
    
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local found=false
    
    # Check in /etc/profile.d/*.sh files
    for file in /etc/profile.d/*.sh; do
        if [[ -f "$file" ]] && grep -qE "(export\s+)?COMPANY\s*=\s*['\"]?RedHat['\"]?" "$file" 2>/dev/null; then
            found=true
            break
        fi
    done
    
    # Check in /etc/environment
    if ! $found && grep -q "^COMPANY=RedHat" /etc/environment 2>/dev/null; then
        found=true
    fi
    
    # Check in /etc/profile
    if ! $found && grep -qE "(export\s+)?COMPANY\s*=\s*['\"]?RedHat['\"]?" /etc/profile 2>/dev/null; then
        found=true
    fi
    
    # Check in /etc/bashrc
    if ! $found && grep -qE "(export\s+)?COMPANY\s*=\s*['\"]?RedHat['\"]?" /etc/bashrc 2>/dev/null; then
        found=true
    fi
    
    if $found; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    
    # Remove from /etc/profile.d/
    rm -f /etc/profile.d/company.sh 2>/dev/null
    rm -f /etc/profile.d/*company*.sh 2>/dev/null
    
    # Remove from /etc/environment
    sed -i '/^COMPANY=/d' /etc/environment 2>/dev/null
    
    # Remove from /etc/profile
    sed -i '/COMPANY.*=.*RedHat/d' /etc/profile 2>/dev/null
    sed -i '/export.*COMPANY/d' /etc/profile 2>/dev/null
    
    # Remove from /etc/bashrc
    sed -i '/COMPANY.*=.*RedHat/d' /etc/bashrc 2>/dev/null
    sed -i '/export.*COMPANY/d' /etc/bashrc 2>/dev/null
    
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
