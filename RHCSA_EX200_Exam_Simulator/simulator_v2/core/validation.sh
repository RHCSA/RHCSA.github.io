#!/usr/bin/env bash
set -u
pass(){ echo "PASS: $*"; }
fail(){ echo "FAIL: $*" >&2; exit 1; }
require_file(){ [[ -f "$1" ]] || fail "missing file: $1"; }
require_executable(){ [[ -x "$1" ]] || fail "not executable: $1"; }
require_grep(){ grep -Eq "$1" "$2" || fail "pattern '$1' not found in $2"; }
