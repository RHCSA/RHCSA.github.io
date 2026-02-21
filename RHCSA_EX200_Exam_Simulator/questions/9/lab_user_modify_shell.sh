#!/bin/bash
# Objective 9: Manage users and groups
# LAB: Modify User Shell

IS_LAB=true
LAB_ID="modify_user_shell"

QUESTION="[LAB] Change a user's login shell"
HINT="Task 1: usermod -s /bin/sh testmod\nTask 2: getent passwd testmod | grep /bin/sh"

LAB_TITLE="Modify User Shell"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Change testmod's shell to /bin/sh" ;;
        1) echo "Verify shell is /bin/sh" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test user...${RESET}"
    userdel -r testmod 2>/dev/null
    useradd -s /bin/bash testmod 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if shell is /bin/sh
    local user_shell=$(getent passwd testmod 2>/dev/null | cut -d: -f7)
    if [[ "$user_shell" == "/bin/sh" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Same verification
    if [[ "$user_shell" == "/bin/sh" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    userdel -r testmod 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
