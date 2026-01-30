#!/usr/bin/env bash
# session-start.sh — 세션 시작 시 인사말 출력
# Hook type: SessionStart

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
READ_CONFIG="${SCRIPT_DIR}/../scripts/read-config.sh"

MSG=$(bash "$READ_CONFIG" ".messages.session_start" 2>/dev/null || echo "안녕! 오늘도 같이 열심히 해보자!")
PERSONA=$(bash "$READ_CONFIG" ".persona.name" 2>/dev/null || echo "친구 클로드")

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${PERSONA}: ${MSG}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
