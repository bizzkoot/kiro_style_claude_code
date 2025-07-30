# Kiroスタイル仕様駆動開発 for Claude Code

Claude CodeでKiroエディタのワークフローを再現するシンプルなシステムです。

## 🎯 コンセプト

Kiroスタイルの仕様駆動開発は、3つのファイルを中心に開発を進める手法です：

1. **requirements.md** - 何を作るか（ユーザーストーリー）
2. **design.md** - どう作るか（技術設計）
3. **tasks.md** - 実装手順（タスク管理）

### メリット

- **明確な開発プロセス** - 次に何をするか常に明確
- **AIとの効率的な協業** - 構造化された仕様によりAIが理解しやすい
- **変更の追跡が容易** - 仕様の変更履歴が明確
- **チーム開発に適している** - 仕様が明確で認識を合わせやすい

## 🚀 使い方

### 1. プロジェクトの初期化

```bash
# 方法1: example-projectをコピー
cp -r example-project/ my-project/
cd my-project/

# 方法2: 既存プロジェクトに追加
cd your-existing-project/
cp -r path/to/example-project/.claude .
cp -r path/to/example-project/specs .
cp path/to/example-project/CLAUDE.md .
```

### 2. Claude Codeで開発開始

```bash
claude
```

### 3. 機能の開発フロー

#### 新機能の仕様を作成
```
/kiro TODOアプリの作成
```

これにより以下のファイルが生成されます：
- `specs/requirements.md` - ユーザーストーリー形式の要件定義
- `specs/design.md` - システムアーキテクチャと技術設計
- `specs/tasks.md` - 実装タスクとチェックリスト

#### 開発の進め方
```
# 1. 要件をレビュー・承認
requirements.mdを承認します

# 2. 設計をレビュー・承認
design.mdを承認します

# 3. タスクを順次実装
Task 1を実装してください
```

#### 仕様変更時の同期
```
# 仕様ファイルを編集後
/sync-spec
```

## 📁 プロジェクト構成

```
my-project/
├── .claude/
│   └── commands/
│       ├── kiro.md        # 仕様初期化コマンド
│       └── sync-spec.md   # 仕様同期コマンド
├── CLAUDE.md              # プロジェクトルール
└── specs/
    ├── requirements.md    # 要件定義
    ├── design.md          # 設計文書
    └── tasks.md           # タスク一覧
```

## 💡 よく使うコマンド

| コマンド | 説明 |
|---------|------|
| `/kiro [機能名]` | 新機能の仕様を生成 |
| `/sync-spec` | 仕様ファイルを同期 |
| `Task Xを実装` | 指定タスクを実装 |
| `進捗を確認` | tasks.mdの状態を表示 |

## 🔄 開発ワークフロー

```mermaid
graph LR
    A[要件定義] --> B[設計]
    B --> C[タスク分割]
    C --> D[実装]
    D --> E[テスト]
```

## 📝 ライセンス

MIT License