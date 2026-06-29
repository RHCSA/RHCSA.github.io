#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_13_ssh_custom_port"
QUESTION="Label TCP-poort 2222 als ssh_port_t."
LAB_TASK_COUNT=1
TASK_1_QUESTION="TCP 2222 moet ssh_port_t hebben."
TASK_1_HINT="Gebruik semanage port -a -t ssh_port_t -p tcp 2222."
TASK_1_COMMAND_1="semanage port -l | awk '$1=="ssh_port_t" && $2=="tcp" && $0 ~ /(^|,| )2222($|,| )/ {found=1} END{exit !found}'"
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
  semanage port -d -t ssh_port_t -p tcp 2222 2>/dev/null || true
}

