# Kiroスタイルプロジェクト構成

```
my-project/
├── .claude/
│   ├── CLAUDE.md          # プロジェクトのコンテキストと開発ルール
│   └── commands/
│       ├── init-spec.md   # 仕様初期化コマンド
│       └── sync-spec.md   # 仕様同期コマンド
├── specs/
│   ├── requirements.md    # 要件定義（何を作るか）
│   ├── design.md          # 設計文書（どう作るか）
│   └── tasks.md           # タスク一覧（実装手順）
└── src/                   # 実際のソースコード
```

## 各ファイルの役割

### .claude/CLAUDE.md
- プロジェクトの“憲法”
- 開発プロセスの定義
- 使用可能なコマンドの説明

### specs/ディレクトリ
- **requirements.md**: ユーザーストーリーと要件
- **design.md**: 技術アーキテクチャ
- **tasks.md**: 実装タスクと進捗

### .claude/commands/
- カスタムコマンドでワークフローを自動化
