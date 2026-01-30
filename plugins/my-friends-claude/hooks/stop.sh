#!/usr/bin/env bash
# stop.sh — 세션 종료 시 마무리 인사 + 스피너 자동 원복
# Hook type: Stop

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
READ_CONFIG="${SCRIPT_DIR}/../scripts/read-config.sh"
SPINNER_MANAGE="${SCRIPT_DIR}/../scripts/spinner-manage.sh"

MSG=$(bash "$READ_CONFIG" ".messages.session_end" 2>/dev/null || echo "오늘 수고했어! 다음에 또 만나자!")
PERSONA=$(bash "$READ_CONFIG" ".persona.name" 2>/dev/null || echo "친구 클로드")

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${PERSONA}: ${MSG}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 스피너 동사 자동 원복
bash "$SPINNER_MANAGE" restore 2>/dev/null || true
