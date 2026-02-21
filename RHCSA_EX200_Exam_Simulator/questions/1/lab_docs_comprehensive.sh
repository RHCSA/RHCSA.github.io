#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Comprehensive System Documentation Lab

IS_LAB=true
LAB_ID="docs_comprehensive"

QUESTION="[LAB] Comprehensive practice: man sections, apropos, help, and /usr/share/doc"

HINT="Task 1: man 5 shadow > /tmp/exam/shadow_format.txt
       (Get shadow password file format documentation)

Task 2: apropos -s 8 filesystem > /tmp/exam/fs_admin.txt
       (Find filesystem admin commands in section 8)

Task 3: man -w ls > /tmp/exam/man_location.txt
       (Find where man page file is stored)

Task 4: help alias > /tmp/exam/alias_help.txt
       (Get help for alias builtin)

Task 5: rpm -qd coreutils | head -10 > /tmp/exam/coreutils_docs.txt
       (List first 10 doc files for coreutils)"

LAB_TITLE="Documentation Comprehensive"
LAB_TASK_COUNT=5

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Get /etc/shadow file format documentation (section 5), save to /tmp/exam/shadow_format.txt" ;;
        1) echo "Find filesystem admin commands (section 8), save to /tmp/exam/fs_admin.txt" ;;
        2) echo "Find where ls man page file is stored, save to /tmp/exam/man_location.txt" ;;
        3) echo "Get help for 'alias' builtin, save to /tmp/exam/alias_help.txt" ;;
        4) echo "List first 10 doc files for coreutils, save to /tmp/exam/coreutils_docs.txt" ;;
    esac
}

prepare_lab() {
    echo "  • Creating comprehensive documentation lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    mkdir -p /tmp/exam
    echo "  • Lab environment ready"
}

check_tasks() {
    # Task 0: shadow_format.txt should have shadow file documentation
    if [[ -f /tmp/exam/shadow_format.txt ]]; then
        if grep -qi "shadow\|password" /tmp/exam/shadow_format.txt 2>/dev/null; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 1: fs_admin.txt should have section 8 results
    if [[ -f /tmp/exam/fs_admin.txt ]]; then
        local count=$(wc -l < /tmp/exam/fs_admin.txt 2>/dev/null)
        if [[ $count -ge 1 ]]; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 2: man_location.txt should have path to man page
    if [[ -f /tmp/exam/man_location.txt ]]; then
        if grep -q "/usr/share/man\|man1/ls" /tmp/exam/man_location.txt 2>/dev/null; then
            TASK_STATUS[2]=true
        else
            TASK_STATUS[2]=false
        fi
    else
        TASK_STATUS[2]=false
    fi
    
    # Task 3: alias_help.txt should have alias help
    if [[ -f /tmp/exam/alias_help.txt ]]; then
        if grep -qi "alias" /tmp/exam/alias_help.txt 2>/dev/null; then
            TASK_STATUS[3]=true
        else
            TASK_STATUS[3]=false
        fi
    else
        TASK_STATUS[3]=false
    fi
    
    # Task 4: coreutils_docs.txt should have file paths
    if [[ -f /tmp/exam/coreutils_docs.txt ]]; then
        if grep -q "/" /tmp/exam/coreutils_docs.txt 2>/dev/null; then
            TASK_STATUS[4]=true
        else
            TASK_STATUS[4]=false
        fi
    else
        TASK_STATUS[4]=false
    fi
}

cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    echo "  • Cleanup complete"
}
