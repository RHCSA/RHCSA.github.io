#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_01_selinux_status"
QUESTION="Controleer dat SELinux beschikbaar is en niet disabled staat."
LAB_TASK_COUNT=1
TASK_1_QUESTION="SELinux moet niet disabled zijn."
TASK_1_HINT="Gebruik getenforce of sestatus."
TASK_1_COMMAND_1="getenforce | grep -Ev '^Disabled$'"
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

