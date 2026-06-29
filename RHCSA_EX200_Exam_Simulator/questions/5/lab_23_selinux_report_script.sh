#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_23_selinux_report_script"
QUESTION="Maak /usr/local/bin/selinux-report.sh dat mode, config en booleans rapporteert."
LAB_TASK_COUNT=2
TASK_1_QUESTION="Script moet bestaan en uitvoerbaar zijn."
TASK_1_HINT="Plaats het in /usr/local/bin en chmod +x."
TASK_1_COMMAND_1="test -x /usr/local/bin/selinux-report.sh"
TASK_2_QUESTION="Script moet een rapport kunnen genereren."
TASK_2_HINT="Laat het SELinux informatie printen."
TASK_2_COMMAND_1="/usr/local/bin/selinux-report.sh | grep -Eiq 'selinux|getenforce|mode|boolean|httpd'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
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
  rm -f /usr/local/bin/selinux-report.sh
}

