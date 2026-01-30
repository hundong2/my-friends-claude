#!/usr/bin/env bash
# prompt-submit.sh — 매 프롬프트 제출 시 페르소나/언어 주입
# Hook type: UserPromptSubmit
# stdin: { "prompt": "user's input", "session_id": "..." }

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
READ_CONFIG="${SCRIPT_DIR}/../scripts/read-config.sh"

LANGUAGE=$(bash "$READ_CONFIG" ".language" 2>/dev/null || echo "ko")
STYLE=$(bash "$READ_CONFIG" ".activeStyle" 2>/dev/null || echo "friendly-korean")
USE_EMOJI=$(bash "$READ_CONFIG" ".persona.emoji" 2>/dev/null || echo "true")

# 페르소나 힌트를 환경에 주입 (Claude가 참조할 수 있도록)
if [ "$LANGUAGE" = "ko" ]; then
  echo '{"instructions": "한국어로 응답해주세요. 현재 스타일: '"$STYLE"'. 이모지 사용: '"$USE_EMOJI"'"}'
else
  echo '{"instructions": "Respond in '"$LANGUAGE"'. Current style: '"$STYLE"'. Use emoji: '"$USE_EMOJI"'"}'
fi
