#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Sum Numeric Arguments (regex, for, $@)

IS_LAB=true
LAB_ID="script_sum_numeric_args"

QUESTION="Write a script that adds together only its numeric arguments and prints their sum."
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/sum_args.sh. Loop over every argument the script receives, one at a time. For each one, use a regex match against the [0-9] digit class to test whether it is made up only of digits. Add every argument that passes this test to a running total, skip any argument that fails it, and after the loop ends print only the final total. The script must work no matter how many arguments are passed"
TASK_1_HINT="Use a regex match such as an anchored one-or-more-digits pattern to test each argument inside the loop; only add it to the running total when the match succeeds"
TASK_1_COMMAND_1="cat > /root/sum_args.sh << 'SCRIPT_END'
#!/bin/bash
sum=0
for arg in \$@
do
    if [[ \$arg =~ ^[0-9]+$ ]]
    then
        sum=\$((sum + arg))
    fi
done
echo \$sum
SCRIPT_END
chmod +x /root/sum_args.sh"

# Task 2
TASK_2_QUESTION="Run the script with three numeric arguments: 20, 25, and 15. It should print only 60"
TASK_2_HINT="Pass only whole numbers as arguments and confirm the script prints their exact sum"
TASK_2_COMMAND_1="/root/sum_args.sh 20 25 15"

# Task 3
TASK_3_QUESTION="Run the script with a mix of arguments: 7, abc, 3, and hello. It should print only 10, ignoring the two non-numeric arguments"
TASK_3_HINT="Mix words in with numbers and confirm the script adds only the numeric ones, silently skipping the rest"
TASK_3_COMMAND_1="/root/sum_args.sh 7 abc 3 hello"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/sum_args.sh
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/sum_args.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        TASK_STATUS[2]="false"
        return
    fi

    # Task 0: 10, 20, 5 -> 35
    local out1
    out1=$("$script" 10 20 5 2>/dev/null)
    if echo "$out1" | grep -qx "35"; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: 20, 25, 15 -> 60 (proves it is not hardcoded to 35)
    local out2
    out2=$("$script" 20 25 15 2>/dev/null)
    if echo "$out2" | grep -qx "60"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: mix of numeric and non-numeric -> only the numeric ones are summed
    local out3
    out3=$("$script" 7 abc 3 hello 2>/dev/null)
    if echo "$out3" | grep -qx "10"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/sum_args.sh
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
