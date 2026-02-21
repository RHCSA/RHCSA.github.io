#!/bin/bash
# Objective 5: Configure local storage
# LAB: Extend Logical Volume

IS_LAB=true
LAB_ID="lvm_extend"

QUESTION="[LAB] Create an LV and extend it non-destructively"
HINT="Task 1: Create vg_extend with 200MB, then lvcreate -L 50M -n lv_grow vg_extend\nTask 2: lvextend -L +50M /dev/vg_extend/lv_grow"

LAB_TITLE="Extend Logical Volume"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create VG vg_extend and 50MB LV lv_grow" ;;
        1) echo "Extend lv_grow by adding 50MB more" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous extend lab...${RESET}"
    lvremove -ff /dev/vg_extend/lv_grow 2>/dev/null
    vgremove -ff vg_extend 2>/dev/null
    for dev in $(losetup -j /tmp/extendlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/extendlab.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if lv_grow exists
    if lvs /dev/vg_extend/lv_grow &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if lv_grow is larger than 50MB (was extended)
    if lvs /dev/vg_extend/lv_grow &>/dev/null; then
        local size=$(lvs --noheadings -o lv_size --units m /dev/vg_extend/lv_grow 2>/dev/null | tr -d ' m')
        # Remove any decimal
        size=${size%%.*}
        if [[ -n "$size" ]] && [[ "$size" -ge 90 ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    lvremove -ff /dev/vg_extend/lv_grow 2>/dev/null
    vgremove -ff vg_extend 2>/dev/null
    for dev in $(losetup -j /tmp/extendlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/extendlab.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
