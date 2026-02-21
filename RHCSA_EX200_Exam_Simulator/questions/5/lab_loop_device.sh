#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create Loop Device for Testing

IS_LAB=true
LAB_ID="loop_device"

QUESTION="[LAB] Create a file-backed loop device for storage testing"
HINT="Task 1: dd if=/dev/zero of=/tmp/labdisk.img bs=1M count=100\nTask 2: losetup /dev/loop99 /tmp/labdisk.img (use losetup -f for auto)"

LAB_TITLE="Create Loop Device"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create 100MB disk image at /tmp/labdisk.img" ;;
        1) echo "Attach image as loop device" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous loop devices...${RESET}"
    losetup -d /dev/loop99 2>/dev/null
    for dev in $(losetup -j /tmp/labdisk.img 2>/dev/null | cut -d: -f1); do
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/labdisk.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if labdisk.img exists with correct size
    if [[ -f /tmp/labdisk.img ]]; then
        local size=$(stat -c %s /tmp/labdisk.img 2>/dev/null)
        if [[ "$size" -ge 100000000 ]]; then
            TASK_STATUS[0]="true"
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if loop device is attached
    if losetup -j /tmp/labdisk.img 2>/dev/null | grep -q '/tmp/labdisk.img'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    for dev in $(losetup -j /tmp/labdisk.img 2>/dev/null | cut -d: -f1); do
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/labdisk.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
