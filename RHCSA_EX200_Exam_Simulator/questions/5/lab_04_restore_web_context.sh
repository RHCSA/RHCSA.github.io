#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_04_restore_web_context"
QUESTION="Herstel de standaard SELinux-context van /var/www/html/rhcsa.html."
LAB_TASK_COUNT=1
TASK_1_QUESTION="Bestand moet httpd_sys_content_t hebben."
TASK_1_HINT="Gebruik restorecon op het bestand."
TASK_1_COMMAND_1="ls -Z /var/www/html/rhcsa.html | grep -q 'httpd_sys_content_t'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /var/www/html
  printf 'RHCSA SELinux lab\n' > /var/www/html/rhcsa.html
  chcon -t user_tmp_t /var/www/html/rhcsa.html 2>/dev/null || true
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
  rm -f /var/www/html/rhcsa.html
}

