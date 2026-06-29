#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_16_avc_report"
QUESTION="Maak /root/reports/avc.txt met recente AVC-denials of een duidelijke melding dat er geen zijn."
LAB_TASK_COUNT=2
TASK_1_QUESTION="AVC-rapport moet bestaan en inhoud hebben."
TASK_1_HINT="Gebruik ausearch -m avc of journalctl."
TASK_1_COMMAND_1="test -s /root/reports/avc.txt"
TASK_2_QUESTION="Rapport moet AVC of geen-AVC status noemen."
TASK_2_HINT="Schrijf ook iets als 'No AVC denials found'."
TASK_2_COMMAND_1="grep -Eiq 'avc|no.*avc|no denials' /root/reports/avc.txt"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /root/reports
}

check_tasks() {
  local passed=0
  local total=2
  if eval "$TASK_1_COMMAND_1" >/dev/null 2>&1; then
    echo "✓ Task 1 passed"
    ((passed++))
  else
    echo "✗ Task 1 failed: $TASK_1_QUESTION"
  fi
  if eval "$TASK_2_COMMAND_1" >/dev/null 2>&1; then
    echo "✓ Task 2 passed"
    ((passed++))
  else
    echo "✗ Task 2 failed: $TASK_2_QUESTION"
  fi
  echo "Score: $passed/$total"
  [[ $passed -eq $total ]]
}

cleanup_lab() {
  rm -f /root/reports/avc.txt
}

