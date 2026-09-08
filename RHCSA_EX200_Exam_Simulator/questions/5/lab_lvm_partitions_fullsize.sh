#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create physical volumes on partitions, a volume group, and a logical
#      volume using 100% of the free space, mounted permanently via UUID
# NOTE: check_prerequisites() is only read by the web UI (webui/server.py).
# The CLI simulator (rhcsa) never calls it, so on the CLI this lab just runs
# prepare_lab/check_tasks/cleanup_lab like any other lab (no pre-flight popup).

IS_LAB=true
LAB_ID="lvm_partitions_fullsize"

QUESTION="Set up LVM storage on partitions: create partitions, physical volumes, a volume group, and a logical volume using 100% of the free space; format it and mount it permanently by UUID"

# Lab configuration
LAB_TITLE="LVM: Partitions, 100% Free Space, UUID Mount"
LAB_TASK_COUNT=6

# =============================================================================
# DISK DISCOVERY - find 2 spare disks (not the one holding /) to partition
# =============================================================================

STATE_FILE="/tmp/.rhcsa_lab_lvm_fullsize_disks"
VG_NAME="full-size-vg"
LV_NAME="full-size-lv"
PART1_SIZE_MB=123
PART2_SIZE_MB=456
PART_TOLERANCE_BYTES=$((4 * 1024 * 1024))
MOUNT_POINT="/full-size"
MIN_DISK_SIZE_GB=5

# Whole disks that are safe to use: no existing partition table (a disk with
# partitions is always OS/boot/manually-used data and must never be touched),
# nothing in the disk's device tree is mounted or used as swap (catches the
# OS disk even when it's a bare whole-disk PV with no partition table, e.g.
# /, /boot, swap, /home), and >= MIN_DISK_SIZE_GB. A disk with only a stray
# leftover LVM signature and no partitions/mounts still qualifies - prepare_lab
# wipes and reuses it.
_lvm_find_spare_disks() {
    lsblk -dnb -o NAME,TYPE,SIZE 2>/dev/null | while read -r name type size; do
        [[ "$type" == "disk" ]] || continue
        if lsblk -n -o TYPE "/dev/$name" 2>/dev/null | grep -q '^part$'; then
            continue
        fi
        if lsblk -n -o MOUNTPOINT "/dev/$name" 2>/dev/null | grep -qE '\S'; then
            continue
        fi
        local size_gb=$((size / 1024 / 1024 / 1024))
        if [[ $size_gb -ge $MIN_DISK_SIZE_GB ]]; then
            echo "/dev/$name"
        fi
    done
}

# Resolve DISK1/DISK2: reuse the disks already chosen for this run (state file)
# if prepare_lab has already run, otherwise detect fresh.
_lvm_load_disks() {
    if [[ -f "$STATE_FILE" ]]; then
        DISK1=$(sed -n '1p' "$STATE_FILE")
        DISK2=$(sed -n '2p' "$STATE_FILE")
    else
        local spares=()
        while IFS= read -r d; do
            [[ -n "$d" ]] && spares+=("$d")
        done < <(_lvm_find_spare_disks)
        DISK1="${spares[0]:-<disk1>}"
        DISK2="${spares[1]:-<disk2>}"
    fi
}
_lvm_load_disks

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create a ${PART1_SIZE_MB}M partition on ${DISK1} and a ${PART2_SIZE_MB}M partition on ${DISK2}"
TASK_1_HINT="Use fdisk or parted to create one partition of each requested size"
TASK_1_COMMAND_1="parted -s ${DISK1} mklabel msdos mkpart primary 1MiB $((PART1_SIZE_MB + 1))MiB"
TASK_1_COMMAND_2="parted -s ${DISK2} mklabel msdos mkpart primary 1MiB $((PART2_SIZE_MB + 1))MiB"

# Task 2
TASK_2_QUESTION="Create LVM physical volumes on ${DISK1}1 and ${DISK2}1"
TASK_2_HINT="Use pvcreate on both partitions to initialize them as LVM physical volumes"
TASK_2_COMMAND_1="pvcreate ${DISK1}1 ${DISK2}1"

# Task 3
TASK_3_QUESTION="Create a volume group named ${VG_NAME} from ${DISK1}1 and ${DISK2}1"
TASK_3_HINT="Use vgcreate to combine both physical volumes into one volume group"
TASK_3_COMMAND_1="vgcreate ${VG_NAME} ${DISK1}1 ${DISK2}1"

# Task 4
TASK_4_QUESTION="Create a logical volume named ${LV_NAME} using 100% of the free space in ${VG_NAME}"
TASK_4_HINT="Use lvcreate with --extents 100%FREE to consume all remaining space in the volume group"
TASK_4_COMMAND_1="lvcreate --name ${LV_NAME} --extents 100%FREE ${VG_NAME}"

# Task 5
TASK_5_QUESTION="Format /dev/${VG_NAME}/${LV_NAME} with the xfs file system"
TASK_5_HINT="Use mkfs.xfs to format the logical volume"
TASK_5_COMMAND_1="mkfs.xfs /dev/${VG_NAME}/${LV_NAME}"

# Task 6
TASK_6_QUESTION="Create ${MOUNT_POINT} and mount /dev/${VG_NAME}/${LV_NAME} there permanently using its UUID (must persist after reboot)"
TASK_6_HINT="Look up the UUID with blkid, then add a UUID= entry to /etc/fstab"
TASK_6_COMMAND_1="mkdir ${MOUNT_POINT}"
TASK_6_COMMAND_2="echo \"UUID=\$(blkid -o value -s UUID /dev/${VG_NAME}/${LV_NAME}) ${MOUNT_POINT} xfs defaults 0 0\" >> /etc/fstab"
TASK_6_COMMAND_3="systemctl daemon-reload"
TASK_6_COMMAND_4="mount -a"

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

# Web UI only: verify 2 spare disks (>= 5G, not the root disk) exist before
# starting. If not, the web UI shows this message and never starts the lab.
check_prerequisites() {
    local spares=()
    while IFS= read -r d; do
        [[ -n "$d" ]] && spares+=("$d")
    done < <(_lvm_find_spare_disks)

    if [[ ${#spares[@]} -lt 2 ]]; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab needs at least 2 extra disks of 5 GB or more each (not the disk that holds /). Only ${#spares[@]} matching disk(s) were found on this machine. Add at least 2 disks of 5 GB+ and try again."
        return
    fi

    PREREQ_OK=true
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Detecting spare disks...${RESET}"
    local spares=()
    while IFS= read -r d; do
        [[ -n "$d" ]] && spares+=("$d")
    done < <(_lvm_find_spare_disks)

    if [[ ${#spares[@]} -lt 2 ]]; then
        echo -e "  ${RED}✗ Not enough spare disks found (need 2, found ${#spares[@]})${RESET}"
        return
    fi

    DISK1="${spares[0]}"
    DISK2="${spares[1]}"
    printf '%s\n%s\n' "$DISK1" "$DISK2" > "$STATE_FILE"

    echo -e "  ${DIM}• Using ${DISK1} and ${DISK2} for this lab...${RESET}"
    echo -e "  ${DIM}• Wiping any existing data on ${DISK1} and ${DISK2}...${RESET}"

    # Unmount anything already mounted from these disks or their partitions
    for d in "$DISK1" "$DISK2"; do
        for part in "$d"*; do
            [[ -e "$part" ]] || continue
            umount "$part" &>/dev/null || true
        done
    done

    # Remove any existing LVM structures built on top of these disks/partitions
    for d in "$DISK1" "$DISK2"; do
        for dev in "$d" "$d"1 "$d"2 "$d"3; do
            [[ -e "$dev" ]] || continue
            for vg in $(pvs --noheadings -o vg_name "$dev" 2>/dev/null | awk 'NF'); do
                lvremove -f "$vg" &>/dev/null || true
                vgremove -f "$vg" &>/dev/null || true
            done
            pvremove -ff -y "$dev" &>/dev/null || true
        done
    done

    # Wipe filesystem/partition/LVM signatures so the disks start blank
    wipefs -a "$DISK1" &>/dev/null || true
    wipefs -a "$DISK2" &>/dev/null || true
    dd if=/dev/zero of="$DISK1" bs=1M count=1 &>/dev/null || true
    dd if=/dev/zero of="$DISK2" bs=1M count=1 &>/dev/null || true
    partprobe "$DISK1" &>/dev/null || true
    partprobe "$DISK2" &>/dev/null || true

    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    _lvm_load_disks

    # Task 0: partitions of the requested sizes exist on each disk
    local p1_bytes p2_bytes exp1_bytes exp2_bytes
    p1_bytes=$(blockdev --getsize64 "${DISK1}1" 2>/dev/null)
    p2_bytes=$(blockdev --getsize64 "${DISK2}1" 2>/dev/null)
    exp1_bytes=$((PART1_SIZE_MB * 1024 * 1024))
    exp2_bytes=$((PART2_SIZE_MB * 1024 * 1024))
    if [[ -n "$p1_bytes" ]] && [[ -n "$p2_bytes" ]] \
        && (( p1_bytes >= exp1_bytes - PART_TOLERANCE_BYTES && p1_bytes <= exp1_bytes + PART_TOLERANCE_BYTES )) \
        && (( p2_bytes >= exp2_bytes - PART_TOLERANCE_BYTES && p2_bytes <= exp2_bytes + PART_TOLERANCE_BYTES )); then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: both partitions are LVM physical volumes
    if pvs "${DISK1}1" &>/dev/null && pvs "${DISK2}1" &>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: volume group exists and contains both physical volumes
    if vgs "$VG_NAME" &>/dev/null; then
        local vg1 vg2
        vg1=$(pvs -o vg_name --noheadings "${DISK1}1" 2>/dev/null | tr -d ' ')
        vg2=$(pvs -o vg_name --noheadings "${DISK2}1" 2>/dev/null | tr -d ' ')
        if [[ "$vg1" == "$VG_NAME" ]] && [[ "$vg2" == "$VG_NAME" ]]; then
            TASK_STATUS[2]="true"
        else
            TASK_STATUS[2]="false"
        fi
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: logical volume exists and consumes (close to) all of the VG's space
    if lvs "${VG_NAME}/${LV_NAME}" &>/dev/null; then
        local lv_bytes vg_bytes
        lv_bytes=$(lvs --noheadings --units b --nosuffix -o lv_size "${VG_NAME}/${LV_NAME}" 2>/dev/null | tr -d ' ')
        vg_bytes=$(vgs --noheadings --units b --nosuffix -o vg_size "$VG_NAME" 2>/dev/null | tr -d ' ')
        if [[ -n "$lv_bytes" ]] && [[ -n "$vg_bytes" ]] && (( vg_bytes - lv_bytes <= 8 * 1024 * 1024 )); then
            TASK_STATUS[3]="true"
        else
            TASK_STATUS[3]="false"
        fi
    else
        TASK_STATUS[3]="false"
    fi

    # Task 4: logical volume formatted with xfs
    local fstype
    fstype=$(blkid -o value -s TYPE "/dev/${VG_NAME}/${LV_NAME}" 2>/dev/null)
    if [[ "$fstype" == "xfs" ]]; then
        TASK_STATUS[4]="true"
    else
        TASK_STATUS[4]="false"
    fi

    # Task 5: mounted right now (by UUID) AND persisted in /etc/fstab using UUID=
    local mounted=false
    local persisted=false
    local cur_src lv_uuid
    cur_src=$(findmnt -no SOURCE "$MOUNT_POINT" 2>/dev/null)
    lv_uuid=$(blkid -o value -s UUID "/dev/${VG_NAME}/${LV_NAME}" 2>/dev/null)
    if [[ -n "$cur_src" ]] && [[ -e "/dev/${VG_NAME}/${LV_NAME}" ]]; then
        if [[ "$(readlink -f "$cur_src" 2>/dev/null)" == "$(readlink -f "/dev/${VG_NAME}/${LV_NAME}" 2>/dev/null)" ]]; then
            mounted=true
        fi
    fi
    if [[ -n "$lv_uuid" ]] && grep -qE "^[[:space:]]*UUID=${lv_uuid}[[:space:]]+${MOUNT_POINT}[[:space:]]" /etc/fstab 2>/dev/null; then
        persisted=true
    fi
    if $mounted && $persisted; then
        TASK_STATUS[5]="true"
    else
        TASK_STATUS[5]="false"
    fi
}

# Cleanup the lab environment before exit - leave the disks completely blank
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

    for d in "$DISK1" "$DISK2"; do
        [[ -n "$d" ]] || continue
        [[ "$d" == "<disk1>" || "$d" == "<disk2>" ]] && continue
        for dev in "$d"1 "$d"2 "$d"3; do
            [[ -e "$dev" ]] || continue
            pvremove -ff -y "$dev" &>/dev/null || true
        done
        parted -s "$d" rm 1 &>/dev/null || true
        wipefs -a "$d" &>/dev/null || true
        dd if=/dev/zero of="$d" bs=1M count=1 &>/dev/null || true
        partprobe "$d" &>/dev/null || true
    done

    rm -f "$STATE_FILE"
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
