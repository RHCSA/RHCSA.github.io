#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_19_restore_log_context"
QUESTION="Herstel de SELinux-context van /var/log/rhcsa-app.log."
LAB_TASK_COUNT=1
TASK_1_QUESTION="Logbestand moet een log-gerelateerde SELinux context hebben."
TASK_1_HINT="Gebruik restorecon -v /var/log/rhcsa-app.log."
TASK_1_COMMAND_1="ls -Z /var/log/rhcsa-app.log | grep -Eq 'var_log_t|var_log'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  touch /var/log/rhcsa-app.log
  chcon -t user_tmp_t /var/log/rhcsa-app.log 2>/dev/null || true
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
  rm -f /var/log/rhcsa-app.log
}

