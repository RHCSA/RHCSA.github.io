#!/bin/bash
# Objective 5: Configure local storage
# LAB: Use a whole disk as swap space
# Host-machine terminal only. Needs 1 spare disk (no partitions, not mounted,
# not used as swap, 2 GB or more).
# NOTE: prepare_lab wipes the spare disk and backs up /etc/fstab. cleanup_lab
# turns the swap off, puts back /etc/fstab and wipes the disk.

IS_LAB=true
LAB_ID="swap_whole_disk"

QUESTION="Use a whole disk as swap space and make it persistent"
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=3

# Not in /tmp: the state must stay if the student reboots during the lab
STATE_DIR="/var/tmp/.rhcsa_lab_swap_whole_disk"
MIN_DISK_SIZE_GB=2

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
TASK_1_QUESTION="Create a swap area on the whole disk ${DISK1}. Do not create a partition"
TASK_1_ANSWER="mkswap writes a swap signature on the device that you give it. Give it the whole disk, not a partition"
TASK_1_COMMAND_1="mkswap ${DISK1}"

# Task 2
TASK_2_QUESTION="Turn on the swap on ${DISK1} now, and make it turn on at each boot. Use the UUID of ${DISK1} in /etc/fstab"
TASK_2_ANSWER="A swap line in /etc/fstab has 6 fields: UUID=<uuid> none swap defaults 0 0. You can also add the line with vim. swapon -a turns on each swap area in /etc/fstab, so it also tests the new line"
TASK_2_COMMAND_1="echo UUID=\$(blkid -s UUID -o value ${DISK1}) none swap defaults 0 0 >> /etc/fstab"
TASK_2_COMMAND_2="systemctl daemon-reload"
TASK_2_COMMAND_3="swapon -a"

# Task 3
TASK_3_QUESTION="Check the swap. Save the output of swapon --show to /tmp/swapon_show.txt, and the output of free -h to /tmp/free_h.txt"
TASK_3_ANSWER="swapon --show lists the active swap areas. In the free -h output, the Swap line shows the total swap space, which now includes ${DISK1}"
TASK_3_COMMAND_1="swapon --show > /tmp/swapon_show.txt"
TASK_3_COMMAND_2="free -h > /tmp/free_h.txt"

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
    # Task 0: swap signature on the whole disk (not on a partition)
    if [[ -b "$DISK1" && "$(blkid -p -o value -s TYPE "$DISK1" 2>/dev/null)" == "swap" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: active now, and a UUID line for it in /etc/fstab
    if _swap_active_kib "$DISK1" >/dev/null && _swap_in_fstab "$DISK1" uuid; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: saved swapon --show and free -h output, taken while the swap was on
    if _swap_verified "$DISK1"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit - leave the disk blank
cleanup_lab() {
    echo -e "  ${DIM}• Turning off the swap, restoring /etc/fstab and wiping the disk...${RESET}"
    _swap_cleanup
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
