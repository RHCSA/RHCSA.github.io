#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_22_writable_cache_context"
QUESTION="Maak /web/app/cache beschrijfbaar voor apache met juiste SELinux-context."
LAB_TASK_COUNT=2
TASK_1_QUESTION="Cachemap moet httpd_sys_rw_content_t hebben."
TASK_1_HINT="Gebruik httpd_sys_rw_content_t."
TASK_1_COMMAND_1="ls -Zd /web/app/cache | grep -q 'httpd_sys_rw_content_t'"
TASK_2_QUESTION="Cachemap moet schrijfbaar zijn voor apache of groep."
TASK_2_HINT="Gebruik chown/chmod passend."
TASK_2_COMMAND_1="stat -c '%a' /web/app/cache | grep -Eq '77[05]|775|770|757'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /web/app/cache
  chown -R root:root /web/app/cache
  chmod 755 /web/app/cache
  chcon -R -t user_tmp_t /web/app/cache 2>/dev/null || true
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
  rm -rf /web/app/cache
  semanage fcontext -d '/web/app/cache(/.*)?' 2>/dev/null || true
}

