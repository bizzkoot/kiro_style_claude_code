# Kiroスタイル仕様駆動開発 for Claude Code

Claude CodeでKiroエディタのワークフローを再現するシンプルなシステムです。

## 🎯 概要

Kiroスタイルの仕様駆動開発は、3つのファイルを中心に開発を進める手法です：

1. **requirements.md** - 何を作るか（ユーザーストーリー）
2. **design.md** - どう作るか（技術設計）
3. **tasks.md** - 実装手順（タスク管理）

## 🚀 クイックスタート

### 1. プロジェクトの初期化

```bash
# 方法1: example-projectをコピー
cp -r example-project/ my-project/

# 方法2: 新規作成の場合
mkdir my-project
cd my-project
mkdir -p .claude/commands specs src
# 必要なファイルをコピー
cp path/to/example-project/.claude/CLAUDE.md .claude/
cp path/to/example-project/.claude/commands/* .claude/commands/
```

### 2. Claude Codeで開発開始

```bash
# Claude Codeを起動
claude-code .
```

### 3. 最初の機能を作成

```
# Claude Code内で実行
/init-spec TODOアプリの作成
```

## 📁 ディレクトリ構成

```
my-project/
├── .claude/
│   ├── CLAUDE.md          # プロジェクトルール
│   └── commands/
│       ├── init-spec.md   # 仕様初期化
│       └── sync-spec.md   # 仕様同期
├── specs/
│   ├── requirements.md    # 要件定義
│   ├── design.md          # 設計文書
│   └── tasks.md           # タスク一覧
└── src/                   # ソースコード
```

## 🔧 基本的な使い方

### 新機能の開発

1. **仕様を作成**
   ```
   /init-spec [機能名]
   ```

2. **要件をレビュー・承認**
   ```
   requirements.mdを承認します
   ```

3. **設計をレビュー・承認**
   ```
   design.mdを承認します
   ```

4. **タスクを実装**
   ```
   Task 1を実装してください
   ```

### 仕様の変更

```
# 仕様を変更後
/sync-spec
```

## 📝 仕様ファイルの役割

### requirements.md
- ユーザーストーリー形式
- 受け入れ基準を含む
- 非機能要件も記載

### design.md
- システムアーキテクチャ
- 技術スタック
- API設計
- データベーススキーマ

### tasks.md
- 実装タスク一覧
- チェックボックスで進捗管理
- 依存関係の明記

## 💡 ベストプラクティス

1. **仕様ファースト**
   - コードを書く前に仕様を確定

2. **段階的承認**
   - 要件→設計→実装の順で進む

3. **一貫性の維持**
   - 仕様変更時は`/sync-spec`で同期

4. **進捗の可視化**
   - tasks.mdで常に進捗を追跡

## 📚 関連ドキュメント

- [QUICKSTART.md](QUICKSTART.md) - 5分で始めるガイド
- [TUTORIAL.md](TUTORIAL.md) - 詳細なチュートリアル
- [project-structure.md](project-structure.md) - ディレクトリ構成の説明

## 🎉 メリット

- **明確な開発プロセス** - 次に何をするか常に明確
- **AIとの効率的な協業** - 構造化された仕様によりAIが理解しやすい
- **変更の追跡が容易** - 仕様の変更履歴が明確
- **チーム開発に適している** - 仕様が明確で認識を合わせやすい

## 🤝 コントリビューション

このシステムはオープンソースです。改善提案やバグ報告は歓迎します。

## 📝 ライセンス

MIT License
