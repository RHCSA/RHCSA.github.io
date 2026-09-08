#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create an LVM volume group/logical volume sized in extents, with a
#      custom PE size, then grow it first by a fixed extent count and finally
#      to consume all remaining free space in the volume group
# NOTE: check_prerequisites() is only read by the web UI (webui/server.py).
# The CLI simulator (rhcsa) never calls it, so on the CLI this lab just runs
# prepare_lab/check_tasks/cleanup_lab like any other lab (no pre-flight popup).
#
# IMPORTANT: 100 extents @ 32M PE size = 3.125 GiB. Each disk only needs to
# individually cover that initial size - disk2 joins the volume group in
# task 7, before the LV is grown further in task 8, so the +100 extent step
# draws from the combined capacity of both disks rather than disk1 alone.

IS_LAB=true
LAB_ID="lvm_extent_sizing"

QUESTION="Create an LVM volume group with a custom PE (physical extent) size, size a logical volume in extents, then grow it - first by a fixed extent count, then to use all remaining free space"

# Lab configuration
LAB_TITLE="LVM: PE Size and Extent-Based Sizing"
LAB_TASK_COUNT=9

# =============================================================================
# DISK DISCOVERY - this lab needs 2 spare disks available: the first is used
# to create the volume group, the second is added to it later (task 7)
# =============================================================================

STATE_FILE="/tmp/.rhcsa_lab_lvm_extent_disks"
VG_NAME="my-extent-vg"
LV_NAME="my-extent-lv"
PE_SIZE="32M"
PE_SIZE_BYTES=$((32 * 1024 * 1024))
INITIAL_EXTENTS=100
EXTEND_EXTENTS=100
INITIAL_SIZE_BYTES=$((INITIAL_EXTENTS * PE_SIZE_BYTES))
AFTER_EXTEND_SIZE_BYTES=$(((INITIAL_EXTENTS + EXTEND_EXTENTS) * PE_SIZE_BYTES))
VG_SIZE_TOLERANCE_BYTES=$((8 * 1024 * 1024))
MOUNT_POINT="/my-extent-dir"
TEST_FILE="${MOUNT_POINT}/testfile"
# Each disk needs to individually cover the initial 100 extents (3.125 GiB)
# plus a little headroom for LVM metadata - the combined pair (after disk2
# joins in task 7) is then plenty for the +100 extent step and the final
# 100%FREE step to have something meaningful left to consume.
MIN_DISK_SIZE_GB=4

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
TASK_1_QUESTION="Create a physical volume on the first available extra disk: ${DISK1} (not the disk that holds /)"
TASK_1_HINT="Use pvcreate to initialize the disk as an LVM physical volume"
TASK_1_COMMAND_1="pvcreate ${DISK1}"

# Task 2
TASK_2_QUESTION="Create a volume group named ${VG_NAME} using ${DISK1} with a PE (physical extent) size of ${PE_SIZE}"
TASK_2_HINT="Use vgcreate with --physicalextentsize to set a custom PE size"
TASK_2_COMMAND_1="vgcreate --physicalextentsize ${PE_SIZE} ${VG_NAME} ${DISK1}"

# Task 3
TASK_3_QUESTION="Create a logical volume named ${LV_NAME} in ${VG_NAME} with an initial size of ${INITIAL_EXTENTS} extents"
TASK_3_HINT="Use lvcreate with --extents to size the logical volume in extents instead of bytes"
TASK_3_COMMAND_1="lvcreate --name ${LV_NAME} --extents ${INITIAL_EXTENTS} ${VG_NAME}"

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
TASK_6_QUESTION="Create a file named testfile inside ${MOUNT_POINT} to confirm the volume is functional"
TASK_6_HINT="Use touch to create an empty file inside the mounted directory"
TASK_6_COMMAND_1="touch ${TEST_FILE}"

# Task 7
TASK_7_QUESTION="Expand ${VG_NAME} by adding a new disk: create a physical volume on ${DISK2} and add it to the volume group"
TASK_7_HINT="Use pvcreate on the new disk, then vgextend to add it to the existing volume group"
TASK_7_COMMAND_1="pvcreate ${DISK2}"
TASK_7_COMMAND_2="vgextend ${VG_NAME} ${DISK2}"

# Task 8
TASK_8_QUESTION="Resize ${LV_NAME} to add ${EXTEND_EXTENTS} extents, ensuring the file system is resized automatically, in one command"
TASK_8_HINT="Use lvextend with --resizefs and --extents +${EXTEND_EXTENTS}"
TASK_8_COMMAND_1="lvextend --resizefs --extents +${EXTEND_EXTENTS} /dev/${VG_NAME}/${LV_NAME}"

# Task 9
TASK_9_QUESTION="Extend ${LV_NAME} to use all remaining free space in ${VG_NAME}, resizing the file system accordingly, in one command"
TASK_9_HINT="Use lvextend with --resizefs and --extents +100%FREE"
TASK_9_COMMAND_1="lvextend --resizefs --extents +100%FREE /dev/${VG_NAME}/${LV_NAME}"

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

# Web UI only: verify 2 spare disks (>= MIN_DISK_SIZE_GB, not the root disk)
# exist before starting. If not, the web UI shows this message and never
# starts the lab.
check_prerequisites() {
    local spares=()
    while IFS= read -r d; do
        [[ -n "$d" ]] && spares+=("$d")
    done < <(_lvm_find_spare_disks)

    if [[ ${#spares[@]} -lt 2 ]]; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab needs at least 2 extra disks of ${MIN_DISK_SIZE_GB} GB or more each (not the disk that holds /). Only ${#spares[@]} matching disk(s) were found on this machine. Add at least 2 disks of ${MIN_DISK_SIZE_GB} GB+ and try again."
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
        echo -e "  ${RED}✗ Not enough spare disks found (need 2 of ${MIN_DISK_SIZE_GB}G+, found ${#spares[@]})${RESET}"
        return
    fi

    DISK1="${spares[0]}"
    DISK2="${spares[1]}"
    printf '%s\n%s\n' "$DISK1" "$DISK2" > "$STATE_FILE"

    echo -e "  ${DIM}• Using ${DISK1} for this lab (${DISK2} will be added to the VG later)...${RESET}"
    echo -e "  ${DIM}• Wiping any existing data on ${DISK1} and ${DISK2}...${RESET}"

    for d in "$DISK1" "$DISK2"; do
        for part in "$d"*; do
            [[ -e "$part" ]] || continue
            umount "$part" &>/dev/null || true
        done
        for vg in $(pvs --noheadings -o vg_name "$d" 2>/dev/null | awk 'NF'); do
            lvremove -f "$vg" &>/dev/null || true
            vgremove -f "$vg" &>/dev/null || true
        done
        pvremove -ff -y "$d" &>/dev/null || true
        wipefs -a "$d" &>/dev/null || true
    done

    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    _lvm_load_disks

    # Task 0: disk1 is an LVM physical volume
    if pvs "$DISK1" &>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: volume group exists, contains disk1, and has the requested PE size
    if vgs "$VG_NAME" &>/dev/null; then
        local vg1 pe_bytes
        vg1=$(pvs -o vg_name --noheadings "$DISK1" 2>/dev/null | tr -d ' ')
        pe_bytes=$(vgs --noheadings --units b --nosuffix -o vg_extent_size "$VG_NAME" 2>/dev/null | tr -d ' ')
        if [[ "$vg1" == "$VG_NAME" ]] && [[ "$pe_bytes" == "$PE_SIZE_BYTES" ]]; then
            TASK_STATUS[1]="true"
        else
            TASK_STATUS[1]="false"
        fi
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: logical volume exists and is at least the initial size
    # (>= not == because tasks 7/8 grow it later - a strict equality check
    # here would flip back to "incomplete" once the LV has been extended)
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

    # Task 5: testfile exists inside the mounted directory
    if [[ -f "$TEST_FILE" ]]; then
        TASK_STATUS[5]="true"
    else
        TASK_STATUS[5]="false"
    fi

    # Task 6: volume group has been expanded with a physical volume on disk2
    if vgs "$VG_NAME" &>/dev/null; then
        local vg2
        vg2=$(pvs -o vg_name --noheadings "$DISK2" 2>/dev/null | tr -d ' ')
        if pvs "$DISK2" &>/dev/null && [[ "$vg2" == "$VG_NAME" ]]; then
            TASK_STATUS[6]="true"
        else
            TASK_STATUS[6]="false"
        fi
    else
        TASK_STATUS[6]="false"
    fi

    # Task 7: logical volume is at least the extended size (100 + 100 extents)
    # AND the file system was actually grown to use the new space
    # (>= not == because task 9 grows it further to 100%FREE)
    if lvs "${VG_NAME}/${LV_NAME}" &>/dev/null; then
        local lv_bytes fs_blocks fs_bsize fs_bytes
        lv_bytes=$(lvs --noheadings --units b --nosuffix -o lv_size "${VG_NAME}/${LV_NAME}" 2>/dev/null | tr -d ' ')
        fs_blocks=$(stat -f --format=%b "$MOUNT_POINT" 2>/dev/null)
        fs_bsize=$(stat -f --format=%S "$MOUNT_POINT" 2>/dev/null)
        if [[ -n "$lv_bytes" ]] && [[ -n "$fs_blocks" ]] && [[ -n "$fs_bsize" ]] \
            && (( lv_bytes >= AFTER_EXTEND_SIZE_BYTES )); then
            fs_bytes=$((fs_blocks * fs_bsize))
            if (( fs_bytes >= AFTER_EXTEND_SIZE_BYTES * 90 / 100 )); then
                TASK_STATUS[7]="true"
            else
                TASK_STATUS[7]="false"
            fi
        else
            TASK_STATUS[7]="false"
        fi
    else
        TASK_STATUS[7]="false"
    fi

    # Task 8: logical volume uses (close to) 100% of the volume group's total
    # size AND the file system was actually grown to use the new space.
    # The exact byte target isn't fixed in advance - it depends on this
    # machine's actual disk size - so compare the LV to the VG dynamically.
    if lvs "${VG_NAME}/${LV_NAME}" &>/dev/null; then
        local lv_bytes vg_bytes fs_blocks fs_bsize fs_bytes
        lv_bytes=$(lvs --noheadings --units b --nosuffix -o lv_size "${VG_NAME}/${LV_NAME}" 2>/dev/null | tr -d ' ')
        vg_bytes=$(vgs --noheadings --units b --nosuffix -o vg_size "$VG_NAME" 2>/dev/null | tr -d ' ')
        fs_blocks=$(stat -f --format=%b "$MOUNT_POINT" 2>/dev/null)
        fs_bsize=$(stat -f --format=%S "$MOUNT_POINT" 2>/dev/null)
        if [[ -n "$lv_bytes" ]] && [[ -n "$vg_bytes" ]] && [[ -n "$fs_blocks" ]] && [[ -n "$fs_bsize" ]] \
            && (( vg_bytes - lv_bytes <= VG_SIZE_TOLERANCE_BYTES )); then
            fs_bytes=$((fs_blocks * fs_bsize))
            if (( fs_bytes >= lv_bytes * 90 / 100 )); then
                TASK_STATUS[8]="true"
            else
                TASK_STATUS[8]="false"
            fi
        else
            TASK_STATUS[8]="false"
        fi
    else
        TASK_STATUS[8]="false"
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
        pvremove -ff -y "$d" &>/dev/null || true
        wipefs -a "$d" &>/dev/null || true
    done

    rm -f "$STATE_FILE"
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
