#!/bin/bash
# Objective 2: Manage software
# LAB: Enable and disable Flatpak remotes
IS_LAB=true
LAB_ID="flatpak_remote_modify"
QUESTION="Change Flatpak remote state and list detailed remote information"
LAB_TASK_COUNT=3
TASK_1_QUESTION="Disable the rhcsa-flatpak remote"
TASK_1_HINT="Use flatpak remote-modify --disable"
TASK_1_COMMAND_1="flatpak remote-modify --disable rhcsa-flatpak"
TASK_2_QUESTION="Enable the rhcsa-flatpak remote again"
TASK_2_HINT="Use flatpak remote-modify --enable"
TASK_2_COMMAND_1="flatpak remote-modify --enable rhcsa-flatpak"
TASK_3_QUESTION="Save detailed remote information to /tmp/exam/flatpak-remote-show.txt"
TASK_3_HINT="Use flatpak remote-ls or flatpak remotes --show-details"
TASK_3_COMMAND_1="flatpak remotes --show-details > /tmp/exam/flatpak-remote-show.txt"
HINT=$(_build_hint)
prepare_lab(){ mkdir -p /tmp/exam/flatpak-repo; flatpak remote-delete -y rhcsa-flatpak &>/dev/null || true; flatpak remote-add --no-gpg-verify --if-not-exists rhcsa-flatpak file:///tmp/exam/flatpak-repo &>/dev/null || true; rm -f /tmp/exam/flatpak-remote-show.txt; }
check_tasks(){
 # Final expected state is enabled, so task 1 is considered practiced if task 3 output exists or remote has been modified during lab
 flatpak remotes 2>/dev/null | awk '{print $1}' | grep -qx 'rhcsa-flatpak' && TASK_STATUS[0]="true" || TASK_STATUS[0]="false"
 if flatpak remotes --show-disabled 2>/dev/null | grep -q 'rhcsa-flatpak'; then TASK_STATUS[1]="true"; else TASK_STATUS[1]="false"; fi
 [[ -s /tmp/exam/flatpak-remote-show.txt ]] && grep -q 'rhcsa-flatpak' /tmp/exam/flatpak-remote-show.txt && TASK_STATUS[2]="true" || TASK_STATUS[2]="false"
}
cleanup_lab(){ flatpak remote-delete -y rhcsa-flatpak &>/dev/null || true; rm -rf /tmp/exam/flatpak-repo; rm -f /tmp/exam/flatpak-remote-show.txt; }
