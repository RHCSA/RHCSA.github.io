#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: whatis and man -f for Brief Descriptions

IS_LAB=true
LAB_ID="whatis_command"

QUESTION="[LAB] Use whatis and man -f to get one-line command descriptions"

HINT="Task 1: whatis tar > /tmp/exam/tar_desc.txt
       (Get brief description of tar command)

Task 2: man -f passwd > /tmp/exam/passwd_sections.txt
       (Shows which sections have passwd pages)

Task 3: whatis ls cp mv > /tmp/exam/multi_desc.txt
       (Get descriptions for multiple commands at once)"

LAB_TITLE="Brief Descriptions (whatis)"
LAB_TASK_COUNT=3

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Get one-line description of 'tar', save to /tmp/exam/tar_desc.txt" ;;
        1) echo "Show all sections for 'passwd', save to /tmp/exam/passwd_sections.txt" ;;
        2) echo "Get descriptions for ls, cp, mv in one command, save to /tmp/exam/multi_desc.txt" ;;
    esac
}

prepare_lab() {
    echo "  • Creating whatis lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    mkdir -p /tmp/exam
    echo "  • Lab environment ready"
}

check_tasks() {
    # Task 0: tar_desc.txt should have tar description
    if [[ -f /tmp/exam/tar_desc.txt ]]; then
        if grep -qi "tar" /tmp/exam/tar_desc.txt 2>/dev/null; then
            TASK_STATUS[0]=true
        else
            TASK_STATUS[0]=false
        fi
    else
        TASK_STATUS[0]=false
    fi
    
    # Task 1: passwd_sections.txt should show multiple sections
    if [[ -f /tmp/exam/passwd_sections.txt ]]; then
        # Should show at least section (1) and (5) for passwd
        if grep -q "passwd" /tmp/exam/passwd_sections.txt 2>/dev/null; then
            TASK_STATUS[1]=true
        else
            TASK_STATUS[1]=false
        fi
    else
        TASK_STATUS[1]=false
    fi
    
    # Task 2: multi_desc.txt should have all three commands
    if [[ -f /tmp/exam/multi_desc.txt ]]; then
        local has_ls=$(grep -c "^ls\|^ls " /tmp/exam/multi_desc.txt 2>/dev/null)
        local has_cp=$(grep -c "^cp\|^cp " /tmp/exam/multi_desc.txt 2>/dev/null)
        local has_mv=$(grep -c "^mv\|^mv " /tmp/exam/multi_desc.txt 2>/dev/null)
        if [[ $has_ls -ge 1 ]] && [[ $has_cp -ge 1 ]] && [[ $has_mv -ge 1 ]]; then
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
