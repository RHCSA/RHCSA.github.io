#!/bin/bash
# Objective 4: Operate running systems
# LAB: Locate and Interpret System Log Files
# Host-machine terminal only (no container) - the single default terminal
# every lab starts with.
# NOTE: this lab writes into REAL system log files (/var/log/messages via
# logger, plus /var/log/secure, /var/log/boot.log, /var/log/cron,
# /var/log/dnf.log, /var/log/audit/audit.log). prepare_lab/cleanup_lab only
# ever append one marker line per file and remove that exact line again
# (sed -i '/marker/d') - the rest of each real log file is never touched,
# same approach as lab_script_persistent_env_var.sh's /etc/bashrc edit.
# prepare_lab also removes any leftover marker from a previous run before
# adding a fresh one, so restarting the lab never piles up duplicates.

IS_LAB=true
LAB_ID="locate_interpret_logs"

QUESTION="Locate and interpret system log files"

# Lab configuration
LAB_TASK_COUNT=7

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="A postfix error was just logged on this system. Find the line that mentions postfix in the general system log, and save it to /tmp/postfix_error.txt"
TASK_1_HINT="Use grep to search the log file for postfix, and redirect the output to the file"
TASK_1_COMMAND_1="cat /var/log/messages | grep postfix > /tmp/postfix_error.txt"

# Task 2
TASK_2_QUESTION="Write the path of the log file that stores general system messages (the one you just searched) to /tmp/messages_log_path.txt"
TASK_2_HINT="This is the standard log file for general system messages on RHEL-based systems"
TASK_2_COMMAND_1="echo /var/log/messages > /tmp/messages_log_path.txt"

# Task 3
TASK_3_QUESTION="Find the authentication problem in the authentication log, and save it to /tmp/secure_issue.txt"
TASK_3_HINT="Authentication logs are stored in /var/log/secure. Use grep to search it"
TASK_3_COMMAND_1="grep 'authentication error' /var/log/secure > /tmp/secure_issue.txt"

# Task 4
TASK_4_QUESTION="Find the disk problem in the boot log, and save it to /tmp/boot_issue.txt"
TASK_4_HINT="Boot messages are stored in /var/log/boot.log. Use grep to search it"
TASK_4_COMMAND_1="grep 'boot error' /var/log/boot.log > /tmp/boot_issue.txt"

# Task 5
TASK_5_QUESTION="Find the cron job problem in the cron log, and save it to /tmp/cron_issue.txt"
TASK_5_HINT="Cron job logs are stored in /var/log/cron. Use grep to search it"
TASK_5_COMMAND_1="grep 'cron error' /var/log/cron > /tmp/cron_issue.txt"

# Task 6
TASK_6_QUESTION="Find the package problem in the package manager log, and save it to /tmp/dnf_issue.txt"
TASK_6_HINT="Package manager logs are stored in /var/log/dnf.log. Use grep to search it"
TASK_6_COMMAND_1="grep 'dnf error' /var/log/dnf.log > /tmp/dnf_issue.txt"

# Task 7
TASK_7_QUESTION="Find the permission problem in the SELinux audit log, and save it to /tmp/audit_issue.txt"
TASK_7_HINT="SELinux audit logs are stored in /var/log/audit/audit.log. Use grep to search it"
TASK_7_COMMAND_1="grep 'audit error' /var/log/audit/audit.log > /tmp/audit_issue.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing any leftover markers from a previous run...${RESET}"
    mkdir -p /var/log/audit
    sed -i '/postfix error: user not found/d' /var/log/messages 2>/dev/null
    sed -i '/authentication error: invalid user detected from 10.0.0.99/d' /var/log/secure 2>/dev/null
    sed -i '/boot error: disk not available/d' /var/log/boot.log 2>/dev/null
    sed -i '/cron error: job failed to execute/d' /var/log/cron 2>/dev/null
    sed -i '/dnf error: package conflict detected/d' /var/log/dnf.log 2>/dev/null
    sed -i '/audit error: permission denied for process/d' /var/log/audit/audit.log 2>/dev/null

    echo -e "  ${DIM}• Removing old output files...${RESET}"
    rm -f /tmp/postfix_error.txt /tmp/messages_log_path.txt /tmp/secure_issue.txt \
        /tmp/boot_issue.txt /tmp/cron_issue.txt /tmp/dnf_issue.txt /tmp/audit_issue.txt
    sleep 0.3

    echo -e "  ${DIM}• Logging a postfix error to the system messages log...${RESET}"
    logger "postfix error: user not found"

    echo -e "  ${DIM}• Writing a sample problem into each log file...${RESET}"
    echo "authentication error: invalid user detected from 10.0.0.99" >> /var/log/secure
    echo "boot error: disk not available" >> /var/log/boot.log
    echo "cron error: job failed to execute" >> /var/log/cron
    echo "dnf error: package conflict detected" >> /var/log/dnf.log
    echo "audit error: permission denied for process" >> /var/log/audit/audit.log
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: postfix error found and saved
    if [[ -f /tmp/postfix_error.txt ]] && grep -q 'postfix error: user not found' /tmp/postfix_error.txt; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi

    # Task 1: correct log file path identified
    if [[ -f /tmp/messages_log_path.txt ]] && grep -q '/var/log/messages' /tmp/messages_log_path.txt; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi

    # Task 2: authentication problem found in /var/log/secure
    if [[ -f /tmp/secure_issue.txt ]] && grep -q 'authentication error: invalid user detected from 10.0.0.99' /tmp/secure_issue.txt; then
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[2]="false"
    fi

    # Task 3: boot problem found in /var/log/boot.log
    if [[ -f /tmp/boot_issue.txt ]] && grep -q 'boot error: disk not available' /tmp/boot_issue.txt; then
        TASK_STATUS[3]="true"
    else
        TASK_STATUS[3]="false"
    fi

    # Task 4: cron problem found in /var/log/cron
    if [[ -f /tmp/cron_issue.txt ]] && grep -q 'cron error: job failed to execute' /tmp/cron_issue.txt; then
        TASK_STATUS[4]="true"
    else
        TASK_STATUS[4]="false"
    fi

    # Task 5: dnf problem found in /var/log/dnf.log
    if [[ -f /tmp/dnf_issue.txt ]] && grep -q 'dnf error: package conflict detected' /tmp/dnf_issue.txt; then
        TASK_STATUS[5]="true"
    else
        TASK_STATUS[5]="false"
    fi

    # Task 6: audit problem found in /var/log/audit/audit.log
    if [[ -f /tmp/audit_issue.txt ]] && grep -q 'audit error: permission denied for process' /tmp/audit_issue.txt; then
        TASK_STATUS[6]="true"
    else
        TASK_STATUS[6]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Removing injected log entries...${RESET}"
    sed -i '/postfix error: user not found/d' /var/log/messages 2>/dev/null
    sed -i '/authentication error: invalid user detected from 10.0.0.99/d' /var/log/secure 2>/dev/null
    sed -i '/boot error: disk not available/d' /var/log/boot.log 2>/dev/null
    sed -i '/cron error: job failed to execute/d' /var/log/cron 2>/dev/null
    sed -i '/dnf error: package conflict detected/d' /var/log/dnf.log 2>/dev/null
    sed -i '/audit error: permission denied for process/d' /var/log/audit/audit.log 2>/dev/null

    echo -e "  ${DIM}• Removing lab output files...${RESET}"
    rm -f /tmp/postfix_error.txt /tmp/messages_log_path.txt /tmp/secure_issue.txt \
        /tmp/boot_issue.txt /tmp/cron_issue.txt /tmp/dnf_issue.txt /tmp/audit_issue.txt
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
