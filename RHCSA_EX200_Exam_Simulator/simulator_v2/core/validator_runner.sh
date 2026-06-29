#!/usr/bin/env bash
set -euo pipefail
QUESTION_FILE=${1:?Usage: validator_runner.sh QUESTION_FILE}
source "$QUESTION_FILE"
declare -a TASK_STATUS
check_tasks
failed=0
for i in "${!TASK_STATUS[@]}"; do
  if [[ "${TASK_STATUS[$i]}" == true ]]; then echo "task_$((i+1)): PASS"; else echo "task_$((i+1)): FAIL"; failed=1; fi
done
exit "$failed"
