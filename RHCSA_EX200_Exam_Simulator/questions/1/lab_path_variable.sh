#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Modify PATH Variable

# This is a LAB exercise
IS_LAB=true
LAB_ID="path_variable"

QUESTION="Add /opt/custom/bin to the PATH variable persistently for all users"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create directory /opt/custom/bin"
TASK_1_HINT="Use -p to create parent directories"
TASK_1_COMMAND_1="mkdir -p /opt/custom/bin"

# Task 2
TASK_2_QUESTION="Add /opt/custom/bin to PATH in /etc/profile"
TASK_2_HINT="Append an export PATH statement to /etc/profile"
TASK_2_COMMAND_1="echo 'export PATH=\$PATH:/opt/custom/bin' >> /etc/profile"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing /opt/custom/bin from /etc/profile...${RESET}"
    sed -i '/\/opt\/custom\/bin/d' /etc/profile 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Removing /opt/custom/bin directory...${RESET}"
    rm -rf /opt/custom 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check directory exists
    if [[ -d /opt/custom/bin ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check PATH is added in /etc/profile
    if grep -q "/opt/custom/bin" /etc/profile 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    
    # Remove the PATH entry from /etc/profile
    sed -i '/\/opt\/custom\/bin/d' /etc/profile 2>/dev/null
    
    # Remove the custom directory
    rm -rf /opt/custom 2>/dev/null
    
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
