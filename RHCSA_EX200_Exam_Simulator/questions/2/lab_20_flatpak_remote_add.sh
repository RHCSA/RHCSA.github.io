#!/bin/bash
# Objective 2: Manage software
# LAB: Configure a Flatpak remote repository
IS_LAB=true
LAB_ID="flatpak_remote_add"
QUESTION="Add and verify a Flatpak remote repository"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Create /tmp/exam/rhcsa.flatpakrepo containing a remote named rhcsa-flatpak"
TASK_1_HINT="Use a [Flatpak Repo] file"
TASK_1_COMMAND_1="cat > /tmp/exam/rhcsa.flatpakrepo <<'EOF'
[Flatpak Repo]
Title=RHCSA Flatpak Repo
Url=file:///tmp/exam/flatpak-repo
GPGVerify=false
EOF"
TASK_2_QUESTION="Add the remote as rhcsa-flatpak from /tmp/exam/rhcsa.flatpakrepo"
TASK_2_HINT="Use flatpak remote-add --if-not-exists rhcsa-flatpak FILE"
TASK_2_COMMAND_1="flatpak remote-add --if-not-exists rhcsa-flatpak /tmp/exam/rhcsa.flatpakrepo"
TASK_3_QUESTION="Save configured Flatpak remotes to /tmp/exam/flatpak-remotes.txt"
TASK_3_HINT="Use flatpak remotes"
TASK_3_COMMAND_1="flatpak remotes > /tmp/exam/flatpak-remotes.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam/flatpak-repo; rm -f /tmp/exam/rhcsa.flatpakrepo /tmp/exam/flatpak-remotes.txt; flatpak remote-delete -y rhcsa-flatpak &>/dev/null || true; }
check_tasks(){
 [[ -f /tmp/exam/rhcsa.flatpakrepo ]] && grep -q 'GPGVerify=false' /tmp/exam/rhcsa.flatpakrepo && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 flatpak remotes 2>/dev/null | awk '{print $1}' | grep -qx 'rhcsa-flatpak' && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -s /tmp/exam/flatpak-remotes.txt ]] && grep -q 'rhcsa-flatpak' /tmp/exam/flatpak-remotes.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ flatpak remote-delete -y rhcsa-flatpak &>/dev/null || true; rm -rf /tmp/exam/flatpak-repo; rm -f /tmp/exam/rhcsa.flatpakrepo /tmp/exam/flatpak-remotes.txt; }
