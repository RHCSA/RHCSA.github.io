#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Error Redirection

# This is a LAB exercise
IS_LAB=true
LAB_ID="error_redirection"

QUESTION="Run /tmp/testscript.sh and redirect stdout to one file and stderr to another"

# Lab configuration
LAB_TASK_COUNT=3

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Run /tmp/testscript.sh with output redirection"
TASK_1_HINT="Run script with > for stdout and 2> for stderr"
TASK_1_COMMAND_1="/tmp/testscript.sh > /tmp/output.txt 2> /tmp/errors.txt"

# Task 2
TASK_2_QUESTION="Redirect stdout to /tmp/output.txt (contains SUCCESS)"
TASK_2_HINT="Use > to redirect stdout (file descriptor 1)"
TASK_2_COMMAND_1="/tmp/testscript.sh > /tmp/output.txt 2> /tmp/errors.txt"

# Task 3
TASK_3_QUESTION="Redirect stderr to /tmp/errors.txt (contains ERROR)"
TASK_3_HINT="Use 2> to redirect stderr (file descriptor 2)"
TASK_3_COMMAND_1="/tmp/testscript.sh > /tmp/output.txt 2> /tmp/errors.txt"


# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM} Creating test script...${RESET}"
    cat > /tmp/testscript.sh << 'SCRIPT'
#!/bin/bash
echo "SUCCESS: This is standard output"
echo "ERROR: This is standard error" >&2
SCRIPT
    chmod +x /tmp/testscript.sh
    sleep 0.3
    
    echo -e "  ${DIM} Removing existing output files...${RESET}"
    rm -f /tmp/output.txt /tmp/errors.txt 2>/dev/null
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check if both files exist (script was run with redirection)
    if [[ -f /tmp/output.txt ]] && [[ -f /tmp/errors.txt ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if output.txt contains SUCCESS (stdout)
    if grep -q "SUCCESS" /tmp/output.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
    
    # Task 2: Check if errors.txt contains ERROR (stderr)
    if grep -q "ERROR" /tmp/errors.txt 2>/dev/null; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM} Cleaning up lab environment...${RESET}"
    rm -f /tmp/testscript.sh /tmp/output.txt /tmp/errors.txt 2>/dev/null
    echo -e "  ${GREEN} Lab environment cleaned up${RESET}"
    sleep 1
}
