#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Fix File Write Permission

IS_LAB=true
LAB_ID="fix_write_perm"

QUESTION="[LAB] Fix file permissions so group can write"
HINT="Task 1: chmod g+w /tmp/labgroupfile.txt\nTask 2: ls -l /tmp/labgroupfile.txt > /tmp/write-check.txt"

LAB_TITLE="Fix File Write Permission"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add write permission for group on /tmp/labgroupfile.txt" ;;
        1) echo "Verify and save permission info to /tmp/write-check.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating group-restricted file...${RESET}"
    echo "Group content" > /tmp/labgroupfile.txt
    chmod 644 /tmp/labgroupfile.txt
    rm -f /tmp/write-check.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if file has write permission for group
    local perms=$(stat -c %a /tmp/labgroupfile.txt 2>/dev/null)
    local group_perm=$(( (perms / 10) % 10 ))
    if [[ $((group_perm & 2)) -eq 2 ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if write-check.txt exists
    if [[ -f /tmp/write-check.txt ]] && grep -q 'labgroupfile' /tmp/write-check.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/labgroupfile.txt /tmp/write-check.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
