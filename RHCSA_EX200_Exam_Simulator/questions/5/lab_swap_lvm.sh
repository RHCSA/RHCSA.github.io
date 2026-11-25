#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create swap space on a logical volume, then extend it
# Host-machine terminal only. Needs 1 spare disk (no partitions, not mounted,
# not used as swap, 2 GB or more).
# NOTE: prepare_lab wipes the spare disk and backs up /etc/fstab. cleanup_lab
# turns the swap off, puts back /etc/fstab, removes the volume group and
# wipes the disk.
# NOTE: Task 1 stays complete after Task 3 extends the logical volume (a
# marker file in STATE_DIR), so all tasks can pass at the same time.

IS_LAB=true
LAB_ID="swap_lvm"

QUESTION="Create swap space on a logical volume, make it persistent, then extend it"
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=4

# Not in /tmp: the state must stay if the student reboots during the lab
STATE_DIR="/var/tmp/.rhcsa_lab_swap_lvm"
MIN_DISK_SIZE_GB=2
VG_NAME="swapvg"
LV_NAME="swaplv"
LV_PATH="/dev/${VG_NAME}/${LV_NAME}"

# =============================================================================
# DISK DISCOVERY - find 1 spare disk (not the one holding /)
# =============================================================================

# Whole disks that are safe to use: no partitions, nothing in the disk's tree
# mounted or used as swap, and MIN_DISK_SIZE_GB or more
_swap_find_spare_disks() {
    lsblk -dnb -o NAME,TYPE,SIZE 2>/dev/null | while read -r name type size; do
        [[ "$type" == "disk" && "$name" != zram* ]] || continue
        lsblk -n -o TYPE "/dev/$name" 2>/dev/null | grep -q '^part$' && continue
        lsblk -n -o MOUNTPOINT "/dev/$name" 2>/dev/null | grep -qE '\S' && continue
        [[ $((size / 1024 / 1024 / 1024)) -ge $MIN_DISK_SIZE_GB ]] && echo "/dev/$name"
    done
}

# DISK1: the disk that prepare_lab selected, or the first spare disk before that
_swap_load_disk() {
    DISK1=$(cat "$STATE_DIR/disk" 2>/dev/null)
    [[ -n "$DISK1" ]] || DISK1=$(_swap_find_spare_disks | head -n1)
    [[ -n "$DISK1" ]] || DISK1="<disk1>"
}
_swap_load_disk

# =============================================================================
# TASK DEFINITIONS - Each task has question, answer, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create a volume group named ${VG_NAME} on ${DISK1}. In it, create a logical volume named ${LV_NAME} with a size of 512 MiB"
TASK_1_ANSWER="pvcreate prepares the disk for LVM, vgcreate makes the volume group, and lvcreate makes the logical volume"
TASK_1_COMMAND_1="pvcreate ${DISK1}"
TASK_1_COMMAND_2="vgcreate ${VG_NAME} ${DISK1}"
TASK_1_COMMAND_3="lvcreate -L 512M -n ${LV_NAME} ${VG_NAME}"

# Task 2
TASK_2_QUESTION="Create a swap area on ${LV_PATH}, turn it on now, and make it turn on at each boot. Use the path ${LV_PATH} in /etc/fstab"
TASK_2_ANSWER="The path of a logical volume does not change. mkswap makes a new UUID each time it runs, so after you extend the volume in the next task, a UUID line would point to nothing. swapon -a turns on each swap area in /etc/fstab, so it also tests the new line"
TASK_2_COMMAND_1="mkswap ${LV_PATH}"
TASK_2_COMMAND_2="echo ${LV_PATH} none swap defaults 0 0 >> /etc/fstab"
TASK_2_COMMAND_3="systemctl daemon-reload"
TASK_2_COMMAND_4="swapon -a"

# Task 3
TASK_3_QUESTION="Extend ${LV_NAME} to 1 GiB, and make the swap use all of the new size. The swap must stay on after a reboot"
TASK_3_ANSWER="Turn off the swap before you change it. lvextend makes the volume larger, but the old swap header still has the old size. mkswap writes a new header for the full size. Then turn the swap on again"
TASK_3_COMMAND_1="swapoff ${LV_PATH}"
TASK_3_COMMAND_2="lvextend -L 1G ${LV_PATH}"
TASK_3_COMMAND_3="mkswap ${LV_PATH}"
TASK_3_COMMAND_4="swapon -a"

# Task 4
TASK_4_QUESTION="Check the swap. Save the output of swapon --show to /tmp/swapon_show.txt, and the output of free -h to /tmp/free_h.txt"
TASK_4_ANSWER="swapon --show lists the active swap areas. A logical volume shows with its kernel name (for example /dev/dm-2). In the free -h output, the Swap line shows the total swap space, which now includes ${LV_NAME}"
TASK_4_COMMAND_1="swapon --show > /tmp/swapon_show.txt"
TASK_4_COMMAND_2="free -h > /tmp/free_h.txt"

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# Size in KiB of the active swap area $1 (from /proc/swaps)
_swap_active_kib() {
    local real name type size rest
    real=$(readlink -f "$1" 2>/dev/null) || return 1
    while read -r name type size rest; do
        if [[ "$name" != "Filename" && "$(readlink -f "$name" 2>/dev/null)" == "$real" ]]; then
            echo "$size"
            return 0
        fi
    done < /proc/swaps
    return 1
}

# /etc/fstab has a swap line for $1. With $2 = uuid, only a UUID line counts
_swap_in_fstab() {
    local real spec mp type rest dev
    real=$(readlink -f "$1" 2>/dev/null) || return 1
    while read -r spec mp type rest; do
        [[ "$type" == "swap" && "$spec" != \#* ]] || continue
        spec=${spec//\"/}
        if [[ "$2" == "uuid" && "$spec" != UUID=* && "$spec" != /dev/disk/by-uuid/* ]]; then
            continue
        fi
        case "$spec" in
            UUID=* | LABEL=* | PARTUUID=* | PARTLABEL=*) dev=$(findfs "$spec" 2>/dev/null) ;;
            *) dev=$spec ;;
        esac
        [[ -n "$dev" && "$(readlink -f "$dev" 2>/dev/null)" == "$real" ]] && return 0
    done < /etc/fstab
    return 1
}

# Swap total in KiB from saved free -h output
_swap_free_total_kib() {
    awk '$1 == "Swap:" {
        n = $2 + 0; u = $2; sub(/^[0-9.]+/, "", u)
        if (u == "B") m = 1 / 1024
        else if (u == "" || u ~ /^K/) m = 1
        else if (u ~ /^M/) m = 1024
        else if (u ~ /^G/) m = 1048576
        else if (u ~ /^T/) m = 1073741824
        else m = 0
        printf "%d\n", n * m
        exit
    }' "$1" 2>/dev/null
}

# The saved swapon --show output lists $1, and the saved free -h Swap total includes it
_swap_verified() {
    local real active baseline total
    real=$(readlink -f "$1" 2>/dev/null)
    active=$(_swap_active_kib "$1") || return 1
    baseline=$(cat "$STATE_DIR/baseline_kib" 2>/dev/null)
    total=$(_swap_free_total_kib /tmp/free_h.txt)
    awk -v d="$real" '$1 == d { f = 1 } END { exit !f }' /tmp/swapon_show.txt 2>/dev/null \
        && [[ -n "$total" ]] && (( total >= ${baseline:-0} + active * 3 / 4 ))
}

# Nothing from the disk is mounted (swap is not a problem: it is turned off first)
_swap_disk_is_free() {
    ! lsblk -n -o MOUNTPOINT "$1" 2>/dev/null | grep -vxF '[SWAP]' | grep -qE '\S'
}

# Remove LVM, partition and swap signatures from the disk
_swap_wipe_disk() {
    local vg dev
    for vg in $(pvs --noheadings -o vg_name "$1" 2>/dev/null); do
        lvremove -f "$vg" &>/dev/null
        vgremove -f "$vg" &>/dev/null
    done
    pvremove -ff -y "$1" &>/dev/null
    for dev in $(lsblk -lnpo NAME,TYPE "$1" 2>/dev/null | awk '$2 == "part" { print $1 }'); do
        wipefs -a "$dev" &>/dev/null
    done
    wipefs -a "$1" &>/dev/null
}

# Turn the lab swap off, put back /etc/fstab and wipe the lab disk (also after an unfinished run of this lab)
_swap_cleanup() {
    local disk dev
    disk=$(cat "$STATE_DIR/disk" 2>/dev/null)
    swapoff "$LV_PATH" &>/dev/null
    if [[ -b "$disk" ]]; then
        for dev in $(lsblk -lnpo NAME "$disk" 2>/dev/null); do
            swapoff "$dev" &>/dev/null
        done
    fi
    if [[ -f "$STATE_DIR/fstab" ]]; then
        cp -f "$STATE_DIR/fstab" /etc/fstab
        systemctl daemon-reload &>/dev/null
    fi
    if [[ -b "$disk" ]] && _swap_disk_is_free "$disk"; then
        _swap_wipe_disk "$disk"
    fi
    rm -f /tmp/swapon_show.txt /tmp/free_h.txt
    rm -rf "$STATE_DIR"
}

# Verify 1 spare disk exists before starting. If not, the web UI shows this
# message and never starts the lab.
check_prerequisites() {
    PREREQ_OK=true
    if [[ ! -b "$(cat "$STATE_DIR/disk" 2>/dev/null)" && -z "$(_swap_find_spare_disks)" ]]; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab needs 1 extra disk of ${MIN_DISK_SIZE_GB} GB or more: not the disk that holds /, with no partitions, and not mounted or used as swap. No such disk was found on this machine. Add a disk and try again."
    elif vgs "$VG_NAME" &>/dev/null && ! pvs --noheadings -o vg_name "$(cat "$STATE_DIR/disk" 2>/dev/null)" 2>/dev/null | grep -qw "$VG_NAME"; then
        PREREQ_OK=false
        PREREQ_MESSAGE="A volume group named ${VG_NAME} is already on this machine, and this lab did not make it. Remove it or rename it, then try again."
    fi
}

# Prepare the lab environment
prepare_lab() {
    _swap_cleanup

    echo -e "  ${DIM}• Detecting a spare disk...${RESET}"
    DISK1=$(_swap_find_spare_disks | head -n1)
    if [[ -z "$DISK1" ]]; then
        echo -e "  ${RED}✗ No spare disk found${RESET}"
        return
    fi
    mkdir -p "$STATE_DIR"
    echo "$DISK1" > "$STATE_DIR/disk"

    echo -e "  ${DIM}• Wiping any existing data on ${DISK1}...${RESET}"
    _swap_wipe_disk "$DISK1"

    echo -e "  ${DIM}• Backing up /etc/fstab...${RESET}"
    cp -f /etc/fstab "$STATE_DIR/fstab"
    awk '/^SwapTotal:/ { print $2 }' /proc/meminfo > "$STATE_DIR/baseline_kib"
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local size vg active
    size=$(lvs --noheadings --units b --nosuffix -o lv_size "${VG_NAME}/${LV_NAME}" 2>/dev/null | tr -d ' ')
    vg=$(pvs --noheadings -o vg_name "$DISK1" 2>/dev/null | tr -d ' ')
    active=$(_swap_active_kib "$LV_PATH")

    # Task 0: the volume group is on the lab disk, and the logical volume is
    # 512 MiB. It stays complete after Task 2 extends the volume.
    if [[ -f "$STATE_DIR/task1_done" ]]; then
        TASK_STATUS[0]="true"
    elif [[ "$vg" == "$VG_NAME" && "$size" == "536870912" ]]; then
        [[ -d "$STATE_DIR" ]] && touch "$STATE_DIR/task1_done"
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: swap signature on the volume, active now, and a line for it in /etc/fstab
    if [[ "$(blkid -p -o value -s TYPE "$LV_PATH" 2>/dev/null)" == "swap" && -n "$active" ]] \
        && _swap_in_fstab "$LV_PATH"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: the volume is 1 GiB, the active swap uses it all (mkswap ran
    # again), and the /etc/fstab line still finds it (a UUID line would not)
    if [[ "$size" == "1073741824" && -n "$active" ]] && (( active >= 1000000 )) \
        && _swap_in_fstab "$LV_PATH"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: saved swapon --show and free -h output, taken while the swap was on
    if _swap_verified "$LV_PATH"; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit - leave the disk blank
cleanup_lab() {
    echo -e "  ${DIM}• Turning off the swap, restoring /etc/fstab, removing ${VG_NAME} and wiping the disk...${RESET}"
    _swap_cleanup
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
