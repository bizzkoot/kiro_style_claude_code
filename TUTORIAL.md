# Kiroスタイル仕様駆動開発チュートリアル

## ステップ1: プロジェクトのセットアップ

```bash
# example-projectをコピー
cp -r example-project/ my-project/
cd my-project/
```

## ステップ2: Claude Codeで開発開始

```bash
claude
```

## ステップ3: 機能の開発

### 3.1 仕様を作成

```
/kiro TODOアプリケーション
```

生成されるファイル：
- `specs/requirements.md` - ユーザーストーリー
- `specs/design.md` - 技術設計
- `specs/tasks.md` - 実装タスク

### 3.2 要件を承認

```
requirements.mdを承認します
```

### 3.3 設計を承認

```
design.mdを承認します
```

### 3.4 タスクを実装

```
Task 1を実装してください
```

## ステップ4: 仕様の変更

要件を変更した場合は、仕様を同期します：

```
/sync-spec
```

## 利用可能なコマンド

- `/kiro [機能名]` - 新機能の仕様を作成
- `/sync-spec` - 仕様ファイルを同期
- `/show-example` - kiroの出力例を表示

## 開発フロー

1. **要件定義** → requirements.mdを作成・承認
2. **設計** → design.mdを作成・承認
3. **実装** → tasks.mdのタスクを順次実装
4. **同期** → 仕様変更時は/sync-specで整合性を保つ
