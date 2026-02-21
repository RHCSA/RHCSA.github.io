#!/bin/bash
# Objective 5: Configure local storage
# LAB: Mount Logical Volume

IS_LAB=true
LAB_ID="mount_lv"

QUESTION="[LAB] Create an LVM filesystem and mount it"
HINT="Task 1: Create LV with XFS (vg_mnt/lv_mnt), mkdir /mnt/lvtest\nTask 2: mount /dev/vg_mnt/lv_mnt /mnt/lvtest"

LAB_TITLE="Mount Logical Volume"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create LV vg_mnt/lv_mnt with XFS and mount point /mnt/lvtest" ;;
        1) echo "Mount the LV at /mnt/lvtest" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous mount lab...${RESET}"
    umount /mnt/lvtest 2>/dev/null
    rm -rf /mnt/lvtest 2>/dev/null
    lvremove -ff /dev/vg_mnt/lv_mnt 2>/dev/null
    vgremove -ff vg_mnt 2>/dev/null
    for dev in $(losetup -j /tmp/mntlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/mntlab.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if mount point exists and LV has filesystem
    if [[ -d /mnt/lvtest ]] && blkid /dev/vg_mnt/lv_mnt 2>/dev/null | grep -q 'TYPE='; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if LV is mounted at /mnt/lvtest
    if mount | grep -q '/dev/mapper/vg_mnt-lv_mnt on /mnt/lvtest'; then
        TASK_STATUS[1]="true"
    elif findmnt /mnt/lvtest &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    umount /mnt/lvtest 2>/dev/null
    rm -rf /mnt/lvtest 2>/dev/null
    lvremove -ff /dev/vg_mnt/lv_mnt 2>/dev/null
    vgremove -ff vg_mnt 2>/dev/null
    for dev in $(losetup -j /tmp/mntlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/mntlab.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
