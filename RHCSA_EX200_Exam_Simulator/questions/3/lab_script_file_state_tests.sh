#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: File Tests -w (writable), -x (executable), -s (not empty)
# Rounds out the standard file tests alongside -e, -d, -f, -r (each already
# covered by their own labs in this objective).

IS_LAB=true
LAB_ID="script_file_state_tests"

QUESTION="Write a script that reports whether a file is executable, writable, and non-empty."

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_file_state.sh. Add one if block for each test against /tmp/rhcsa_state_file.txt: -x should echo 'Executable', -w should echo 'Writable', and -s should echo 'Has content', each only when that specific test is true"
TASK_1_HINT="Three separate if blocks: [ -x FILE ] echoes Executable, [ -w FILE ] echoes Writable, [ -s FILE ] echoes Has content"
TASK_1_COMMAND_1="cat > /root/check_file_state.sh << 'SCRIPT_END'
#!/bin/bash
if [ -x /tmp/rhcsa_state_file.txt ]; then
    echo Executable
fi
if [ -w /tmp/rhcsa_state_file.txt ]; then
    echo Writable
fi
if [ -s /tmp/rhcsa_state_file.txt ]; then
    echo Has content
fi
SCRIPT_END
chmod +x /root/check_file_state.sh"

# Task 2
TASK_2_QUESTION="Confirm the script prints 'Executable' once the target file itself is made executable"
TASK_2_HINT="chmod +x the target file, then run the script again"
TASK_2_COMMAND_1="chmod +x /tmp/rhcsa_state_file.txt && /root/check_file_state.sh"

# Task 3
TASK_3_QUESTION="Confirm the script does not print 'Has content' once the target file is emptied"
TASK_3_HINT="Truncate the file to zero bytes, then run the script again"
TASK_3_COMMAND_1=": > /tmp/rhcsa_state_file.txt && /root/check_file_state.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/check_file_state.sh /tmp/rhcsa_state_file.txt
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_file_state.sh"
    local target="/tmp/rhcsa_state_file.txt"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        TASK_STATUS[2]="false"
        return
    fi

    # Task 0: non-empty, non-executable file -> Writable + Has content, no Executable
    echo data > "$target"
    chmod 644 "$target"
    local out1
    out1=$("$script" 2>/dev/null)
    if echo "$out1" | grep -qx "Writable" \
        && echo "$out1" | grep -qx "Has content" \
        && ! echo "$out1" | grep -qx "Executable"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: same file made executable -> Executable now appears too
    chmod 744 "$target"
    local out2
    out2=$("$script" 2>/dev/null)
    if echo "$out2" | grep -qx "Executable"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: file truncated to empty -> Has content must be absent
    : > "$target"
    chmod 644 "$target"
    local out3
    out3=$("$script" 2>/dev/null)
    if ! echo "$out3" | grep -qx "Has content"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/check_file_state.sh /tmp/rhcsa_state_file.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
