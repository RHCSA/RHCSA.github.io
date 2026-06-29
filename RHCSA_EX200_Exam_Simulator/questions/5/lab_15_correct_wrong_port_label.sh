#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_15_correct_wrong_port_label"
QUESTION="Corrigeer TCP-poort 9090 zodat deze http_port_t is."
LAB_TASK_COUNT=1
TASK_1_QUESTION="TCP 9090 moet http_port_t hebben."
TASK_1_HINT="Gebruik semanage port -m of verwijder en voeg opnieuw toe."
TASK_1_COMMAND_1="semanage port -l | awk '$1=="http_port_t" && $2=="tcp" && $0 ~ /(^|,| )9090($|,| )/ {found=1} END{exit !found}'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  semanage port -d -p tcp 9090 2>/dev/null || true
  semanage port -a -t ssh_port_t -p tcp 9090 2>/dev/null || true
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
  semanage port -d -t http_port_t -p tcp 9090 2>/dev/null || true
  semanage port -d -t ssh_port_t -p tcp 9090 2>/dev/null || true
}

