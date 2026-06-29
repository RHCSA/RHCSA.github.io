#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_18_journal_selinux_report"
QUESTION="Maak /root/reports/selinux-journal.txt met SELinux/audit meldingen uit journalctl."
LAB_TASK_COUNT=1
TASK_1_QUESTION="Journalrapport moet bestaan en inhoud hebben."
TASK_1_HINT="Gebruik journalctl en grep op selinux/audit/avc."
TASK_1_COMMAND_1="test -s /root/reports/selinux-journal.txt"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /root/reports
}

check_tasks() {
  local passed=0
  local total=1
  if eval "$TASK_1_COMMAND_1" >/dev/null 2>&1; then
    echo "✓ Task 1 passed"
    ((passed++))
  else
    echo "✗ Task 1 failed: $TASK_1_QUESTION"
  fi
  echo "Score: $passed/$total"
  [[ $passed -eq $total ]]
}

cleanup_lab() {
  rm -f /root/reports/selinux-journal.txt
}

