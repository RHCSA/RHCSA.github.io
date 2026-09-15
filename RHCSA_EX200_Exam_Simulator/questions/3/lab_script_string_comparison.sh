#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: String Comparisons (=, !=) and -z / -n
# NOTE: uses [[ ]] instead of [ ] specifically so empty/unset arguments can be
# tested safely without needing quotes around the variable (a framework
# limitation makes embedded quotes in these fields unreliable - see repo
# memory). [[ ]] is standard, widely-accepted bash and behaves identically
# here to a properly-quoted [ ] test.

IS_LAB=true
LAB_ID="script_string_comparison"

QUESTION="Write a script that compares an input string to 'admin' using =, !=, -z, and -n."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/check_string.sh. It should read a username from its first argument: if the argument is empty, use -z to print 'No value provided'. If it is not empty, use -n together with = and != to compare the value to 'admin', printing 'Username matches' or 'Username does not match'"
TASK_1_HINT="Use -z for empty, -n for non-empty, then = or != to compare the value to admin"
TASK_1_COMMAND_1="cat > /root/check_string.sh << 'SCRIPT_END'
#!/bin/bash
name=\$1
if [[ -z \$name ]]; then
    echo No value provided
elif [[ -n \$name ]]; then
    if [[ \$name = admin ]]; then
        echo Username matches
    elif [[ \$name != admin ]]; then
        echo Username does not match
    fi
fi
SCRIPT_END
chmod +x /root/check_string.sh"

# Task 2
TASK_2_QUESTION="Run the script with 'admin' as the argument: it should print 'Username matches'"
TASK_2_HINT="Pass admin as the first argument"
TASK_2_COMMAND_1="/root/check_string.sh admin"

# Task 3
TASK_3_QUESTION="Run the script with 'guest' as the argument: it should print 'Username does not match'"
TASK_3_HINT="Pass any value other than admin as the first argument"
TASK_3_COMMAND_1="/root/check_string.sh guest"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/check_string.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/check_string.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        TASK_STATUS[2]="false"
        return
    fi

    # Task 0: no argument -> No value provided
    local out_empty
    out_empty=$("$script" 2>/dev/null)
    if echo "$out_empty" | grep -qx "No value provided"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: admin -> Username matches
    local out_admin
    out_admin=$("$script" admin 2>/dev/null)
    if echo "$out_admin" | grep -qx "Username matches"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: guest -> Username does not match
    local out_guest
    out_guest=$("$script" guest 2>/dev/null)
    if echo "$out_guest" | grep -qx "Username does not match"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/check_string.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
