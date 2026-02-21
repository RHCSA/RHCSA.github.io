#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Create VFAT Filesystem

IS_LAB=true
LAB_ID="create_vfat_fs"

QUESTION="[LAB] Create a VFAT (FAT32) filesystem on a loop device"
HINT="Task 1: dd if=/dev/zero of=/tmp/vfattest.img bs=1M count=100 && losetup -f /tmp/vfattest.img\nTask 2: mkfs.vfat -F 32 /dev/loopX"

LAB_TITLE="Create VFAT Filesystem"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create 100MB image and attach as loop device" ;;
        1) echo "Create VFAT filesystem on the loop device" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab setup...${RESET}"
    for dev in $(losetup -j /tmp/vfattest.img 2>/dev/null | cut -d: -f1); do
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/vfattest.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if loop device is attached
    if losetup -j /tmp/vfattest.img 2>/dev/null | grep -q '/tmp/vfattest.img'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if VFAT filesystem exists on the loop device
    local loop_dev=$(losetup -j /tmp/vfattest.img 2>/dev/null | cut -d: -f1 | head -1)
    if [[ -n "$loop_dev" ]] && blkid "$loop_dev" 2>/dev/null | grep -qE 'TYPE="vfat"|TYPE="fat"'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    for dev in $(losetup -j /tmp/vfattest.img 2>/dev/null | cut -d: -f1); do
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/vfattest.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
