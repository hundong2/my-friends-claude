#!/usr/bin/env bash
# statusline.sh — 커스텀 상태 표시줄
# Claude Code StatusLine 스크립트로 등록하여 사용

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
READ_CONFIG="${SCRIPT_DIR}/read-config.sh"

# config 읽기
get_config() {
  bash "$READ_CONFIG" "$1" 2>/dev/null || echo ""
}

PREFIX=$(get_config ".statusLine.custom_prefix")
SHOW_MODEL=$(get_config ".statusLine.show_model")
SHOW_BRANCH=$(get_config ".statusLine.show_git_branch")
SHOW_COST=$(get_config ".statusLine.show_cost")
SHOW_CONTEXT=$(get_config ".statusLine.show_context_remaining")

PARTS=()

# 커스텀 prefix
if [ -n "$PREFIX" ] && [ "$PREFIX" != "null" ]; then
  PARTS+=("$PREFIX")
fi

# 모델 정보
if [ "$SHOW_MODEL" = "true" ] && [ -n "${CLAUDE_MODEL:-}" ]; then
  PARTS+=("🤖 $CLAUDE_MODEL")
fi

# Git 브랜치
if [ "$SHOW_BRANCH" = "true" ]; then
  BRANCH=$(git branch --show-current 2>/dev/null || echo "")
  if [ -n "$BRANCH" ]; then
    PARTS+=("🌿 $BRANCH")
  fi
fi

# 비용 (환경변수로 제공되는 경우)
if [ "$SHOW_COST" = "true" ] && [ -n "${CLAUDE_COST:-}" ]; then
  PARTS+=("💰 $CLAUDE_COST")
fi

# 컨텍스트 잔량 (환경변수로 제공되는 경우)
if [ "$SHOW_CONTEXT" = "true" ] && [ -n "${CLAUDE_CONTEXT_REMAINING:-}" ]; then
  PARTS+=("📊 $CLAUDE_CONTEXT_REMAINING")
fi

# 구분자로 연결
IFS=" │ "
echo "${PARTS[*]}"
