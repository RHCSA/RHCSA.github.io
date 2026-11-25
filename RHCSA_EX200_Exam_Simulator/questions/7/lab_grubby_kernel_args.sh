#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Add and remove kernel command-line parameters with grubby
# Host-machine terminal only: a container has no boot loader.
# NOTE: prepare_lab backs up the GRUB files and the boot entries, removes all
# audit= and audit_backlog_limit= parameters and adds rhgb quiet to each
# entry, so no task can pass before the student does it. cleanup_lab puts
# back the original files.
# NOTE: Task 3 needs a second kernel. If the system has only one (a rescue
# entry does not count), prepare_lab adds a hard link to the running kernel
# with its own boot entry (<version>-0.rhcsa_lab.<arch>). It starts the same
# kernel and initramfs. cleanup_lab removes it.

IS_LAB=true
LAB_ID="grubby_kernel_args"

QUESTION="Add and remove kernel command-line parameters with grubby"
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=3

# Not in /tmp: the backup must stay if the student reboots during the lab
BACKUP_DIR="/var/tmp/.rhcsa_lab_grubby_kernel_args"

# =============================================================================
# TASK DEFINITIONS - Each task has question, answer, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Add the kernel parameter audit=1 to all installed kernels"
TASK_1_ANSWER="--update-kernel=ALL changes the boot entries of all kernels, and --args adds the parameter. grubby writes the change in /boot/loader/entries, so it stays after a reboot"
TASK_1_COMMAND_1="grubby --update-kernel=ALL --args='audit=1'"
TASK_1_COMMAND_2="grubby --info=ALL"

# Task 2
TASK_2_QUESTION="Show the boot messages during startup: remove the parameters 'rhgb quiet' from all installed kernels"
TASK_2_ANSWER="rhgb shows the graphical boot screen, and quiet hides most boot messages. --remove-args removes one or more parameters. Put two or more parameters in quotes"
TASK_2_COMMAND_1="grubby --update-kernel=ALL --remove-args='rhgb quiet'"

# Task 3
TASK_3_QUESTION="Add the kernel parameter audit_backlog_limit=8192 only to the kernel that runs now. The other kernels must not get it"
TASK_3_ANSWER="uname -r shows the version of the running kernel. Give --update-kernel the path of this kernel, not ALL. A kernel with rhcsa_lab in its name is a copy that the lab adds when the system has only one kernel"
TASK_3_COMMAND_1="grubby --update-kernel=/boot/vmlinuz-\$(uname -r) --args='audit_backlog_limit=8192'"
TASK_3_COMMAND_2="grubby --info=ALL"

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

# One line for each boot entry: <kernel path><TAB><parameters>
_lab_entries() {
    grubby --info=ALL 2>/dev/null | awk '
        /^index=/  { if (n++) print k "\t" a; k = ""; a = "" }
        /^kernel=/ { k = substr($0, 8); gsub(/"/, "", k) }
        /^args=/   { a = substr($0, 6); gsub(/"/, "", a) }
        END        { if (n) print k "\t" a }'
}

check_prerequisites() {
    PREREQ_OK=true
    if systemd-detect-virt --container -q 2>/dev/null; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab changes the boot loader, so it cannot run inside a container. Use a Rocky Linux 10 virtual machine."
    elif ! command -v grubby &>/dev/null || [[ -z "$(_lab_entries)" ]]; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab needs the grubby command and GRUB boot entries in /boot/loader/entries. They were not found on this machine."
    elif ! _lab_entries | cut -f1 | grep -qxF "/boot/vmlinuz-$(uname -r)"; then
        PREREQ_OK=false
        PREREQ_MESSAGE="The kernel that runs now ($(uname -r)) has no boot entry. Reboot into the default kernel, then start the lab again."
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

# Each boot entry: no audit= or audit_backlog_limit=, and rhgb quiet at the end
_lab_reset_args() {
    local f content
    for f in /boot/loader/entries/*.conf; do
        [[ -f "$f" ]] || continue
        content=$(awk '
            $1 == "options" {
                line = "options"
                for (i = 2; i <= NF; i++)
                    if ($i !~ /^audit(_backlog_limit)?=/ && $i != "rhgb" && $i != "quiet") line = line " " $i
                print line " rhgb quiet"
                next
            }
            { print }' "$f") && printf '%s\n' "$content" > "$f"
    done
}

# Put back the files from the backup (also after an unfinished run of this lab)
_lab_restore() {
    local f
    rm -f /boot/loader/entries/*rhcsa_lab*.conf /boot/vmlinuz-*rhcsa_lab*
    [[ -d "$BACKUP_DIR" ]] || return 0
    [[ -f "$BACKUP_DIR/default_grub" ]] && cp -f "$BACKUP_DIR/default_grub" /etc/default/grub
    [[ -f "$BACKUP_DIR/grub.cfg" ]] && cp -f "$BACKUP_DIR/grub.cfg" /boot/grub2/grub.cfg
    for f in "$BACKUP_DIR"/entries/*.conf; do
        [[ -f "$f" ]] && cp -f "$f" /boot/loader/entries/
    done
    rm -rf "$BACKUP_DIR"
}

# Prepare the lab environment
prepare_lab() {
    _lab_restore

    echo -e "  ${DIM}• Backing up the GRUB files and boot entries...${RESET}"
    mkdir -p "$BACKUP_DIR/entries"
    cp -f /etc/default/grub "$BACKUP_DIR/default_grub" 2>/dev/null
    cp -f /boot/grub2/grub.cfg "$BACKUP_DIR/grub.cfg" 2>/dev/null
    cp -f /boot/loader/entries/*.conf "$BACKUP_DIR/entries/"

    echo -e "  ${DIM}• Adding a second kernel if the system has only one...${RESET}"
    _lab_add_second_kernel

    echo -e "  ${DIM}• Setting known kernel parameters in each boot entry...${RESET}"
    _lab_reset_args
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local running kernel args count=0
    local all_audit="true" no_rhgb_quiet="true" running_limit="false" other_limit="false"
    running="/boot/vmlinuz-$(uname -r)"

    while IFS=$'\t' read -r kernel args; do
        [[ -n "$kernel" ]] || continue
        count=$((count + 1))
        args=" $args "
        [[ "$args" == *" audit=1 "* ]] || all_audit="false"
        if [[ "$args" == *" rhgb "* || "$args" == *" quiet "* ]]; then
            no_rhgb_quiet="false"
        fi
        if [[ "$args" == *" audit_backlog_limit=8192 "* ]]; then
            if [[ "$kernel" == "$running" ]]; then
                running_limit="true"
            else
                other_limit="true"
            fi
        fi
    done < <(_lab_entries)

    # Task 0: audit=1 in every boot entry
    if [[ $count -gt 0 && "$all_audit" == "true" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: no boot entry has rhgb or quiet
    if [[ $count -gt 0 && "$no_rhgb_quiet" == "true" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: audit_backlog_limit=8192 in the running kernel's entry and in no other entry
    if [[ "$running_limit" == "true" && "$other_limit" == "false" ]]; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Restoring the original boot entries and GRUB files...${RESET}"
    _lab_restore
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
