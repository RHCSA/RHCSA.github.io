#!/usr/bin/env bash
set -euo pipefail
QUESTION_FILE=${1:?Usage: question_runner.sh QUESTION_FILE}
source "$QUESTION_FILE"
prepare_lab
printf '%s\n' "$QUESTION"
