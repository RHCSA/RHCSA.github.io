#!/bin/bash
# Objective 1: Understand and use essential tools
# LAB: Find Non-HTTPS URLs (Security Audit)

# This is a LAB exercise
IS_LAB=true
LAB_ID="grep_security_audit"

QUESTION="[LAB] Find HTTP links that are NOT using HTTPS (security audit)"
HINT="Task 1: grep 'http[^s]' /tmp/config-files/*.conf > /tmp/insecure-urls.txt\n([^s] matches 'http:' but not 'https:')"

# Lab configuration
LAB_TITLE="Find Non-HTTPS URLs (Security Audit)"
LAB_TASK_COUNT=1

# Task descriptions (indexed from 0)
get_task_description() {
    local task_idx=$1
    case "$task_idx" in
        0) echo "Find all HTTP URLs (not HTTPS) from files in /tmp/config-files/, save to /tmp/insecure-urls.txt" ;;
    esac
}

# Prepare the lab environment
prepare_lab() {
    echo -e "  ${DIM}• Removing existing files...${RESET}"
    rm -f /tmp/insecure-urls.txt 2>/dev/null
    rm -rf /tmp/config-files 2>/dev/null
    sleep 0.3
    
    echo -e "  ${DIM}• Creating config files directory...${RESET}"
    mkdir -p /tmp/config-files
    
    echo -e "  ${DIM}• Creating sample config files...${RESET}"
    cat > /tmp/config-files/app.conf << 'EOF'
# Application Configuration
server_name = myapp.example.com
api_endpoint = https://api.secure.com/v1
legacy_api = http://old-api.example.com/v2
database_url = postgresql://localhost:5432/mydb
backup_url = http://backup.internal.net/storage
cdn_url = https://cdn.example.com/assets
EOF

    cat > /tmp/config-files/web.conf << 'EOF'
# Web Server Configuration
listen_port = 443
redirect_http = true
upstream_server = http://192.168.1.100:8080
ssl_certificate = /etc/ssl/certs/server.crt
external_api = https://external.api.com
webhook_url = http://hooks.example.org/notify
EOF

    cat > /tmp/config-files/services.conf << 'EOF'
# External Services
payment_gateway = https://secure.payment.com/api
notification_service = http://notify.example.com/send
logging_endpoint = https://logs.example.com/ingest
metrics_url = http://metrics.internal:9090/push
auth_server = https://auth.example.com/oauth
EOF
    sleep 0.3
}

# Check task completion - sets TASK_STATUS array
check_tasks() {
    # Task 0: Check insecure-urls.txt contains http:// but not https://
    if [[ -f /tmp/insecure-urls.txt ]]; then
        local line_count=$(wc -l < /tmp/insecure-urls.txt 2>/dev/null)
        # Should have at least 4 lines with http:// URLs
        if [[ $line_count -ge 3 ]]; then
            # Should contain http:// references
            if grep -q 'http:' /tmp/insecure-urls.txt 2>/dev/null; then
                # Should NOT contain lines with only https:// (no http://)
                # Check that we're not just matching https
                local http_count=$(grep -c 'http[^s]' /tmp/insecure-urls.txt 2>/dev/null)
                if [[ $http_count -ge 3 ]]; then
                    TASK_STATUS[0]="true"
                else
                    TASK_STATUS[0]="false"
                fi
            else
                TASK_STATUS[0]="false"
            fi
        else
            TASK_STATUS[0]="false"
        fi
    else
        TASK_STATUS[0]="false"
    fi
}

# Cleanup the lab environment before exit
cleanup_lab() {
    echo -e "  ${DIM}• Cleaning up lab environment...${RESET}"
    rm -f /tmp/insecure-urls.txt 2>/dev/null
    rm -rf /tmp/config-files 2>/dev/null
    echo -e "  ${GREEN}✓ Lab environment cleaned up${RESET}"
    sleep 1
}
