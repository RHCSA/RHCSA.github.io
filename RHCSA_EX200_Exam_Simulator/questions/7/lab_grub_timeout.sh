#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Change the GRUB boot menu timeout
# Host-machine terminal only: a container has no boot loader, and
# grub2-mkconfig cannot find the root device there.
# NOTE: prepare_lab backs up /etc/default/grub and /boot/grub2/grub.cfg,
# then sets GRUB_TIMEOUT=5 and writes grub.cfg again, so the task cannot pass
# before the student does it. cleanup_lab puts back the original files.

IS_LAB=true
LAB_ID="grub_timeout"

QUESTION="Change the GRUB boot menu timeout"
YOUTUBE_VIDEO="https://www.youtube.com/watch?v=Me6Y12-sux8"

# Lab configuration
LAB_TASK_COUNT=1

# Not in /tmp: the backup must stay if the student reboots during the lab
BACKUP_DIR="/var/tmp/.rhcsa_lab_grub_timeout"

# =============================================================================
# TASK DEFINITIONS - Each task has question, answer, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Set the GRUB boot menu timeout to 10 seconds. Edit /etc/default/grub, then write a new GRUB configuration file, so that the change stays after a reboot"
TASK_1_ANSWER="GRUB does not read /etc/default/grub at boot. grub2-mkconfig writes the new value into /boot/grub2/grub.cfg. On RHEL 10, use this path on BIOS and UEFI systems"
TASK_1_COMMAND_1="sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=10/' /etc/default/grub"
TASK_1_COMMAND_2="grub2-mkconfig -o /boot/grub2/grub.cfg"

# =============================================================================
# LAB IMPLEMENTATION
# =============================================================================

check_prerequisites() {
    PREREQ_OK=true
    if systemd-detect-virt --container -q 2>/dev/null; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab changes the boot loader, so it cannot run inside a container. Use a Rocky Linux 10 virtual machine."
    elif [[ ! -f /etc/default/grub || ! -f /boot/grub2/grub.cfg ]] || ! command -v grub2-mkconfig &>/dev/null; then
        PREREQ_OK=false
        PREREQ_MESSAGE="This lab needs GRUB 2: /etc/default/grub, /boot/grub2/grub.cfg and the grub2-mkconfig command. They were not found on this machine."
    fi
}

# Put back the files from the backup (also after an unfinished run of this lab)
_lab_restore() {
    [[ -d "$BACKUP_DIR" ]] || return 0
    [[ -f "$BACKUP_DIR/default_grub" ]] && cp -f "$BACKUP_DIR/default_grub" /etc/default/grub
    [[ -f "$BACKUP_DIR/grub.cfg" ]] && cp -f "$BACKUP_DIR/grub.cfg" /boot/grub2/grub.cfg
    rm -rf "$BACKUP_DIR"
}

# Prepare the lab environment
prepare_lab() {
    _lab_restore

    echo -e "  ${DIM}• Backing up /etc/default/grub and /boot/grub2/grub.cfg...${RESET}"
    mkdir -p "$BACKUP_DIR"
    cp -f /etc/default/grub "$BACKUP_DIR/default_grub"
    cp -f /boot/grub2/grub.cfg "$BACKUP_DIR/grub.cfg"

    echo -e "  ${DIM}• Setting the timeout to 5 seconds...${RESET}"
    if grep -q '^GRUB_TIMEOUT=' /etc/default/grub; then
        sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' /etc/default/grub
    else
        echo 'GRUB_TIMEOUT=5' >> /etc/default/grub
    fi
    grub2-mkconfig -o /boot/grub2/grub.cfg &>/dev/null
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: GRUB_TIMEOUT=10 in /etc/default/grub, and grub2-mkconfig wrote
    # it into grub.cfg (an edit of /etc/default/grub alone does not pass)
    if grep -qE "^GRUB_TIMEOUT=[\"']?10[\"']?[[:space:]]*$" /etc/default/grub 2>/dev/null \
        && grep -qE '^[[:space:]]*set timeout=10[[:space:]]*$' /boot/grub2/grub.cfg 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Restoring the original GRUB files...${RESET}"
    _lab_restore
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
