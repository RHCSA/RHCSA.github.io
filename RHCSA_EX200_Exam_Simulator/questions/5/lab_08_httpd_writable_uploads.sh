#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_08_httpd_writable_uploads"
QUESTION="Maak /web/uploads beschrijfbaar voor httpd met juiste SELinux-context."
LAB_TASK_COUNT=1
TASK_1_QUESTION="/web/uploads moet httpd_sys_rw_content_t hebben."
TASK_1_HINT="Gebruik httpd_sys_rw_content_t en restorecon."
TASK_1_COMMAND_1="ls -Zd /web/uploads | grep -q 'httpd_sys_rw_content_t'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /web/uploads
  chcon -R -t user_tmp_t /web/uploads 2>/dev/null || true
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
  rm -rf /web/uploads
  semanage fcontext -d '/web/uploads(/.*)?' 2>/dev/null || true
}

