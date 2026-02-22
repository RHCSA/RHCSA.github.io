#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Shell Built-in Commands - type and help

IS_LAB=true
LAB_ID="builtin_help"

QUESTION="[LAB] Identify shell built-in commands with 'type' and get help with 'help'"

HINT="Task 1: type cd > /tmp/exam/type_cd.txt
       (Shows that cd is a shell builtin)

Task 2: type ls > /tmp/exam/type_ls.txt
       (Shows that ls is an external command)

Task 3: help export > /tmp/exam/help_export.txt
       (Get help for export builtin, not man)"

LAB_TITLE="Built-in Commands (type, help)"
LAB_TASK_COUNT=3

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Check if 'cd' is builtin or external, save to /tmp/exam/type_cd.txt" ;;
        1) echo "Check if 'ls' is builtin or external, save to /tmp/exam/type_ls.txt" ;;
        2) echo "Get help for 'export' builtin command, save to /tmp/exam/help_export.txt" ;;
    esac
}

prepare_lab() {
    echo "  • Creating builtin help lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    mkdir -p /tmp/exam
    echo "  • Lab environment ready"
}

check_tasks() {
    # Task 0: type_cd.txt should show "builtin"
    if [[ -f /tmp/exam/type_cd.txt ]]; then
        if grep -qi "builtin" /tmp/exam/type_cd.txt 2>/dev/null; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 1: type_ls.txt should show path like /usr/bin/ls or "aliased"
    if [[ -f /tmp/exam/type_ls.txt ]]; then
        if grep -qiE "/bin/ls|aliased|hashed" /tmp/exam/type_ls.txt 2>/dev/null; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 2: help_export.txt should have export help content
    if [[ -f /tmp/exam/help_export.txt ]]; then
        if grep -qi "export" /tmp/exam/help_export.txt 2>/dev/null && \
           grep -qiE "variable|environment|name" /tmp/exam/help_export.txt 2>/dev/null; then
            TASK_STATUS[2]=true
        else
            TASK_STATUS[2]=false
        fi
    else
        TASK_STATUS[2]=false
    fi
}

cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    echo "  • Cleanup complete"
}
