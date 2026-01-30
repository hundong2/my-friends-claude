#!/usr/bin/env bash
# spinner-manage.sh — spinnerVerbs를 ~/.claude/settings.json에 적용/원복
# Usage: ./spinner-manage.sh apply   — 커스텀 스피너 적용 (기존값 백업)
#        ./spinner-manage.sh restore — 원본 스피너 복원

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../config/config.json"
SETTINGS_FILE="${HOME}/.claude/settings.json"
ACTION="${1:-apply}"

# jq 또는 python3 필수
if ! command -v jq &>/dev/null && ! command -v python3 &>/dev/null; then
  exit 0
fi

# config.json에서 spinnerVerbs 활성화 여부 확인
is_enabled() {
  if command -v jq &>/dev/null; then
    jq -r '.spinnerVerbs.enabled // false' "$CONFIG_FILE" 2>/dev/null
  else
    python3 -c "
import json
with open('$CONFIG_FILE') as f:
    d = json.load(f)
print(str(d.get('spinnerVerbs', {}).get('enabled', False)).lower())
" 2>/dev/null
  fi
}

# config.json에서 spinnerVerbs 배열 추출
get_verbs_json() {
  if command -v jq &>/dev/null; then
    jq -c '.spinnerVerbs.verbs' "$CONFIG_FILE" 2>/dev/null
  else
    python3 -c "
import json
with open('$CONFIG_FILE') as f:
    d = json.load(f)
print(json.dumps(d.get('spinnerVerbs', {}).get('verbs', []), ensure_ascii=False))
" 2>/dev/null
  fi
}

# settings.json 읽기 (없으면 빈 오브젝트)
read_settings() {
  if [ -f "$SETTINGS_FILE" ]; then
    cat "$SETTINGS_FILE"
  else
    echo "{}"
  fi
}

# settings.json 쓰기
write_settings() {
  local content="$1"
  mkdir -p "$(dirname "$SETTINGS_FILE")"
  echo "$content" > "$SETTINGS_FILE"
}

apply_spinner() {
  local enabled
  enabled=$(is_enabled)
  if [ "$enabled" != "true" ]; then
    exit 0
  fi

  local verbs_json
  verbs_json=$(get_verbs_json)
  if [ -z "$verbs_json" ] || [ "$verbs_json" = "null" ] || [ "$verbs_json" = "[]" ]; then
    exit 0
  fi

  local settings
  settings=$(read_settings)

  if command -v jq &>/dev/null; then
    # 기존 spinnerVerbs가 있고 백업이 없으면 백업
    local has_backup
    has_backup=$(echo "$settings" | jq 'has("_spinnerVerbs_backup")' 2>/dev/null || echo "false")
    local has_spinner
    has_spinner=$(echo "$settings" | jq 'has("spinnerVerbs")' 2>/dev/null || echo "false")

    if [ "$has_spinner" = "true" ] && [ "$has_backup" = "false" ]; then
      # 현재 spinnerVerbs가 이미 우리가 적용한 것인지 확인
      local current_first
      current_first=$(echo "$settings" | jq -r '.spinnerVerbs[0] // ""' 2>/dev/null || echo "")
      local our_first
      our_first=$(echo "$verbs_json" | jq -r '.[0] // ""' 2>/dev/null || echo "")
      if [ "$current_first" != "$our_first" ]; then
        # 다른 값 → 백업
        settings=$(echo "$settings" | jq '._spinnerVerbs_backup = .spinnerVerbs')
      fi
    fi

    # spinnerVerbs 적용
    settings=$(echo "$settings" | jq --argjson verbs "$verbs_json" '.spinnerVerbs = $verbs')
    write_settings "$(echo "$settings" | jq .)"
  else
    python3 -c "
import json, os

settings_path = '$SETTINGS_FILE'
verbs = json.loads('$verbs_json')

if os.path.exists(settings_path):
    with open(settings_path) as f:
        settings = json.load(f)
else:
    settings = {}

# 기존 spinnerVerbs가 있고 백업이 없으면 백업
if 'spinnerVerbs' in settings and '_spinnerVerbs_backup' not in settings:
    current = settings.get('spinnerVerbs', [])
    if isinstance(current, list) and len(current) > 0 and len(verbs) > 0:
        if current[0] != verbs[0]:
            settings['_spinnerVerbs_backup'] = current

settings['spinnerVerbs'] = verbs

os.makedirs(os.path.dirname(settings_path), exist_ok=True)
with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
" 2>/dev/null
  fi
}

restore_spinner() {
  if [ ! -f "$SETTINGS_FILE" ]; then
    exit 0
  fi

  local settings
  settings=$(read_settings)

  if command -v jq &>/dev/null; then
    local has_backup
    has_backup=$(echo "$settings" | jq 'has("_spinnerVerbs_backup")' 2>/dev/null || echo "false")

    if [ "$has_backup" = "true" ]; then
      # 백업에서 복원
      settings=$(echo "$settings" | jq '.spinnerVerbs = ._spinnerVerbs_backup | del(._spinnerVerbs_backup)')
    else
      # 백업 없음 → spinnerVerbs 키 자체를 삭제 (Claude Code 기본값으로)
      settings=$(echo "$settings" | jq 'del(.spinnerVerbs) | del(._spinnerVerbs_backup)')
    fi
    write_settings "$(echo "$settings" | jq .)"
  else
    python3 -c "
import json

settings_path = '$SETTINGS_FILE'
with open(settings_path) as f:
    settings = json.load(f)

if '_spinnerVerbs_backup' in settings:
    settings['spinnerVerbs'] = settings.pop('_spinnerVerbs_backup')
else:
    settings.pop('spinnerVerbs', None)
    settings.pop('_spinnerVerbs_backup', None)

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
" 2>/dev/null
  fi
}

case "$ACTION" in
  apply)
    apply_spinner
    ;;
  restore)
    restore_spinner
    ;;
  *)
    echo "Usage: $0 {apply|restore}" >&2
    exit 1
    ;;
esac
