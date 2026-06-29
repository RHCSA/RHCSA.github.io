#!/usr/bin/env bash
IS_LAB=true
LAB_ID="lab_20_systemd_unit_context"
QUESTION="Herstel de context van /etc/systemd/system/rhcsa-demo.service."
LAB_TASK_COUNT=1
TASK_1_QUESTION="Unitfile moet systemd_unit_file_t of geldige etc-context hebben."
TASK_1_HINT="Gebruik restorecon op de unitfile."
TASK_1_COMMAND_1="ls -Z /etc/systemd/system/rhcsa-demo.service | grep -Eq 'systemd_unit_file_t|etc_t'"
HINT=$(_build_hint)

prepare_lab() {
  echo 'Preparing SELinux lab environment...'
  cat >/etc/systemd/system/rhcsa-demo.service <<'EOF'
[Unit]
Description=RHCSA demo
[Service]
Type=oneshot
ExecStart=/usr/bin/true
EOF
  chcon -t user_tmp_t /etc/systemd/system/rhcsa-demo.service 2>/dev/null || true
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
  rm -f /etc/systemd/system/rhcsa-demo.service
  systemctl daemon-reload >/dev/null 2>&1 || true
}

