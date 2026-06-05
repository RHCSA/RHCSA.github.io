#!/bin/bash
# Objective 2: Manage software
# LAB: Configure separate BaseOS and AppStream repositories
IS_LAB=true
LAB_ID="rpm_repo_two_repos"
QUESTION="Configure two local RPM repositories for BaseOS and AppStream"
LAB_TASK_COUNT=4
TASK_1_QUESTION="Create /repo/exam/BaseOS and /repo/exam/AppStream"
TASK_1_HINT="Create both directories with one mkdir -p command"
TASK_1_COMMAND_1="mkdir -p /repo/exam/BaseOS /repo/exam/AppStream"
TASK_2_QUESTION="Create /etc/yum.repos.d/exam.repo with sections exam-baseos and exam-appstream"
TASK_2_HINT="A repo file may contain more than one [repoid] section"
TASK_2_COMMAND_1="vi /etc/yum.repos.d/exam.repo"
TASK_3_QUESTION="Set BaseOS baseurl to file:///repo/exam/BaseOS and AppStream baseurl to file:///repo/exam/AppStream"
TASK_3_HINT="Use baseurl= in each section"
TASK_3_COMMAND_1="cat > /etc/yum.repos.d/exam.repo <<'EOF'
[exam-baseos]
name=Exam BaseOS
baseurl=file:///repo/exam/BaseOS
enabled=1
gpgcheck=0

[exam-appstream]
name=Exam AppStream
baseurl=file:///repo/exam/AppStream
enabled=1
gpgcheck=0
EOF"
TASK_4_QUESTION="Confirm both repositories are enabled"
TASK_4_HINT="Use dnf repolist or dnf repolist all"
TASK_4_COMMAND_1="dnf repolist all | grep exam-"
HINT=$(_build_hint)
prepare_lab(){ rm -f /etc/yum.repos.d/exam.repo; rm -rf /repo/exam; }
check_tasks(){
 [[ -d /repo/exam/BaseOS && -d /repo/exam/AppStream ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -f /etc/yum.repos.d/exam.repo && $(grep -Ec '^\[exam-(baseos|appstream)\]' /etc/yum.repos.d/exam.repo) -eq 2 ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 if grep -q 'baseurl=file:///repo/exam/BaseOS' /etc/yum.repos.d/exam.repo 2>/dev/null && grep -q 'baseurl=file:///repo/exam/AppStream' /etc/yum.repos.d/exam.repo 2>/dev/null; then TASK_STATUS[2]="true"; else TASK_STATUS[2]="false"; fi
 if awk '/^\[exam-baseos\]/{s=1}/^\[/{if($0!="[exam-baseos]")s=0}s&&/^enabled=1/{b=1}END{exit !b}' /etc/yum.repos.d/exam.repo 2>/dev/null && awk '/^\[exam-appstream\]/{s=1}/^\[/{if($0!="[exam-appstream]")s=0}s&&/^enabled=1/{a=1}END{exit !a}' /etc/yum.repos.d/exam.repo 2>/dev/null; then TASK_STATUS[3]="true"; else TASK_STATUS[3]="false"; fi
}
cleanup_lab(){ rm -f /etc/yum.repos.d/exam.repo; rm -rf /repo/exam; }
