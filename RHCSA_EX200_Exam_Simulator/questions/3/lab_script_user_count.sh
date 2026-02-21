#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: User Count Script

IS_LAB=true
LAB_ID="script_user_count"

QUESTION="[LAB] Create a script that counts number of users in /etc/passwd"
HINT="Task 1: Create /tmp/usercount.sh using COUNT=\$(wc -l < /etc/passwd)\nTask 2: Script outputs 'Total users: N' to /tmp/count.txt"

LAB_TITLE="User Count Script"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/usercount.sh using wc -l with command substitution" ;;
        1) echo "Script saves 'Total users: N' to /tmp/count.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/usercount.sh /tmp/count.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses wc -l with command substitution
    if [[ -f /tmp/usercount.sh ]] && [[ -x /tmp/usercount.sh ]] && \
       grep -q 'wc' /tmp/usercount.sh 2>/dev/null && grep -qE '\$\(' /tmp/usercount.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run script and check output
    /tmp/usercount.sh 2>/dev/null
    if [[ -f /tmp/count.txt ]] && grep -qiE 'users?:?\s*[0-9]+' /tmp/count.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/usercount.sh /tmp/count.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
