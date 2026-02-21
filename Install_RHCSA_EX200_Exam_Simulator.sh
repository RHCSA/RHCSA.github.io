#!/bin/bash
# RHCSA EX200 Exam Simulator - One-Line Installer
# Usage: curl -sL https://raw.githubusercontent.com/RHCSA/RHCSA.github.io/main/Install_RHCSA_EX200_Exam_Simulator.sh | sudo bash

# Check if running as root - if not, re-run with sudo
if [[ $EUID -ne 0 ]]; then
    # Save the script to a temp file and re-execute with sudo
    SCRIPT_TMP="/tmp/rhcsa_installer_$$.sh"
    # Download the script again and run with sudo
    echo "Root privileges required. Re-running with sudo..."
    curl -sL https://raw.githubusercontent.com/RHCSA/RHCSA.github.io/main/Install_RHCSA_EX200_Exam_Simulator.sh -o "$SCRIPT_TMP"
    chmod +x "$SCRIPT_TMP"
    sudo bash "$SCRIPT_TMP"
    rm -f "$SCRIPT_TMP"
    exit $?
fi

clear
set -e

# ============================================================================
# CONFIGURATION
# ============================================================================
GITHUB_RAW_BASE="https://raw.githubusercontent.com/RHCSA/RHCSA.github.io/main/RHCSA_EX200_Exam_Simulator"
GITHUB_API_URL="https://api.github.com/repos/RHCSA/RHCSA.github.io/contents/RHCSA_EX200_Exam_Simulator"
# ============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Installation paths
INSTALL_DIR="/usr/local/share/rhcsa"
BIN_LINK="/usr/bin/rhcsa"
TMP_DIR="/tmp/rhcsa_install_$$"

echo ""
echo -e "${YELLOW}${BOLD}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}${BOLD}║         RHCSA EX200 Exam Simulator - Installer             ║${NC}"
echo -e "${YELLOW}${BOLD}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Cleanup function
cleanup() {
    rm -rf "$TMP_DIR" 2>/dev/null || true
}
trap cleanup EXIT

# Step 1: Check internet connectivity
echo -e "  ${YELLOW}[1/5]${NC} Checking internet connectivity..."
if ! ping -c 1 github.com &>/dev/null && ! curl -sI https://github.com &>/dev/null; then
    echo -e "        ${RED}✗ No internet connection detected${NC}"
    echo ""
    echo -e "${YELLOW}${BOLD}Please configure your VM for internet access:${NC}"
    echo ""
    echo -e "  ${CYAN}1. Shut down the VM${NC}"
    echo -e "  ${CYAN}2. In VM settings, set Network Adapter to 'Bridged' or 'NAT'${NC}"
    echo -e "  ${CYAN}3. Start the VM${NC}"
    echo -e "  ${CYAN}4. Run: nmcli device status${NC}"
    echo -e "  ${CYAN}5. If interface is disconnected, run: nmcli connection up <connection-name>${NC}"
    echo -e "  ${CYAN}6. Verify with: ping -c 3 google.com${NC}"
    echo ""
    echo -e "${YELLOW}Then re-run this installer.${NC}"
    echo ""
    exit 1
fi
echo -e "        ${GREEN}✓${NC} Internet connection available"

# Step 2: Check for required tools
echo -e "  ${YELLOW}[2/5]${NC} Checking requirements..."
if ! command -v curl &>/dev/null; then
    echo -e "        ${CYAN}Installing curl...${NC}"
    dnf install -y curl &>/dev/null || yum install -y curl &>/dev/null
fi
if ! command -v tmux &>/dev/null; then
    echo -e "        ${CYAN}Installing tmux...${NC}"
    dnf install -y tmux &>/dev/null || yum install -y tmux &>/dev/null
fi
echo -e "        ${GREEN}✓${NC} Requirements satisfied (curl, tmux)"

# Step 3: Create temp directory and download files
echo -e "  ${YELLOW}[3/5]${NC} Downloading RHCSA Exam Simulator files..."
mkdir -p "$TMP_DIR/RHCSA_EX200_Exam_Simulator/questions"

# Download main rhcsa executable
echo -e "        ${CYAN}↓${NC} Downloading main executable..."
curl -sL "${GITHUB_RAW_BASE}/rhcsa" -o "$TMP_DIR/RHCSA_EX200_Exam_Simulator/rhcsa"

# Download questions - iterate through question directories (1-10)
for i in {1..10}; do
    echo -ne "        ${CYAN}↓${NC} Downloading Chapter $i questions...     \r"
    mkdir -p "$TMP_DIR/RHCSA_EX200_Exam_Simulator/questions/$i"
    
    # Get list of files in the question directory using GitHub API
    files=$(curl -sL "https://api.github.com/repos/RHCSA/RHCSA.github.io/contents/RHCSA_EX200_Exam_Simulator/questions/$i" 2>/dev/null | grep '"name"' | sed 's/.*"name": "\([^"]*\)".*/\1/')
    
    # If API fails, try common file patterns
    if [[ -z "$files" ]]; then
        # Try downloading numbered question files
        for q in {1..20}; do
            curl -sL "${GITHUB_RAW_BASE}/questions/$i/q${q}.sh" -o "$TMP_DIR/RHCSA_EX200_Exam_Simulator/questions/$i/q${q}.sh" 2>/dev/null || true
            curl -sL "${GITHUB_RAW_BASE}/questions/$i/question${q}.sh" -o "$TMP_DIR/RHCSA_EX200_Exam_Simulator/questions/$i/question${q}.sh" 2>/dev/null || true
        done
    else
        file_count=0
        for file in $files; do
            curl -sL "${GITHUB_RAW_BASE}/questions/$i/$file" -o "$TMP_DIR/RHCSA_EX200_Exam_Simulator/questions/$i/$file" 2>/dev/null || true
            file_count=$((file_count + 1))
            echo -ne "        ${CYAN}↓${NC} Chapter $i: Downloaded $file_count files...     \r"
        done
    fi
    echo -e "        ${GREEN}✓${NC} Chapter $i questions downloaded          "
done

# Download README if exists
curl -sL "${GITHUB_RAW_BASE}/questions/README.md" -o "$TMP_DIR/RHCSA_EX200_Exam_Simulator/questions/README.md" 2>/dev/null || true

# Remove empty files
find "$TMP_DIR" -type f -empty -delete 2>/dev/null || true

echo -e "        ${GREEN}✓${NC} All files downloaded"

# Step 4: Install
echo -e "  ${YELLOW}[4/5]${NC} Installing to ${INSTALL_DIR}..."

# Preserve progress file from previous installation
PROGRESS_FILE="${INSTALL_DIR}/.progress"
PROGRESS_BACKUP="/tmp/.rhcsa_progress_backup_$$"
if [[ -f "$PROGRESS_FILE" ]]; then
    cp "$PROGRESS_FILE" "$PROGRESS_BACKUP" 2>/dev/null
    echo -e "        ${CYAN}ℹ${NC} Preserving previous progress..."
fi
# Also check legacy location
if [[ -f "/tmp/.rhcsa_progress" ]] && [[ ! -f "$PROGRESS_BACKUP" ]]; then
    cp "/tmp/.rhcsa_progress" "$PROGRESS_BACKUP" 2>/dev/null
    echo -e "        ${CYAN}ℹ${NC} Migrating progress from legacy location..."
fi

# Remove previous installation
rm -rf "$INSTALL_DIR" 2>/dev/null || true
mkdir -p "$INSTALL_DIR"
cp -r "$TMP_DIR/RHCSA_EX200_Exam_Simulator/"* "$INSTALL_DIR/"

# Restore progress file
if [[ -f "$PROGRESS_BACKUP" ]]; then
    cp "$PROGRESS_BACKUP" "$PROGRESS_FILE" 2>/dev/null
    rm -f "$PROGRESS_BACKUP" 2>/dev/null
    echo -e "        ${GREEN}✓${NC} Progress restored"
fi

# Convert Windows line endings to Unix (CRLF -> LF)
find "$INSTALL_DIR" -type f -name "*.sh" -exec sed -i 's/\r$//' {} \; 2>/dev/null || true
sed -i 's/\r$//' "$INSTALL_DIR/rhcsa" 2>/dev/null || true

chmod +x "$INSTALL_DIR/rhcsa"
chmod +x "$INSTALL_DIR"/*.sh 2>/dev/null || true
find "$INSTALL_DIR/questions" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
echo -e "        ${GREEN}✓${NC} Files installed"

# Step 5: Create command
echo -e "  ${YELLOW}[5/5]${NC} Creating 'rhcsa' command..."
ln -sf "$INSTALL_DIR/rhcsa" "$BIN_LINK"
echo -e "        ${GREEN}✓${NC} Command created"

# Verify
echo ""
if [[ -x "$BIN_LINK" ]] && [[ -f "$INSTALL_DIR/rhcsa" ]]; then
    echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}  ✓ Installation successful!${NC}"
    echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  Run the simulator with: ${CYAN}rhcsa${NC}"
    echo ""
    echo -e "  ${YELLOW}[root@server ~]#${NC} rhcsa"
    echo ""
    echo -e "  ${YELLOW}Note: You must run as root for the labs to work.${NC}"
    echo ""
else
    echo -e "${RED}Installation failed. Please check errors above.${NC}"
    exit 1
fi
