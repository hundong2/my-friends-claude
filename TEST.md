# my-friends-claude 플러그인 테스트 & 사용법

## 1. 설치

```bash
# 마켓플레이스 등록 후 설치
/plugin marketplace add hundong2/my-friends-claude
/plugin install my-friends-claude@my-friends-claude

# 또는 수동 설치
git clone https://github.com/hundong2/my-friends-claude.git
claude --plugin-dir ./my-friends-claude/plugins/my-friends-claude
```

## 2. 슬래시 커맨드

| 커맨드 | 설명 | 사용 예시 |
|--------|------|-----------|
| `/my-friends-claude:show-config` | 현재 설정 확인 | `/my-friends-claude:show-config` |
| `/my-friends-claude:set-style` | 응답 스타일 변경 | `/my-friends-claude:set-style concise` |
| `/my-friends-claude:set-message` | 메시지 커스터마이징 | `/my-friends-claude:set-message session_start 반가워!` |
| `/my-friends-claude:apply-spinner` | 스피너 한글화 적용/복원 | `/my-friends-claude:apply-spinner restore` |
| `/my-friends-claude:status` | 플러그인 상태 대시보드 | `/my-friends-claude:status` |

## 3. 응답 스타일

| 스타일 | 어투 | 특징 |
|--------|------|------|
| `friendly-korean` | 반말 (기본값) | 캐주얼, 이모지 사용, 격려형 ("이렇게 바꿔볼게!") |
| `concise` | 존댓말 | 최소한의 설명, 이모지 없음, 코드 중심 ("수정 완료.") |
| `mentor` | 존댓말 | 이유 설명, Before/After 비교, 학습 중심 |

## 4. Hook 자동 동작

```
세션 시작 ─► session-start.sh ─► 인사 출력 + 스피너 한글화 적용
    │
매 프롬프트 ─► prompt-submit.sh ─► 언어/스타일 설정 주입
    │
도구 사용 전 ─► pre-tool-use.sh ─► git push 경고 / 테스트 피드백
    │
알림 발생 ─► notification.sh ─► macOS 알림 제목 커스터마이징
    │
세션 종료 ─► stop.sh ─► 인사 출력 + 스피너 원래대로 복원
```

## 5. 커스터마이징 가능한 메시지

`plugins/my-friends-claude/config/config.json` 에서 직접 수정하거나 `/my-friends-claude:set-message` 사용

| 키 | 기본값 | 용도 |
|----|--------|------|
| `session_start` | 안녕! 오늘도 같이 열심히 해보자! 🚀 | 세션 시작 인사 |
| `session_end` | 오늘 수고했어! 다음에 또 만나자! 👋 | 세션 종료 인사 |
| `working` | 열심히 만드는중! 🔨 | 작업 중 표시 |
| `thinking` | 음... 생각중... 🤔 | 사고 중 표시 |
| `error_occurred` | 앗, 에러가 났어! 같이 고쳐보자! 🔧 | 에러 발생 시 |
| `task_complete` | 완료! 확인해볼래? ✅ | 작업 완료 시 |
| `git_push_warning` | ⚠️ 푸시하기 전에 한번 더 확인해볼까? | git push 감지 시 |
| `test_passed` | 테스트 통과! 🎉 | 테스트 성공 시 |
| `test_failed` | 테스트 실패... 같이 살펴보자! 🔍 | 테스트 실패 시 |

## 6. 스피너 한글화 (56개)

세션 시작/종료 시 자동 적용/복원됩니다.

```
Thinking    → 생각하는중        Reading     → 읽는중
Working     → 열심히하는중      Writing     → 쓰는중
Cooking     → 요리하는중        Searching   → 찾는중
Crafting    → 만드는중          Debugging   → 디버깅중
Clauding    → 클로딩중          Compiling   → 컴파일중
...                             (총 56개)
```

## 7. 상태바 설정

`config.json` > `statusBar` 섹션에서 표시 항목 제어:

```json
{
  "show_model": true,
  "show_git_branch": true,
  "show_cost": true,
  "show_context_remaining": true,
  "custom_prefix": "친구"
}
```

출력 예시: `친구 │ 🤖 claude-opus │ 🌿 main │ 💰 $0.025`

## 8. 테스트 결과

> 테스트 일시: 2026-01-31

| 항목 | 상태 |
|------|------|
| config.json 유효성 | ✅ |
| marketplace.json 유효성 | ✅ |
| plugin.json 유효성 | ✅ |
| hooks.json 유효성 | ✅ |
| 스크립트 실행 권한 (8개) | ✅ |
| session-start.sh 실행 | ✅ |
| stop.sh 실행 | ✅ |
| pre-tool-use.sh (git push 감지) | ✅ |
| pre-tool-use.sh (테스트 감지) | ✅ |
| prompt-submit.sh (설정 주입) | ✅ |
| read-config.sh (값 읽기) | ✅ |
| spinner-manage.sh apply | ✅ |
| 스타일 파일 3개 존재 | ✅ |
| 스킬 파일 5개 존재 | ✅ |

## 9. 의존성

| 도구 | 필수 여부 | 용도 |
|------|-----------|------|
| `jq` | 권장 (python3 대체 가능) | JSON 파싱 |
| `python3` | jq 없을 때 대체 | JSON 파싱 폴백 |
| `git` | 선택 | 상태바 브랜치 표시 |
| `osascript` | 선택 (macOS 전용) | 데스크탑 알림 |

## 10. 제거

```bash
/plugin uninstall my-friends-claude@my-friends-claude
/plugin marketplace remove my-friends-claude
# 스피너는 다음 세션에서 자동 복원됩니다
```
