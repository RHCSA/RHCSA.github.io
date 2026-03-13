#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Execute Command as Another User with su

# This is a LAB exercise
IS_LAB=true
LAB_ID="su_execute_command"

QUESTION="Execute a command as another user using su -c"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Run 'whoami' command as 'operator' user and save output to ~/i_am"
TASK_1_HINT="-c option allows running single command as specified user"
TASK_1_COMMAND_1="su - operator -c 'whoami' > ~/i_am"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test user operator...${RESET}"
    userdel -r operator 2>/dev/null
    useradd -m operator 2>/dev/null
    echo "operator:password123" | chpasswd 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Removing existing output file...${RESET}"
    rm -f ~/i_am 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if ~/i_am exists with 'operator'
    if [[ -f ~/i_am ]]; then
        local file_content=$(cat ~/i_am 2>/dev/null | tr -d '[:space:]')
        if [[ "$file_content" == "operator" ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r operator 2>/dev/null
    rm -f ~/i_am 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
