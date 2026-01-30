#!/usr/bin/env bash
# read-config.sh — config.json 읽기 헬퍼
# Usage: ./read-config.sh <json_path>
# Example: ./read-config.sh ".messages.session_start"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../config/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: config.json not found at $CONFIG_FILE" >&2
  exit 1
fi

JSON_PATH="${1:-.}"

# Try jq first, fallback to python3
if command -v jq &>/dev/null; then
  jq -r "$JSON_PATH" "$CONFIG_FILE"
elif command -v python3 &>/dev/null; then
  python3 -c "
import json, sys
with open('$CONFIG_FILE') as f:
    data = json.load(f)
path = '$JSON_PATH'.lstrip('.')
keys = path.split('.') if path else []
result = data
for key in keys:
    if isinstance(result, dict):
        result = result.get(key, '')
    else:
        result = ''
        break
print(result if isinstance(result, str) else json.dumps(result, ensure_ascii=False))
"
else
  echo "Error: jq or python3 required" >&2
  exit 1
fi
