#!/bin/bash
# Objective 2: Manage software
# LAB: Configure GPG checking for a repository
IS_LAB=true
LAB_ID="rpm_repo_gpgcheck"
QUESTION="Configure repository GPG checking and gpgkey settings"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /etc/pki/rpm-gpg/RPM-GPG-KEY-rhcsa containing the text RHCSA-TEST-KEY"
TASK_1_HINT="Use echo or a here-document"
TASK_1_COMMAND_1="echo RHCSA-TEST-KEY > /etc/pki/rpm-gpg/RPM-GPG-KEY-rhcsa"
TASK_2_QUESTION="In /etc/yum.repos.d/rhcsa-gpg.repo enable gpgcheck for repo rhcsa-gpg"
TASK_2_HINT="Set gpgcheck=1"
TASK_2_COMMAND_1="sed -i 's/gpgcheck=0/gpgcheck=1/' /etc/yum.repos.d/rhcsa-gpg.repo"
TASK_3_QUESTION="Set gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rhcsa for repo rhcsa-gpg"
TASK_3_HINT="Add gpgkey= to the repository section"
TASK_3_COMMAND_1="echo 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rhcsa' >> /etc/yum.repos.d/rhcsa-gpg.repo"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /repo/rhcsa/gpg /etc/pki/rpm-gpg; cat > /etc/yum.repos.d/rhcsa-gpg.repo <<'EOF'
[rhcsa-gpg]
name=RHCSA GPG Repo
baseurl=file:///repo/rhcsa/gpg
enabled=1
gpgcheck=0
EOF
rm -f /etc/pki/rpm-gpg/RPM-GPG-KEY-rhcsa; }
check_tasks(){
 [[ -f /etc/pki/rpm-gpg/RPM-GPG-KEY-rhcsa ]] && grep -q 'RHCSA-TEST-KEY' /etc/pki/rpm-gpg/RPM-GPG-KEY-rhcsa && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 grep -q '^gpgcheck=1' /etc/yum.repos.d/rhcsa-gpg.repo 2>/dev/null && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 grep -q '^gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rhcsa' /etc/yum.repos.d/rhcsa-gpg.repo 2>/dev/null && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ rm -f /etc/yum.repos.d/rhcsa-gpg.repo /etc/pki/rpm-gpg/RPM-GPG-KEY-rhcsa; rm -rf /repo/rhcsa/gpg; }
