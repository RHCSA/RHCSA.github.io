#!/bin/bash
# Objective 10: Manage security
# LAB: Add Custom File Context Rule

IS_LAB=true
LAB_ID="selinux_fcontext_add"

QUESTION="[LAB] Add a custom SELinux file context rule"
HINT="Task 1: semanage fcontext -a -t httpd_sys_content_t '/labweb(/.*)?'\nTask 2: restorecon -Rv /labweb (apply the context)"

LAB_TITLE="Add File Context Rule"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add httpd_sys_content_t rule for /labweb" ;;
        1) echo "Apply context with restorecon" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test directory...${RESET}"
    semanage fcontext -d '/labweb(/.*)?' 2>/dev/null
    rm -rf /labweb 2>/dev/null
    mkdir -p /labweb 2>/dev/null
    touch /labweb/index.html 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if file context rule exists
    if semanage fcontext -l 2>/dev/null | grep -q '/labweb'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if context is applied
    if ls -dZ /labweb 2>/dev/null | grep -q 'httpd_sys_content_t'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    semanage fcontext -d '/labweb(/.*)?' 2>/dev/null
    rm -rf /labweb 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
