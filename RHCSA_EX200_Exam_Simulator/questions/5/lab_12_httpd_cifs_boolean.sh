#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_12_httpd_cifs_boolean"
QUESTION="Sta toe dat httpd Samba/CIFS-content gebruikt."
LAB_TASK_COUNT=1
TASK_1_QUESTION="Boolean httpd_use_cifs moet aan staan."
TASK_1_HINT="Gebruik setsebool -P httpd_use_cifs on."
TASK_1_COMMAND_1="getsebool httpd_use_cifs | grep -q -- '--> on'"
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

