#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Print the First Argument ($1)
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $1, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_first_argument"

QUESTION="Write a script that prints only its first argument, ignoring the rest."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/first_arg.sh. Have it print only its first command-line argument, ignoring any other arguments it may receive"
TASK_1_HINT="The first command-line argument is available directly as its own variable. This is different from the variable that holds the script's own name, so echo the argument variable, not the name variable"
TASK_1_COMMAND_1="cat > /root/first_arg.sh << 'SCRIPT_END'
#!/bin/bash
echo $1
SCRIPT_END
chmod +x /root/first_arg.sh"

# Task 2
TASK_2_QUESTION="Run the script with three arguments: first, second, and third. It should print only 'first'"
TASK_2_HINT="Pass several arguments and confirm only the first one is printed, with the rest ignored"
TASK_2_COMMAND_1="/root/first_arg.sh first second third"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/first_arg.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/first_arg.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: first, second, third -> prints only "first"
    local out1
    out1=$("$script" first second third 2>/dev/null)
    if echo "$out1" | grep -qx "first"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: different words -> prints only "red" (proves it is not hardcoded or using the script name)
    local out2
    out2=$("$script" red green blue yellow 2>/dev/null)
    if echo "$out2" | grep -qx "red"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/first_arg.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
