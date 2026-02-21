#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Extend LV with ext4

IS_LAB=true
LAB_ID="extend_lv_ext4"

QUESTION="[LAB] Create an LV with ext4 and extend it"
HINT="Task 1: Create vg_eext with 300MB, lvcreate -L 100M -n lv_eext vg_eext, mkfs.ext4\nTask 2: lvextend -L +50M -r /dev/vg_eext/lv_eext"

LAB_TITLE="Extend LV with ext4"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create VG vg_eext, LV lv_eext 100MB with ext4" ;;
        1) echo "Extend lv_eext by 50MB with filesystem resize" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous extend lab...${RESET}"
    umount /dev/vg_eext/lv_eext 2>/dev/null
    lvremove -ff /dev/vg_eext/lv_eext 2>/dev/null
    vgremove -ff vg_eext 2>/dev/null
    for dev in $(losetup -j /tmp/eextlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/eextlab.img 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if LV exists with ext4
    if lvs /dev/vg_eext/lv_eext &>/dev/null && blkid /dev/vg_eext/lv_eext 2>/dev/null | grep -q 'TYPE="ext4"'; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if LV is larger than 100MB (was extended)
    if lvs /dev/vg_eext/lv_eext &>/dev/null; then
        local size=$(lvs --noheadings -o lv_size --units m /dev/vg_eext/lv_eext 2>/dev/null | tr -d ' m')
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
    umount /dev/vg_eext/lv_eext 2>/dev/null
    lvremove -ff /dev/vg_eext/lv_eext 2>/dev/null
    vgremove -ff vg_eext 2>/dev/null
    for dev in $(losetup -j /tmp/eextlab.img 2>/dev/null | cut -d: -f1); do
        pvremove -ff "$dev" 2>/dev/null
        losetup -d "$dev" 2>/dev/null
    done
    rm -f /tmp/eextlab.img 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
