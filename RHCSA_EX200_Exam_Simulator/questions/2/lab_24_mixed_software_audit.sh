#!/bin/bash
# Objective 2: Manage software
# LAB: Software audit report
IS_LAB=true
LAB_ID="mixed_software_audit"
QUESTION="Create a small software audit report using RPM, DNF and Flatpak tools"
LAB_TASK_COUNT=5
TASK_1_QUESTION="Create directory /tmp/exam/software-audit"
TASK_1_HINT="Use mkdir -p"
TASK_1_COMMAND_1="mkdir -p /tmp/exam/software-audit"
TASK_2_QUESTION="Save all enabled DNF repositories to /tmp/exam/software-audit/enabled-repos.txt"
TASK_2_HINT="Use dnf repolist"
TASK_2_COMMAND_1="dnf repolist > /tmp/exam/software-audit/enabled-repos.txt"
TASK_3_QUESTION="Save all installed packages with names starting with kernel to /tmp/exam/software-audit/kernel-packages.txt"
TASK_3_HINT="Use rpm -qa 'kernel*' or dnf list installed 'kernel*'"
TASK_3_COMMAND_1="rpm -qa 'kernel*' > /tmp/exam/software-audit/kernel-packages.txt"
TASK_4_QUESTION="Save package owner of /etc/passwd to /tmp/exam/software-audit/passwd-owner.txt"
TASK_4_HINT="Use rpm -qf /etc/passwd"
TASK_4_COMMAND_1="rpm -qf /etc/passwd > /tmp/exam/software-audit/passwd-owner.txt"
TASK_5_QUESTION="Save Flatpak remotes to /tmp/exam/software-audit/flatpak-remotes.txt"
TASK_5_HINT="Use flatpak remotes"
TASK_5_COMMAND_1="flatpak remotes > /tmp/exam/software-audit/flatpak-remotes.txt"
HINT=$(_build_hint)
prepare_lab(){ rm -rf /tmp/exam/software-audit; mkdir -p /tmp/exam; }
check_tasks(){
 [[ -d /tmp/exam/software-audit ]] && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 [[ -s /tmp/exam/software-audit/enabled-repos.txt ]] && TASK_STATUS[1]="true" || TASK_STATUS[1]="false"
 [[ -f /tmp/exam/software-audit/kernel-packages.txt ]] && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
 [[ -s /tmp/exam/software-audit/passwd-owner.txt ]] && grep -Eqi 'setup|filesystem' /tmp/exam/software-audit/passwd-owner.txt && TASK_STATUS[3]="true" || TASK_STATUS[3]="false"
 [[ -f /tmp/exam/software-audit/flatpak-remotes.txt ]] && TASK_STATUS[4]="true" || TASK_STATUS[4]="false"
}
cleanup_lab(){ rm -rf /tmp/exam/software-audit; }
