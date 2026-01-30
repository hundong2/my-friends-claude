# my-friends-claude 🤝

Claude Code의 출력 문구와 UX를 커스터마이즈할 수 있는 플러그인 마켓플레이스입니다.
`config.json` 하나만 수정하면 세션 인사말, 작업 메시지, 상태바, 응답 스타일 등을 원하는 문구로 바꿀 수 있습니다.

A Claude Code plugin marketplace to customize messages and UX. Edit one `config.json` to change session greetings, status bar, response styles, and more.

---

## 설치 (Installation)

### 마켓플레이스로 설치 (권장)

Claude Code 안에서 아래 명령을 실행하세요:

```
# 1. 마켓플레이스 추가
/plugin marketplace add hundong2/my-friends-claude

# 2. 플러그인 설치
/plugin install my-friends-claude@my-friends-claude
```

### 수동 설치

```bash
git clone https://github.com/hundong2/my-friends-claude.git
claude --plugin-dir ./my-friends-claude/plugins/my-friends-claude
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
| 8 | **스피너 동사** | "✽ Effecting…" 등 로딩 문구를 한국어로 변경 |

## 사용법 (Usage)

### 슬래시 커맨드

```
/my-friends-claude:show-config      # 현재 설정 조회
/my-friends-claude:set-style        # 스타일 변경
/my-friends-claude:set-message      # 메시지 변경
/my-friends-claude:apply-spinner    # 스피너 동사 적용/원복
/my-friends-claude:status           # 플러그인 상태 대시보드
```

### 스타일 종류

- **friendly-korean** — 친구같은 한국어 스타일 (반말, 이모지, 친근한 톤)
- **concise** — 간결한 스타일 (존댓말, 핵심만 전달, 이모지 없음)
- **mentor** — 멘토 스타일 (존댓말, 설명 중심, 학습 유도)

### 스피너 동사 커스터마이즈

Claude Code가 작업 중 표시하는 `✽ Effecting…`, `✽ Thinking…` 같은 스피너 문구를 한국어로 바꿀 수 있습니다.

```
/my-friends-claude:apply-spinner          # 한국어 스피너 적용
/my-friends-claude:apply-spinner restore  # 원본 영어로 복원
```

적용 후 Claude Code를 재시작하면 `✽ 생각하는중…`, `✽ 만드는중…` 등으로 표시됩니다.

원본 56개 동사와 한국어 대응은 `config/config.json`의 `spinnerVerbs._original_mapping`에 정리되어 있습니다.

| 원본 (영어) | 한국어 | 의미 |
|-------------|--------|------|
| Thinking | 생각하는중 | 기본 사고 동작 |
| Working | 열심히하는중 | 작업 수행 |
| Crafting | 만드는중 | 정성들여 제작 |
| Cooking | 요리하는중 | 코드를 요리하는 비유 |
| Clauding | 클로딩중 | Claude 고유 동사 |
| Vibing | 느끼는중 | 분위기를 타는 슬랭 |
| ... | ... | (총 56개, config.json 참조) |

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
├── .claude-plugin/
│   └── marketplace.json               # 마켓플레이스 매니페스트
├── plugins/
│   └── my-friends-claude/
│       ├── .claude-plugin/plugin.json  # 플러그인 매니페스트
│       ├── config/config.json          # 메시지 설정 (사용자 편집 대상)
│       ├── styles/                     # Output Styles
│       │   ├── friendly-korean.md
│       │   ├── concise.md
│       │   └── mentor.md
│       ├── skills/                     # 슬래시 커맨드
│       │   ├── set-style/SKILL.md
│       │   ├── show-config/SKILL.md
│       │   ├── set-message/SKILL.md
│       │   ├── apply-spinner/SKILL.md
│       │   └── status/SKILL.md
│       ├── hooks/                      # Hook 스크립트
│       │   ├── hooks.json
│       │   ├── session-start.sh
│       │   ├── prompt-submit.sh
│       │   ├── stop.sh
│       │   ├── pre-tool-use.sh
│       │   └── notification.sh
│       ├── scripts/                    # 유틸리티 스크립트
│       │   ├── statusline.sh
│       │   ├── read-config.sh
│       │   └── spinner-manage.sh
│       └── rules/CLAUDE.md            # 기본 행동 규칙
├── LICENSE
└── README.md
```

## 삭제 (Uninstall)

```
/plugin uninstall my-friends-claude@my-friends-claude
/plugin marketplace remove my-friends-claude
```

스피너 동사는 세션 시작 시 자동 적용, 세션 종료 시 자동 원복됩니다. 플러그인을 삭제하면 다음 세션부터 hooks가 실행되지 않으므로 모든 커스터마이즈가 자동으로 원래 상태로 돌아갑니다.

## 의존성 (Dependencies)

- `jq` (권장) — JSON 파싱. 없으면 `python3` fallback 사용
- `git` — 상태바에서 브랜치 표시용

## 라이선스 (License)

MIT License
