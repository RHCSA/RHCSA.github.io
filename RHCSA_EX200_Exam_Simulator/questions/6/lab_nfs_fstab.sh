#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Create NFS fstab Entry

IS_LAB=true
LAB_ID="nfs_fstab"

QUESTION="[LAB] Create a persistent NFS mount entry in fstab template"
HINT="Task 1: mkdir -p /mnt/nfstest && create mount point\nTask 2: echo 'server:/share /mnt/nfstest nfs defaults,_netdev 0 0' >> /tmp/nfs-fstab.txt"

LAB_TITLE="Create NFS fstab Entry"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Create mount point directory /mnt/nfstest" ;;
        1) echo "Create NFS fstab entry template in /tmp/nfs-fstab.txt" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Cleaning up previous outputs...${RESET}"
    rm -rf /mnt/nfstest /tmp/nfs-fstab.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if mount point exists
    if [[ -d /mnt/nfstest ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if fstab entry template exists with NFS format
    if [[ -f /tmp/nfs-fstab.txt ]] && grep -qE '.*:.*\s+/mnt/nfstest\s+nfs' /tmp/nfs-fstab.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /mnt/nfstest /tmp/nfs-fstab.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
