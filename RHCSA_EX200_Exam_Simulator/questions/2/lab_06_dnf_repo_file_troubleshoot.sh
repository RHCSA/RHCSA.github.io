#!/bin/bash
# Objective 2: Manage software
# LAB: Troubleshoot a broken RPM repository file
IS_LAB=true
LAB_ID="dnf_repo_file_troubleshoot"
QUESTION="Fix common mistakes in a repository configuration file"
LAB_TASK_COUNT=4
TASK_1_QUESTION="Fix the repo section header so it is [brokenrepo]"
TASK_1_HINT="Repository IDs must be enclosed in square brackets"
TASK_1_COMMAND_1="sed -i 's/^brokenrepo$/[brokenrepo]/' /etc/yum.repos.d/brokenrepo.repo"
TASK_2_QUESTION="Fix the baseurl to file:///repo/brokenrepo"
TASK_2_HINT="The baseurl line must include file:///"
TASK_2_COMMAND_1="sed -i 's#^baseurl=.*#baseurl=file:///repo/brokenrepo#' /etc/yum.repos.d/brokenrepo.repo"
TASK_3_QUESTION="Enable the repository and disable GPG checking"
TASK_3_HINT="Set enabled=1 and gpgcheck=0"
TASK_3_COMMAND_1="sed -i 's/^enabled=.*/enabled=1/; s/^gpgcheck=.*/gpgcheck=0/' /etc/yum.repos.d/brokenrepo.repo"
TASK_4_QUESTION="Save the fixed repository file to /tmp/exam/fixed-brokenrepo.txt"
TASK_4_HINT="Use cp or cat redirection"
TASK_4_COMMAND_1="cp /etc/yum.repos.d/brokenrepo.repo /tmp/exam/fixed-brokenrepo.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam /repo/brokenrepo; cat > /etc/yum.repos.d/brokenrepo.repo <<'EOF'
brokenrepo
name=Broken Repository
baseurl=/repo/wrong
enabled=0
gpgcheck=1
EOF
rm -f /tmp/exam/fixed-brokenrepo.txt; }
check_tasks(){
 grep -q '^\[brokenrepo\]' /etc/yum.repos.d/brokenrepo.repo 2>/dev/null && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 grep -q '^baseurl=file:///repo/brokenrepo' /etc/yum.repos.d/brokenrepo.repo 2>/dev/null && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 if grep -q '^enabled=1' /etc/yum.repos.d/brokenrepo.repo 2>/dev/null && grep -q '^gpgcheck=0' /etc/yum.repos.d/brokenrepo.repo 2>/dev/null; then TASK_STATUS[2]="true"; else TASK_STATUS[2]="false"; fi
 [[ -s /tmp/exam/fixed-brokenrepo.txt ]] && grep -q '^\[brokenrepo\]' /tmp/exam/fixed-brokenrepo.txt && TASK_STATUS[3]="true" || TASK_STATUS[3]="false"
}
cleanup_lab(){ rm -f /etc/yum.repos.d/brokenrepo.repo /tmp/exam/fixed-brokenrepo.txt; rm -rf /repo/brokenrepo; }
