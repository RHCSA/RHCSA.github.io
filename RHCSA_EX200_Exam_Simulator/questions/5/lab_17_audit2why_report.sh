#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_17_audit2why_report"
QUESTION="Maak /root/reports/avc-why.txt met audit2why-output of fallbackmelding."
LAB_TASK_COUNT=1
TASK_1_QUESTION="Analysebestand moet bestaan en inhoud hebben."
TASK_1_HINT="Gebruik ausearch -m avc | audit2why of fallbacktekst."
TASK_1_COMMAND_1="test -s /root/reports/avc-why.txt"
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
  rm -f /root/reports/avc-why.txt
}

