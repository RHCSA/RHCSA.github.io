#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create LVM Physical Volume on Loop Device

IS_LAB=true
LAB_ID="lvm_loop_pv"

QUESTION="[LAB] Create an LVM physical volume using a loop device"
HINT="Task 1: dd if=/dev/zero of=/tmp/lvmtest.img bs=1M count=200 && losetup -f /tmp/lvmtest.img\nTask 2: pvcreate /dev/loopX (use losetup -j to find device)"

LAB_TITLE="Create PV on Loop Device"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create 200MB image and attach as loop device" ;;
        1) echo "Initialize loop device as physical volume" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous LVM test setup...${RESET}"
    # Find and clean up existing loop device
    for dev in $(losetup -j /tmp/lvmtest.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/lvmtest.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if loop device is attached with lvmtest.img
    if losetup -j /tmp/lvmtest.img 2>/dev/null | grep -q '/tmp/lvmtest.img'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if the loop device is a PV
    local loop_dev=$(losetup -j /tmp/lvmtest.img 2>/dev/null | cut -d: -f1 | head -1)
    if [[ -n "$loop_dev" ]] && pvs "$loop_dev" &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    for dev in $(losetup -j /tmp/lvmtest.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/lvmtest.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
