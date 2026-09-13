#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Count Lines Per File (for, command substitution)
# NOTE ON HINT TEXT: TASK_1_COMMAND_1 below contains a literal $FILE, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.

IS_LAB=true
LAB_ID="script_count_lines_per_file"

QUESTION="Write a script that prints the line count of every file in the current directory."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an executable script at /root/count_lines.sh. Have it loop over the names of the files in the current directory, and for each one print a line such as: Line count of notes.txt is 12, where the number comes from counting that file's lines with wc -l"
TASK_1_HINT="Loop over the output of ls; for each file name, use a command substitution with cat piped into wc -l to get its line count, then echo the file name and count together on one line"
TASK_1_COMMAND_1="cat > /root/count_lines.sh << 'SCRIPT_END'
#!/bin/bash
for FILE in $(ls)
do
    echo Line count of $FILE is $(cat $FILE | wc -l)
done
SCRIPT_END
chmod +x /root/count_lines.sh"

# Task 2
TASK_2_QUESTION="Change into /root/linecount_lab2 and run the script from there. For its two files, it should report a line count of 5 for apple.txt and 2 for banana.txt"
TASK_2_HINT="cd into the directory first, since the script lists whatever the current directory happens to be, then run the script directly"
TASK_2_COMMAND_1="cd /root/linecount_lab2 && /root/count_lines.sh"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -f /root/count_lines.sh
    rm -rf /root/linecount_lab1 /root/linecount_lab2
    mkdir -p /root/linecount_lab1 /root/linecount_lab2
    printf '1\n2\n3\n' > /root/linecount_lab1/alpha.txt
    printf 'x\n' > /root/linecount_lab1/beta.txt
    printf '1\n2\n3\n4\n5\n' > /root/linecount_lab2/apple.txt
    printf 'a\nb\n' > /root/linecount_lab2/banana.txt
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local script="/root/count_lines.sh"

    if [[ ! -f "$script" ]]; then
        TASK_STATUS[0]="false"
        TASK_STATUS[1]="false"
        return
    fi

    # Task 0: run inside linecount_lab1 (alpha.txt=3 lines, beta.txt=1 line)
    local out1
    out1=$(cd /root/linecount_lab1 && "$script" 2>/dev/null)
    if [[ "$out1" == $'Line count of alpha.txt is 3\nLine count of beta.txt is 1' ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: run inside linecount_lab2 (apple.txt=5, banana.txt=2; proves it is not hardcoded)
    local out2
    out2=$(cd /root/linecount_lab2 && "$script" 2>/dev/null)
    if [[ "$out2" == $'Line count of apple.txt is 5\nLine count of banana.txt is 2' ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /root/count_lines.sh
    rm -rf /root/linecount_lab1 /root/linecount_lab2
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
