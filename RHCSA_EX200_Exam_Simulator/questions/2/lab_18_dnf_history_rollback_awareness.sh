#!/bin/bash
# Objective 2: Manage software
# LAB: Inspect DNF transaction history
IS_LAB=true
LAB_ID="dnf_history_rollback_awareness"
QUESTION="Inspect DNF transaction history after a package operation"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Install package bc"
TASK_1_HINT="Use dnf install -y bc"
TASK_1_COMMAND_1="dnf install -y bc"
TASK_2_QUESTION="Save DNF transaction history to /tmp/exam/dnf-history.txt"
TASK_2_HINT="Use dnf history"
TASK_2_COMMAND_1="dnf history > /tmp/exam/dnf-history.txt"
TASK_3_QUESTION="Save detailed information for the most recent transaction to /tmp/exam/dnf-history-last.txt"
TASK_3_HINT="Use dnf history info last"
TASK_3_COMMAND_1="dnf history info last > /tmp/exam/dnf-history-last.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam; rm -f /tmp/exam/dnf-history.txt /tmp/exam/dnf-history-last.txt; dnf remove -y bc &>/dev/null || true; }
check_tasks(){
 rpm -q bc &>/dev/null && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -s /tmp/exam/dnf-history.txt ]] && grep -Eqi 'ID|Transaction|Install|history' /tmp/exam/dnf-history.txt && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/dnf-history-last.txt ]] && grep -Eqi 'Transaction ID|Packages Altered|Install|bc' /tmp/exam/dnf-history-last.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ dnf remove -y bc &>/dev/null || true; rm -f /tmp/exam/dnf-history.txt /tmp/exam/dnf-history-last.txt; }
