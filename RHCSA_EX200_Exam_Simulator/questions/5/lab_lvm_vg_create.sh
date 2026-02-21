#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create Volume Group from Loop PV

IS_LAB=true
LAB_ID="lvm_vg_create"

QUESTION="[LAB] Create a volume group named vg_lab using a loop-backed PV"
HINT="Task 1: Create loop device and PV (dd, losetup -f, pvcreate)\nTask 2: vgcreate vg_lab /dev/loopX"

LAB_TITLE="Create Volume Group"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create loop device and initialize as PV" ;;
        1) echo "Create volume group vg_lab using the PV" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous VG lab setup...${RESET}"
    vgremove -ff vg_lab 2>/dev/null
    for dev in $(losetup -j /tmp/vglab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/vglab.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if loop device exists with PV
    local loop_dev=$(losetup -j /tmp/vglab.img 2>/dev/null | cut -d: -f1 | head -1)
    if [[ -n "$loop_dev" ]] && pvs "$loop_dev" &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if vg_lab exists
    if vgs vg_lab &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    vgremove -ff vg_lab 2>/dev/null
    for dev in $(losetup -j /tmp/vglab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/vglab.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
