#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Count with a While Loop
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $x, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_while_count_to_5"

QUESTION="Write a script that prints the numbers 1 through 5, each on its own line, using a while loop."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/count_to_5.sh. Set a counter variable to 1, then use a while loop that continues as long as the counter is less than or equal to 5. On each pass, print the counter's current value on its own line, then increase the counter by 1 before the loop checks again"
TASK_1_HINT="Initialize a counter at 1; the while condition tests it with -le 5; echo the counter each pass, then increment it with arithmetic expansion before the loop repeats"
TASK_1_COMMAND_1="cat > /root/count_to_5.sh << 'SCRIPT_END'
#!/bin/bash
x=1
while [ $x -le 5 ]
do
    echo $x
    x=$(( x + 1 ))
done
SCRIPT_END
chmod +x /root/count_to_5.sh"

# Task 2
TASK_2_QUESTION="Run the script: it should print 1, 2, 3, 4, and 5, each on its own line, and stop right after 5"
TASK_2_HINT="Run the script directly and confirm it counts from 1 up to 5 and then stops, with no extra lines"
TASK_2_COMMAND_1="/root/count_to_5.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/count_to_5.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/count_to_5.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    local out
    out=$("$script" 2>/dev/null)

    # Task 0: the five numbers appear in order, with no extra text
    if [[ "$out" == $'1\n2\n3\n4\n5' ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: exactly five lines of output (catches off-by-one loop bounds)
    local line_count
    line_count=$(echo "$out" | wc -l)
    if [[ "$line_count" -eq 5 ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/count_to_5.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
