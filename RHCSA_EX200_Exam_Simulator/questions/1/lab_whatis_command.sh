#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: whatis and man -f for Brief Descriptions

IS_LAB=true
LAB_ID="whatis_command"

QUESTION="Use whatis and man -f to get one-line command descriptions"

LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Get one-line description of 'tar', save to /tmp/exam/tar_desc.txt"
TASK_1_HINT="whatis gives brief description of a command"
TASK_1_COMMAND_1="whatis tar > /tmp/exam/tar_desc.txt"

# Task 2
TASK_2_QUESTION="Show all sections for 'passwd', save to /tmp/exam/passwd_sections.txt"
TASK_2_HINT="man -f shows which sections have pages for a command"
TASK_2_COMMAND_1="man -f passwd > /tmp/exam/passwd_sections.txt"

# Task 3
TASK_3_QUESTION="Get descriptions for ls, cp, mv in one command, save to /tmp/exam/multi_desc.txt"
TASK_3_HINT="whatis accepts multiple commands as arguments"
TASK_3_COMMAND_1="whatis ls cp mv > /tmp/exam/multi_desc.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

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
