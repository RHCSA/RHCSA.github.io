#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Set Numeric Permissions

IS_LAB=true
LAB_ID="numeric_perms"

QUESTION="[LAB] Set file permissions using numeric mode"
HINT="Task 1: chmod 755 /tmp/labnumfile.sh\nTask 2: chmod 640 /tmp/labnumprivate.txt"

LAB_TITLE="Set Numeric Permissions"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Set /tmp/labnumfile.sh to 755 (rwxr-xr-x)" ;;
        1) echo "Set /tmp/labnumprivate.txt to 640 (rw-r-----)" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating test files with default permissions...${RESET}"
    echo "#!/bin/bash" > /tmp/labnumfile.sh
    echo "Private data" > /tmp/labnumprivate.txt
    chmod 600 /tmp/labnumfile.sh /tmp/labnumprivate.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if labnumfile.sh has 755
    local perms1=$(stat -c %a /tmp/labnumfile.sh 2>/dev/null)
    if [[ "$perms1" == "755" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if labnumprivate.txt has 640
    local perms2=$(stat -c %a /tmp/labnumprivate.txt 2>/dev/null)
    if [[ "$perms2" == "640" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/labnumfile.sh /tmp/labnumprivate.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
