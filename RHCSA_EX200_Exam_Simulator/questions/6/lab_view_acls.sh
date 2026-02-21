#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: View File ACLs

IS_LAB=true
LAB_ID="view_acls"

QUESTION="[LAB] View Access Control Lists on files"
HINT="Task 1: getfacl /tmp/labaclfile.txt > /tmp/acl-output.txt\nTask 2: getfacl /etc/passwd >> /tmp/acl-output.txt"

LAB_TITLE="View File ACLs"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Get ACL of /tmp/labaclfile.txt and save to /tmp/acl-output.txt" ;;
        1) echo "Append /etc/passwd ACL to /tmp/acl-output.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test file...${RESET}"
    echo "ACL test" > /tmp/labaclfile.txt
    rm -f /tmp/acl-output.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if acl-output.txt exists with labaclfile info
    if [[ -f /tmp/acl-output.txt ]] && grep -q 'labaclfile' /tmp/acl-output.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if passwd acl was appended
    if [[ -f /tmp/acl-output.txt ]] && grep -q 'passwd' /tmp/acl-output.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/labaclfile.txt /tmp/acl-output.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
