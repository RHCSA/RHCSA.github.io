#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_30_full_selinux_audit"
QUESTION="Maak /root/reports/selinux-full-audit.txt met mode, config, fcontext, ports en booleans."
LAB_TASK_COUNT=2
TASK_1_QUESTION="Full audit rapport moet bestaan."
TASK_1_HINT="Maak /root/reports/selinux-full-audit.txt."
TASK_1_COMMAND_1="test -s /root/reports/selinux-full-audit.txt"
TASK_2_QUESTION="Rapport moet SELinux kernonderdelen bevatten."
TASK_2_HINT="Neem getenforce, semanage fcontext, semanage port en getsebool op."
TASK_2_COMMAND_1="grep -Eiq 'getenforce|SELinux|semanage|boolean|context|port|fcontext' /root/reports/selinux-full-audit.txt"
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
  rm -f /root/reports/selinux-full-audit.txt
}

