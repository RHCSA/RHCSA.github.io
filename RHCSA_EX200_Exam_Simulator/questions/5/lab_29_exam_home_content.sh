#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_29_exam_home_content"
QUESTION="User public_html moet via httpd kunnen werken. Zet de juiste boolean persistent aan."
LAB_TASK_COUNT=1
TASK_1_QUESTION="httpd_enable_homedirs moet aan staan."
TASK_1_HINT="Gebruik setsebool -P httpd_enable_homedirs on."
TASK_1_COMMAND_1="getsebool httpd_enable_homedirs | grep -q -- '--> on'"
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

