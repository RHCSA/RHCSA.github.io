#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Set Environment Variable

# This is a LAB exercise
IS_LAB=true
LAB_ID="environment_variable"

QUESTION="Create a persistent environment variable COMPANY with value 'RedHat' for all users"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set COMPANY=RedHat persistently for all users"
TASK_1_HINT="Create a script in /etc/profile.d/ or add to /etc/environment"
TASK_1_COMMAND_1="echo 'export COMPANY=RedHat' > /etc/profile.d/company.sh"


# Auto-generate HINT from commands
HINT=$(_build_hint)
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
