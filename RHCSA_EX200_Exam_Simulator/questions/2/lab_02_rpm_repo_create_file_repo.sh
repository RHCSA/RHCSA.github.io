#!/bin/bash
# Objective 2: Manage software
# LAB: Create a local RPM repository definition
IS_LAB=true
LAB_ID="rpm_repo_create_file_repo"
QUESTION="Create and enable a local RPM repository file"
LAB_TASK_COUNT=4
TASK_1_QUESTION="Create the directory /repo/rhcsa/BaseOS"
TASK_1_HINT="Use mkdir -p"
TASK_1_COMMAND_1="mkdir -p /repo/rhcsa/BaseOS"
TASK_2_QUESTION="Create /etc/yum.repos.d/rhcsa-local.repo"
TASK_2_HINT="Repository definitions are stored below /etc/yum.repos.d/"
TASK_2_COMMAND_1="vi /etc/yum.repos.d/rhcsa-local.repo"
TASK_3_QUESTION="Add a repository named rhcsa-local with baseurl file:///repo/rhcsa/BaseOS"
TASK_3_HINT="Use a [rhcsa-local] section with name= and baseurl="
TASK_3_COMMAND_1="cat > /etc/yum.repos.d/rhcsa-local.repo <<'EOF'
[rhcsa-local]
name=RHCSA Local Repository
baseurl=file:///repo/rhcsa/BaseOS
enabled=1
gpgcheck=0
EOF"
TASK_4_QUESTION="Verify that the rhcsa-local repository appears in dnf repolist all"
TASK_4_HINT="Use dnf repolist all"
TASK_4_COMMAND_1="dnf repolist all | grep rhcsa-local"
HINT=$(_build_hint)
prepare_lab(){ echo -e "  ${DIM}• Resetting local repository lab...${RESET}"; rm -f /etc/yum.repos.d/rhcsa-local.repo; rm -rf /repo/rhcsa; mkdir -p /tmp/exam; }
check_tasks(){
 [[ -d /repo/rhcsa/BaseOS ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /etc/yum.repos.d/rhcsa-local.repo ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 if grep -q '^\[rhcsa-local\]' /etc/yum.repos.d/rhcsa-local.repo 2>/dev/null && grep -q '^baseurl=file:///repo/rhcsa/BaseOS' /etc/yum.repos.d/rhcsa-local.repo 2>/dev/null; then TASK_STATUS[2]="true"; else TASK_STATUS[2]="false"; fi
 if grep -Eq '^enabled=1|^enabled=True|^enabled=yes' /etc/yum.repos.d/rhcsa-local.repo 2>/dev/null && grep -Eq '^gpgcheck=0|^gpgcheck=False|^gpgcheck=no' /etc/yum.repos.d/rhcsa-local.repo 2>/dev/null; then TASK_STATUS[3]="true"; else TASK_STATUS[3]="false"; fi
}
cleanup_lab(){ rm -f /etc/yum.repos.d/rhcsa-local.repo; rm -rf /repo/rhcsa; }
