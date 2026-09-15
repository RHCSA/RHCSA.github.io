#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Convert Case with tr

IS_LAB=true
LAB_ID="script_tr_case_conversion"

QUESTION="Write a script that converts input text to lowercase using tr."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/lowercase.sh. Use read to capture a line of input into a variable, then pipe that variable through tr '[:upper:]' '[:lower:]' to convert any uppercase letters to lowercase, and print the result"
TASK_1_HINT="Read the input into a variable, then pipe it through tr [:upper:] [:lower:]"
TASK_1_COMMAND_1="cat > /root/lowercase.sh << 'SCRIPT_END'
#!/bin/bash
read input
echo \$input | tr '[:upper:]' '[:lower:]'
SCRIPT_END
chmod +x /root/lowercase.sh"

# Task 2
TASK_2_QUESTION="Run the script and enter 'RHCSA Exam' when prompted: it should print 'rhcsa exam'"
TASK_2_HINT="Run the script, type mixed-case text, and press Enter"
TASK_2_COMMAND_1="/root/lowercase.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/lowercase.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/lowercase.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: HELLO World -> hello world
    local out1
    out1=$(echo "HELLO World" | "$script" 2>/dev/null)
    if echo "$out1" | grep -qx "hello world"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: RHCSA Exam -> rhcsa exam (proves it is not hardcoded)
    local out2
    out2=$(echo "RHCSA Exam" | "$script" 2>/dev/null)
    if echo "$out2" | grep -qx "rhcsa exam"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/lowercase.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
