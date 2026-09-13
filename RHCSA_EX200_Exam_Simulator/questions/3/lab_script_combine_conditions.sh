#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Combining Conditions in a Script (-f and -r together)
# Rounds out the standard file tests (-e and -d already have their own
# labs) and combines two conditions with && - deliberately avoids -a/-o/!/$?/=
# since those already have dedicated labs elsewhere in this objective.

IS_LAB=true
LAB_ID="script_combine_conditions"

QUESTION="Write a script that checks if a file is both a regular file and readable."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_readable.sh. Combine two tests with && so both must be true: -f to check that /tmp/rhcsa_ready_file.txt is a regular file, and -r to check that it is readable. Print 'File is ready' when both are true, or 'File is not ready' otherwise"
TASK_1_HINT="[ -f FILE ] && [ -r FILE ] - both must succeed for the file to be ready"
TASK_1_COMMAND_1="cat > /root/check_readable.sh << 'SCRIPT_END'
#!/bin/bash
if [ -f /tmp/rhcsa_ready_file.txt ] && [ -r /tmp/rhcsa_ready_file.txt ]; then
    echo File is ready
else
    echo File is not ready
fi
SCRIPT_END
chmod +x /root/check_readable.sh"

# Task 2
TASK_2_QUESTION="Confirm the script prints 'File is not ready' when the target file does not exist"
TASK_2_HINT="Remove the file, then run the script again"
TASK_2_COMMAND_1="rm -f /tmp/rhcsa_ready_file.txt && /root/check_readable.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/check_readable.sh /tmp/rhcsa_ready_file.txt
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_readable.sh"
    local target="/tmp/rhcsa_ready_file.txt"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: file exists and is readable -> File is ready
    echo data > "$target"
    chmod +r "$target"
    local out_ready
    out_ready=$("$script" 2>/dev/null)
    if echo "$out_ready" | grep -qx "File is ready"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: file absent -> File is not ready
    rm -f "$target"
    local out_missing
    out_missing=$("$script" 2>/dev/null)
    if echo "$out_missing" | grep -qx "File is not ready"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/check_readable.sh /tmp/rhcsa_ready_file.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
