#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Command Substitution

IS_LAB=true
LAB_ID="script_cmd_substitution"

QUESTION="[LAB] Create a script using command substitution \$(command)"
HINT="Task 1: Create /tmp/sysinfo.sh using DATE=\$(date +%Y-%m-%d)\nTask 2: Script saves hostname and date to /tmp/sysinfo.txt"

LAB_TITLE="Command Substitution"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/sysinfo.sh using \$() command substitution" ;;
        1) echo "Script saves date and hostname to /tmp/sysinfo.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous files...${RESET}"
    rm -f /tmp/sysinfo.sh /tmp/sysinfo.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script uses $() command substitution
    if [[ -f /tmp/sysinfo.sh ]] && [[ -x /tmp/sysinfo.sh ]] && grep -qE '\$\(' /tmp/sysinfo.sh 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Run script and check output file
    /tmp/sysinfo.sh 2>/dev/null
    if [[ -f /tmp/sysinfo.txt ]] && [[ -s /tmp/sysinfo.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/sysinfo.sh /tmp/sysinfo.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
