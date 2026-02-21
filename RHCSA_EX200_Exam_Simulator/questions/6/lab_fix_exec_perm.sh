#!/bin/bash
# Objective 6: Create and configure file systems
# LAB: Fix Execute Permission

IS_LAB=true
LAB_ID="fix_exec_perm"

QUESTION="[LAB] Fix script execute permission so owner can run it"
HINT="Task 1: chmod u+x /tmp/labscript.sh\nTask 2: Test by running ./tmp/labscript.sh (should work)"

LAB_TITLE="Fix Execute Permission"
LAB_TASK_COUNT=2

get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Add execute permission for owner on /tmp/labscript.sh" ;;
        1) echo "Create /tmp/script-ran.txt by running the script" ;;
    esac
}

prepare_lab() {
    echo -e "  ${DIM}• Creating non-executable script...${RESET}"
    cat > /tmp/labscript.sh << 'EOF'
#!/bin/bash
echo "Script executed successfully" > /tmp/script-ran.txt
EOF
    chmod 644 /tmp/labscript.sh
    rm -f /tmp/script-ran.txt 2>/dev/null
    sleep 0.3
}

check_tasks() {
    # Task 0: Check if file has execute permission for owner
    local perms=$(stat -c %a /tmp/labscript.sh 2>/dev/null)
    local owner_perm=$(( perms / 100 ))
    if [[ $((owner_perm & 1)) -eq 1 ]]; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
    
    # Task 1: Check if script-ran.txt exists (script was executed)
    if [[ -f /tmp/script-ran.txt ]] && grep -q 'executed' /tmp/script-ran.txt 2>/dev/null; then
        TASK_STATUS[1]="true"
    else
        TASK_STATUS[1]="false"
    fi
}

cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/labscript.sh /tmp/script-ran.txt 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
