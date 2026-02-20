#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Error Redirection

# This is a LAB exercise
IS_LAB=true
LAB_ID="error_redirection"

QUESTION="[LAB] Run /tmp/testscript.sh and redirect stdout to one file and stderr to another"
HINT="This lab has 3 tasks:\n\n1. Run the test script with separated output:\n   /tmp/testscript.sh > /tmp/output.txt 2> /tmp/errors.txt\n\n2. stdout (SUCCESS) goes to /tmp/output.txt\n\n3. stderr (ERROR) goes to /tmp/errors.txt\n\nTip: > = stdout, 2> = stderr."

# Lab configuration
LAB_TITLE="Error Redirection (2>)"
LAB_TASK_COUNT=3

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Run /tmp/testscript.sh with output redirection" ;;
        1) echo "Redirect stdout to /tmp/output.txt (contains SUCCESS)" ;;
        2) echo "Redirect stderr to /tmp/errors.txt (contains ERROR)" ;;
    esac
}

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
