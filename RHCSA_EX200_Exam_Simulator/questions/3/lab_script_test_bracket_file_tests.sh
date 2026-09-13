#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: File Tests with test and [ ] (the -d operator)

IS_LAB=true
LAB_ID="script_test_bracket_file_tests"

QUESTION="Write a script that checks if a path is a directory using test -d or [ -d ]."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_dir.sh. Use [ -d /tmp/rhcsa_test_dir ] (or the equivalent test -d /tmp/rhcsa_test_dir) to test whether that exact path is a directory, and print 'Directory exists' when true"
TASK_1_HINT="test -d PATH and [ -d PATH ] are equivalent - both check if PATH is a directory"
TASK_1_COMMAND_1="cat > /root/check_dir.sh << 'SCRIPT_END'
#!/bin/bash
if [ -d /tmp/rhcsa_test_dir ]; then
    echo Directory exists
else
    echo Not a directory
fi
SCRIPT_END
chmod +x /root/check_dir.sh"

# Task 2
TASK_2_QUESTION="Confirm the script prints 'Not a directory' when the path is a regular file instead of a directory"
TASK_2_HINT="Replace the directory with a plain file, then run the script again"
TASK_2_COMMAND_1="rm -rf /tmp/rhcsa_test_dir && touch /tmp/rhcsa_test_dir && /root/check_dir.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -rf /root/check_dir.sh /tmp/rhcsa_test_dir
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_dir.sh"
    local target="/tmp/rhcsa_test_dir"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: correctly reports when the path IS a directory
    rm -rf "$target"
    mkdir -p "$target"
    local out_dir
    out_dir=$("$script" 2>/dev/null)
    if echo "$out_dir" | grep -qx "Directory exists"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: correctly reports when the path is NOT a directory
    rm -rf "$target"
    touch "$target"
    local out_file
    out_file=$("$script" 2>/dev/null)
    if echo "$out_file" | grep -qx "Not a directory"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /root/check_dir.sh /tmp/rhcsa_test_dir
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
