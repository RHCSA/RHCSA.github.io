#!/bin/bash
# =============================================================================
# RHCSA EX200 Exam Simulator - Installer
#
#   curl -sL https://raw.githubusercontent.com/RHCSA/RHCSA.github.io/main/Install_RHCSA_EX200_Exam_Simulator.sh | sudo bash
#
# Options (put them after "bash -s --"):
#   --force, -f   skip the update questions and install right away
#   --plain       no full-screen display, print simple lines instead
#   --tui         full-screen display even if the output does not look like a terminal
#   --help, -h    show this text
#
# Everything is inside functions and main() runs on the very last line, so a
# download that is cut short can never run half of the installer.
# =============================================================================

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
GITHUB_RAW_BASE="https://raw.githubusercontent.com/RHCSA/RHCSA.github.io/main/RHCSA_EX200_Exam_Simulator"
GITHUB_TREE_URL="https://api.github.com/repos/RHCSA/RHCSA.github.io/git/trees/main?recursive=1"
GITHUB_COMMITS_API="https://api.github.com/repos/RHCSA/RHCSA.github.io/commits?sha=main&per_page=1"
INSTALLER_URL="https://raw.githubusercontent.com/RHCSA/RHCSA.github.io/main/Install_RHCSA_EX200_Exam_Simulator.sh"

INSTALL_DIR="/usr/local/share/rhcsa"
VERSION_FILE="${INSTALL_DIR}/.version"
PROGRESS_FILE="${INSTALL_DIR}/.progress"
BIN_LINK="/usr/bin/rhcsa"
SYSTEMD_DIR="/etc/systemd/system"
SERVICE_NAME="rhcsa-webui"
WEBUI_PORT=80
TERMINAL_PORT=7682
DOCKER_IMAGE="rockylinux/rockylinux:10-ubi-init"
LOG_FILE="/var/log/rhcsa-installer.log"

# Smallest terminal the full-screen display is drawn in, and the biggest frame.
MIN_COLS=60
MIN_ROWS=14
MAX_COLS=100
MAX_ROWS=34

STEP_COUNT=9
STEP_NAME=( "" "Checking internet connectivity" "Installing requirements"
            "Setting up Docker for the container labs" "Downloading simulator files"
            "Installing simulator files" "Creating the 'rhcsa' command"
            "Configuring firewall and SELinux" "Starting the web interface" "Finishing up" )
# Share of the progress bar for each step (index 0 is unused). plan_weights() adjusts these
# so that steps with nothing to do (tool already installed) take almost no bar.
STEP_WEIGHT=( 0 3 20 20 28 5 1 6 15 2 )

# Python snippet that turns the GitHub "git tree" answer into the list of files to download.
PY_LIST='
import json, sys
prefix = "RHCSA_EX200_Exam_Simulator/"
fixed = {"rhcsa", "webui/index.html", "webui/server.py", "webui/start-webui.sh", "webui/rhcsa-webui.service"}
data = json.load(sys.stdin)
if "tree" not in data:
    sys.stderr.write(str(data.get("message", "unexpected answer from GitHub")) + "\n")
    sys.exit(1)
for entry in data["tree"]:
    path = entry.get("path", "")
    if entry.get("type") != "blob" or not path.startswith(prefix):
        continue
    rel = path[len(prefix):]
    name = rel.rsplit("/", 1)[-1]
    if name.startswith(".") or name.endswith(".pyc") or "__pycache__" in rel:
        continue
    if rel in fixed or rel.startswith("questions/"):
        print(rel)
'

# -----------------------------------------------------------------------------
# State
# -----------------------------------------------------------------------------
FORCE_UPDATE=false
UI_MODE=auto            # auto | tui | plain  (what the user asked for)
UI_ON=false             # true while the full-screen display is drawn
UI_SMALL=false          # true while the terminal is smaller than the minimum
IS_TTY=false
UTF8=false
COLOR_MODE=0            # 0 none, 16, 256, 24 (true color)
LINKS=false             # terminal understands clickable links (OSC 8)
LOG_OK=false
WORK_DIR=""
RUN_PID=""
RUN_SEQ=0
PEND=""
NEED_RELAYOUT=0
SPACES=$(printf '%*s' 240 '')

LOG_N=0
LOG_TS=(); LOG_KIND=(); LOG_TXT=()
SUM_PLAIN=(); SUM_STYLED=()
BODY_MODE=log           # log | summary
CUR_STEP=0
DONE_W=0
TOTAL_W=100
STEP_PM=0               # progress inside the current step, 0..1000
SUB_N=1
SUB_I=0
PCT=0
PCT_MAX=0
SPIN_I=0
FAILED=false
FINISHED=false
SUM_TRUNCATED=false     # true when the result screen had to leave some addresses out
WEB_OK=true
VERSION_TEXT=""
TERM_COLS=80
TERM_ROWS=24
LOG_ROWS=100            # rows available to the result screen (the full-screen layout lowers it)
CW=76
DL_DONE=0
DL_TOTAL=0
DL_FAILED=()

# -----------------------------------------------------------------------------
# Small helpers
# -----------------------------------------------------------------------------
have() { command -v "$1" >/dev/null 2>&1; }
have_ttyd() { have ttyd || [[ -x /usr/local/bin/ttyd ]]; }   # sudo's secure_path hides /usr/local/bin

log_raw() { [[ $LOG_OK == true ]] && printf '%s\n' "$*" >> "$LOG_FILE"; return 0; }

rep() {                       # rep <char> <count>  ->  REPLY
    local n=$2
    (( n < 0 )) && n=0
    printf -v REPLY '%*s' "$n" ''
    REPLY=${REPLY// /"$1"}
}

fit() {                       # fit <text> <width>  ->  REPLY, exactly <width> characters
    local t=$1 w=$2
    (( w < 0 )) && w=0
    if (( ${#t} > w )); then
        if (( w > 0 )); then REPLY="${t:0:w-1}${S_ELL}"; else REPLY=""; fi
    else
        REPLY="${t}${SPACES:0:w-${#t}}"
    fi
}

fmt_elapsed() { printf -v REPLY '%02d:%02d' $(( $1 / 60 )) $(( $1 % 60 )); }

show_usage() {
    cat <<'EOF'
RHCSA EX200 Exam Simulator - Installer

  curl -sL https://raw.githubusercontent.com/RHCSA/RHCSA.github.io/main/Install_RHCSA_EX200_Exam_Simulator.sh | sudo bash

Options (put them after "bash -s --"):
  --force, -f   skip the update questions and install right away
  --plain       no full-screen display, print simple lines instead
  --tui         full-screen display even if the output does not look like a terminal
  --help, -h    show this text
EOF
}

parse_args() {
    local arg
    for arg in "$@"; do
        case $arg in
            --force|-f) FORCE_UPDATE=true ;;
            --plain)    UI_MODE=plain ;;
            --tui)      UI_MODE=tui ;;
            --help|-h)  show_usage; exit 0 ;;
        esac
    done
}

# Not root: download this script again and run it with sudo (keeps the options).
ensure_root() {
    [[ $EUID -eq 0 ]] && return 0
    echo "Root privileges required. Re-running with sudo..."
    if ! have sudo; then
        echo "sudo is not available. Please run this installer as root." >&2
        exit 1
    fi
    local tmp rc
    tmp=$(mktemp /tmp/rhcsa_installer.XXXXXX) || exit 1
    if ! curl -fsSL "$INSTALLER_URL" -o "$tmp"; then
        rm -f "$tmp"
        echo "Could not download the installer. Please check your internet connection." >&2
        exit 1
    fi
    sudo bash "$tmp" "$@"
    rc=$?
    rm -f "$tmp"
    exit $rc
}

init_logging() {
    if { : > "$LOG_FILE"; } 2>/dev/null; then
        LOG_OK=true
    elif { : > /tmp/rhcsa-installer.log; } 2>/dev/null; then
        LOG_FILE=/tmp/rhcsa-installer.log
        LOG_OK=true
    fi
    log_raw "RHCSA installer started $(date '+%Y-%m-%d %H:%M:%S') on $(hostname 2>/dev/null) ($(uname -sr))"
}

# -----------------------------------------------------------------------------
# Terminal detection, symbols and the Red Hat color theme
# -----------------------------------------------------------------------------
detect_terminal() {
    [[ -t 1 && -n ${TERM:-} && ${TERM} != dumb ]] && IS_TTY=true
    [[ $UI_MODE == tui ]] && IS_TTY=true

    case $(locale charmap 2>/dev/null) in UTF-8|utf8|UTF8) UTF8=true ;; esac

    if [[ -z ${NO_COLOR:-} && $IS_TTY == true ]]; then
        case ${COLORTERM:-} in
            truecolor|24bit) COLOR_MODE=24 ;;
            *)  case ${TERM:-} in
                    *256color*|*-direct|xterm|screen|tmux|putty|alacritty|wezterm|foot*|kitty*) COLOR_MODE=256 ;;
                    *) COLOR_MODE=16 ;;
                esac ;;
        esac
    fi

    # Clickable links: every xterm-like terminal either supports or silently ignores them.
    if [[ $IS_TTY == true ]]; then
        case ${TERM:-} in linux|vt*|ansi|cons*|sun*) ;; *) LINKS=true ;; esac
    fi
}

get_term_size() {
    local sz=""
    sz=$(stty size 2>/dev/null </dev/tty) || sz=""
    [[ $sz =~ ^[0-9]+\ [0-9]+$ ]] || { sz=$(stty size 2>/dev/null <&1) || sz=""; }
    if [[ $sz =~ ^([0-9]+)\ ([0-9]+)$ ]]; then
        TERM_ROWS=${BASH_REMATCH[1]}
        TERM_COLS=${BASH_REMATCH[2]}
    else
        TERM_ROWS=${LINES:-24}
        TERM_COLS=${COLUMNS:-80}
    fi
    [[ $TERM_COLS =~ ^[0-9]+$ ]] && (( TERM_COLS > 0 )) || TERM_COLS=80
    [[ $TERM_ROWS =~ ^[0-9]+$ ]] && (( TERM_ROWS > 0 )) || TERM_ROWS=24
}

init_symbols() {
    if [[ $UTF8 == true ]]; then
        B_TL='╔'; B_TR='╗'; B_BL='╚'; B_BR='╝'; B_H='═'; B_V='║'; B_ML='╠'; B_MR='╣'
        B_FULL='█'; B_TRACK='░'
        if [[ ${TERM:-} == linux ]]; then
            # The Linux text console has the frame and block glyphs, but not check marks or braille.
            S_OK='+'; S_ERR='x'; S_WARN='!'; S_ACT='>'; S_STEP='>'; S_INFO='-'; S_RAW='|'; S_DL='v'; S_ELL='~'
            SPIN_FRAMES=( '|' '/' '-' '\' )
            B_PART=()
        else
            S_OK='✓'; S_ERR='✗'; S_WARN='!'; S_ACT='›'; S_STEP='»'; S_INFO='·'; S_RAW='│'; S_DL='↓'; S_ELL='…'
            SPIN_FRAMES=( '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏' )
            B_PART=( '' '▏' '▎' '▍' '▌' '▋' '▊' '▉' )
        fi
    else
        B_TL='+'; B_TR='+'; B_BL='+'; B_BR='+'; B_H='='; B_V='|'; B_ML='+'; B_MR='+'
        S_OK='+'; S_ERR='x'; S_WARN='!'; S_ACT='>'; S_STEP='>'; S_INFO='-'; S_RAW='|'; S_DL='v'; S_ELL='~'
        SPIN_FRAMES=( '|' '/' '-' '\' )
        B_FULL='#'; B_TRACK='-'
        B_PART=()
    fi
    SPIN_N=${#SPIN_FRAMES[@]}
}

# Red Hat red is #EE0000. Colors drop to 256 or 16 colors when the terminal cannot do more.
init_theme() {
    RESET=$'\e[0m'; BOLD=$'\e[1m'; UL=$'\e[4m'
    C_RED=''; C_BAND=''; C_WHITE=''; C_GRAY=''; C_DIM=''; C_OK=''; C_WARN=''; C_ERRC=''
    C_TRACK=''; C_TRACKBG=''; PANEL=''
    case $COLOR_MODE in
        24)  C_RED=$'\e[38;2;238;0;0m';   C_BAND=$'\e[48;2;238;0;0m';  C_WHITE=$'\e[38;2;255;255;255m'
             C_GRAY=$'\e[38;2;190;190;190m'; C_DIM=$'\e[38;2;125;125;125m'
             C_OK=$'\e[38;2;110;198;100m'; C_WARN=$'\e[38;2;240;171;0m'; C_ERRC=$'\e[38;2;255;120;110m'
             C_TRACK=$'\e[38;2;62;62;62m'; C_TRACKBG=$'\e[48;2;62;62;62m'; PANEL=$'\e[48;2;21;21;21m' ;;
        256) C_RED=$'\e[38;5;196m';       C_BAND=$'\e[48;5;196m';       C_WHITE=$'\e[38;5;231m'
             C_GRAY=$'\e[38;5;250m';      C_DIM=$'\e[38;5;243m'
             C_OK=$'\e[38;5;77m';         C_WARN=$'\e[38;5;214m';       C_ERRC=$'\e[38;5;210m'
             C_TRACK=$'\e[38;5;238m';     C_TRACKBG=$'\e[48;5;238m';    PANEL=$'\e[48;5;233m' ;;
        16)  C_RED=$'\e[91m';             C_BAND=$'\e[41m';             C_WHITE=$'\e[97m'
             C_GRAY=$'\e[37m';            C_DIM=$'\e[90m'
             C_OK=$'\e[92m';              C_WARN=$'\e[93m';             C_ERRC=$'\e[91m'
             C_TRACK=$'\e[90m';           PANEL=$'\e[40m' ;;
        *)   [[ $IS_TTY == true ]] && C_BAND=$'\e[7m'
             [[ $IS_TTY == true ]] || { RESET=''; BOLD=''; UL=''; } ;;
    esac
    P="${RESET}${PANEL}"
}

# -----------------------------------------------------------------------------
# Logging (every message goes to the log file, the screen and an in-memory list)
# -----------------------------------------------------------------------------
plain_log() {                 # used when the full-screen display is off
    local kind=$1 text=$2 ts=$3 icon col
    case $kind in
        step) printf '\n%s[%3d%%]%s %s%s%s\n' "$C_RED$BOLD" "$PCT" "$RESET" "$BOLD" "$text" "$RESET"; return ;;
        ok)   icon=$S_OK;   col=$C_OK ;;
        warn) icon=$S_WARN; col=$C_WARN ;;
        err)  icon=$S_ERR;  col=$C_ERRC ;;
        act)  icon=$S_ACT;  col=$C_GRAY ;;
        *)    icon=$S_INFO; col=$C_GRAY ;;
    esac
    if [[ $IS_TTY == true ]]; then
        printf '  %s%s%s %s\n' "$col" "$icon" "$RESET" "$text"
    else
        printf '%s  %s %s\n' "$ts" "$icon" "$text"
    fi
}

ui_log_quiet() {              # ui_log_quiet <kind> <text>   kinds: step ok act info warn err raw
    local kind=$1 text=$2 ts
    text=${text//[[:cntrl:]]/}          # a stray control character would break the frame
    printf -v ts '%(%H:%M:%S)T' -1
    log_raw "$ts [$kind] $text"
    LOG_TS[LOG_N]=$ts; LOG_KIND[LOG_N]=$kind; LOG_TXT[LOG_N]=$text
    (( LOG_N++ ))
    if [[ $UI_ON != true && $kind != raw ]]; then plain_log "$kind" "$text" "$ts"; fi
}

ui_log() { ui_log_quiet "$1" "$2"; [[ $UI_ON == true ]] && ui_render; return 0; }

sanitize_line() {             # sets SANITIZED, returns 1 for an empty line
    local s=$1 re=$'\e\\[[0-9;?]*[ -/]*[@-~]'
    s=${s##*$'\r'}
    while [[ $s =~ $re ]]; do s=${s/"${BASH_REMATCH[0]}"/}; done
    s=${s//$'\t'/ }
    s=${s//[[:cntrl:]]/}
    if [[ $UTF8 != true ]]; then local LC_ALL=C; s=${s//[^ -~]/?}; fi
    s=${s#"${s%%[![:space:]]*}"}
    SANITIZED=$s
    [[ -n $s ]]
}

raw_cb() { sanitize_line "$1" && ui_log_quiet raw "$SANITIZED"; return 0; }

# Read every complete new line of an open file; a half-written last line waits in PEND.
pump_lines() {                # pump_lines <fd> <callback>
    local fd=$1 cb=$2 line rc
    while :; do
        IFS= read -r -t 0.001 -u "$fd" line; rc=$?
        if (( rc == 0 )); then
            line=${PEND}${line}; PEND=""
            "$cb" "$line"
        else
            [[ -n $line ]] && PEND+=$line
            break
        fi
    done
}

# -----------------------------------------------------------------------------
# Full-screen layout and drawing
# -----------------------------------------------------------------------------
ui_layout() {
    F_W=$(( TERM_COLS < MAX_COLS ? TERM_COLS : MAX_COLS ))
    F_X=$(( (TERM_COLS - F_W) / 2 + 1 ))
    F_Y=1
    F_H=$(( TERM_ROWS - 2 ))
    (( F_H > MAX_ROWS )) && F_H=$MAX_ROWS
    if (( F_H >= 20 )); then HDR_ROWS=4; else HDR_ROWS=3; fi
    LOG_ROWS=$(( F_H - HDR_ROWS - 4 ))
    CW=$(( F_W - 4 ))
    rep "$B_H" $(( F_W - 2 )); HLINE=$REPLY
    BORDER_L="${PANEL}${C_RED}${B_V}${P} "
    BORDER_R=" ${PANEL}${C_RED}${B_V}${RESET}"
    ROW_TOP="${PANEL}${C_RED}${B_TL}${HLINE}${B_TR}${RESET}"
    ROW_SEP="${PANEL}${C_RED}${B_ML}${HLINE}${B_MR}${RESET}"
    ROW_BOT="${PANEL}${C_RED}${B_BL}${HLINE}${B_BR}${RESET}"
}

frame_row() { REPLY="${BORDER_L}$1${BORDER_R}"; }

compose_title() {
    local left=" RHCSA EX200 EXAM SIMULATOR" right="INSTALLER " gap
    gap=$(( F_W - ${#left} - ${#right} ))
    REPLY="${C_BAND}${BOLD}${C_WHITE}${left}${SPACES:0:gap}${right}${RESET}"
}

compose_subtitle() {
    local left="Mock exams & hands-on labs  ${S_INFO}  rhcsa.github.io" right="Terminal ${TERM_COLS}x${TERM_ROWS}" gap
    gap=$(( CW - ${#left} - ${#right} ))
    if (( gap < 1 )); then right=""; gap=$(( CW - ${#left} )); fi
    (( gap < 0 )) && { left=${left:0:CW}; gap=0; }
    frame_row "${C_GRAY}${left}${P}${SPACES:0:gap}${C_DIM}${right}${P}"
}

log_row() {                   # log_row <entry-index>  ->  REPLY, styled, CW characters wide
    local i=$1 kind=${LOG_KIND[$1]} ts=${LOG_TS[$1]} icon col tcol body
    case $kind in
        step) icon=$S_STEP; col="${C_RED}${BOLD}"; tcol="${BOLD}${C_WHITE}" ;;
        ok)   icon=$S_OK;   col=$C_OK;             tcol=$C_WHITE ;;
        act)  icon=$S_ACT;  col=$C_GRAY;           tcol=$C_GRAY ;;
        warn) icon=$S_WARN; col=$C_WARN;           tcol=$C_WARN ;;
        err)  icon=$S_ERR;  col="${C_ERRC}${BOLD}"; tcol=$C_ERRC ;;
        raw)  icon=$S_RAW;  col=$C_DIM;            tcol=$C_DIM; ts="        " ;;
        *)    icon=$S_INFO; col=$C_GRAY;           tcol=$C_GRAY ;;
    esac
    fit "${LOG_TXT[$i]}" $(( CW - 11 )); body=$REPLY
    REPLY="${C_DIM}${ts}${P} ${col}${icon}${P} ${tcol}${body}${P}"
}

body_row() {                  # body_row <summary-line-index>  ->  REPLY, CW characters wide
    local p=${SUM_PLAIN[$1]} s=${SUM_STYLED[$1]} pad
    if (( ${#p} <= CW )); then
        pad=$(( CW - ${#p} ))
        REPLY="${s}${SPACES:0:pad}"
    else
        fit "$p" "$CW"
        REPLY="${C_GRAY}${REPLY}${P}"
    fi
}

bar_str() {                   # bar_str <percent> <width>  ->  REPLY, styled
    local pct=$1 w=$2 eighths full rem used filled track part
    if [[ $UTF8 == true && $COLOR_MODE -ge 256 ]]; then
        eighths=$(( pct * w * 8 / 100 )); full=$(( eighths / 8 )); rem=$(( eighths % 8 ))
        used=$full; part=""
        if (( rem > 0 )); then part=${B_PART[rem]}; (( used++ )); fi
        rep "$B_FULL" "$full"; filled=$REPLY
        rep "$B_FULL" $(( w - used )); track=$REPLY
        REPLY="${C_RED}${filled}"
        [[ -n $part ]] && REPLY+="${C_TRACKBG}${part}${P}"
        REPLY+="${C_TRACK}${track}${P}"
    else
        full=$(( pct * w / 100 ))
        rep "$B_FULL" "$full"; filled=$REPLY
        rep "$B_TRACK" $(( w - full )); track=$REPLY
        REPLY="${C_RED}${filled}${C_DIM}${track}${P}"
    fi
}

compose_footer_rows() {       # sets FOOT_STEP and FOOT_BAR (both complete rows)
    local lead lstyle title right t ptxt gap
    fmt_elapsed "$SECONDS"; t=$REPLY
    if [[ $FAILED == true ]]; then
        lead=$S_ERR; lstyle="${C_ERRC}${BOLD}"; title="Stopped at step ${CUR_STEP}/${STEP_COUNT}"; right=$t
    elif [[ $FINISHED == true ]]; then
        lead=$S_OK; lstyle="${C_OK}${BOLD}"; title="Installation complete"; right="${STEP_COUNT}/${STEP_COUNT}  $t"
    elif (( CUR_STEP == 0 )); then
        lead=$S_ACT; lstyle=$C_RED; title="Starting"; right=$t
    else
        lead=${SPIN_FRAMES[SPIN_I]}; lstyle="${C_RED}${BOLD}"; title=${STEP_NAME[CUR_STEP]}; right="${CUR_STEP}/${STEP_COUNT}  $t"
    fi
    local maxt=$(( CW - 2 - ${#right} - 1 ))
    (( ${#title} > maxt )) && title="${title:0:maxt-1}${S_ELL}"
    gap=$(( CW - 2 - ${#title} - ${#right} ))
    frame_row "${lstyle}${lead}${P} ${BOLD}${C_WHITE}${title}${P}${SPACES:0:gap}${C_GRAY}${right}${P}"
    FOOT_STEP=$REPLY

    printf -v ptxt '%3d%%' "$PCT"
    bar_str "$PCT" $(( CW - 5 ))
    frame_row "${REPLY} ${BOLD}${C_WHITE}${ptxt}${P}"
    FOOT_BAR=$REPLY
}

compose_rows() {
    local n=0 i first idx
    ROW=()
    ROW[n++]=$ROW_TOP
    compose_title; ROW[n++]=$REPLY
    if (( HDR_ROWS == 4 )); then compose_subtitle; ROW[n++]=$REPLY; fi
    ROW[n++]=$ROW_SEP
    if [[ $BODY_MODE == log ]]; then
        first=$(( LOG_N - LOG_ROWS )); (( first < 0 )) && first=0
        for (( i = 0; i < LOG_ROWS; i++ )); do
            idx=$(( first + i ))
            if (( idx < LOG_N )); then log_row "$idx"; else REPLY=${SPACES:0:CW}; fi
            frame_row "$REPLY"; ROW[n++]=$REPLY
        done
    else
        for (( i = 0; i < LOG_ROWS; i++ )); do
            if (( i < ${#SUM_PLAIN[@]} )); then body_row "$i"; else REPLY=${SPACES:0:CW}; fi
            frame_row "$REPLY"; ROW[n++]=$REPLY
        done
    fi
    ROW[n++]=$ROW_SEP
    compose_footer_rows
    ROW[n++]=$FOOT_STEP
    ROW[n++]=$FOOT_BAR
    ROW[n++]=$ROW_BOT
    ROW_COUNT=$n
}

# Draw only the rows that changed since the last time.
ui_render() {
    [[ $UI_ON == true ]] || return 0
    if (( NEED_RELAYOUT )); then
        NEED_RELAYOUT=0
        get_term_size
        PREV=()
        printf '%s' $'\e[0m\e[2J\e[H'
        if (( TERM_COLS < MIN_COLS || TERM_ROWS < MIN_ROWS )); then UI_SMALL=true; else UI_SMALL=false; ui_layout; fi
    fi
    if [[ $UI_SMALL == true ]]; then
        printf '\e[H\e[2K Terminal %sx%s is too small - please enlarge it to at least %sx%s' \
            "$TERM_COLS" "$TERM_ROWS" "$MIN_COLS" "$MIN_ROWS"
        return 0
    fi
    compose_rows
    local out="" r
    for (( r = 0; r < ROW_COUNT; r++ )); do
        if [[ ${ROW[r]} != "${PREV[r]-}" ]]; then
            out+=$'\e['$(( F_Y + r ))';'${F_X}'H'${ROW[r]}
            PREV[r]=${ROW[r]}
        fi
    done
    [[ -n $out ]] && printf '%s' "$out"
    return 0
}

ui_start() {
    if [[ $UI_RUN == tui ]]; then
        UI_ON=true
        get_term_size
        ui_layout
        PREV=()
        trap 'NEED_RELAYOUT=1' WINCH
        printf '%s' $'\e[0m\e[?25l\e[?7l\e[2J\e[H'
        ui_render
    else
        print_plain_banner
    fi
}

ui_stop() {
    [[ $UI_ON == true ]] || return 0
    UI_ON=false
    printf '\e[0m\e[?7h\e[?25h\e[%d;1H\n' $(( F_Y + F_H ))
}

print_plain_banner() {
    printf '\n%s%s RHCSA EX200 EXAM SIMULATOR - INSTALLER %s\n' "${C_BAND}${BOLD}${C_WHITE}" "" "$RESET"
}

# -----------------------------------------------------------------------------
# Progress and running commands
# -----------------------------------------------------------------------------
ui_progress_update() {
    local num pct
    if (( CUR_STEP >= 1 )); then
        num=$(( DONE_W * 1000 + STEP_WEIGHT[CUR_STEP] * STEP_PM ))
    else
        num=$(( DONE_W * 1000 ))
    fi
    pct=$(( num / (TOTAL_W * 10) ))
    (( pct > 99 )) && pct=99
    (( pct < PCT_MAX )) && pct=$PCT_MAX
    PCT_MAX=$pct
    PCT=$pct
}

ui_tick() {
    SPIN_I=$(( (SPIN_I + 1) % SPIN_N ))
    ui_progress_update
    ui_render
    sleep 0.1
}

ui_step_begin() {
    (( CUR_STEP++ ))
    STEP_PM=0
    ui_progress_update
    ui_log step "Step ${CUR_STEP}/${STEP_COUNT} - ${STEP_NAME[CUR_STEP]}"
}

ui_step_end() {
    (( DONE_W += STEP_WEIGHT[CUR_STEP] ))
    STEP_PM=0
    ui_progress_update
    ui_render
}

# Run a command in the background, show its output in the log area while it runs and let the bar
# creep from <from> to <to> (permille of the step). Returns the command's exit status.
ui_run() {                    # ui_run <half-life seconds> <from> <to> <command...>
    local half=$1 from=$2 to=$3; shift 3
    local out fd pid rc ticks=0 span=$(( to - from ))
    out="$WORK_DIR/run.$(( ++RUN_SEQ )).out"
    : > "$out"
    PEND=""
    "$@" > "$out" 2>&1 < /dev/null &
    pid=$!
    RUN_PID=$pid
    exec {fd}< "$out"
    while kill -0 "$pid" 2>/dev/null; do
        pump_lines "$fd" raw_cb
        (( ticks++ ))
        STEP_PM=$(( from + span * 920 * ticks / ((ticks + half * 10) * 1000) ))
        ui_tick
    done
    wait "$pid"; rc=$?
    RUN_PID=""
    pump_lines "$fd" raw_cb
    exec {fd}<&-
    PEND=""
    STEP_PM=$to
    ui_progress_update
    return $rc
}

sub_begin() { SUB_N=$1; SUB_I=0; STEP_PM=0; }
sub_skip()  { (( SUB_I++ )); STEP_PM=$(( 1000 * SUB_I / SUB_N )); ui_progress_update; }
ui_sub() {                    # ui_sub <half-life seconds> <command...>  (one share of the step)
    local half=$1; shift
    local from=$(( 1000 * SUB_I / SUB_N )) to=$(( 1000 * (SUB_I + 1) / SUB_N )) rc
    ui_run "$half" "$from" "$to" "$@"; rc=$?
    (( SUB_I++ ))
    return $rc
}

# -----------------------------------------------------------------------------
# Result screens
# -----------------------------------------------------------------------------
sum_add()   { SUM_PLAIN+=("$1"); SUM_STYLED+=("$2"); }
sum_blank() { SUM_PLAIN+=(""); SUM_STYLED+=(""); }

link_styled() {               # link_styled <url> <text>  ->  REPLY
    if [[ $LINKS == true ]]; then
        REPLY=$'\e]8;;'"$1"$'\e\\'"$2"$'\e]8;;\e\\'
    else
        REPLY=$2
    fi
}

get_server_ips() {            # prints "<ip> <interface>" for every address a browser could use
    local ifc cidr
    if have ip; then
        while read -r ifc cidr; do
            case $ifc in
                lo|docker*|br-*|veth*|virbr*|cni*|podman*|flannel*|cali*|kube*|lxc*|lxd*|tun*|tap*|vnet*) continue ;;
            esac
            printf '%s %s\n' "${cidr%/*}" "$ifc"
        done < <(ip -o -4 addr show scope global 2>/dev/null | awk '{print $2, $4}')
    elif have hostname; then
        for cidr in $(hostname -I 2>/dev/null); do
            [[ $cidr == *.* ]] && printf '%s -\n' "$cidr"
        done
    fi
}

build_success_summary() {
    local ip ifc t url text i shown room extra
    local -a ips=() ifs=()
    fmt_elapsed "$SECONDS"; t=$REPLY
    while read -r ip ifc; do
        [[ -n $ip ]] && { ips+=("$ip"); ifs+=("$ifc"); }
    done < <(get_server_ips)
    (( ${#ips[@]} )) || { ips=(localhost); ifs=("-"); }

    SUM_PLAIN=(); SUM_STYLED=(); SUM_TRUNCATED=false
    local head_p="${S_OK}  INSTALLATION COMPLETE  ${S_INFO}  ${VERSION_TEXT:+${VERSION_TEXT}  ${S_INFO}  }${t}"
    local head_s="${C_OK}${BOLD}${S_OK}${P}  ${BOLD}${C_WHITE}INSTALLATION COMPLETE${P}${C_GRAY}  ${S_INFO}  ${VERSION_TEXT:+${VERSION_TEXT}  ${S_INFO}  }${t}${P}"

    # Rows left for the links once the fixed lines (head, intro, terminal command, log path) are placed
    local fixed=4 blanks=0
    [[ $WEB_OK == true ]] || (( fixed++ ))
    (( LOG_ROWS - fixed >= ${#ips[@]} + 2 )) && blanks=1
    room=$(( LOG_ROWS - fixed - 2 * blanks ))
    (( room < 1 )) && room=1
    shown=${#ips[@]}
    extra=0
    if (( shown > room )); then
        shown=$(( room > 1 ? room - 1 : 1 )); extra=$(( ${#ips[@]} - shown )); SUM_TRUNCATED=true
    fi

    sum_add "$head_p" "$head_s"
    (( blanks )) && sum_blank
    # "Ctrl+click" only makes sense where the terminal can make links (not on the text console or in a log file)
    local link_note=":"
    [[ $LINKS == true ]] && link_note=" (Ctrl+click):"
    sum_add "Open the simulator in your browser${link_note}" "${C_WHITE}Open the simulator in your browser${P}${C_GRAY}${link_note}${P}"
    for (( i = 0; i < shown; i++ )); do
        url="http://${ips[i]}"
        [[ $WEBUI_PORT == 80 ]] || url+=":${WEBUI_PORT}"
        text="  ${S_STEP} ${url}"
        local pad=$(( 28 - ${#url} )); (( pad < 2 )) && pad=2
        link_styled "$url" "$url"
        sum_add "${text}${SPACES:0:pad}${ifs[i]}" "  ${C_RED}${BOLD}${S_STEP}${P} ${BOLD}${C_WHITE}${UL}${REPLY}${P}${SPACES:0:pad}${C_DIM}${ifs[i]}${P}"
    done
    (( extra > 0 )) && sum_add "  ${S_INFO} +${extra} more addresses" "  ${C_DIM}${S_INFO} +${extra} more addresses${P}"
    (( blanks )) && sum_blank
    [[ $WEB_OK == true ]] || sum_add "${S_WARN} The web interface did not answer yet - run: systemctl status ${SERVICE_NAME}" \
        "${C_WARN}${S_WARN} The web interface did not answer yet - run: systemctl status ${SERVICE_NAME}${P}"
    sum_add "Reinstall/update:  sudo rhcsa" "${C_GRAY}Reinstall/update:${P}  ${BOLD}${C_WHITE}sudo rhcsa${P}"
    sum_add "Install log:       ${LOG_FILE}" "${C_GRAY}Install log:${P}       ${C_DIM}${LOG_FILE}${P}"
}

build_failure_summary() {     # build_failure_summary <what went wrong> [help line...]
    local title=$1 line i from room width=$(( CW - 2 ))
    shift
    local -a head_p=() head_s=() help_p=() help_s=() tail_p=() tail_s=()
    (( width < 20 )) && width=20

    head_p+=("${S_ERR}  INSTALLATION FAILED"); head_s+=("${C_ERRC}${BOLD}${S_ERR}${P}  ${BOLD}${C_ERRC}INSTALLATION FAILED${P}")
    head_p+=(""); head_s+=("")
    while IFS= read -r line; do
        head_p+=("$line"); head_s+=("${C_WHITE}${line}${P}")
    done < <(printf '%s\n' "$title" | fold -s -w "$width")

    if (( $# > 0 )); then
        help_p+=(""); help_s+=("")
        help_p+=("What to do:"); help_s+=("${BOLD}${C_WHITE}What to do:${P}")
        for line in "$@"; do
            while IFS= read -r line; do
                help_p+=("  $line"); help_s+=("  ${C_GRAY}${line}${P}")
            done < <(printf '%s\n' "$line" | fold -s -w "$(( width - 2 ))")
        done
    fi

    tail_p+=(""); tail_s+=("")
    tail_p+=("Full log: ${LOG_FILE}"); tail_s+=("${C_DIM}Full log: ${LOG_FILE}${P}")

    SUM_PLAIN=("${head_p[@]}" "${help_p[@]}")
    SUM_STYLED=("${head_s[@]}" "${help_s[@]}")

    # Whatever room is left shows the last messages from the log (in plain mode the user has just seen them, so only a few)
    room=$(( LOG_ROWS - ${#SUM_PLAIN[@]} - ${#tail_p[@]} - 2 ))
    if [[ $UI_ON != true ]] && (( room > 8 )); then room=8; fi
    if (( room >= 2 )); then
        SUM_PLAIN+=(""); SUM_STYLED+=("")
        SUM_PLAIN+=("Last messages:"); SUM_STYLED+=("${C_GRAY}Last messages:${P}")
        from=$(( LOG_N - (room - 1) )); (( from < 0 )) && from=0
        for (( i = from; i < LOG_N; i++ )); do
            SUM_PLAIN+=("  ${LOG_TXT[i]}"); SUM_STYLED+=("  ${C_DIM}${LOG_TXT[i]}${P}")
        done
    fi
    SUM_PLAIN+=("${tail_p[@]}")
    SUM_STYLED+=("${tail_s[@]}")
}

print_plain_summary() {
    local i rule w=64
    if [[ $IS_TTY == true ]]; then
        get_term_size
        (( TERM_COLS - 2 < w )) && w=$(( TERM_COLS - 2 ))
        (( w < 10 )) && w=10
    fi
    rep "$B_H" "$w"; rule=$REPLY
    printf '\n%s%s%s\n' "$C_RED$BOLD" "$rule" "$RESET"
    for (( i = 0; i < ${#SUM_PLAIN[@]}; i++ )); do
        if [[ -z ${SUM_PLAIN[i]} ]]; then printf '\n'; else printf '  %s\n' "${SUM_STYLED[i]}"; fi
    done
    printf '%s%s%s\n\n' "$C_RED$BOLD" "$rule" "$RESET"
}

finish_success() {
    FINISHED=true
    PCT=100
    show_result build_success_summary
}

# Show the result screen: run the builder, then draw it in the frame. If it does not fit (very small window,
# or addresses had to be left out), leave the frame and print the complete result as text instead.
show_result() {               # show_result <builder function> [arguments...]
    "$@"
    if [[ $UI_ON == true ]]; then
        if [[ $UI_SMALL != true && $SUM_TRUNCATED != true ]] && (( ${#SUM_PLAIN[@]} <= LOG_ROWS )); then
            BODY_MODE=summary
            ui_render
            ui_stop
            return 0
        fi
        ui_stop
        printf '\e[0m\e[2J\e[H'
        LOG_ROWS=1000
        CW=$(( TERM_COLS - 4 )); (( CW < 40 )) && CW=40; (( CW > 76 )) && CW=76
        "$@"
    fi
    print_plain_summary
    return 0
}

# Stop with an error. Extra arguments are help lines shown with the message.
die() {                       # die <what went wrong> [help line...]
    local title=$1
    ui_log_quiet err "$title"
    FAILED=true
    show_result build_failure_summary "$@"
    exit 1
}

on_exit() {
    local rc=$?
    [[ -n $RUN_PID ]] && kill "$RUN_PID" 2>/dev/null
    ui_stop
    [[ -n $WORK_DIR && -d $WORK_DIR ]] && rm -rf "$WORK_DIR"
    return $rc
}

on_signal() {
    local sig=$1
    log_raw "Interrupted by $sig"
    [[ -n $RUN_PID ]] && kill "$RUN_PID" 2>/dev/null
    ui_stop
    printf '\n  Installation cancelled.\n  Log: %s\n\n' "$LOG_FILE"
    case $sig in INT) exit 130 ;; HUP) exit 129 ;; *) exit 143 ;; esac
}

# -----------------------------------------------------------------------------
# Questions asked before the full-screen display starts
# -----------------------------------------------------------------------------
print_box() {                 # print_box <text> <color>
    local text=$1 col=$2 w=60 line l r edge mid
    rep "$B_H" $(( w - 2 )); line=$REPLY
    l=$(( (w - 2 - ${#text}) / 2 )); r=$(( w - 2 - ${#text} - l ))
    edge="${col}${BOLD}"
    mid="${SPACES:0:l}${RESET}${BOLD}${text}${RESET}${SPACES:0:r}"
    printf '\n  %s%s%s%s%s\n' "$edge" "$B_TL" "$line" "$B_TR" "$RESET"
    printf '  %s%s%s%s%s%s%s\n' "$edge" "$B_V" "$RESET" "$mid" "$edge" "$B_V" "$RESET"
    printf '  %s%s%s%s%s\n\n' "$edge" "$B_BL" "$line" "$B_BR" "$RESET"
}

# Returns 0 for yes, 1 for no, 2 when there is no terminal to ask on.
ask_yes_no() {
    local reply=""
    { : < /dev/tty; } 2>/dev/null || return 2
    read -r -n 1 -p "$1" reply < /dev/tty
    echo
    [[ $reply =~ ^[Yy]$ ]]
}

# Version = total number of commits on main (the Link header's last page when asking for 1 per page).
get_latest_commit_count() {
    local headers count
    headers=$(curl -s --max-time 15 -D - -o /dev/null -H "User-Agent: RHCSA-Simulator" "$GITHUB_COMMITS_API" 2>/dev/null)
    count=$(echo "$headers" | tr -d '\r' | grep -i '^link:' | grep -oE 'page=[0-9]+>; rel="last"' | grep -oE '[0-9]+' | head -1)
    echo "$count"
}

check_for_update() {
    [[ $FORCE_UPDATE == true ]] && return 0
    [[ -f $VERSION_FILE ]] || return 0
    local installed latest rc
    installed=$(cat "$VERSION_FILE" 2>/dev/null)
    latest=$(get_latest_commit_count)
    [[ -n $latest ]] || return 0

    if [[ $installed != "$latest" ]]; then
        print_box "Update available" "$C_RED"
        printf '  Installed: %sv%s%s\n  Latest:    %sv%s%s\n\n' "$C_WARN" "$installed" "$RESET" "$C_OK" "$latest" "$RESET"
        ask_yes_no "  Do you want to update now? (y/n): "; rc=$?
        if (( rc == 1 )); then
            printf '\n  %sUpdate skipped. Run the installer again to update later.%s\n\n' "$C_WARN" "$RESET"
            exit 0
        fi
        echo
    else
        print_box "Already up to date" "$C_RED"
        printf '  Version: %sv%s%s\n\n' "$C_OK" "$installed" "$RESET"
        ask_yes_no "  Do you want to reinstall anyway? (y/n): "; rc=$?
        if (( rc != 0 )); then echo; exit 0; fi
        echo
    fi
}

# The full-screen display needs room. Wait a little for the window to be enlarged, else use plain lines.
wait_for_size() {
    local i key rc
    printf '\n  %sThe installer looks best in a window of at least %sx%s.%s\n' "$C_WARN" "$MIN_COLS" "$MIN_ROWS" "$RESET"
    printf '  Enlarge this window to continue - or press any key for simple output.\n'
    for (( i = 0; i < 60; i++ )); do
        get_term_size
        if (( TERM_COLS >= MIN_COLS && TERM_ROWS >= MIN_ROWS )); then printf '\r\e[2K'; return 0; fi
        printf '\r\e[2K  Terminal is %sx%s, need %sx%s' "$TERM_COLS" "$TERM_ROWS" "$MIN_COLS" "$MIN_ROWS"
        read -r -s -n 1 -t 0.5 key 2>/dev/null </dev/tty; rc=$?
        if (( rc == 0 )); then break; fi
        (( rc > 128 )) || sleep 0.5
    done
    printf '\r\e[2K'
    return 1
}

choose_ui() {
    UI_RUN=plain
    [[ $UI_MODE == plain ]] && return 0
    [[ $UI_MODE == tui || $IS_TTY == true ]] || return 0
    get_term_size
    if (( TERM_COLS >= MIN_COLS && TERM_ROWS >= MIN_ROWS )) || wait_for_size; then
        UI_RUN=tui
    fi
}

# -----------------------------------------------------------------------------
# Plan: give the progress bar to the steps that really have work to do
# -----------------------------------------------------------------------------
plan_weights() {
    local req=4 dock=4
    have curl    || (( req += 6 ))
    have tmux    || (( req += 6 ))
    have python3 || (( req += 6 ))
    have_ttyd    || (( req += 14 ))
    if ! have docker; then
        dock=40
    elif ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
        dock=18
    fi
    STEP_WEIGHT=( 0 3 "$req" "$dock" 28 5 1 6 15 2 )
    TOTAL_W=0
    local i
    for (( i = 1; i <= STEP_COUNT; i++ )); do (( TOTAL_W += STEP_WEIGHT[i] )); done
}

# -----------------------------------------------------------------------------
# Work done in the background (plain commands: their output is shown live in the log)
# -----------------------------------------------------------------------------
pkg_install() {
    local pm
    if have dnf; then pm=dnf; elif have yum; then pm=yum; else echo "No package manager (dnf or yum) found" >&2; return 1; fi
    "$pm" install -y "$@"
}

internet_ok() { ping -c 1 -W 3 github.com >/dev/null 2>&1 || curl -sI --max-time 10 https://github.com >/dev/null 2>&1; }

download_ttyd_binary() {
    local asset
    case $(uname -m) in
        x86_64|amd64)  asset=ttyd.x86_64 ;;
        aarch64|arm64) asset=ttyd.aarch64 ;;
        *) echo "No ttyd binary is published for $(uname -m)" >&2; return 1 ;;
    esac
    # A running ttyd holds its binary open; overwriting it fails with "text file busy"
    pkill -f "ttyd.*${TERMINAL_PORT}" >/dev/null 2>&1
    curl -fsSL --retry 3 --connect-timeout 15 "https://github.com/tsl0922/ttyd/releases/latest/download/${asset}" -o /usr/local/bin/ttyd.part \
        && chmod +x /usr/local/bin/ttyd.part && mv -f /usr/local/bin/ttyd.part /usr/local/bin/ttyd
}

install_ttyd_cmd() {
    pkg_install epel-release || echo "EPEL is not available - continuing"
    pkg_install ttyd && return 0
    echo "ttyd is not in the repositories - downloading the binary"
    download_ttyd_binary
}

install_docker_cmd() {
    pkg_install dnf-plugins-core || pkg_install 'dnf-command(config-manager)' || true
    have dnf && { dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo || true; }
    pkg_install docker-ce docker-ce-cli containerd.io || true
    return 0
}

pull_image_cmd() { docker pull "$DOCKER_IMAGE"; }

list_remote_files() {         # list_remote_files <outfile>
    local out=$1 attempt json
    for attempt in 1 2 3; do
        if json=$(curl -fsSL --connect-timeout 10 --max-time 60 -H "User-Agent: RHCSA-Simulator" "$GITHUB_TREE_URL" 2>/dev/null); then
            # tr keeps only plain path characters, so a stray carriage return can never end up in a file name
            if printf '%s' "$json" | python3 -c "$PY_LIST" | tr -cd 'A-Za-z0-9_./+@%\n-' > "$out" && [[ -s $out ]]; then return 0; fi
        fi
        echo "GitHub did not return the file list (attempt $attempt of 3)"
        sleep 3
    done
    return 1
}

firewall_cmd() {
    firewall-cmd --permanent --add-port="${WEBUI_PORT}/tcp"
    firewall-cmd --permanent --add-port="${TERMINAL_PORT}/tcp"
    firewall-cmd --reload
    return 0
}

selinux_cmd() {
    semanage port -a -t http_port_t -p tcp "$WEBUI_PORT" || echo "port ${WEBUI_PORT} already has an SELinux type"
    semanage port -a -t http_port_t -p tcp "$TERMINAL_PORT" || echo "port ${TERMINAL_PORT} already has an SELinux type"
    return 0
}

service_cmd() {
    cp "${INSTALL_DIR}/webui/rhcsa-webui.service" "$SYSTEMD_DIR/" || return 1
    systemctl daemon-reload || return 1
    systemctl enable "$SERVICE_NAME"
    # Restart (not just start) so an update really picks up the new files
    systemctl restart "$SERVICE_NAME"
}

wait_web_ready() {
    local i
    for (( i = 1; i <= 25; i++ )); do
        if curl -fs -o /dev/null --max-time 2 "http://127.0.0.1:${WEBUI_PORT}/"; then
            echo "The web interface answers on port ${WEBUI_PORT}"
            return 0
        fi
        echo "Waiting for the web interface ($i/25)"
        sleep 1
    done
    return 1
}

fetch_version_cmd() {
    local v
    v=$(get_latest_commit_count)
    [[ -n $v ]] && printf '%s\n' "$v" > "$WORK_DIR/latest_version"
    return 0
}

# -----------------------------------------------------------------------------
# The installation steps
# -----------------------------------------------------------------------------
step_connectivity() {
    ui_step_begin
    local pretty="" id="" like=""
    if [[ -r /etc/os-release ]]; then
        pretty=$(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-}")
        id=$(. /etc/os-release 2>/dev/null; echo "${ID:-}")
        like=$(. /etc/os-release 2>/dev/null; echo "${ID_LIKE:-}")
    fi
    ui_log info "System: ${pretty:-unknown} (${HOSTNAME:-$(uname -n)}, $(uname -m))"
    case " $id $like " in
        *" rhel "*|*" centos "*|*" fedora "*|*" rocky "*|*" almalinux "*|*" ol "*) ;;
        *) ui_log warn "This installer is made for RHEL-compatible systems - continuing anyway" ;;
    esac
    [[ $FORCE_UPDATE == true ]] && ui_log info "Update mode (--force): no questions asked"

    ui_log act "Contacting github.com"
    if ui_run 3 0 1000 internet_ok; then
        ui_log ok "Internet connection available"
    else
        die "No internet connection detected." \
            "Please configure your VM for internet access:" \
            "1. Shut down the VM" \
            "2. In the VM settings, set the Network Adapter to 'Bridged' or 'NAT'" \
            "3. Start the VM" \
            "4. Run: nmcli device status" \
            "5. If the interface is disconnected, run: nmcli connection up <connection-name>" \
            "6. Verify with: ping -c 3 google.com" \
            "Then run this installer again."
    fi
    ui_step_end
}

step_requirements() {
    ui_step_begin
    local tool
    sub_begin 4
    for tool in curl tmux python3; do
        if have "$tool"; then
            ui_log ok "$tool is already installed"
            sub_skip
        else
            ui_log act "Installing $tool"
            ui_sub 10 pkg_install "$tool" \
                || die "Could not install $tool." "Check the package repositories (dnf or yum) and run this installer again."
            ui_log ok "$tool installed"
        fi
    done
    if have_ttyd; then
        ui_log ok "ttyd is already installed"
        sub_skip
    else
        ui_log act "Installing ttyd for the web terminal"
        ui_sub 15 install_ttyd_cmd
        have_ttyd || die "Could not install ttyd (the web terminal)." \
            "Install it by hand from https://github.com/tsl0922/ttyd/releases and run this installer again."
        ui_log ok "ttyd installed"
    fi
    ui_step_end
}

step_docker() {
    ui_step_begin
    sub_begin 3
    if have docker; then
        ui_log ok "Docker is already installed"
        sub_skip
    else
        ui_log act "Installing Docker (used by the container labs)"
        ui_sub 40 install_docker_cmd
        if have docker; then ui_log ok "Docker installed"
        else ui_log warn "Docker could not be installed - the container labs will not work"; fi
    fi
    if have docker; then
        ui_log act "Starting the Docker service"
        ui_sub 5 systemctl enable --now docker || ui_log warn "The Docker service did not start"
        # Pre-pull the RHEL practice image so container labs start instantly.
        ui_log act "Pulling the RHEL practice image (this may take a minute)"
        if ui_sub 30 pull_image_cmd; then ui_log ok "Practice image ready"
        else ui_log warn "Could not pull ${DOCKER_IMAGE} - container labs will pull it when needed"; fi
    else
        sub_skip; sub_skip
    fi
    ui_step_end
}

dl_cb() {                     # one line from the download log: "OK <path>" or "FAIL <path>"
    local state=${1%% *} path=${1#* }
    (( DL_DONE++ ))
    if [[ $state == OK ]]; then
        if [[ $UI_ON == true ]]; then
            ui_log_quiet act "${S_DL} ${path}"
        else
            log_raw "downloaded ${path}"
            (( DL_DONE % 25 == 0 )) && ui_log_quiet info "Downloaded ${DL_DONE} of ${DL_TOTAL} files"
        fi
    else
        DL_FAILED+=("$path")
        ui_log_quiet warn "Download failed: ${path}"
    fi
}

step_download() {
    ui_step_begin
    local list="$WORK_DIR/files.list" dest="$WORK_DIR/RHCSA_EX200_Exam_Simulator" total fd pid f
    mkdir -p "$dest"

    # The version is read BEFORE the files, so a commit made during the download is never marked as installed.
    ui_log act "Checking the latest version"
    ui_run 3 0 40 fetch_version_cmd
    ui_log act "Listing the simulator files on GitHub"
    ui_run 5 40 120 list_remote_files "$list" \
        || die "Could not get the list of files from GitHub." \
               "GitHub may be limiting requests from this address (60 per hour without an account)." \
               "Wait a few minutes and run this installer again."
    total=$(wc -l < "$list")
    DL_TOTAL=$total
    ui_log ok "${total} files to download"

    cat > "$WORK_DIR/dl_one.sh" <<'EOF'
#!/bin/bash
rel=$1
mkdir -p "$DL_DEST/$(dirname "$rel")"
if curl -fsSL --retry 3 --retry-delay 1 --connect-timeout 10 --max-time 120 -o "$DL_DEST/$rel" "$DL_BASE/$rel"; then
    [ -s "$DL_DEST/$rel" ] || rm -f "$DL_DEST/$rel"
    echo "OK $rel" >> "$DL_LOG"
else
    rm -f "$DL_DEST/$rel"
    echo "FAIL $rel" >> "$DL_LOG"
fi
EOF
    export DL_BASE="$GITHUB_RAW_BASE" DL_DEST="$dest" DL_LOG="$WORK_DIR/dl.log"
    : > "$DL_LOG"
    DL_DONE=0
    DL_FAILED=()
    PEND=""
    xargs -d '\n' -n 1 -P 6 bash "$WORK_DIR/dl_one.sh" < "$list" > /dev/null 2>&1 &
    pid=$!
    RUN_PID=$pid
    exec {fd}< "$DL_LOG"
    while kill -0 "$pid" 2>/dev/null; do
        pump_lines "$fd" dl_cb
        (( total > 0 )) && STEP_PM=$(( 120 + 830 * DL_DONE / total ))
        ui_tick
    done
    wait "$pid"
    RUN_PID=""
    pump_lines "$fd" dl_cb
    exec {fd}<&-

    if (( ${#DL_FAILED[@]} > 0 )); then
        ui_log warn "Trying ${#DL_FAILED[@]} failed download(s) again"
        local -a still=()
        for f in "${DL_FAILED[@]}"; do
            bash "$WORK_DIR/dl_one.sh" "$f"
            [[ $(tail -n 1 "$DL_LOG") == "OK $f" ]] || still+=("$f")
        done
        (( ${#still[@]} == 0 )) || die "Could not download ${#still[@]} file(s), for example: ${still[0]}" \
            "Check the internet connection and run this installer again. Nothing was changed on this system."
    fi

    local -a missing=()
    for f in rhcsa webui/index.html webui/server.py webui/start-webui.sh webui/rhcsa-webui.service; do
        [[ -s $dest/$f ]] || missing+=("$f")
    done
    (( ${#missing[@]} == 0 )) || die "Required file missing after the download: ${missing[0]}" \
        "Run this installer again. Nothing was changed on this system."

    STEP_PM=1000
    ui_log ok "Downloaded ${total} files"
    ui_step_end
}

step_install() {
    ui_step_begin
    local src="$WORK_DIR/RHCSA_EX200_Exam_Simulator" stage="${INSTALL_DIR}.new.$$" old="${INSTALL_DIR}.old.$$"
    rm -rf "$stage" "$old"
    mkdir -p "$stage" && cp -r "$src/." "$stage/" || die "Could not copy the files to $stage"
    STEP_PM=300; ui_progress_update

    # Keep the student's progress from a previous installation
    if [[ -f $PROGRESS_FILE ]]; then
        cp -p "$PROGRESS_FILE" "$stage/.progress" 2>/dev/null
        ui_log info "Keeping your previous progress"
    elif [[ -f /tmp/.rhcsa_progress ]]; then
        cp "/tmp/.rhcsa_progress" "$stage/.progress" 2>/dev/null
        ui_log info "Moving progress over from the old location"
    fi

    # Windows line endings (CRLF -> LF) and permissions
    find "$stage" -type f \( -name '*.sh' -o -name rhcsa \) -exec sed -i 's/\r$//' {} + 2>/dev/null
    chmod +x "$stage/rhcsa"
    chmod +x "$stage"/*.sh 2>/dev/null
    chmod +x "$stage/webui"/*.sh "$stage/webui"/*.py 2>/dev/null
    find "$stage/questions" -name '*.sh' -exec chmod +x {} + 2>/dev/null
    STEP_PM=600; ui_progress_update

    # Swap the new files in; the old installation is only removed once the new one is in place
    if [[ -d $INSTALL_DIR ]]; then
        mv "$INSTALL_DIR" "$old" || { rm -rf "$stage"; die "Could not replace the previous installation in ${INSTALL_DIR}. Nothing was changed."; }
    fi
    if mv "$stage" "$INSTALL_DIR"; then
        rm -rf "$old"
        have restorecon && restorecon -R "$INSTALL_DIR" >/dev/null 2>&1
        ui_log ok "Installed to ${INSTALL_DIR}"
    else
        rm -rf "$stage"
        [[ -d $old ]] && mv "$old" "$INSTALL_DIR"
        die "Could not move the new files into ${INSTALL_DIR}. The previous installation was kept."
    fi
    ui_step_end
}

step_command() {
    ui_step_begin
    ln -sf "${INSTALL_DIR}/rhcsa" "$BIN_LINK" || die "Could not create ${BIN_LINK}"
    ui_log ok "Command created: rhcsa"
    ui_step_end
}

step_security() {
    ui_step_begin
    sub_begin 3
    if have firewall-cmd; then
        if systemctl is-active firewalld >/dev/null 2>&1; then
            ui_log act "Opening ports ${WEBUI_PORT} and ${TERMINAL_PORT} in the firewall"
            ui_sub 5 firewall_cmd
            ui_log ok "Firewall rules added (ports ${WEBUI_PORT}, ${TERMINAL_PORT})"
        else
            ui_log info "firewalld is not running - nothing to configure"; sub_skip
        fi
    else
        ui_log info "firewall-cmd not found - nothing to configure"; sub_skip
    fi

    if ! have semanage && have dnf; then
        ui_log act "Installing the SELinux tools"
        ui_sub 10 pkg_install policycoreutils-python-utils
    else
        sub_skip
    fi
    if have semanage; then
        ui_log act "Allowing the web ports in SELinux"
        ui_sub 5 selinux_cmd
        ui_log ok "SELinux configured"
    else
        ui_log info "SELinux tools not available - skipping"; sub_skip
    fi
    ui_step_end
}

step_service() {
    ui_step_begin
    sub_begin 2
    if [[ -f ${INSTALL_DIR}/webui/rhcsa-webui.service ]]; then
        ui_log act "Installing and starting the ${SERVICE_NAME} service"
        if ui_sub 6 service_cmd; then
            ui_log ok "Service installed"
        else
            ui_log warn "The service did not start cleanly - run: systemctl status ${SERVICE_NAME}"
        fi
        if ui_sub 12 wait_web_ready; then
            ui_log ok "Web interface is running on port ${WEBUI_PORT}"
        else
            WEB_OK=false
            ui_log warn "The web interface does not answer yet - run: systemctl status ${SERVICE_NAME}"
        fi
        if ! have ss; then
            :
        elif ss -ltn 2>/dev/null | grep -q ":${TERMINAL_PORT} "; then
            ui_log ok "Web terminal is listening on port ${TERMINAL_PORT}"
        else
            ui_log warn "The web terminal (ttyd) is not listening on port ${TERMINAL_PORT} yet"
        fi
    else
        WEB_OK=false
        ui_log warn "Web interface service file not found - skipping"
    fi
    ui_step_end
}

step_finish() {
    ui_step_begin
    local latest=""
    [[ -s $WORK_DIR/latest_version ]] || { ui_log act "Asking GitHub for the version number"; ui_run 3 0 700 fetch_version_cmd; }
    [[ -s $WORK_DIR/latest_version ]] && latest=$(cat "$WORK_DIR/latest_version")
    if [[ -n $latest ]]; then
        echo "$latest" > "$VERSION_FILE"
        VERSION_TEXT="v${latest}"
        ui_log ok "Version saved (${VERSION_TEXT})"
    else
        ui_log warn "Could not fetch the version number"
    fi
    if [[ -x $BIN_LINK && -f ${INSTALL_DIR}/rhcsa ]]; then
        ui_log ok "Installation verified"
    else
        die "The installation could not be verified (${BIN_LINK} is missing)."
    fi
    STEP_PM=1000
    ui_step_end
}

# -----------------------------------------------------------------------------
main() {
    SECONDS=0
    parse_args "$@"
    ensure_root "$@"
    init_logging
    detect_terminal
    init_symbols
    init_theme
    WORK_DIR=$(mktemp -d /tmp/rhcsa_install.XXXXXX) || { echo "Cannot create a temporary directory in /tmp" >&2; exit 1; }
    trap on_exit EXIT
    trap 'on_signal INT' INT
    trap 'on_signal TERM' TERM
    trap 'on_signal HUP' HUP

    check_for_update
    choose_ui
    plan_weights
    SECONDS=0
    ui_start

    step_connectivity
    step_requirements
    step_docker
    step_download
    step_install
    step_command
    step_security
    step_service
    step_finish
    finish_success
}

# Tests source this file with RHCSA_INSTALLER_NO_MAIN=1 and call the pieces themselves.
if [[ -z ${RHCSA_INSTALLER_NO_MAIN:-} ]]; then
    main "$@"
fi
