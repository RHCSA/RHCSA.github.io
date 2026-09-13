#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Logical Operators (-a, -o, !)
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $1/$num, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_logical_operators"

QUESTION="Write a script that classifies a number using the -a, -o, and ! logical operators."

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_combo.sh. It should read a number from its first argument and report three things: whether it is between 1 and 100 (using -a to combine two comparisons), whether it is outside that range (using -o), and whether it is not equal to 50 (using !)"
TASK_1_HINT="[ A -a B ] is true only if both A and B are true; [ A -o B ] is true if either is true; [ ! A ] negates A"
TASK_1_COMMAND_1="cat > /root/check_combo.sh << 'SCRIPT_END'
#!/bin/bash
num=$1
if [ $num -ge 1 -a $num -le 100 ]; then
    echo In range
fi
if [ $num -lt 1 -o $num -gt 100 ]; then
    echo Out of range
fi
if [ ! $num -eq 50 ]; then
    echo Not fifty
fi
SCRIPT_END
chmod +x /root/check_combo.sh"

# Task 2
TASK_2_QUESTION="Run the script with 5 as the argument: it should report 'In range' and 'Not fifty' only"
TASK_2_HINT="5 is between 1 and 100, and is not fifty"
TASK_2_COMMAND_1="/root/check_combo.sh 5"

# Task 3
TASK_3_QUESTION="Run the script with 150 as the argument: it should report 'Out of range' and 'Not fifty' only"
TASK_3_HINT="150 is outside 1-100, and is not fifty"
TASK_3_COMMAND_1="/root/check_combo.sh 150"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/check_combo.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_combo.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        TASK_STATUS[2]="false"
        return
    fi

    # Task 0: 50 is in range and IS fifty (Not fifty must be absent)
    local out50
    out50=$("$script" 50 2>/dev/null)
    if echo "$out50" | grep -qx "In range" \
        && ! echo "$out50" | grep -qx "Out of range" \
        && ! echo "$out50" | grep -qx "Not fifty"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: 5 is in range and not fifty
    local out5
    out5=$("$script" 5 2>/dev/null)
    if echo "$out5" | grep -qx "In range" \
        && echo "$out5" | grep -qx "Not fifty" \
        && ! echo "$out5" | grep -qx "Out of range"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: 150 is out of range and not fifty
    local out150
    out150=$("$script" 150 2>/dev/null)
    if echo "$out150" | grep -qx "Out of range" \
        && echo "$out150" | grep -qx "Not fifty" \
        && ! echo "$out150" | grep -qx "In range"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/check_combo.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
