#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Count Arguments ($#)
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $#, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_argument_count"

QUESTION="Write a script that prints the total number of arguments it receives."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/count_args.sh. Have it print the total number of command-line arguments it was given, using the shell's built-in argument count, and nothing else. The script must work no matter how many arguments are passed"
TASK_1_HINT="A special shell variable already holds the number of arguments given to a script; echo that variable directly"
TASK_1_COMMAND_1="cat > /root/count_args.sh << 'SCRIPT_END'
#!/bin/bash
echo $#
SCRIPT_END
chmod +x /root/count_args.sh"

# Task 2
TASK_2_QUESTION="Run the script with five arguments of your choice: it should print 5 and nothing else"
TASK_2_HINT="Pass any five words as separate arguments and confirm the script reports the correct count"
TASK_2_COMMAND_1="/root/count_args.sh a b c d e"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/count_args.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/count_args.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: three arguments -> prints 3
    local out3
    out3=$("$script" x y z 2>/dev/null)
    if echo "$out3" | grep -qx "3"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: five arguments -> prints 5 (proves it is not hardcoded)
    local out5
    out5=$("$script" a b c d e 2>/dev/null)
    if echo "$out5" | grep -qx "5"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/count_args.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
