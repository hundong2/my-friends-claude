#!/usr/bin/env bash
# notification.sh — 데스크톱 알림 커스터마이즈
# Hook type: Notification
# stdin: { "title": "...", "message": "..." }

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
READ_CONFIG="${SCRIPT_DIR}/../scripts/read-config.sh"

TITLE_PREFIX=$(bash "$READ_CONFIG" ".notifications.title_prefix" 2>/dev/null || echo "친구 클로드")

# stdin에서 원본 알림 읽기
INPUT=$(cat)

if command -v jq &>/dev/null; then
  ORIGINAL_TITLE=$(echo "$INPUT" | jq -r '.title // "알림"' 2>/dev/null || echo "알림")
  MESSAGE=$(echo "$INPUT" | jq -r '.message // ""' 2>/dev/null || echo "")
else
  ORIGINAL_TITLE=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('title','알림'))" 2>/dev/null || echo "알림")
  MESSAGE=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('message',''))" 2>/dev/null || echo "")
fi

# macOS 알림 (osascript)
if command -v osascript &>/dev/null; then
  osascript -e "display notification \"${MESSAGE}\" with title \"${TITLE_PREFIX}: ${ORIGINAL_TITLE}\""
fi
