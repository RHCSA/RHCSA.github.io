#!/bin/bash
# Objective 3: Create simple shell scripts
# LAB: Script with File Test Conditionals

IS_LAB=true
LAB_ID="script_file_test"

QUESTION="[LAB] Create a script that checks if a file exists and is readable"
HINT="Task 1: Create /tmp/filecheck.sh with #!/bin/bash shebang\nTask 2: Use if [ -e file ] and [ -r file ] to check /etc/passwd"

LAB_TITLE="Script with File Test"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/filecheck.sh and make it executable" ;;
        1) echo "Script must test if /etc/passwd exists AND is readable" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous script...${RESET}"
    rm -f /tmp/filecheck.sh 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if script exists and is executable
    if [[ -f /tmp/filecheck.sh ]] && [[ -x /tmp/filecheck.sh ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if script contains file test conditionals
    if grep -q '\-e' /tmp/filecheck.sh 2>/dev/null && grep -q '\-r' /tmp/filecheck.sh 2>/dev/null && \
       grep -q 'if' /tmp/filecheck.sh 2>/dev/null && grep -q '/etc/passwd' /tmp/filecheck.sh 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/filecheck.sh 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
