#!/bin/bash
# Objective 5: Configure local storage
# LAB: Resize an existing logical volume to an exact size and grow its file system
# NOTE: check_prerequisites() is only read by the web UI (webui/server.py).
# The CLI simulator (rhcsa) never calls it, so on the CLI this lab just runs
# prepare_lab/check_tasks/cleanup_lab like any other lab (no pre-flight popup).

IS_LAB=true
LAB_ID="lvm_resize_lv_exact"

QUESTION="Create a logical volume, format and mount it, then resize it to an EXACT size and grow its file system to match"

# Lab configuration
LAB_TITLE="LVM: Resize a Logical Volume to an Exact Size"
LAB_TASK_COUNT=6

# =============================================================================
# DISK DISCOVERY - find 1 spare disk (not the one holding /) to use for LVM
# =============================================================================

STATE_FILE="/tmp/.rhcsa_lab_lvm_resize_disk"
VG_NAME="vg-to-resize"
LV_NAME="lv-to-resize"
INITIAL_SIZE="1234M"
INITIAL_SIZE_BYTES=$((1234 * 1024 * 1024))
TARGET_SIZE="2345M"
TARGET_SIZE_BYTES=$((2345 * 1024 * 1024))
MOUNT_POINT="/resize-data"
MIN_DISK_SIZE_GB=5

# Whole disks that are safe to use: no existing partition table (a disk with
# partitions is always OS/boot/manually-used data and must never be touched),
# and >= MIN_DISK_SIZE_GB. A disk with only a stray leftover LVM signature and
# no partitions still qualifies - prepare_lab wipes and reuses it.
_lvm_find_spare_disks() {
    lsblk -dnb -o NAME,TYPE,SIZE 2>/dev/null | while read -r name type size; do
        [[ "$type" == "disk" ]] || continue
        if lsblk -n -o TYPE "/dev/$name" 2>/dev/null | grep -q '^part$'; then
            continue
        fi
        local size_gb=$((size / 1024 / 1024 / 1024))
        if [[ $size_gb -ge $MIN_DISK_SIZE_GB ]]; then
            echo "/dev/$name"
        fi
    done
}

# Resolve DISK1: reuse the disk already chosen for this run (state file)
# if prepare_lab has already run, otherwise detect fresh.
_lvm_load_disks() {
    if [[ -f "$STATE_FILE" ]]; then
        DISK1=$(sed -n '1p' "$STATE_FILE")
    else
        local spares=()
        while IFS= read -r d; do
            [[ -n "$d" ]] && spares+=("$d")
        done < <(_lvm_find_spare_disks)
        DISK1="${spares[0]:-<disk1>}"
    fi
}
_lvm_load_disks

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create an LVM physical volume on ${DISK1} (do not use the disk that holds /)"
TASK_1_HINT="Use pvcreate to initialize the disk as an LVM physical volume"
TASK_1_COMMAND_1="pvcreate ${DISK1}"

# Task 2
TASK_2_QUESTION="Create a volume group named ${VG_NAME} from ${DISK1}"
TASK_2_HINT="Use vgcreate to build a volume group on top of the physical volume"
TASK_2_COMMAND_1="vgcreate ${VG_NAME} ${DISK1}"

# Task 3
TASK_3_QUESTION="Create a logical volume named ${LV_NAME} with a size of ${INITIAL_SIZE} in ${VG_NAME}"
TASK_3_HINT="Use lvcreate with --name and --size"
TASK_3_COMMAND_1="lvcreate --name ${LV_NAME} --size ${INITIAL_SIZE} ${VG_NAME}"

# Task 4
TASK_4_QUESTION="Format /dev/${VG_NAME}/${LV_NAME} with the xfs file system"
TASK_4_HINT="Use mkfs.xfs to format the logical volume"
TASK_4_COMMAND_1="mkfs.xfs /dev/${VG_NAME}/${LV_NAME}"

# Task 5
TASK_5_QUESTION="Create ${MOUNT_POINT} and mount /dev/${VG_NAME}/${LV_NAME} there permanently (must persist after reboot)"
TASK_5_HINT="Add an entry to /etc/fstab, then reload systemd and mount -a"
TASK_5_COMMAND_1="mkdir ${MOUNT_POINT}"
TASK_5_COMMAND_2="echo '/dev/${VG_NAME}/${LV_NAME} ${MOUNT_POINT} xfs defaults 0 0' >> /etc/fstab"
TASK_5_COMMAND_3="systemctl daemon-reload"
TASK_5_COMMAND_4="mount -a"

# Task 6
TASK_6_QUESTION="Resize ${LV_NAME} to be EXACTLY ${TARGET_SIZE} and grow its file system to match, in one command"
TASK_6_HINT="Use lvresize with --resizefs so the file system is grown along with the logical volume"
TASK_6_COMMAND_1="lvresize --resizefs --size ${TARGET_SIZE} /dev/${VG_NAME}/${LV_NAME}"

# =============================================================================
# TASK HELPER FUNCTIONS
# =============================================================================

# Get task description by index (0-based)
get_task_description() {
    local task_idx=$1
    local task_num=$((task_idx + 1))
    local var_name="TASK_${task_num}_QUESTION"
    echo "${!var_name}"
}

# Get commands for a task (returns newline-separated commands)
get_task_commands() {
    local task_idx=$1
    local task_num=$((task_idx + 1))
    local result=""

    for i in 1 2 3 4 5; do
        local var_name="TASK_${task_num}_COMMAND_${i}"
        local cmd="${!var_name}"
        if [[ -n "$cmd" ]]; then
            if [[ -n "$result" ]]; then
                result+=$'\n'
            fi
            result+="$cmd"
        fi
    done
    echo "$result"
}

# Build HINT from all task commands (called automatically)
_build_hint() {
    local result=""
    for ((i=0; i<LAB_TASK_COUNT; i++)); do
        local task_num=$((i+1))
        local cmds=$(get_task_commands $i)
        if [[ -n "$cmds" ]]; then
            while IFS= read -r cmd; do
                if [[ -n "$cmd" ]]; then
                    if [[ -n "$result" ]]; then
                        result+=$'\n'
                    fi
                    result+="Task ${task_num}: ${cmd}"
                fi
            done <<< "$cmds"
        fi
    done
    echo "$result"
}

# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Web UI only: verify 1 spare disk (>= 5G, not the root disk) exists before
# starting. If not, the web UI shows this message and never starts the lab.
check_prerequisites() {
    local spares=()
    while IFS= read -r d; do
        [[ -n "$d" ]] && spares+=("$d")
    done < <(_lvm_find_spare_disks)

    if [[ ${#spares[@]} -lt 1 ]]; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab needs at least 1 extra disk of 5 GB or more (not the disk that holds /). No matching disk was found on this machine. Add at least 1 disk of 5 GB+ and try again."
        return
    fi

    PREREQ_OK=true
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Detecting a spare disk...${RESET}"
    local spares=()
    while IFS= read -r d; do
        [[ -n "$d" ]] && spares+=("$d")
    done < <(_lvm_find_spare_disks)

    if [[ ${#spares[@]} -lt 1 ]]; then
        echo -e "  ${RED}✗ No spare disk found${RESET}"
        return
    fi

    DISK1="${spares[0]}"
    printf '%s\n' "$DISK1" > "$STATE_FILE"

    echo -e "  ${DIM}• Using ${DISK1} for this lab...${RESET}"
    echo -e "  ${DIM}• Wiping any existing data on ${DISK1}...${RESET}"

    for part in "$DISK1"*; do
        [[ -e "$part" ]] || continue
        umount "$part" &>/dev/null || true
    done

    for vg in $(pvs --noheadings -o vg_name "$DISK1" 2>/dev/null | awk 'NF'); do
        lvremove -f "$vg" &>/dev/null || true
        vgremove -f "$vg" &>/dev/null || true
    done
    pvremove -ff -y "$DISK1" &>/dev/null || true
    wipefs -a "$DISK1" &>/dev/null || true

    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    _lvm_load_disks

    # Task 0: disk is an LVM physical volume
    if pvs "$DISK1" &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: volume group exists and contains the physical volume
    if vgs "$VG_NAME" &>/dev/null; then
        local vg1
        vg1=$(pvs -o vg_name --noheadings "$DISK1" 2>/dev/null | tr -d ' ')
        if [[ "$vg1" == "$VG_NAME" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: logical volume exists and is at least the initial size
    # (>= not == because task 5 resizes it later - a strict equality check
    # here would flip back to "incomplete" once the LV has been resized)
    if lvs "${VG_NAME}/${LV_NAME}" &>/dev/null; then
        local lv_bytes
        lv_bytes=$(lvs --noheadings --units b --nosuffix -o lv_size "${VG_NAME}/${LV_NAME}" 2>/dev/null | tr -d ' ')
        if [[ -n "$lv_bytes" ]] && (( lv_bytes >= INITIAL_SIZE_BYTES )); then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: logical volume formatted with xfs
    local fstype
    fstype=$(blkid -o value -s TYPE "/dev/${VG_NAME}/${LV_NAME}" 2>/dev/null)
    if [[ "$fstype" == "xfs" ]]; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi

    # Task 4: mounted right now AND persisted in /etc/fstab
    local mounted=false
    local persisted=false
    local cur_src
    cur_src=$(findmnt -no SOURCE "$MOUNT_POINT" 2>/dev/null)
    if [[ -n "$cur_src" ]] && [[ -e "/dev/${VG_NAME}/${LV_NAME}" ]]; then
        if [[ "$(readlink -f "$cur_src" 2>/dev/null)" == "$(readlink -f "/dev/${VG_NAME}/${LV_NAME}" 2>/dev/null)" ]]; then
            mounted=true
        fi
    fi
    if grep -qE "^[[:space:]]*/dev/${VG_NAME}/${LV_NAME}[[:space:]]+${MOUNT_POINT}[[:space:]]" /etc/fstab 2>/dev/null || \
       grep -qE "^[[:space:]]*/dev/mapper/${VG_NAME}-${LV_NAME}[[:space:]]+${MOUNT_POINT}[[:space:]]" /etc/fstab 2>/dev/null; then
        persisted=true
    fi
    if $mounted && $persisted; then
        TASK_STATUS[4]="true"
    else
        TASK_STATUS[4]="false"
    fi

    # Task 5: logical volume is EXACTLY the target size AND the file system
    # was actually grown to use the new space (not just the LV metadata)
    if lvs "${VG_NAME}/${LV_NAME}" &>/dev/null; then
        local lv_bytes fs_blocks fs_bsize fs_bytes
        lv_bytes=$(lvs --noheadings --units b --nosuffix -o lv_size "${VG_NAME}/${LV_NAME}" 2>/dev/null | tr -d ' ')
        fs_blocks=$(stat -f --format=%b "$MOUNT_POINT" 2>/dev/null)
        fs_bsize=$(stat -f --format=%S "$MOUNT_POINT" 2>/dev/null)
        if [[ "$lv_bytes" == "$TARGET_SIZE_BYTES" ]] && [[ -n "$fs_blocks" ]] && [[ -n "$fs_bsize" ]]; then
            fs_bytes=$((fs_blocks * fs_bsize))
            if (( fs_bytes >= TARGET_SIZE_BYTES * 90 / 100 )); then
                TASK_STATUS[5]="true"
            else
                TASK_STATUS[5]="false"
            fi
        else
            TASK_STATUS[5]="false"
        fi
    else
        TASK_STATUS[5]="false"
    fi
}

# Cleanup the lab environment before exit - leave the disk completely blank
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    _lvm_load_disks

    umount "$MOUNT_POINT" &>/dev/null || true
    if [[ -f /etc/fstab ]]; then
        grep -v "[[:space:]]${MOUNT_POINT}[[:space:]]" /etc/fstab > /etc/fstab.rhcsa_tmp 2>/dev/null \
            && mv /etc/fstab.rhcsa_tmp /etc/fstab
    fi
    systemctl daemon-reload &>/dev/null || true
    rmdir "$MOUNT_POINT" &>/dev/null || true

    lvremove -f "$VG_NAME" &>/dev/null || true
    vgremove -f "$VG_NAME" &>/dev/null || true

    if [[ -n "$DISK1" ]] && [[ "$DISK1" != "<disk1>" ]]; then
        pvremove -ff -y "$DISK1" &>/dev/null || true
        wipefs -a "$DISK1" &>/dev/null || true
    fi

    rm -f "$STATE_FILE"
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
