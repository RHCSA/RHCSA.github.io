#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_10_httpd_network_boolean"
QUESTION="Zet httpd_can_network_connect persistent aan."
LAB_TASK_COUNT=1
TASK_1_QUESTION="Boolean httpd_can_network_connect moet aan staan."
TASK_1_HINT="Gebruik setsebool -P."
TASK_1_COMMAND_1="getsebool httpd_can_network_connect | grep -q -- '--> on'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
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
  true
}

