#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_05_persistent_web_fcontext"
QUESTION="Maak /web/content persistent leesbaar voor httpd."
LAB_TASK_COUNT=2
TASK_1_QUESTION="Er moet een semanage fcontext-regel zijn voor /web/content(/.*)?."
TASK_1_HINT="Gebruik semanage fcontext -a -t httpd_sys_content_t."
TASK_1_COMMAND_1="semanage fcontext -l | grep -E '^/web/content\(/\.\*\)\?[[:space:]]+' | grep -q 'httpd_sys_content_t'"
TASK_2_QUESTION="/web/content moet httpd_sys_content_t hebben."
TASK_2_HINT="Gebruik restorecon -Rv /web/content."
TASK_2_COMMAND_1="ls -Zd /web/content | grep -q 'httpd_sys_content_t'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /web/content
  printf 'web content\n' > /web/content/index.html
  chcon -R -t user_tmp_t /web/content 2>/dev/null || true
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
  rm -rf /web/content
  semanage fcontext -d '/web/content(/.*)?' 2>/dev/null || true
}

