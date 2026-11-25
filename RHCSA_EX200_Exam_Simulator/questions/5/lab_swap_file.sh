#!/bin/bash
# Objective 5: Configure local storage
# LAB: Create a swap file, then make it larger
# Host-machine terminal only. Needs about 1.2 GiB of free space on /.
# NOTE: prepare_lab backs up /etc/fstab. cleanup_lab turns the swap off,
# removes /swapfile_lab and puts back /etc/fstab.
# NOTE: Task 1 stays complete after Task 3 makes the file larger (a marker
# file in STATE_DIR), so all tasks can pass at the same time.

IS_LAB=true
LAB_ID="swap_file"

QUESTION="Create a swap file, make it persistent, then make it larger"
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=4

# Not in /tmp: the state must stay if the student reboots during the lab
STATE_DIR="/var/tmp/.rhcsa_lab_swap_file"
SWAP_FILE="/swapfile_lab"

# =============================================================================
# TASK DEFINITIONS - Each task has question, answer, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create the file /swapfile_lab with a size of 512 MiB, to use for swap. Only root can read and write the file"
TASK_1_ANSWER="dd writes 512 blocks of 1 MiB. Use dd, not truncate: a swap file must not have holes. mkswap gives a warning if other users can read the file"
TASK_1_COMMAND_1="dd if=/dev/zero of=/swapfile_lab bs=1M count=512"
TASK_1_COMMAND_2="chmod 600 /swapfile_lab"

# Task 2
TASK_2_QUESTION="Create a swap area in /swapfile_lab, turn it on now, and make it turn on at each boot"
TASK_2_ANSWER="For a swap file, put the path of the file in the first field of the /etc/fstab line. You can also add the line with vim. swapon -a turns on each swap area in /etc/fstab, so it also tests the new line"
TASK_2_COMMAND_1="mkswap /swapfile_lab"
TASK_2_COMMAND_2="echo /swapfile_lab none swap defaults 0 0 >> /etc/fstab"
TASK_2_COMMAND_3="systemctl daemon-reload"
TASK_2_COMMAND_4="swapon -a"

# Task 3
TASK_3_QUESTION="Make the swap file larger: 1 GiB in total. The swap must stay on after a reboot"
TASK_3_ANSWER="You cannot change the size of an active swap area. Turn it off, write the larger file, and run mkswap again, so that the swap uses the new size. Then turn it on. The line in /etc/fstab uses the path, so it does not change"
TASK_3_COMMAND_1="swapoff /swapfile_lab"
TASK_3_COMMAND_2="dd if=/dev/zero of=/swapfile_lab bs=1M count=1024"
TASK_3_COMMAND_3="mkswap /swapfile_lab"
TASK_3_COMMAND_4="swapon -a"

# Task 4
TASK_4_QUESTION="Check the swap. Save the output of swapon --show to /tmp/swapon_show.txt, and the output of free -h to /tmp/free_h.txt"
TASK_4_ANSWER="swapon --show lists the active swap areas. In the free -h output, the Swap line shows the total swap space, which now includes /swapfile_lab"
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

# /etc/fstab has a swap line for the file $1
_swap_in_fstab() {
    local spec mp type rest
    while read -r spec mp type rest; do
        [[ "$type" == "swap" && "${spec//\"/}" == "$1" ]] && return 0
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
    local active baseline total
    active=$(_swap_active_kib "$1") || return 1
    baseline=$(cat "$STATE_DIR/baseline_kib" 2>/dev/null)
    total=$(_swap_free_total_kib /tmp/free_h.txt)
    awk -v d="$1" '$1 == d { f = 1 } END { exit !f }' /tmp/swapon_show.txt 2>/dev/null \
        && [[ -n "$total" ]] && (( total >= ${baseline:-0} + active * 3 / 4 ))
}

# Turn the lab swap off, remove the file and put back /etc/fstab (also after an unfinished run of this lab)
_swap_cleanup() {
    swapoff "$SWAP_FILE" &>/dev/null
    rm -f "$SWAP_FILE"
    if [[ -f "$STATE_DIR/fstab" ]]; then
        cp -f "$STATE_DIR/fstab" /etc/fstab
        systemctl daemon-reload &>/dev/null
    fi
    rm -f /tmp/swapon_show.txt /tmp/free_h.txt
    rm -rf "$STATE_DIR"
}

# Verify there is space for a 1 GiB swap file before starting
check_prerequisites() {
    local avail_kib
    PREREQ_OK=true
    avail_kib=$(df --output=avail -k / 2>/dev/null | tail -n 1)
    [[ -f "$SWAP_FILE" ]] && avail_kib=$(( avail_kib + $(stat -c %s "$SWAP_FILE") / 1024 ))
    if [[ -z "$avail_kib" ]] || (( avail_kib < 1258291 )); then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab needs about 1.2 GiB of free space on / for the swap file. There is not enough free space on this machine."
    fi
}

# Prepare the lab environment
prepare_lab() {
    _swap_cleanup

    echo -e "  ${DIM}• Backing up /etc/fstab...${RESET}"
    mkdir -p "$STATE_DIR"
    cp -f /etc/fstab "$STATE_DIR/fstab"
    awk '/^SwapTotal:/ { print $2 }' /proc/meminfo > "$STATE_DIR/baseline_kib"
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local active
    active=$(_swap_active_kib "$SWAP_FILE")

    # Task 0: a 512 MiB file that only root can read and write. It stays
    # complete after Task 2 makes the file larger.
    if [[ -f "$STATE_DIR/task1_done" ]]; then
        TASK_STATUS[0]="true"
    elif [[ "$(stat -c '%s %a %U' "$SWAP_FILE" 2>/dev/null)" == "536870912 600 root" ]]; then
        [[ -d "$STATE_DIR" ]] && touch "$STATE_DIR/task1_done"
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: swap signature in the file, active now, and a line for it in /etc/fstab
    if [[ "$(blkid -p -o value -s TYPE "$SWAP_FILE" 2>/dev/null)" == "swap" && -n "$active" ]] \
        && _swap_in_fstab "$SWAP_FILE"; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: the file is 1 GiB, the active swap uses it all (mkswap ran again), and it is still in /etc/fstab
    if [[ "$(stat -c %s "$SWAP_FILE" 2>/dev/null)" == "1073741824" && -n "$active" ]] \
        && (( active >= 1000000 )) && _swap_in_fstab "$SWAP_FILE"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: saved swapon --show and free -h output, taken while the swap was on
    if _swap_verified "$SWAP_FILE"; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Turning off the swap, removing /swapfile_lab and restoring /etc/fstab...${RESET}"
    _swap_cleanup
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
