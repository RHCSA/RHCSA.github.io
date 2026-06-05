#!/bin/bash
# Objective 2: Manage software
# LAB: Enable and disable RPM repositories
IS_LAB=true
LAB_ID="rpm_repo_enable_disable"
QUESTION="Change repository enabled state using dnf tools or repo files"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Disable the rhcsa-disabled repository"
TASK_1_HINT="Use dnf config-manager --set-disabled or edit enabled=0"
TASK_1_COMMAND_1="dnf config-manager --set-disabled rhcsa-disabled"
TASK_2_QUESTION="Enable the rhcsa-enabled repository"
TASK_2_HINT="Use dnf config-manager --set-enabled or edit enabled=1"
TASK_2_COMMAND_1="dnf config-manager --set-enabled rhcsa-enabled"
TASK_3_QUESTION="Save all repository states containing rhcsa- to /tmp/exam/repo-state.txt"
TASK_3_HINT="Use dnf repolist all and grep"
TASK_3_COMMAND_1="dnf repolist all | grep rhcsa- > /tmp/exam/repo-state.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam /repo/rhcsa/disabled /repo/rhcsa/enabled; cat > /etc/yum.repos.d/rhcsa-state.repo <<'EOF'
[rhcsa-disabled]
name=RHCSA Disable Me
baseurl=file:///repo/rhcsa/disabled
enabled=1
gpgcheck=0

[rhcsa-enabled]
name=RHCSA Enable Me
baseurl=file:///repo/rhcsa/enabled
enabled=0
gpgcheck=0
EOF
rm -f /tmp/exam/repo-state.txt; }
check_tasks(){
 grep -A4 '^\[rhcsa-disabled\]' /etc/yum.repos.d/rhcsa-state.repo 2>/dev/null | grep -q '^enabled=0' && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 grep -A4 '^\[rhcsa-enabled\]' /etc/yum.repos.d/rhcsa-state.repo 2>/dev/null | grep -q '^enabled=1' && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -f /tmp/exam/repo-state.txt ]] && grep -q 'rhcsa-disabled' /tmp/exam/repo-state.txt && grep -q 'rhcsa-enabled' /tmp/exam/repo-state.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /etc/yum.repos.d/rhcsa-state.repo; rm -rf /repo/rhcsa; rm -f /tmp/exam/repo-state.txt; }
