#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: List the kernels and change the default kernel with grubby
# Host-machine terminal only: a container has no boot loader.
# NOTE: Task 3 needs a second kernel. If the system has only one (a rescue
# entry does not count), prepare_lab adds a hard link to the running kernel
# with its own boot entry (<version>-0.rhcsa_lab.<arch>). It starts the same
# kernel and initramfs. cleanup_lab sets the original default kernel again
# and removes the copy.
# NOTE: Task 2 accepts the default kernel from the start of the lab or the
# default kernel now, so the order of Tasks 2 and 3 does not matter.

IS_LAB=true
LAB_ID="grubby_default_kernel"

QUESTION="List the kernels and change the default kernel with grubby"
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=3

# Not in /tmp: the original default must stay known if the student reboots during the lab
STATE_DIR="/var/tmp/.rhcsa_lab_grubby_default_kernel"

# One line for each boot entry: <kernel path><TAB><parameters>
_lab_entries() {
    grubby --info=ALL 2>/dev/null | awk '
        /^index=/  { if (n++) print k "\t" a; k = ""; a = "" }
        /^kernel=/ { k = substr($0, 8); gsub(/"/, "", k) }
        /^args=/   { a = substr($0, 6); gsub(/"/, "", a) }
        END        { if (n) print k "\t" a }'
}

# ORIG_DEFAULT: the default kernel at the start of the lab.
# OTHER_KERNEL: a kernel for the answer of Task 3 (not a rescue kernel, if possible).
_lab_load_kernels() {
    local others
    ORIG_DEFAULT=$(cat "$STATE_DIR/orig_default" 2>/dev/null)
    [[ -n "$ORIG_DEFAULT" ]] || ORIG_DEFAULT=$(grubby --default-kernel 2>/dev/null)
    others=$(_lab_entries | cut -f1 | grep -vxF "${ORIG_DEFAULT:-none}")
    OTHER_KERNEL=$(grep -v rescue <<< "$others" | head -n1)
    [[ -n "$OTHER_KERNEL" ]] || OTHER_KERNEL=$(head -n1 <<< "$others")
    [[ -n "$OTHER_KERNEL" ]] || OTHER_KERNEL="/boot/vmlinuz-<other-version>"
}
_lab_load_kernels

# =============================================================================
# TASK DEFINITIONS - Each task has question, answer, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="List all kernels that the boot loader can start. Save the list to /root/kernel_list.txt"
TASK_1_ANSWER="grubby --info=ALL shows all boot entries. Each kernel= line is a kernel that GRUB can start. A kernel with rhcsa_lab in its name is a copy that the lab adds when the system has only one kernel"
TASK_1_COMMAND_1="grubby --info=ALL | grep ^kernel > /root/kernel_list.txt"

# Task 2
TASK_2_QUESTION="Write the path of the default kernel to /root/default_kernel.txt. Do this before you change the default kernel in the next task"
TASK_2_ANSWER="grubby --default-kernel shows the path of the kernel that GRUB starts when you do not select a menu entry"
TASK_2_COMMAND_1="grubby --default-kernel > /root/default_kernel.txt"

# Task 3
TASK_3_QUESTION="Make a different kernel the default kernel: any kernel from the list that is not the default now. The change must stay after a reboot"
TASK_3_ANSWER="grubby --set-default writes the new default in /boot/grub2/grubenv, so it stays after a reboot. You can also use --set-default-index with an index from grubby --info=ALL"
TASK_3_COMMAND_1="grubby --set-default=${OTHER_KERNEL}"
TASK_3_COMMAND_2="grubby --default-kernel"

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

check_prerequisites() {
    PREREQ_OK=true
    if systemd-detect-virt --container -q 2>/dev/null; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab changes the boot loader, so it cannot run inside a container. Use a Rocky Linux 10 virtual machine."
    elif ! command -v grubby &>/dev/null || [[ -z "$(grubby --default-kernel 2>/dev/null)" ]]; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab needs the grubby command and GRUB boot entries in /boot/loader/entries. They were not found on this machine."
    elif [[ $(_lab_entries | cut -f1 | grep -vc rescue) -lt 2 ]] \
        && ! _lab_entries | cut -f1 | grep -qxF "/boot/vmlinuz-$(uname -r)"; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab needs a second kernel. The lab can add one, but only when the kernel that runs now ($(uname -r)) has a boot entry. Reboot into the default kernel, then start the lab again."
    fi
}

# A second kernel when the system has only one: a hard link to the running
# kernel, with a copy of its boot entry
_lab_add_second_kernel() {
    local running lab_kver template entry line
    running=$(uname -r)
    [[ $(_lab_entries | cut -f1 | grep -vc rescue) -lt 2 ]] || return 0
    template=$(awk -v k="/vmlinuz-$running" '$1 == "linux" && substr($2, length($2) - length(k) + 1) == k { print FILENAME; exit }' /boot/loader/entries/*.conf 2>/dev/null)
    [[ -n "$template" && -f "/boot/vmlinuz-$running" ]] || return 0

    lab_kver="${running%%-*}-0.rhcsa_lab.$(uname -m)"
    entry="${template%"$running.conf"}"
    [[ "$entry" != "$template" ]] || entry="/boot/loader/entries/$(cat /etc/machine-id)-"
    entry="$entry$lab_kver.conf"

    ln -f "/boot/vmlinuz-$running" "/boot/vmlinuz-$lab_kver" || return 0
    while IFS= read -r line; do
        case "$line" in
            "title "* | "linux "*) line="${line//"$running"/$lab_kver}" ;;
            "version "*) line="version $lab_kver" ;;
        esac
        printf '%s\n' "$line"
    done < "$template" > "$entry"
    restorecon "$entry" &>/dev/null
}

# Set the original default kernel again and remove the copy (also after an unfinished run of this lab)
_lab_restore() {
    local orig
    orig=$(cat "$STATE_DIR/orig_default" 2>/dev/null)
    [[ -n "$orig" ]] && grubby --set-default="$orig" &>/dev/null
    rm -f /boot/loader/entries/*rhcsa_lab*.conf /boot/vmlinuz-*rhcsa_lab*
    rm -rf "$STATE_DIR"
}

# Prepare the lab environment
prepare_lab() {
    _lab_restore

    echo -e "  ${DIM}• Saving the current default kernel...${RESET}"
    mkdir -p "$STATE_DIR"
    grubby --default-kernel > "$STATE_DIR/orig_default" 2>/dev/null

    echo -e "  ${DIM}• Adding a second kernel if the system has only one...${RESET}"
    _lab_add_second_kernel

    echo -e "  ${DIM}• Removing old output files...${RESET}"
    rm -f /root/kernel_list.txt /root/default_kernel.txt
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local kernels current listed found k ok
    kernels=$(_lab_entries | cut -f1)
    current=$(grubby --default-kernel 2>/dev/null)

    # Task 0: the list names each kernel that has a boot entry
    listed=$(grep -o 'vmlinuz-[^"[:space:]]*' /root/kernel_list.txt 2>/dev/null | sort -u)
    ok="false"
    if [[ -n "$kernels" && -n "$listed" ]]; then
        ok="true"
        while IFS= read -r k; do
            grep -qxF "${k##*/}" <<< "$listed" || ok="false"
        done <<< "$kernels"
    fi
    TASK_STATUS[0]="$ok"

    # Task 1: the file names one kernel only: the default at the start of the lab, or the default now
    found=$(grep -o 'vmlinuz-[^"[:space:]]*' /root/default_kernel.txt 2>/dev/null | sort -u)
    if [[ -n "$found" && "$found" != *$'\n'* ]] \
        && [[ "$found" == "${ORIG_DEFAULT##*/}" || "$found" == "${current##*/}" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: the default is now a different kernel, and that kernel has a boot entry
    if [[ -n "$current" && "$current" != "$ORIG_DEFAULT" ]] && grep -qxF "$current" <<< "$kernels"; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Setting the original default kernel again...${RESET}"
    _lab_restore
    rm -f /root/kernel_list.txt /root/default_kernel.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
