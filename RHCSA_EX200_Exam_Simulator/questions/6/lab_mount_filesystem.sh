#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Mount Filesystem

IS_LAB=true
LAB_ID="mount_filesystem"

QUESTION="[LAB] Create a filesystem and mount it to a directory"
HINT="Task 1: Create loop device with XFS: dd, losetup -f, mkfs.xfs, mkdir /mnt/labfs\nTask 2: mount /dev/loopX /mnt/labfs"

LAB_TITLE="Mount Filesystem"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create loop device with XFS and mount point /mnt/labfs" ;;
        1) echo "Mount the filesystem at /mnt/labfs" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous lab setup...${RESET}"
    umount /mnt/labfs 2>/dev/null
    rm -rf /mnt/labfs 2>/dev/null
    for dev in $(losetup -j /tmp/mounttest.img 2>/dev/null | cut -d: -f1); do
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/mounttest.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if mount point and filesystem exist
    local loop_dev=$(losetup -j /tmp/mounttest.img 2>/dev/null | cut -d: -f1 | head -1)
    if [[ -d /mnt/labfs ]] && [[ -n "$loop_dev" ]] && blkid "$loop_dev" 2>/dev/null | grep -q 'TYPE='; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if filesystem is mounted at /mnt/labfs
    if findmnt /mnt/labfs &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    umount /mnt/labfs 2>/dev/null
    rm -rf /mnt/labfs 2>/dev/null
    for dev in $(losetup -j /tmp/mounttest.img 2>/dev/null | cut -d: -f1); do
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/mounttest.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
