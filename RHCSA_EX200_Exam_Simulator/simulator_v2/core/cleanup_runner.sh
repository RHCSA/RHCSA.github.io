#!/usr/bin/env bash
set -euo pipefail
QUESTION_FILE=${1:?Usage: cleanup_runner.sh QUESTION_FILE}
source "$QUESTION_FILE"
cleanup_lab
