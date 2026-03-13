#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Directory Permissions - Understanding r, w, x on directories

# This is a LAB exercise
IS_LAB=true
LAB_ID="directory_permissions"

QUESTION="Set directory permissions to control access (r=list, w=create/delete, x=enter)"

# Lab configuration
LAB_TASK_COUNT=4

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set the permission of /tmp/exam/public, so owner has full access, others can list and enter but not create files"
TASK_1_HINT="Use chmod 755 (rwxr-xr-x) - owner: full, others: read+execute"
TASK_1_COMMAND_1="chmod 755 /tmp/exam/public"

# Task 2
TASK_2_QUESTION="Set the permission of /tmp/exam/private, so only owner can access - completely private from others"
TASK_2_HINT="Use chmod 700 (rwx------) - only owner has any access"
TASK_2_COMMAND_1="chmod 700 /tmp/exam/private"

# Task 3
TASK_3_QUESTION="Set the permission of /tmp/exam/dropbox, so others can enter and create files but cannot list contents"
TASK_3_HINT="Use chmod 733 (rwx-wx-wx) - owner: full, others: write+execute"
TASK_3_COMMAND_1="chmod 733 /tmp/exam/dropbox"

# Task 4
TASK_4_QUESTION="Set the permission of /tmp/exam/gateway, so others can only enter - cannot list (must know exact filename)"
TASK_4_HINT="Use chmod 711 (rwx--x--x) - owner: full, others: execute only"
TASK_4_COMMAND_1="chmod 711 /tmp/exam/gateway"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare lab environment
prepare_lab() {
    echo "  • Creating directory permission test directories..."
    
    # Clean up any existing lab files
    rm -rf /tmp/exam 2>/dev/null
    
    # Create exam directory structure
    mkdir -p /tmp/exam/public
    mkdir -p /tmp/exam/private
    mkdir -p /tmp/exam/dropbox
    mkdir -p /tmp/exam/gateway
    
    # Create sample files in each directory to test access
    echo "public file" > /tmp/exam/public/readme.txt
    echo "private data" > /tmp/exam/private/secret.txt
    echo "drop here" > /tmp/exam/dropbox/info.txt
    echo "gateway file" > /tmp/exam/gateway/known.txt
    
    # Set initial permissions (all open)
    chmod 777 /tmp/exam/public /tmp/exam/private /tmp/exam/dropbox /tmp/exam/gateway
}

# Check tasks
check_tasks() {
    # Task 1: /tmp/exam/public should be 755
    local perms1=$(stat -c "%a" /tmp/exam/public 2>/dev/null)
    if [[ "$perms1" == "755" ]]; then
        TASK_STATUS[0]=true
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 2: /tmp/exam/private should be 700
    local perms2=$(stat -c "%a" /tmp/exam/private 2>/dev/null)
    if [[ "$perms2" == "700" ]]; then
        TASK_STATUS[1]=true
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 3: /tmp/exam/dropbox should be 733
    local perms3=$(stat -c "%a" /tmp/exam/dropbox 2>/dev/null)
    if [[ "$perms3" == "733" ]]; then
        TASK_STATUS[2]=true
    else
        TASK_STATUS[2]=false
    fi
    
    # Task 4: /tmp/exam/gateway should be 711
    local perms4=$(stat -c "%a" /tmp/exam/gateway 2>/dev/null)
    if [[ "$perms4" == "711" ]]; then
        TASK_STATUS[3]=true
    else
        TASK_STATUS[3]=false
    fi
}

# Cleanup lab environment
cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    echo "  • Cleanup complete"
}
