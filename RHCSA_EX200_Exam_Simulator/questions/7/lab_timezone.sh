#!/bin/bash
# Objective 7: Deploy, configure, and maintain systems
# LAB: Set Time Zone

IS_LAB=true
LAB_ID="set_timezone"

QUESTION="[LAB] List and set the system time zone"
HINT="Task 1: timedatectl list-timezones | grep America > /tmp/timezones.txt\nTask 2: timedatectl set-timezone America/Toronto"

LAB_TITLE="Set Time Zone"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "List America timezones to /tmp/timezones.txt" ;;
        1) echo "Set timezone to America/Toronto" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Saving current timezone...${RESET}"
    timedatectl show --property=Timezone --value > /tmp/.lab_original_tz 2>/dev/null
    rm -f /tmp/timezones.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if timezones.txt exists with America zones
    if [[ -f /tmp/timezones.txt ]] && grep -q 'America/' /tmp/timezones.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if timezone is set to America/Toronto
    local current_tz=$(timedatectl show --property=Timezone --value 2>/dev/null)
    if [[ "$current_tz" == "America/Toronto" ]]; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Restoring original timezone...${RESET}"
    if [[ -f /tmp/.lab_original_tz ]]; then
        local orig_tz=$(cat /tmp/.lab_original_tz)
        timedatectl set-timezone "$orig_tz" 2>/dev/null
    fi
    rm -f /tmp/timezones.txt /tmp/.lab_original_tz 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
