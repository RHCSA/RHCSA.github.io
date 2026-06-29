#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_25_boolean_audit_script"
QUESTION="Maak /usr/local/bin/boolean-audit.sh dat httpd SELinux booleans rapporteert."
LAB_TASK_COUNT=2
TASK_1_QUESTION="Script moet bestaan en uitvoerbaar zijn."
TASK_1_HINT="Gebruik getsebool -a | grep httpd."
TASK_1_COMMAND_1="test -x /usr/local/bin/boolean-audit.sh"
TASK_2_QUESTION="Scriptoutput moet httpd booleans bevatten."
TASK_2_HINT="Filter op httpd."
TASK_2_COMMAND_1="/usr/local/bin/boolean-audit.sh | grep -qi httpd"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
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
  rm -f /usr/local/bin/boolean-audit.sh
}

