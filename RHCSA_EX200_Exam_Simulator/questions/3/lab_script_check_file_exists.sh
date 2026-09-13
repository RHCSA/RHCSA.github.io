#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Check if a File Exists (the -e test operator)

IS_LAB=true
LAB_ID="script_check_file_exists"

QUESTION="Write a script that checks if a file exists using the -e test."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_file.sh. Use [ -e /tmp/rhcsa_script_target.txt ] to test whether that exact file exists, and print 'File exists' when the test is true"
TASK_1_HINT="Write the if/-e logic, then chmod +x the script so it can run directly as ./check_file.sh"
TASK_1_COMMAND_1="cat > /root/check_file.sh << 'SCRIPT_END'
#!/bin/bash
if [ -e /tmp/rhcsa_script_target.txt ]; then
    echo File exists
else
    echo File does not exist
fi
SCRIPT_END
chmod +x /root/check_file.sh"

# Task 2
TASK_2_QUESTION="Confirm the script prints 'File does not exist' when the target file is absent (the else branch)"
TASK_2_HINT="Remove the target file, then run ./check_file.sh again to see the else branch"
TASK_2_COMMAND_1="rm -f /tmp/rhcsa_script_target.txt && /root/check_file.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/check_file.sh /tmp/rhcsa_script_target.txt
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_file.sh"
    local target="/tmp/rhcsa_script_target.txt"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: script must be executable (run directly, not via bash) and
    # correctly report an existing file
    touch "$target"
    local out_exists
    out_exists=$("$script" 2>/dev/null)
    if echo "$out_exists" | grep -q "File exists"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: script correctly reports a missing file
    rm -f "$target"
    local out_missing
    out_missing=$("$script" 2>/dev/null)
    if echo "$out_missing" | grep -q "File does not exist"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/check_file.sh /tmp/rhcsa_script_target.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
