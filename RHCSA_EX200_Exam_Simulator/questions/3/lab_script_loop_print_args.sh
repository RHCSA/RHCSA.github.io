#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Loop Over Arguments (for, $@, $0)
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $@/$arg/$0, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_loop_print_args"

QUESTION="Write a script that prints each of its arguments on its own line using a for loop, then prints its own name (print the script name)."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/print_args.sh. Use a for loop that steps through every argument the script receives, one at a time, and echo each argument on its own line, in the order given. After the loop, also echo the script's own name as one final line. The script must work no matter how many arguments are passed"
TASK_1_HINT="A for loop can step through every argument a script was given, one at a time; echo the loop variable once per pass. A separate special variable holds the script's own name; echo it once after the loop ends"
TASK_1_COMMAND_1="cat > /root/print_args.sh << 'SCRIPT_END'
#!/bin/bash
for arg in $@
do
    echo $arg
done
echo $0
SCRIPT_END
chmod +x /root/print_args.sh"

# Task 2
TASK_2_QUESTION="Run the script with four arguments: one, two, three, and four. It should print each of them on its own line, in that exact order, followed by the script's own name as the last line"
TASK_2_HINT="Pass several words as separate arguments; the loop should handle any number of them, and the script's name should always appear last, exactly as it was created"
TASK_2_COMMAND_1="/root/print_args.sh one two three four"

# Task 3
TASK_3_QUESTION="Run the script with two different arguments: red and blue. It should print 'red', then 'blue', then the script's own path as the last line"
TASK_3_HINT="Pass a different pair of arguments and confirm the script's own name still appears last"
TASK_3_COMMAND_1="/root/print_args.sh red blue"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/print_args.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/print_args.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        TASK_STATUS[2]="false"
        return
    fi

    # Task 0: two arguments -> two lines, in order, then the script's own name
    local out2
    out2=$("$script" alpha beta 2>/dev/null)
    if [[ "$out2" == $'alpha\nbeta\n'"$script" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: four arguments -> four lines, in order, then the script's own name (proves it is not hardcoded)
    local out4
    out4=$("$script" one two three four 2>/dev/null)
    if [[ "$out4" == $'one\ntwo\nthree\nfour\n'"$script" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: a different pair of arguments -> confirms the script's own name still appears last
    local outname
    outname=$("$script" red blue 2>/dev/null)
    if [[ "$outname" == $'red\nblue\n'"$script" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/print_args.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
