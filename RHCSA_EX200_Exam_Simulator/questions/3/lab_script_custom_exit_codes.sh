#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Custom Exit Codes
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $1, which the
# CLI's bash-based parser will expand while sourcing (a framework limitation
# - see repo memory). This does NOT affect grading (check_tasks is real
# bash, not a parsed string) or the web UI, which shows/sends it correctly.
# CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_custom_exit_codes"

QUESTION="Write a script that exits with different custom status codes based on a condition."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_exit.sh. It should read a number from its first argument: if the number is greater than 10, exit with status 100; otherwise, exit with status 1000. Note that exit statuses only go up to 255, so exit 1000 will actually be observed as 232 when checked"
TASK_1_HINT="if condition; then exit 100; else exit 1000; fi - use -gt to compare the argument to 10"
TASK_1_COMMAND_1="cat > /root/check_exit.sh << 'SCRIPT_END'
#!/bin/bash
if [ $1 -gt 10 ]; then
    exit 100
else
    exit 1000
fi
SCRIPT_END
chmod +x /root/check_exit.sh"

# Task 2
TASK_2_QUESTION="Confirm the exit status is 232 (the wrapped form of 1000) when the argument is 10 or less"
TASK_2_HINT="Run the script with a small number, then check the exit status of that last command"
TASK_2_COMMAND_1="/root/check_exit.sh 5"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/check_exit.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_exit.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: called with 20 (>10) -> exit status 100
    "$script" 20 2>/dev/null
    if [ $? -eq 100 ]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: called with 5 (<=10) -> exit 1000, observed as 232 after wraparound
    "$script" 5 2>/dev/null
    if [ $? -eq 232 ]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/check_exit.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
