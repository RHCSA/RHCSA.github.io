#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Return Codes ($?) to Check Command Success
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $?, which the
# CLI's bash-based parser will expand while sourcing (a framework limitation
# - see repo memory). This does NOT affect grading (check_tasks is real
# bash, not a parsed string) or the web UI, which shows/sends it correctly.
# CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_return_codes"

QUESTION="Write a script that checks a command's exit status to decide if it succeeded."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_command.sh. It should run grep to search for a marker inside /tmp/rhcsa_return_code_test.txt, then immediately check whether the exit status of that command was 0, printing 'Command succeeded' if it was or 'Command failed' if it wasn't"
TASK_1_HINT="Run the command first, then check right after it whether the exit status equals 0"
TASK_1_COMMAND_1="cat > /root/check_command.sh << 'SCRIPT_END'
#!/bin/bash
grep -q rhcsa_marker /tmp/rhcsa_return_code_test.txt 2>/dev/null
if [ $? -eq 0 ]; then
    echo Command succeeded
else
    echo Command failed
fi
SCRIPT_END
chmod +x /root/check_command.sh"

# Task 2
TASK_2_QUESTION="Confirm the script prints 'Command failed' when the marker text is not found in the file"
TASK_2_HINT="Put unrelated text in the file, then run the script again"
TASK_2_COMMAND_1="echo something_else > /tmp/rhcsa_return_code_test.txt && /root/check_command.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/check_command.sh /tmp/rhcsa_return_code_test.txt
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_command.sh"
    local target="/tmp/rhcsa_return_code_test.txt"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: marker present -> grep succeeds -> Command succeeded
    echo rhcsa_marker > "$target"
    local out_ok
    out_ok=$("$script" 2>/dev/null)
    if echo "$out_ok" | grep -qx "Command succeeded"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: marker absent -> grep fails -> Command failed
    echo something_else > "$target"
    local out_fail
    out_fail=$("$script" 2>/dev/null)
    if echo "$out_fail" | grep -qx "Command failed"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/check_command.sh /tmp/rhcsa_return_code_test.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
