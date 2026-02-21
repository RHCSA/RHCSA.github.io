#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create fstab Entry Template

IS_LAB=true
LAB_ID="fstab_entry"

QUESTION="[LAB] Create an fstab entry template file with proper format"
HINT="Task 1: echo 'UUID=xxxx /mnt/data xfs defaults 0 0' > /tmp/fstab-template.txt\nTask 2: Add a LABEL entry with LABEL=DATA /mnt/backup ext4 defaults 0 2"

LAB_TITLE="Create fstab Entry Template"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create /tmp/fstab-template.txt with UUID mount entry" ;;
        1) echo "Add LABEL mount entry to the file" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/fstab-template.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if file contains UUID entry
    if [[ -f /tmp/fstab-template.txt ]] && grep -qE '^UUID=' /tmp/fstab-template.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if file contains LABEL entry
    if [[ -f /tmp/fstab-template.txt ]] && grep -qE '^LABEL=' /tmp/fstab-template.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/fstab-template.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
