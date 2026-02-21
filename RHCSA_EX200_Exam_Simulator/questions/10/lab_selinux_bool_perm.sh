#!/bin/bash
# Objective 10: Manage security
# LAB: Set SELinux Boolean Permanently

IS_LAB=true
LAB_ID="selinux_bool_perm"

QUESTION="[LAB] Set an SELinux boolean permanently"
HINT="Task 1: setsebool -P httpd_enable_homedirs on\nTask 2: semanage boolean -l | grep httpd_enable_homedirs > /tmp/bool-perm.txt"

LAB_TITLE="Set Boolean Permanent"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Enable httpd_enable_homedirs permanently" ;;
        1) echo "Verify permanent setting in /tmp/bool-perm.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Ensuring boolean is off initially...${RESET}"
    setsebool -P httpd_enable_homedirs off 2>/dev/null
    rm -f /tmp/bool-perm.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if boolean is on
    if getsebool httpd_enable_homedirs 2>/dev/null | grep -q '\-\-> on'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if bool-perm.txt exists with boolean info
    if [[ -f /tmp/bool-perm.txt ]] && grep -qi 'httpd_enable_homedirs' /tmp/bool-perm.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Resetting boolean permanently...${RESET}"
    setsebool -P httpd_enable_homedirs off 2>/dev/null
    rm -f /tmp/bool-perm.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
