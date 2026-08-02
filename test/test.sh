#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1}"
FILE="${2:-test.typ}"

if [[ ! -f "$FILE" ]]; then
  echo "Error: file '$FILE' not found" >&2
  exit 1
fi

ABS_FILE="$(realpath "$FILE")"

docker run --rm \
  -v "${ABS_FILE}:/lint_target" \
  "$IMAGE" lint /lint_target && {
  echo "FAIL: expected lint errors but none were reported" >&2
  exit 1
}

echo "PASS: lint errors detected"
