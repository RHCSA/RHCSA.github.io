#!/bin/bash
# Objective 2: Manage software
# LAB: Install multiple packages at once
IS_LAB=true
LAB_ID="dnf_install_multiple"
QUESTION="Install several useful command line packages and verify them"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Install packages tmux and lsof using one command"
TASK_1_HINT="dnf install accepts multiple package names"
TASK_1_COMMAND_1="dnf install -y tmux lsof"
TASK_2_QUESTION="Save installed package names to /tmp/exam/multi-packages.txt"
TASK_2_HINT="Use rpm -q tmux lsof"
TASK_2_COMMAND_1="rpm -q tmux lsof > /tmp/exam/multi-packages.txt"
TASK_3_QUESTION="Confirm both commands are available in PATH"
TASK_3_HINT="Use command -v or which"
TASK_3_COMMAND_1="command -v tmux lsof > /tmp/exam/multi-commands.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/multi-packages.txt /tmp/exam/multi-commands.txt; dnf remove -y tmux lsof &>/dev/null || true; }
check_tasks(){
 rpm -q tmux &>/dev/null && rpm -q lsof &>/dev/null && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /tmp/exam/multi-packages.txt ]] && grep -q '^tmux-' /tmp/exam/multi-packages.txt && grep -q '^lsof-' /tmp/exam/multi-packages.txt && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -f /tmp/exam/multi-commands.txt ]] && grep -q '/tmux' /tmp/exam/multi-commands.txt && grep -q '/lsof' /tmp/exam/multi-commands.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ dnf remove -y tmux lsof &>/dev/null || true; rm -f /tmp/exam/multi-packages.txt /tmp/exam/multi-commands.txt; }
