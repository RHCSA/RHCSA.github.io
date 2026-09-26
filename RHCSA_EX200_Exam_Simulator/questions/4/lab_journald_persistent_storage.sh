#!/bin/bash
# Objective 4: Operate running systems
# LAB: Configure Persistent Journals (journald.conf)
# Host-machine terminal only (no container) - the single default terminal
# every lab starts with.
# NOTE: this lab edits the REAL /etc/systemd/journald.conf. prepare_lab
# backs up the real file and resets Storage/SystemMaxUse to a known state
# (Storage=volatile, no SystemMaxUse) so both tasks start meaningful;
# cleanup_lab restores the exact original file and restarts the service -
# same reasoning as lab_systemd_targets_management.sh.
# NOTE: both tasks require systemd-journald to actually be restarted, not
# just the config file edited - checked by comparing the service's MainPID
# to a baseline captured at the end of prepare_lab (a restart always gets a
# new PID), not by anything that could be faked by editing the file alone.

IS_LAB=true
LAB_ID="journald_persistent_storage"

QUESTION="Configure persistent journals with journald.conf"

# Lab configuration
LAB_TASK_COUNT=2

BACKUP_FILE="/tmp/.rhcsa_lab_journald_conf_backup"
STATE_FILE="/tmp/.rhcsa_lab_journald_baseline_pid"

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Configure persistent journal storage. Edit /etc/systemd/journald.conf, add Storage=persistent under the [Journal] section, then restart the systemd-journald service so /var/log/journal starts being used"
TASK_1_HINT="Add a Storage=persistent line under [Journal] in journald.conf, then restart the service so the change takes effect"
TASK_1_COMMAND_1="sed -i '/^\[Journal\]/a Storage=persistent' /etc/systemd/journald.conf && systemctl restart systemd-journald"

# Task 2
TASK_2_QUESTION="Limit the journal to a maximum of 500M of disk space. Add SystemMaxUse=500M under the [Journal] section in the same file, then restart the systemd-journald service"
TASK_2_HINT="Add a SystemMaxUse=500M line under [Journal] in journald.conf, then restart the service so the change takes effect"
TASK_2_COMMAND_1="sed -i '/^\[Journal\]/a SystemMaxUse=500M' /etc/systemd/journald.conf && systemctl restart systemd-journald"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Backing up the real journald.conf...${RESET}"
    cp -f /etc/systemd/journald.conf "$BACKUP_FILE" 2>/dev/null

    echo -e "  ${DIM}• Resetting Storage/SystemMaxUse to a known state...${RESET}"
    sed -i '/^Storage=/d; /^#Storage=/d; /^SystemMaxUse=/d; /^#SystemMaxUse=/d' /etc/systemd/journald.conf
    grep -q '^\[Journal\]' /etc/systemd/journald.conf || echo '[Journal]' >> /etc/systemd/journald.conf
    # No Storage= line is (re-)added here on purpose: Task 1's own
    # `sed -i '/^\[Journal\]/a ...'` insert must be the ONLY Storage= line
    # afterward, since systemd config files use last-line-wins - a leftover
    # line here would end up below it and silently override it. Leaving
    # Storage unset (default "auto") plus no /var/log/journal already
    # behaves as non-persistent, matching the same starting state.
    rm -rf /var/log/journal

    echo -e "  ${DIM}• Restarting systemd-journald to apply the reset state...${RESET}"
    systemctl restart systemd-journald 2>/dev/null
    sleep 1

    echo -e "  ${DIM}• Recording the baseline journald PID...${RESET}"
    systemctl show systemd-journald -p MainPID --value > "$STATE_FILE" 2>/dev/null
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    local baseline_pid current_pid restarted
    baseline_pid=$(cat "$STATE_FILE" 2>/dev/null)
    current_pid=$(systemctl show systemd-journald -p MainPID --value 2>/dev/null)
    restarted="false"
    if [[ -n "$baseline_pid" ]] && [[ -n "$current_pid" ]] && [[ "$baseline_pid" != "$current_pid" ]]; then
        restarted="true"
    fi

    # Task 0: Storage=persistent set, journald restarted since the lab
    # started, and /var/log/journal actually has content now
    if grep -qE '^Storage=persistent$' /etc/systemd/journald.conf \
        && [[ "$restarted" == "true" ]] \
        && [[ -d /var/log/journal ]] && [[ -n "$(ls -A /var/log/journal 2>/dev/null)" ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: SystemMaxUse=500M set, and journald restarted since the lab started
    if grep -qE '^SystemMaxUse=500M$' /etc/systemd/journald.conf && [[ "$restarted" == "true" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Restoring the original journald.conf...${RESET}"
    if [[ -f "$BACKUP_FILE" ]]; then
        cp -f "$BACKUP_FILE" /etc/systemd/journald.conf
        rm -f "$BACKUP_FILE"
    fi
    systemctl restart systemd-journald 2>/dev/null
    rm -f "$STATE_FILE"
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
