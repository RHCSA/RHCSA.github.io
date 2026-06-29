#!/usr/bin/env bash
set -u
log_info(){ printf '[INFO] %s\n' "$*"; }
log_ok(){ printf '[OK] %s\n' "$*"; }
log_fail(){ printf '[FAIL] %s\n' "$*" >&2; }
