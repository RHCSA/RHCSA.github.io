#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_28_exam_upload_failure"
QUESTION="Uploadmap /examweb/uploads werkt niet door SELinux. Los op zonder SELinux uit te zetten."
LAB_TASK_COUNT=1
TASK_1_QUESTION="Uploads moeten httpd_sys_rw_content_t hebben."
TASK_1_HINT="Gebruik httpd_sys_rw_content_t."
TASK_1_COMMAND_1="ls -Zd /examweb/uploads | grep -q 'httpd_sys_rw_content_t'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /examweb/uploads
  chcon -R -t user_tmp_t /examweb/uploads 2>/dev/null || true
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
  rm -rf /examweb/uploads
  semanage fcontext -d '/examweb/uploads(/.*)?' 2>/dev/null || true
}

