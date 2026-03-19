#!/bin/bash
# RHCSA Web Interface Startup Script
# Starts both the web API server and ttyd terminal

WEBUI_PORT=8080
TERMINAL_PORT=7682
INSTALL_DIR="/usr/local/share/rhcsa"
WEBUI_DIR="${INSTALL_DIR}/webui"
LOG_DIR="/var/log/rhcsa"
PID_FILE="/var/run/rhcsa-webui.pid"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Create log directory
mkdir -p "$LOG_DIR"

# Function to get server IPs
get_server_ips() {
    ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1'
}

# Function to check if a port is in use
port_in_use() {
    local port=$1
    ss -tuln | grep -q ":${port} "
}

# Function to start ttyd (background)
start_ttyd() {
    if port_in_use $TERMINAL_PORT; then
        echo -e "${YELLOW}ttyd already running on port ${TERMINAL_PORT}${NC}"
        return 0
    fi
    
    if ! command -v ttyd &>/dev/null; then
        echo -e "${RED}Error: ttyd not found. Please install it.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Starting ttyd on port ${TERMINAL_PORT}...${NC}"
    # Start ttyd with working directory /tmp using bash -c
    ttyd -p $TERMINAL_PORT -W /bin/bash -c 'cd /tmp && exec bash -l' >> "$LOG_DIR/ttyd.log" 2>&1 &
    local ttyd_pid=$!
    echo $ttyd_pid >> "$PID_FILE"
    sleep 1
    
    if port_in_use $TERMINAL_PORT; then
        echo -e "${GREEN}ttyd started successfully (PID: $ttyd_pid)${NC}"
    else
        echo -e "${RED}Failed to start ttyd${NC}"
        return 1
    fi
}

# Function to start web server (foreground for systemd)
start_webserver() {
    if port_in_use $WEBUI_PORT; then
        echo -e "${YELLOW}Web server already running on port ${WEBUI_PORT}${NC}"
        return 0
    fi
    
    echo -e "${GREEN}Starting web server on port ${WEBUI_PORT}...${NC}"
    cd "$WEBUI_DIR"
    
    # Check if running under systemd (foreground mode)
    if [[ "${SYSTEMD_EXEC:-}" == "1" ]] || [[ -n "${INVOCATION_ID:-}" ]]; then
        # Run in foreground for systemd
        exec python3 server.py
    else
        # Run in background for interactive use
        python3 server.py >> "$LOG_DIR/webui.log" 2>&1 &
        local web_pid=$!
        echo $web_pid >> "$PID_FILE"
        sleep 1
        
        if port_in_use $WEBUI_PORT; then
            echo -e "${GREEN}Web server started successfully (PID: $web_pid)${NC}"
        else
            echo -e "${RED}Failed to start web server${NC}"
            return 1
        fi
    fi
}

# Function to configure firewall
configure_firewall() {
    echo -e "${GREEN}Configuring firewall...${NC}"
    
    if command -v firewall-cmd &>/dev/null; then
        # Check if firewalld is running
        if systemctl is-active firewalld &>/dev/null; then
            firewall-cmd --permanent --add-port=${WEBUI_PORT}/tcp 2>/dev/null
            firewall-cmd --permanent --add-port=${TERMINAL_PORT}/tcp 2>/dev/null
            firewall-cmd --reload 2>/dev/null
            echo -e "${GREEN}Firewall rules added for ports ${WEBUI_PORT} and ${TERMINAL_PORT}${NC}"
        fi
    fi
}

# Function to configure SELinux
configure_selinux() {
    if command -v semanage &>/dev/null; then
        echo -e "${GREEN}Configuring SELinux...${NC}"
        semanage port -a -t http_port_t -p tcp $WEBUI_PORT 2>/dev/null || true
        semanage port -a -t http_port_t -p tcp $TERMINAL_PORT 2>/dev/null || true
    fi
}

# Function to stop services
stop_services() {
    echo -e "${YELLOW}Stopping RHCSA web services...${NC}"
    
    if [ -f "$PID_FILE" ]; then
        while read pid; do
            kill $pid 2>/dev/null
        done < "$PID_FILE"
        rm -f "$PID_FILE"
    fi
    
    # Also kill by process name
    pkill -f "python3.*server.py" 2>/dev/null
    pkill -f "ttyd.*${TERMINAL_PORT}" 2>/dev/null
    
    echo -e "${GREEN}Services stopped${NC}"
}

# Function to show status
show_status() {
    echo -e "${GREEN}RHCSA Web Interface Status${NC}"
    echo "================================"
    
    if port_in_use $WEBUI_PORT; then
        echo -e "Web Server (port $WEBUI_PORT): ${GREEN}Running${NC}"
    else
        echo -e "Web Server (port $WEBUI_PORT): ${RED}Stopped${NC}"
    fi
    
    if port_in_use $TERMINAL_PORT; then
        echo -e "Terminal (port $TERMINAL_PORT): ${GREEN}Running${NC}"
    else
        echo -e "Terminal (port $TERMINAL_PORT): ${RED}Stopped${NC}"
    fi
    
    echo ""
    echo "Access URLs:"
    for ip in $(get_server_ips); do
        echo -e "  ${GREEN}http://${ip}:${WEBUI_PORT}${NC}"
    done
}

# Main
case "${1:-start}" in
    start)
        # Create PID file
        > "$PID_FILE"
        
        configure_firewall
        configure_selinux
        start_ttyd
        start_webserver  # Note: if SYSTEMD_EXEC=1, this will exec and not return
        
        # Only reached in interactive mode
        echo ""
        show_status
        ;;
    stop)
        stop_services
        ;;
    restart)
        stop_services
        sleep 2
        $0 start
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
