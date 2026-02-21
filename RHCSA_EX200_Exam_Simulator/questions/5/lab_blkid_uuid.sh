#!/bin/bash
# Objective 5: Configure local storage
# LAB: Find UUID with blkid

IS_LAB=true
LAB_ID="blkid_uuid"

QUESTION="[LAB] Display block device UUIDs using blkid"
HINT="Task 1: blkid > /tmp/all-uuids.txt\nTask 2: blkid -o list > /tmp/blkid-list.txt"

LAB_TITLE="Find UUID with blkid"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save all block device UUIDs to /tmp/all-uuids.txt" ;;
        1) echo "Save blkid list format to /tmp/blkid-list.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/all-uuids.txt /tmp/blkid-list.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if all-uuids.txt exists with UUID info
    if [[ -f /tmp/all-uuids.txt ]] && grep -qiE 'UUID|TYPE' /tmp/all-uuids.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if blkid-list.txt exists
    if [[ -f /tmp/blkid-list.txt ]] && [[ -s /tmp/blkid-list.txt ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/all-uuids.txt /tmp/blkid-list.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
