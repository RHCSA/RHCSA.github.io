#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Locate and use system documentation

IS_LAB=true
LAB_ID="system_documentation"

QUESTION="Locate, read and use Linux system documentation with whatis, apropos and man"

LAB_TASK_COUNT=5

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1 - whatis
TASK_1_QUESTION="Find the short one-line manual description for the passwd command and save it to /tmp/exam/passwd_desc.txt"
TASK_1_HINT="Use the command that shows the one-line manual page description for a known command."
TASK_1_COMMAND_1="whatis passwd > /tmp/exam/passwd_desc.txt"

# Task 2 - apropos
TASK_2_QUESTION="You do not know the exact manual page name. Use apropos to search for manual pages related to passwd and save the results to /tmp/exam/passwd_apropos.txt"
TASK_2_HINT="Use apropos with the keyword passwd and redirect the output to the requested file."
TASK_2_COMMAND_1="apropos passwd > /tmp/exam/passwd_apropos.txt"

# Task 3 - man
TASK_3_QUESTION="Read the manual page for the passwd command and save only the first 20 lines to /tmp/exam/passwd_man.txt"
TASK_3_HINT="Use man for the known manual page and pipe the beginning of the output to a file."
TASK_3_COMMAND_1="man passwd | head -20 > /tmp/exam/passwd_man.txt"

# Task 4 - man sections
TASK_4_QUESTION="The name passwd exists in more than one manual section. Read the file-format manual page for passwd and save only the first 20 lines to /tmp/exam/passwd_section5.txt"
TASK_4_HINT="File formats are documented in manual section 5. Specify the section number before the page name."
TASK_4_COMMAND_1="man 5 passwd | head -20 > /tmp/exam/passwd_section5.txt"

# Task 5 - man -k
TASK_5_QUESTION="Use the keyword-search option of the man command to find manual pages related to user and save the results to /tmp/exam/user_mank.txt"
TASK_5_HINT="Use the man option that performs a keyword search through manual page names and descriptions."
TASK_5_COMMAND_1="man -k user > /tmp/exam/user_mank.txt"

# Auto-generate HINT from commands if the simulator framework provides _build_hint
if declare -F _build_hint >/dev/null 2>&1; then
    HINT=$(_build_hint)
fi

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

prepare_lab() {
    echo "  • Creating system documentation lab environment..."
    rm -rf /tmp/exam 2>/dev/null
    mkdir -p /tmp/exam/.expected

    # Ensure the whatis/apropos database is available where possible.
    # On minimal systems mandb may not be installed; do not fail setup.
    if command -v mandb >/dev/null 2>&1; then
        mandb -q 2>/dev/null || true
    fi

    # Build reference output on the same system where the lab runs.
    # This avoids package/version differences between RHEL-like systems.
    whatis passwd > /tmp/exam/.expected/passwd_desc.txt 2>/dev/null || true
    apropos passwd > /tmp/exam/.expected/passwd_apropos.txt 2>/dev/null || true
    man passwd 2>/dev/null | head -20 > /tmp/exam/.expected/passwd_man.txt || true
    man 5 passwd 2>/dev/null | head -20 > /tmp/exam/.expected/passwd_section5.txt || true
    man -k user > /tmp/exam/.expected/user_mank.txt 2>/dev/null || true

    echo "  • Lab environment ready"
}

# =============================================================================
# CHECK HELPERS
# =============================================================================

_file_has_content() {
    local file="$1"
    [[ -s "$file" ]]
}

_normalize_for_compare() {
    # Normalize only formatting noise and dates/timestamps.
    # Do not normalize the actual command content.
    local file="$1"

    if command -v col >/dev/null 2>&1; then
        col -b < "$file"
    else
        cat "$file"
    fi | sed -E \
        -e 's/\x1B\[[0-9;]*[A-Za-z]//g' \
        -e 's/[[:space:]]+$//' \
        -e 's/[0-9]{4}-[0-9]{2}-[0-9]{2}/<DATE>/g' \
        -e 's/[0-9]{2}\/[0-9]{2}\/[0-9]{4}/<DATE>/g' \
        -e 's/[0-9]{1,2} [A-Z][a-z]{2,8} [0-9]{4}/<DATE>/g' \
        -e 's/[A-Z][a-z]{2,8} [0-9]{1,2}, [0-9]{4}/<DATE>/g' \
        -e 's/[0-9]{2}:[0-9]{2}(:[0-9]{2})?/<TIME>/g'
}

_compare_output_file() {
    local actual="$1"
    local expected="$2"
    local actual_norm expected_norm

    [[ -f "$actual" && -f "$expected" ]] || return 1

    actual_norm=$(mktemp)
    expected_norm=$(mktemp)

    _normalize_for_compare "$actual" > "$actual_norm"
    _normalize_for_compare "$expected" > "$expected_norm"

    if cmp -s "$actual_norm" "$expected_norm"; then
        rm -f "$actual_norm" "$expected_norm"
        return 0
    fi

    rm -f "$actual_norm" "$expected_norm"
    return 1
}

# =============================================================================
# TASK CHECKS
# =============================================================================

check_tasks() {
    # Task 1: exact content check against whatis passwd reference output.
    if _file_has_content /tmp/exam/passwd_desc.txt \
       && _compare_output_file /tmp/exam/passwd_desc.txt /tmp/exam/.expected/passwd_desc.txt; then
        TASK_STATUS[0]=true
    else
        TASK_STATUS[0]=false
    fi

    # Task 2: exact content check against apropos passwd reference output.
    if _file_has_content /tmp/exam/passwd_apropos.txt \
       && _compare_output_file /tmp/exam/passwd_apropos.txt /tmp/exam/.expected/passwd_apropos.txt; then
        TASK_STATUS[1]=true
    else
        TASK_STATUS[1]=false
    fi

    # Task 3: exact content check against the first 20 lines of man passwd.
    # No MANWIDTH is used in either the task command or reference command.
    if _file_has_content /tmp/exam/passwd_man.txt \
       && _compare_output_file /tmp/exam/passwd_man.txt /tmp/exam/.expected/passwd_man.txt; then
        TASK_STATUS[2]=true
    else
        TASK_STATUS[2]=false
    fi

    # Task 4: exact content check against the first 20 lines of man section 5 passwd.
    if _file_has_content /tmp/exam/passwd_section5.txt \
       && _compare_output_file /tmp/exam/passwd_section5.txt /tmp/exam/.expected/passwd_section5.txt; then
        TASK_STATUS[3]=true
    else
        TASK_STATUS[3]=false
    fi

    # Task 5: exact content check against man -k user reference output.
    # Uses a common keyword instead of partition to avoid dependency on optional disk tools/docs.
    if _file_has_content /tmp/exam/user_mank.txt \
       && _compare_output_file /tmp/exam/user_mank.txt /tmp/exam/.expected/user_mank.txt; then
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
