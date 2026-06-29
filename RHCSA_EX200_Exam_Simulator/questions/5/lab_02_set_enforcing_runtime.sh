#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_02_set_enforcing_runtime"
QUESTION="Zet SELinux runtime op enforcing."
LAB_TASK_COUNT=1
TASK_1_QUESTION="SELinux runtime mode moet Enforcing zijn."
TASK_1_HINT="Gebruik setenforce 1."
TASK_1_COMMAND_1="getenforce | grep -q '^Enforcing$'"
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

