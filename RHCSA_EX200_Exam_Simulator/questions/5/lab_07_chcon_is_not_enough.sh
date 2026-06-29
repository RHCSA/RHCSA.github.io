#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_07_chcon_is_not_enough"
QUESTION="Maak /opt/app/public persistent httpd-leesbaar. Alleen chcon is onvoldoende."
LAB_TASK_COUNT=2
TASK_1_QUESTION="Persistent fcontext-regel moet aanwezig zijn."
TASK_1_HINT="Gebruik semanage fcontext, niet alleen chcon."
TASK_1_COMMAND_1="semanage fcontext -l | grep -E '^/opt/app/public\(/\.\*\)\?[[:space:]]+' | grep -q 'httpd_sys_content_t'"
TASK_2_QUESTION="Context moet daadwerkelijk toegepast zijn."
TASK_2_HINT="Gebruik restorecon."
TASK_2_COMMAND_1="ls -Zd /opt/app/public | grep -q 'httpd_sys_content_t'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /opt/app/public
  printf 'app\n' > /opt/app/public/index.html
  chcon -R -t user_tmp_t /opt/app/public 2>/dev/null || true
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
  rm -rf /opt/app/public
  semanage fcontext -d '/opt/app/public(/.*)?' 2>/dev/null || true
}

