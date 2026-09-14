#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Numeric Comparisons (-eq, -ne, -lt, -le, -gt, -ge)
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $1/$num, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_numeric_comparison"

QUESTION="Write a script that compares a number to 10 using all six numeric test operators."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_number.sh. Store its first command-line argument in a variable, then use each of -eq, -ne, -lt, -le, -gt, and -ge to compare that number to 10, printing one message for every comparison that is true"
TASK_1_HINT="Use test/[ ] once per operator, e.g. if the value is less than 10, greater than 10, etc."
TASK_1_COMMAND_1="cat > /root/check_number.sh << 'SCRIPT_END'
#!/bin/bash
num=$1
if [ $num -eq 10 ]; then
    echo Equal to 10
fi
if [ $num -ne 10 ]; then
    echo Not equal to 10
fi
if [ $num -lt 10 ]; then
    echo Less than 10
fi
if [ $num -le 10 ]; then
    echo Less than or equal to 10
fi
if [ $num -gt 10 ]; then
    echo Greater than 10
fi
if [ $num -ge 10 ]; then
    echo Greater than or equal to 10
fi
SCRIPT_END
chmod +x /root/check_number.sh"

# Task 2
TASK_2_QUESTION="Run the script with 10 as the argument: it should report equal, less-than-or-equal, and greater-than-or-equal to 10 (and nothing else)"
TASK_2_HINT="Test the equal case first, since it is the trickiest of the six operators"
TASK_2_COMMAND_1="/root/check_number.sh 10"

# Task 3
TASK_3_QUESTION="Run the script with 15 as the argument: it should report not-equal, greater-than, and greater-than-or-equal to 10"
TASK_3_HINT="Test a value above 10 to exercise the greater-than family of operators"
TASK_3_COMMAND_1="/root/check_number.sh 15"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/check_number.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_number.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        TASK_STATUS[2]="false"
        return
    fi

    # Task 0: called with 5 (less than 10)
    local out5
    out5=$("$script" 5 2>/dev/null)
    if echo "$out5" | grep -qx "Not equal to 10" \
        && echo "$out5" | grep -qx "Less than 10" \
        && echo "$out5" | grep -qx "Less than or equal to 10" \
        && ! echo "$out5" | grep -qx "Equal to 10" \
        && ! echo "$out5" | grep -qx "Greater than 10" \
        && ! echo "$out5" | grep -qx "Greater than or equal to 10"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: called with 10 (equal to 10)
    local out10
    out10=$("$script" 10 2>/dev/null)
    if echo "$out10" | grep -qx "Equal to 10" \
        && echo "$out10" | grep -qx "Less than or equal to 10" \
        && echo "$out10" | grep -qx "Greater than or equal to 10" \
        && ! echo "$out10" | grep -qx "Not equal to 10" \
        && ! echo "$out10" | grep -qx "Less than 10" \
        && ! echo "$out10" | grep -qx "Greater than 10"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: called with 15 (greater than 10)
    local out15
    out15=$("$script" 15 2>/dev/null)
    if echo "$out15" | grep -qx "Not equal to 10" \
        && echo "$out15" | grep -qx "Greater than 10" \
        && echo "$out15" | grep -qx "Greater than or equal to 10" \
        && ! echo "$out15" | grep -qx "Equal to 10" \
        && ! echo "$out15" | grep -qx "Less than 10" \
        && ! echo "$out15" | grep -qx "Less than or equal to 10"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/check_number.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
