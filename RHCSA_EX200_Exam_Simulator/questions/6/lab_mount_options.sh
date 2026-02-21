#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Mount with Options

IS_LAB=true
LAB_ID="mount_options"

QUESTION="[LAB] Mount a filesystem with specific mount options"
HINT="Task 1: Create loop device with ext4, mkdir /mnt/labopts\nTask 2: mount -o ro,noexec /dev/loopX /mnt/labopts"

LAB_TITLE="Mount with Options"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create loop device with ext4 and mount point /mnt/labopts" ;;
        1) echo "Mount with read-only and noexec options" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab setup...${RESET}"
    umount /mnt/labopts 2>/dev/null
    rm -rf /mnt/labopts 2>/dev/null
    for dev in $(losetup -j /tmp/optstest.img 2>/dev/null | cut -d: -f1); do
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/optstest.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if mount point and filesystem exist
    local loop_dev=$(losetup -j /tmp/optstest.img 2>/dev/null | cut -d: -f1 | head -1)
    if [[ -d /mnt/labopts ]] && [[ -n "$loop_dev" ]] && blkid "$loop_dev" 2>/dev/null | grep -q 'TYPE='; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if mounted with ro and noexec
    if findmnt /mnt/labopts 2>/dev/null | grep -qE 'ro.*noexec|noexec.*ro'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    umount /mnt/labopts 2>/dev/null
    rm -rf /mnt/labopts 2>/dev/null
    for dev in $(losetup -j /tmp/optstest.img 2>/dev/null | cut -d: -f1); do
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/optstest.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
