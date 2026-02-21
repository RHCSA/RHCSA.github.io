#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: View Time Settings

IS_LAB=true
LAB_ID="time_settings"

QUESTION="[LAB] View and save system time settings"
HINT="Task 1: timedatectl > /tmp/time-settings.txt\nTask 2: date +%Y-%m-%d' '%H:%M:%S > /tmp/current-time.txt"

LAB_TITLE="View Time Settings"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Save timedatectl output to /tmp/time-settings.txt" ;;
        1) echo "Save formatted date to /tmp/current-time.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -f /tmp/time-settings.txt /tmp/current-time.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if time-settings.txt exists with timedatectl output
    if [[ -f /tmp/time-settings.txt ]] && grep -qiE 'time zone|local time|ntp' /tmp/time-settings.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if current-time.txt exists with date format
    if [[ -f /tmp/current-time.txt ]] && grep -qE '[0-9]{4}-[0-9]{2}-[0-9]{2}' /tmp/current-time.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/time-settings.txt /tmp/current-time.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
