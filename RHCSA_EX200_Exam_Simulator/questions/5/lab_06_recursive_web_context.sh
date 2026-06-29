#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_06_recursive_web_context"
QUESTION="Configureer /srv/www/site inclusief subdirectories als httpd content."
LAB_TASK_COUNT=2
TASK_1_QUESTION="Nested bestand moet httpd_sys_content_t hebben."
TASK_1_HINT="Gebruik een recursieve fcontext-regel met (/.*)?."
TASK_1_COMMAND_1="ls -Z /srv/www/site/sub/index.html | grep -q 'httpd_sys_content_t'"
TASK_2_QUESTION="De fcontext-regel moet persistent bestaan."
TASK_2_HINT="Controleer semanage fcontext -l."
TASK_2_COMMAND_1="semanage fcontext -l | grep -E '^/srv/www/site\(/\.\*\)\?[[:space:]]+' | grep -q 'httpd_sys_content_t'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /srv/www/site/sub
  printf 'site\n' > /srv/www/site/sub/index.html
  chcon -R -t user_tmp_t /srv/www/site 2>/dev/null || true
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
  rm -rf /srv/www/site
  semanage fcontext -d '/srv/www/site(/.*)?' 2>/dev/null || true
}

