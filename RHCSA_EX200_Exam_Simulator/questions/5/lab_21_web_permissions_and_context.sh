#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_21_web_permissions_and_context"
QUESTION="Maak /web/app correct voor root:root, 755 en httpd_sys_content_t."
LAB_TASK_COUNT=2
TASK_1_QUESTION="/web/app moet root:root en 755 zijn."
TASK_1_HINT="Gebruik chown en chmod."
TASK_1_COMMAND_1="test "$(stat -c '%U:%G:%a' /web/app)" = 'root:root:755'"
TASK_2_QUESTION="/web/app moet httpd_sys_content_t hebben."
TASK_2_HINT="Gebruik semanage fcontext + restorecon."
TASK_2_COMMAND_1="ls -Zd /web/app | grep -q 'httpd_sys_content_t'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /web/app
  printf 'app\n' >/web/app/index.html
  chown -R nobody:nobody /web/app
  chmod 700 /web/app
  chcon -R -t user_tmp_t /web/app 2>/dev/null || true
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
  rm -rf /web/app
  semanage fcontext -d '/web/app(/.*)?' 2>/dev/null || true
}

