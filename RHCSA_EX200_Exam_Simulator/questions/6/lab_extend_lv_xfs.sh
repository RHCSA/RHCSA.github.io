#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Extend LV with XFS

IS_LAB=true
LAB_ID="extend_lv_xfs"

QUESTION="[LAB] Create an LV with XFS and extend it"
HINT="Task 1: Create vg_xext with 300MB, lvcreate -L 100M -n lv_xext vg_xext, mkfs.xfs\nTask 2: lvextend -L +50M -r /dev/vg_xext/lv_xext"

LAB_TITLE="Extend LV with XFS"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create VG vg_xext, LV lv_xext 100MB with XFS" ;;
        1) echo "Extend lv_xext by 50MB with filesystem resize" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous extend lab...${RESET}"
    umount /dev/vg_xext/lv_xext 2>/dev/null
    lvremove -ff /dev/vg_xext/lv_xext 2>/dev/null
    vgremove -ff vg_xext 2>/dev/null
    for dev in $(losetup -j /tmp/xextlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/xextlab.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if LV exists with XFS
    if lvs /dev/vg_xext/lv_xext &>/dev/null && blkid /dev/vg_xext/lv_xext 2>/dev/null | grep -q 'TYPE="xfs"'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if LV is larger than 100MB (was extended)
    if lvs /dev/vg_xext/lv_xext &>/dev/null; then
        local size=$(lvs --noheadings -o lv_size --units m /dev/vg_xext/lv_xext 2>/dev/null | tr -d ' m')
        size=${size%%.*}
        if [[ -n "$size" ]] && [[ "$size" -ge 140 ]]; then
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
    umount /dev/vg_xext/lv_xext 2>/dev/null
    lvremove -ff /dev/vg_xext/lv_xext 2>/dev/null
    vgremove -ff vg_xext 2>/dev/null
    for dev in $(losetup -j /tmp/xextlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/xextlab.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
