#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Reading User Input (read -p)
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $name, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_read_input"

QUESTION="Write a script that prompts for a name and echoes a greeting."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/greet.sh. Use read -p with a prompt such as Name: to read a name into a variable, then echo a greeting that includes that name, for example Hello followed by the entered name"
TASK_1_HINT="read -p followed by a prompt string reads user input into a variable; then echo a greeting using that variable"
TASK_1_COMMAND_1="cat > /root/greet.sh << 'SCRIPT_END'
#!/bin/bash
read -p 'Name: ' name
echo Hello $name
SCRIPT_END
chmod +x /root/greet.sh"

# Task 2
TASK_2_QUESTION="Run the script and enter 'Bob' when prompted: it should print 'Hello Bob'"
TASK_2_HINT="Run the script, type a name at the prompt, and press Enter"
TASK_2_COMMAND_1="/root/greet.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/greet.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/greet.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: entering Alice should print Hello Alice
    local out_alice
    out_alice=$(echo "Alice" | "$script" 2>/dev/null)
    if echo "$out_alice" | grep -qx "Hello Alice"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: entering Bob should print Hello Bob (proves it is not hardcoded)
    local out_bob
    out_bob=$(echo "Bob" | "$script" 2>/dev/null)
    if echo "$out_bob" | grep -qx "Hello Bob"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/greet.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
