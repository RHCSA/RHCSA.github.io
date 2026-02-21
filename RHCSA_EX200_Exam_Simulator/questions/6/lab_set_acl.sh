#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Set File ACL

IS_LAB=true
LAB_ID="set_acl"

QUESTION="[LAB] Set Access Control List for a specific user"
HINT="Task 1: setfacl -m u:nobody:rw /tmp/labsetacl.txt\nTask 2: getfacl /tmp/labsetacl.txt > /tmp/acl-verify.txt"

LAB_TITLE="Set File ACL"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set ACL granting 'nobody' read-write on /tmp/labsetacl.txt" ;;
        1) echo "Verify ACL and save to /tmp/acl-verify.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test file...${RESET}"
    echo "ACL set test" > /tmp/labsetacl.txt
    setfacl -b /tmp/labsetacl.txt 2>/dev/null
    rm -f /tmp/acl-verify.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if ACL for nobody exists with rw
    if getfacl /tmp/labsetacl.txt 2>/dev/null | grep -qE 'user:nobody:rw'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if acl-verify.txt exists with nobody entry
    if [[ -f /tmp/acl-verify.txt ]] && grep -q 'nobody' /tmp/acl-verify.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/labsetacl.txt /tmp/acl-verify.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
