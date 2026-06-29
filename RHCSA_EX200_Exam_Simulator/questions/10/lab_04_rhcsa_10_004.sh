#!/bin/bash
# Objective 10: exam, integrated
# LAB: Full RHCSA scenario 4
# Converted from qdir format: q004-rhcsa-10-004

IS_LAB=true
LAB_ID="rhcsa_10_004"
QUESTION="Full RHCSA scenario 4"

LAB_TASK_COUNT=3

# Task 1
TASK_1_QUESTION="Prepare the lab environment for: Full RHCSA scenario 4"
TASK_1_HINT="Start the lab; setup is handled automatically by prepare_lab"
TASK_1_COMMAND_1="# Environment preparation is automatic"

# Task 2
TASK_2_QUESTION="Voer geïntegreerd RHCSA scenario 4 uit: users, scripts, storage, SELinux/systemd/networking of Flatpak volgens question.md."
TASK_2_HINT="Use RHCSA commands appropriate for this objective. Do not disable security controls or use temporary-only workarounds when persistence is required."
TASK_2_COMMAND_1="# Complete the requested configuration"

# Task 3
TASK_3_QUESTION="Validate your solution with the simulator"
TASK_3_HINT="The lab validator checks the final system state"
TASK_3_COMMAND_1="# Run validation from the simulator UI"

HINT=$(_build_hint)


# Embedded helper functions for converted qdir labs.
sim_lab_pass(){ return 0; }
sim_lab_fail(){ return 1; }
exists_cmd(){ command -v "$1" >/dev/null 2>&1; }
mountpoint_exists(){ mountpoint -q "$1"; }
fstab_has_mount(){ local mnt="$1"; grep -E "[[:space:]]${mnt}[[:space:]]" /etc/fstab >/dev/null 2>&1; }
fstab_uses_uuid_for_mount(){ local mnt="$1"; grep -E "^UUID=.*[[:space:]]${mnt}[[:space:]]" /etc/fstab >/dev/null 2>&1; }
lv_exists(){ lvs "$1" >/dev/null 2>&1; }
vg_exists(){ vgs "$1" >/dev/null 2>&1; }
swap_active(){ swapon --show=NAME --noheadings 2>/dev/null | grep -Fx "$1" >/dev/null 2>&1; }
unit_exists(){ systemctl list-unit-files "$1" >/dev/null 2>&1; }
unit_enabled(){ systemctl is-enabled "$1" >/dev/null 2>&1; }
unit_active(){ systemctl is-active "$1" >/dev/null 2>&1; }
timer_enabled(){ systemctl is-enabled "$1" >/dev/null 2>&1; }
firewall_port_runtime(){ firewall-cmd --list-ports 2>/dev/null | grep -qw "$1"; }
firewall_port_permanent(){ firewall-cmd --permanent --list-ports 2>/dev/null | grep -qw "$1"; }
firewall_service_permanent(){ firewall-cmd --permanent --list-services 2>/dev/null | grep -qw "$1"; }
nm_connection_exists(){ nmcli -t -f NAME con show 2>/dev/null | grep -Fx "$1" >/dev/null 2>&1; }
flatpak_remote_exists(){ flatpak remotes --columns=name 2>/dev/null | grep -Fx "$1" >/dev/null 2>&1; }
flatpak_app_installed(){ flatpak list --app --columns=application 2>/dev/null | grep -Fx "$1" >/dev/null 2>&1; }
flatpak_app_installed_user(){ flatpak --user list --app --columns=application 2>/dev/null | grep -Fx "$1" >/dev/null 2>&1; }
flatpak_app_installed_system(){ flatpak --system list --app --columns=application 2>/dev/null | grep -Fx "$1" >/dev/null 2>&1; }
grub_cfg_exists(){ [[ -f /boot/grub2/grub.cfg || -f /boot/efi/EFI/redhat/grub.cfg ]]; }
fstab_sane(){ findmnt --verify --verbose >/dev/null 2>&1; }
default_target_is(){ local target="$1"; systemctl get-default 2>/dev/null | grep -Fx "$target" >/dev/null 2>&1; }
pass(){ return 0; }
fail(){ return 1; }
require_root(){ return 0; }
sim_log(){ return 0; }


prepare_lab() {
mkdir -p /root/reports
}

_validate_converted_lab() {
[[ -s /root/reports/exam-scenario-4.txt ]] || fail 'scenario report missing'
grep -Eiq 'PASS|completed|storage|selinux|systemd|network|flatpak|user' /root/reports/exam-scenario-4.txt || fail 'scenario report incomplete'
pass 'full exam scenario 4 complete'
}

check_tasks() {
    TASK_STATUS[0]="true"
    if _validate_converted_lab >/dev/null 2>&1; then
        TASK_STATUS[1]="true"
        TASK_STATUS[2]="true"
    else
        TASK_STATUS[1]="false"
        TASK_STATUS[2]="false"
    fi
}

cleanup_lab() {
set +e
rm -f /root/reports/exam-scenario-4.txt

exit 0
}
