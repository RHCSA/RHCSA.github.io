#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Comprehensive System Documentation Lab

IS_LAB=true
LAB_ID="docs_comprehensive"

QUESTION="Comprehensive practice: man sections, apropos, help, man page location, and package documentation"

LAB_TASK_COUNT=5

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Get /etc/passwd file format documentation from manual section 5 and save it to /tmp/exam/passwd_format.txt"
TASK_1_HINT="Section 5 contains file format documentation. Specify the section number before the page name."
TASK_1_COMMAND_1="man 5 passwd > /tmp/exam/passwd_format.txt"

# Task 2
TASK_2_QUESTION="Find user administration manual pages from section 8 and save the results to /tmp/exam/user_admin.txt"
TASK_2_HINT="Use apropos with a section filter for administrator commands."
TASK_2_COMMAND_1="apropos -s 8 user > /tmp/exam/user_admin.txt"

# Task 3
TASK_3_QUESTION="Find where the ls manual page file is stored and save the path to /tmp/exam/ls_man_location.txt"
TASK_3_HINT="Use the man option that prints the manual page file location instead of opening the page."
TASK_3_COMMAND_1="man -w ls > /tmp/exam/ls_man_location.txt"

# Task 4
TASK_4_QUESTION="Get help for the alias Bash builtin and save it to /tmp/exam/alias_help.txt"
TASK_4_HINT="Use the shell help command for Bash builtins."
TASK_4_COMMAND_1="help alias > /tmp/exam/alias_help.txt"

# Task 5
TASK_5_QUESTION="List the first 10 documentation files installed by the bash package and save them to /tmp/exam/bash_docs.txt"
TASK_5_HINT="Use rpm to query documentation files for an installed package, then limit the output."
TASK_5_COMMAND_1="rpm -qd bash | head -10 > /tmp/exam/bash_docs.txt"

# Auto-generate HINT from commands if the simulator framework provides _build_hint
if declare -F _build_hint >/dev/null 2>&1; then
    HINT=$(_build_hint)
fi

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

prepare_lab() {
    echo "  • Creating comprehensive documentation lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    mkdir -p /tmp/exam

    # apropos/whatis/man -k rely on the man-db index. Rebuild quietly when available.
    if command -v mandb >/dev/null 2>&1; then
        mandb -q >/dev/null 2>&1 || true
    fi

    echo "  • Lab environment ready"
}

_file_has_content() {
    local file="$1"
    [[ -f "$file" && -s "$file" ]]
}

check_tasks() {
    # Task 1: passwd_format.txt should contain the section 5 passwd file-format documentation.
    if _file_has_content /tmp/exam/passwd_format.txt \
       && grep -qiE "passwd|password file|/etc/passwd|account information" /tmp/exam/passwd_format.txt 2>/dev/null; then
        TASK_STATUS[0]=true
    else
        TASK_STATUS[0]=false
    fi

    # Task 2: user_admin.txt should contain section 8 user administration manual pages.
    # Do not require exact ordering; apropos output can vary by installed man pages.
    if _file_has_content /tmp/exam/user_admin.txt \
       && grep -qiE '\(8\)' /tmp/exam/user_admin.txt 2>/dev/null \
       && grep -qiE 'user|account|login|passwd|shadow' /tmp/exam/user_admin.txt 2>/dev/null; then
        TASK_STATUS[1]=true
    else
        TASK_STATUS[1]=false
    fi

    # Task 3: ls_man_location.txt should contain a path to the ls man page.
    if _file_has_content /tmp/exam/ls_man_location.txt \
       && grep -qE '/usr/share/man/.*/ls\.[0-9]' /tmp/exam/ls_man_location.txt 2>/dev/null; then
        TASK_STATUS[2]=true
    else
        TASK_STATUS[2]=false
    fi

    # Task 4: alias_help.txt should contain Bash help for alias.
    if _file_has_content /tmp/exam/alias_help.txt \
       && grep -qiE '^alias:|alias \[' /tmp/exam/alias_help.txt 2>/dev/null; then
        TASK_STATUS[3]=true
    else
        TASK_STATUS[3]=false
    fi

    # Task 5: bash_docs.txt should contain documentation paths from the installed bash package.
    # bash is part of the base system, unlike optional packages such as coreutils-doc.
    if _file_has_content /tmp/exam/bash_docs.txt \
       && grep -qE '^/usr/share/(doc|info|man)/' /tmp/exam/bash_docs.txt 2>/dev/null; then
        TASK_STATUS[4]=true
    else
        TASK_STATUS[4]=false
    fi
}

cleanup_lab() {
    echo "  • Cleaning up lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    echo "  • Cleanup complete"
}
