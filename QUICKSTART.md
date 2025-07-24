# Kiroスタイル開発 - クイックスタートガイド

## 🎯 5分で始める

### 1. プロジェクト作成
```bash
# example-projectをコピー
cp -r example-project/ todo-app/
cd todo-app/
```

### 2. Claude Codeで開発開始
```bash
claude
```

### 3. TODOアプリの仕様を生成
```
/init-spec TODOアプリの作成
```

これだけでClaudeが以下を生成します：
- 📄 specs/requirements.md (ユーザーストーリー)
- 📄 specs/design.md (技術設計)
- 📄 specs/tasks.md (実装タスク)

### 4. 開発を進める
```
# 要件を確認後
requirements.mdを承認します

# 設計を確認後
design.mdを承認します

# 実装開始
Task 1を実装してください
```

## 💡 よく使うコマンド

| コマンド | 説明 |
|---------|------|
| `/init-spec [機能名]` | 新機能の仕様を生成 |
| `/sync-spec` | 仕様ファイルを同期 |
| `Task Xを実装` | 指定タスクを実装 |
| `進捗を確認` | tasks.mdの状態を表示 |

## 🔄 ワークフロー

```mermaid
graph LR
    A[要件定義] --> B[設計]
    B --> C[タスク分割]
    C --> D[実装]
    D --> E[テスト]
```

## 🌟 ヒント

- **仕様変更時**: `/sync-spec`で一貫性を保つ
- **作業再開時**: `現在の進捗を教えて`で状態確認
- **レビュー時**: 各フェーズで明示的に承認

詳細は[TUTORIAL.md](TUTORIAL.md)を参照してください。
