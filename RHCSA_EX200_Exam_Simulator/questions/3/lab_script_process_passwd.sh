#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Process Users from /etc/passwd

IS_LAB=true
LAB_ID="script_process_passwd"

QUESTION="[LAB] Create a script that extracts usernames from /etc/passwd"
HINT="Task 1: Create /tmp/users.sh using while IFS=: read username rest; do\nTask 2: Script saves usernames to /tmp/userlist.txt"

LAB_TITLE="Process Users from passwd"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/users.sh with IFS=: to parse /etc/passwd" ;;
        1) echo "Script extracts usernames to /tmp/userlist.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/users.sh /tmp/userlist.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses IFS to parse fields
    if [[ -f /tmp/users.sh ]] && [[ -x /tmp/users.sh ]] && \
       grep -q 'IFS' /tmp/users.sh 2>/dev/null && grep -q '/etc/passwd' /tmp/users.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run script and check output
    /tmp/users.sh 2>/dev/null
    if [[ -f /tmp/userlist.txt ]] && grep -q 'root' /tmp/userlist.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/users.sh /tmp/userlist.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
