#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_03_persistent_enforcing"
QUESTION="Zet SELinux persistent op enforcing in /etc/selinux/config."
LAB_TASK_COUNT=1
TASK_1_QUESTION="Persistent configuratie moet SELINUX=enforcing bevatten."
TASK_1_HINT="Bewerk /etc/selinux/config."
TASK_1_COMMAND_1="grep -Eq '^SELINUX=enforcing$' /etc/selinux/config"
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

