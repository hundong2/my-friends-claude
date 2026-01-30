#!/usr/bin/env bash
# pre-tool-use.sh — 도구 사용 전 피드백 메시지
# Hook type: PreToolUse
# stdin: { "tool_name": "Bash", "tool_input": { "command": "git push" } }

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
READ_CONFIG="${SCRIPT_DIR}/../scripts/read-config.sh"

# stdin에서 JSON 읽기
INPUT=$(cat)

# tool_name 추출
TOOL_NAME=""
if command -v jq &>/dev/null; then
  TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
  TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")
else
  TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null || echo "")
  TOOL_INPUT=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")
fi

# git push 감지 → 경고 메시지
if [ "$TOOL_NAME" = "Bash" ]; then
  if echo "$TOOL_INPUT" | grep -q "git push"; then
    WARNING=$(bash "$READ_CONFIG" ".messages.git_push_warning" 2>/dev/null || echo "⚠️ 푸시하기 전에 한번 더 확인해볼까?")
    echo "$WARNING" >&2
  fi
fi

# 테스트 실행 감지
if [ "$TOOL_NAME" = "Bash" ]; then
  if echo "$TOOL_INPUT" | grep -qE "(npm test|pytest|jest|cargo test|go test)"; then
    WORKING=$(bash "$READ_CONFIG" ".messages.working" 2>/dev/null || echo "열심히 만드는중!")
    echo "$WORKING" >&2
  fi
fi
