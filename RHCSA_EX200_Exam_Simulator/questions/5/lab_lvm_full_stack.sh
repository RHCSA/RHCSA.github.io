#!/bin/bash
# Objective 5: Configure local storage
# LAB: Complete LVM Stack Creation

IS_LAB=true
LAB_ID="lvm_full_stack"

QUESTION="[LAB] Create complete LVM stack: loop device, PV, VG, LV with XFS filesystem"
HINT="Task 1: Create 300MB loop, pvcreate, vgcreate vg_full, lvcreate -L 100M -n lv_full vg_full\nTask 2: mkfs.xfs /dev/vg_full/lv_full"

LAB_TITLE="Complete LVM Stack"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create loop device, PV, VG vg_full, and LV lv_full" ;;
        1) echo "Create XFS filesystem on the logical volume" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous full stack lab...${RESET}"
    umount /dev/vg_full/lv_full 2>/dev/null
    lvremove -ff /dev/vg_full/lv_full 2>/dev/null
    vgremove -ff vg_full 2>/dev/null
    for dev in $(losetup -j /tmp/fullstack.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/fullstack.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if LV exists
    if lvs /dev/vg_full/lv_full &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if XFS filesystem exists on LV
    if blkid /dev/vg_full/lv_full 2>/dev/null | grep -q 'TYPE="xfs"'; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    umount /dev/vg_full/lv_full 2>/dev/null
    lvremove -ff /dev/vg_full/lv_full 2>/dev/null
    vgremove -ff vg_full 2>/dev/null
    for dev in $(losetup -j /tmp/fullstack.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/fullstack.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
