#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_26_exam_webdata_selinux"
QUESTION="Website-content staat in /examweb maar is door SELinux niet correct. Los persistent op."
LAB_TASK_COUNT=2
TASK_1_QUESTION="Persistent fcontext-regel voor /examweb moet bestaan."
TASK_1_HINT="Gebruik semanage fcontext."
TASK_1_COMMAND_1="semanage fcontext -l | grep -E '^/examweb\(/\.\*\)\?[[:space:]]+' | grep -q 'httpd_sys_content_t'"
TASK_2_QUESTION="/examweb/index.html moet httpd_sys_content_t hebben."
TASK_2_HINT="Gebruik restorecon -Rv /examweb."
TASK_2_COMMAND_1="ls -Z /examweb/index.html | grep -q 'httpd_sys_content_t'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /examweb
  printf 'exam web\n' >/examweb/index.html
  chcon -R -t user_tmp_t /examweb 2>/dev/null || true
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
  rm -rf /examweb
  semanage fcontext -d '/examweb(/.*)?' 2>/dev/null || true
}

