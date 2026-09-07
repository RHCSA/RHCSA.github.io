#!/bin/bash
# Objective 8: Manage basic networking
# LAB: Multi-Terminal Practice (demo of web UI terminal tabs)
# NOTE: prepare_lab_2/prepare_lab_3 and PREPARE_LAB_N_NAME are only read by the
# web UI (webui/server.py + webui/index.html). The CLI simulator (rhcsa) only
# ever calls prepare_lab/check_tasks/cleanup_lab, so this lab behaves exactly
# like any other single-terminal lab there.

IS_LAB=true
LAB_ID="multi_terminal_demo"

QUESTION="This lab has extra terminal tabs on the same machine (web UI only). Create /tmp/lab_multi_terminal/status.txt containing the word 'ready' - you can do this from any of the terminal tabs."

# Lab configuration
LAB_TASK_COUNT=1

# =============================================================================
# TASK DEFINITIONS - Each task has question, hint, and command(s)
# =============================================================================

# Task 1
TASK_1_QUESTION="Create /tmp/lab_multi_terminal/status.txt containing the word 'ready'"
TASK_1_HINT="Use mkdir -p and echo with output redirection"
TASK_1_COMMAND_1="mkdir -p /tmp/lab_multi_terminal && echo 'ready' > /tmp/lab_multi_terminal/status.txt"

# Auto-generate HINT from commands
HINT=$(_build_hint)

# =============================================================================
# EXTRA TERMINAL TABS (web UI only) - each gets its own name and preparation
# =============================================================================

# Tab 1 is the default/main terminal - naming it is optional (falls back to "Terminal")
PREPARE_LAB_1_NAME="server1.rhcsa.github.io"

PREPARE_LAB_2_NAME="server2.rhcsa.github.io"
prepare_lab_2() {
    echo -e "  ${DIM}• Preparing server2 terminal tab...${RESET}"
    sleep 0.2
}

PREPARE_LAB_3_NAME="server3.rhcsa.github.io"
prepare_lab_3() {
    echo -e "  ${DIM}• Preparing server3 terminal tab...${RESET}"
    sleep 0.2
}

# Prepare the lab environment (main terminal / tab 1)
prepare_lab() {
    echo -e "  ${DIM}• Resetting environment...${RESET}"
    rm -rf /tmp/lab_multi_terminal
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    if [[ -f /tmp/lab_multi_terminal/status.txt ]] && grep -qx "ready" /tmp/lab_multi_terminal/status.txt 2>/dev/null; then
        TASK_STATUS[0]="true"
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -rf /tmp/lab_multi_terminal
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
