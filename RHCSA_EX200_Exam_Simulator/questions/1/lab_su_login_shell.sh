#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Switch User with Login Shell

# This is a LAB exercise
IS_LAB=true
LAB_ID="su_login_shell"

QUESTION="Switch to another user with full login environment"

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Switch to 'devuser' with login shell (su -) and create ~/i_was_here.txt"
TASK_1_HINT="su - loads full login shell environment including profile scripts"
TASK_1_COMMAND_1="su - devuser"
TASK_1_COMMAND_2="touch ~/i_was_here.txt"
TASK_1_COMMAND_3="exit"


# Auto-generate HINT from commands
HINT=$(_build_hint)
# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Creating test user devuser...${RESET}"
    userdel -r devuser 2>/dev/null
    useradd -m devuser 2>/dev/null
    echo "devuser:password123" | chpasswd 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if ~/i_was_here.txt exists in devuser's home
    if [[ -f /home/devuser/i_was_here.txt ]]; then
        # Verify it's owned by devuser
        local owner=$(stat -c %U /home/devuser/i_was_here.txt 2>/dev/null)
        if [[ "$owner" == "devuser" ]]; then
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
    userdel -r devuser 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
