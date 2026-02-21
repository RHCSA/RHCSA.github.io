#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Fix File Read Permission

IS_LAB=true
LAB_ID="fix_read_perm"

QUESTION="[LAB] Fix file read permissions so all users can read"
HINT="Task 1: chmod o+r /tmp/labpermfile.txt\nTask 2: Verify with ls -l /tmp/labpermfile.txt"

LAB_TITLE="Fix File Read Permission"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add read permission for others on /tmp/labpermfile.txt" ;;
        1) echo "Verify file has o+r permission (save to /tmp/perm-check.txt)" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating restricted file...${RESET}"
    echo "Secret content" > /tmp/labpermfile.txt
    chmod 600 /tmp/labpermfile.txt
    rm -f /tmp/perm-check.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if file has read permission for others
    local perms=$(stat -c %a /tmp/labpermfile.txt 2>/dev/null)
    local other_read=$((perms % 10))
    if [[ $((other_read & 4)) -eq 4 ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if perm-check.txt exists with permission info
    if [[ -f /tmp/perm-check.txt ]] && grep -q 'labpermfile' /tmp/perm-check.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/labpermfile.txt /tmp/perm-check.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
