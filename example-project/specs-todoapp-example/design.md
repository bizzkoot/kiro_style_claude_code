# TODOアプリ設計文書

## アーキテクチャ概要

シングルページアプリケーション（SPA）として実装。フロントエンドのみで完結し、データはブラウザのローカルストレージに保存する。

## 技術スタック

- **言語**: TypeScript 5.x
- **フレームワーク**: React 18.x
- **ビルドツール**: Vite 5.x
- **スタイリング**: CSS Modules
- **状態管理**: React Context API + useReducer
- **テスト**: Vitest + React Testing Library
- **リンター**: ESLint + Prettier

## コンポーネント構成

```
src/
├── components/
│   ├── App.tsx                 # ルートコンポーネント
│   ├── TodoInput.tsx           # タスク入力フォーム
│   ├── TodoList.tsx            # タスク一覧表示
│   ├── TodoItem.tsx            # 個別タスクコンポーネント
│   ├── TodoFilter.tsx          # フィルターボタン
│   └── EditModal.tsx           # 編集用モーダル（インライン編集の場合は不要）
├── contexts/
│   └── TodoContext.tsx         # TODOの状態管理
├── hooks/
│   ├── useTodos.ts             # TODO操作のカスタムフック
│   └── useLocalStorage.ts      # ローカルストレージ同期フック
├── types/
│   └── todo.ts                 # 型定義
└── utils/
    └── storage.ts              # ローカルストレージ操作

```

## データフロー

1. **タスク作成**: TodoInput → useTodos → TodoContext → LocalStorage
2. **状態更新**: TodoItem → useTodos → TodoContext → LocalStorage
3. **フィルタリング**: TodoFilter → TodoContext → TodoList（表示の更新）
4. **初期化**: App起動時 → LocalStorage → TodoContext → 各コンポーネント

## 型定義

```typescript
// types/todo.ts
interface Todo {
  id: string;           // UUID
  title: string;        // タスクのタイトル
  completed: boolean;   // 完了状態
  createdAt: Date;      // 作成日時
  updatedAt: Date;      // 更新日時
}

type FilterType = 'all' | 'active' | 'completed';

interface TodoState {
  todos: Todo[];
  filter: FilterType;
}
```

## 状態管理設計

### TodoContext

```typescript
interface TodoContextValue {
  todos: Todo[];
  filter: FilterType;
  addTodo: (title: string) => void;
  updateTodo: (id: string, title: string) => void;
  toggleTodo: (id: string) => void;
  deleteTodo: (id: string) => void;
  setFilter: (filter: FilterType) => void;
}
```

### Reducer Actions

```typescript
type TodoAction =
  | { type: 'ADD_TODO'; payload: { title: string } }
  | { type: 'UPDATE_TODO'; payload: { id: string; title: string } }
  | { type: 'TOGGLE_TODO'; payload: { id: string } }
  | { type: 'DELETE_TODO'; payload: { id: string } }
  | { type: 'SET_FILTER'; payload: { filter: FilterType } }
  | { type: 'LOAD_TODOS'; payload: { todos: Todo[] } };
```

## ローカルストレージ設計

- **キー**: `todo-app-data`
- **形式**: JSON文字列
- **保存タイミング**: 全ての状態変更時
- **エラーハンドリング**: try-catchで包み、エラー時はコンソールに出力

## UI/UX設計

### レイアウト

```
┌─────────────────────────────────────┐
│          TODOアプリ                  │
├─────────────────────────────────────┤
│  [          入力フィールド        ]  │
│  [追加]                             │
├─────────────────────────────────────┤
│  [すべて] [未完了] [完了済み]       │
├─────────────────────────────────────┤
│  □ タスク1              [編集][削除] │
│  ☑ タスク2              [編集][削除] │
│  □ タスク3              [編集][削除] │
└─────────────────────────────────────┘
```

### スタイリング方針

- モバイルファースト設計
- 最小幅: 320px
- 最大幅: 800px（中央寄せ）
- カラーパレット:
  - プライマリ: #007bff
  - 完了: #6c757d
  - 削除: #dc3545
  - 背景: #f8f9fa

## パフォーマンス最適化

- React.memoを使用してコンポーネントの再レンダリングを最小化
- useCallbackでイベントハンドラをメモ化
- 大量のタスクに対応するため、仮想スクロールの実装を検討（1000件以上の場合）

## アクセシビリティ

- すべてのインタラクティブ要素にaria-label
- キーボードナビゲーション対応
- フォーカス管理
- スクリーンリーダー対応
