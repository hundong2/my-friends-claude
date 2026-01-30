# my-friends-claude 🤝

Claude Code의 출력 문구와 UX를 커스터마이즈할 수 있는 플러그인입니다.
`config.json` 하나만 수정하면 세션 인사말, 작업 메시지, 상태바, 응답 스타일 등을 원하는 문구로 바꿀 수 있습니다.

A Claude Code plugin to customize messages and UX. Edit one `config.json` to change session greetings, status bar, response styles, and more.

---

## 설치 (Installation)

```bash
# 플러그인 디렉토리에서 Claude Code 실행
claude --plugin-dir ./my-friends-claude
```

또는 프로젝트에 서브모듈로 추가:
```bash
git submodule add <repo-url> .claude-plugins/my-friends-claude
```

## 커스터마이즈 가능한 영역

| # | 영역 | 설명 |
|---|------|------|
| 1 | **응답 스타일** | Claude 응답 톤/언어 변경 (친구체, 간결체, 멘토체) |
| 2 | **상태 표시줄** | 터미널 하단 정보바 커스터마이즈 |
| 3 | **세션 인사/종료** | 시작/종료 시 커스텀 메시지 |
| 4 | **프롬프트별 페르소나** | 매 입력마다 언어/페르소나 주입 |
| 5 | **도구 사용 피드백** | git push 경고, 테스트 결과 메시지 등 |
| 6 | **알림** | 데스크톱 알림 제목 커스터마이즈 |
| 7 | **기본 행동 규칙** | 지속적 행동 지침 |

## 사용법 (Usage)

### 설정 변경

`config/config.json`을 직접 편집하거나 슬래시 커맨드를 사용합니다:

```
/my-friends-claude:show-config     # 현재 설정 조회
/my-friends-claude:set-style       # 스타일 변경
/my-friends-claude:set-message     # 메시지 변경
/my-friends-claude:status          # 플러그인 상태 대시보드
```

### 스타일 종류

- **friendly-korean** — 친구같은 한국어 스타일 (반말, 이모지, 친근한 톤)
- **concise** — 간결한 스타일 (존댓말, 핵심만 전달, 이모지 없음)
- **mentor** — 멘토 스타일 (존댓말, 설명 중심, 학습 유도)

### config.json 예시

```json
{
  "language": "ko",
  "activeStyle": "friendly-korean",
  "persona": { "name": "친구 클로드", "emoji": true },
  "messages": {
    "session_start": "안녕! 오늘도 같이 열심히 해보자! 🚀",
    "session_end": "오늘 수고했어! 다음에 또 만나자! 👋",
    "working": "열심히 만드는중! 🔨",
    "thinking": "음... 생각하는중... 🤔",
    "error_occurred": "앗, 문제가 생겼어. 같이 해결해보자! 💪",
    "task_complete": "완료! 다음은 뭘 해볼까? ✅",
    "git_push_warning": "⚠️ 푸시하기 전에 한번 더 확인해볼까?",
    "test_passed": "테스트 통과! 🎉",
    "test_failed": "테스트 실패... 같이 고쳐보자! 🔧"
  }
}
```

## 디렉토리 구조

```
my-friends-claude/
├── .claude-plugin/plugin.json     # 플러그인 매니페스트
├── config/config.json             # 메시지 설정 (사용자 편집 대상)
├── styles/                        # Output Styles
│   ├── friendly-korean.md
│   ├── concise.md
│   └── mentor.md
├── skills/                        # 슬래시 커맨드
│   ├── set-style/SKILL.md
│   ├── show-config/SKILL.md
│   ├── set-message/SKILL.md
│   └── status/SKILL.md
├── hooks/                         # Hook 스크립트
│   ├── hooks.json
│   ├── session-start.sh
│   ├── prompt-submit.sh
│   ├── stop.sh
│   ├── pre-tool-use.sh
│   └── notification.sh
├── scripts/                       # 유틸리티 스크립트
│   ├── statusline.sh
│   └── read-config.sh
└── rules/CLAUDE.md                # 기본 행동 규칙
```

## 의존성 (Dependencies)

- `jq` (권장) — JSON 파싱. 없으면 `python3` fallback 사용
- `git` — 상태바에서 브랜치 표시용

## 라이선스 (License)

MIT License
