#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create Logical Volume

IS_LAB=true
LAB_ID="lvm_lv_create"

QUESTION="[LAB] Create a logical volume named lv_test in vg_labtest"
HINT="Task 1: Set up loop, PV, VG vg_labtest (dd, losetup, pvcreate, vgcreate)\nTask 2: lvcreate -L 50M -n lv_test vg_labtest"

LAB_TITLE="Create Logical Volume"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create loop device, PV, and VG vg_labtest" ;;
        1) echo "Create 50MB logical volume lv_test" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous LV lab setup...${RESET}"
    lvremove -ff /dev/vg_labtest/lv_test 2>/dev/null
    vgremove -ff vg_labtest 2>/dev/null
    for dev in $(losetup -j /tmp/lvlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/lvlab.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if vg_labtest exists
    if vgs vg_labtest &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if lv_test exists in vg_labtest
    if lvs /dev/vg_labtest/lv_test &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    lvremove -ff /dev/vg_labtest/lv_test 2>/dev/null
    vgremove -ff vg_labtest 2>/dev/null
    for dev in $(losetup -j /tmp/lvlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/lvlab.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
