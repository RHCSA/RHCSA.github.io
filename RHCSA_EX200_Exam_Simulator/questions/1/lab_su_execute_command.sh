#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Execute Command as Another User with su

# This is a LAB exercise
IS_LAB=true
LAB_ID="su_execute_command"

QUESTION="[LAB] Execute a command as another user using su -c"
HINT="This lab has 1 task:\n\n1. Run whoami as operator and save output:\n   su - operator -c 'whoami' > ~/i_am\n\nTip: su -c allows running single command\nYou return to your shell after command completes"

# Lab configuration
LAB_TITLE="Execute Command as Another User"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Run 'whoami' command as 'operator' user and save output to ~/i_am" ;;
    esac
}

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
