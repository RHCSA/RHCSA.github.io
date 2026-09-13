#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Permanently Add an Environment Variable (/etc/bashrc)
# NOTE ON HINT TEXT: TASK_2_COMMAND_1 below contains a literal $EXAM, which
# the CLI's bash-based parser will expand while sourcing (a framework
# limitation - see repo memory). This does NOT affect grading (check_tasks
# is real bash, not a parsed string) or the web UI, which shows/sends it
# correctly. CLI users may see a slightly different hint text for this task.
# NOTE: this lab edits the real /etc/bashrc; prepare_lab/cleanup_lab remove
# only the exact line this lab adds, restoring the file afterward.

IS_LAB=true
LAB_ID="script_persistent_env_var"

QUESTION="Permanently set an environment variable for every new shell."

# Lab configuration
LAB_TASK_COUNT=2

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Append a line to /etc/bashrc that exports the environment variable EXAM with the value RHCSA, for example export EXAM=RHCSA, so that every new shell session has it set automatically"
TASK_1_HINT="Use export VAR=value and append it to /etc/bashrc so it applies to every new shell"
TASK_1_COMMAND_1="cat >> /etc/bashrc << 'SCRIPT_END'
export EXAM=RHCSA
SCRIPT_END"

# Task 2
TASK_2_QUESTION="Confirm a brand new shell actually has EXAM set to RHCSA, not just that the line exists in the file"
TASK_2_HINT="Open a new interactive shell and check the value of EXAM in it"
TASK_2_COMMAND_1="bash -ic 'echo $EXAM'"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    sed -i '/EXAM=RHCSA/d' /etc/bashrc 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: the export line exists in /etc/bashrc
    if grep -q 'EXAM=RHCSA' /etc/bashrc 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: a fresh interactive shell actually has EXAM set to RHCSA
    local value
    value=$(bash -ic 'echo $EXAM' 2>/dev/null | tail -n 1)
    if [[ "$value" == "RHCSA" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    sed -i '/EXAM=RHCSA/d' /etc/bashrc 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
