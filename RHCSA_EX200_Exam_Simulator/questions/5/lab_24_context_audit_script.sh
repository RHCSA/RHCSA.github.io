#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_24_context_audit_script"
QUESTION="Maak /usr/local/bin/context-audit.sh dat contexts onder /web controleert."
LAB_TASK_COUNT=2
TASK_1_QUESTION="Script moet bestaan en uitvoerbaar zijn."
TASK_1_HINT="Gebruik find en ls -Z."
TASK_1_COMMAND_1="test -x /usr/local/bin/context-audit.sh"
TASK_2_QUESTION="Scriptoutput moet contextinformatie bevatten."
TASK_2_HINT="Laat ls -Z output zien."
TASK_2_COMMAND_1="/usr/local/bin/context-audit.sh | grep -Eiq 'context|httpd|_t|/web'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  mkdir -p /web
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
  rm -f /usr/local/bin/context-audit.sh
}

