#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Comprehensive System Documentation Lab

IS_LAB=true
LAB_ID="docs_comprehensive"

QUESTION="Comprehensive practice: man sections, apropos, help, and /usr/share/doc"

LAB_TASK_COUNT=5

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Get /etc/shadow file format documentation (section 5), save to /tmp/exam/shadow_format.txt"
TASK_1_HINT="Section 5 contains file format documentation"
TASK_1_COMMAND_1="man 5 shadow > /tmp/exam/shadow_format.txt"

# Task 2
TASK_2_QUESTION="Find filesystem admin commands (section 8), save to /tmp/exam/fs_admin.txt"
TASK_2_HINT="Use apropos -s 8 to search only admin commands"
TASK_2_COMMAND_1="apropos -s 8 filesystem > /tmp/exam/fs_admin.txt"

# Task 3
TASK_3_QUESTION="Find where ls man page file is stored, save to /tmp/exam/man_location.txt"
TASK_3_HINT="man -w shows the location of the man page file"
TASK_3_COMMAND_1="man -w ls > /tmp/exam/man_location.txt"

# Task 4
TASK_4_QUESTION="Get help for 'alias' builtin, save to /tmp/exam/alias_help.txt"
TASK_4_HINT="Use help command for shell builtins"
TASK_4_COMMAND_1="help alias > /tmp/exam/alias_help.txt"

# Task 5
TASK_5_QUESTION="List first 10 doc files for coreutils, save to /tmp/exam/coreutils_docs.txt"
TASK_5_HINT="rpm -qd lists doc files, pipe to head for first 10"
TASK_5_COMMAND_1="rpm -qd coreutils | head -10 > /tmp/exam/coreutils_docs.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

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
