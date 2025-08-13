# TODO App Design Document

## Architecture Overview

Implemented as a Single Page Application (SPA). Runs entirely on the frontend with data stored in browser's local storage.

## Technology Stack

- **Language**: TypeScript 5.x
- **Framework**: React 18.x
- **Build Tool**: Vite 5.x
- **Styling**: CSS Modules
- **State Management**: React Context API + useReducer
- **Testing**: Vitest + React Testing Library
- **Linter**: ESLint + Prettier

## Component Structure

```
src/
├── components/
│   ├── App.tsx                 # Root component
│   ├── TodoInput.tsx           # Task input form
│   ├── TodoList.tsx            # Task list display
│   ├── TodoItem.tsx            # Individual task component
│   ├── TodoFilter.tsx          # Filter buttons
│   └── EditModal.tsx           # Edit modal (not needed for inline editing)
├── contexts/
│   └── TodoContext.tsx         # TODO state management
├── hooks/
│   ├── useTodos.ts             # Custom hook for TODO operations
│   └── useLocalStorage.ts      # Local storage synchronization hook
├── types/
│   └── todo.ts                 # Type definitions
└── utils/
    └── storage.ts              # Local storage operations

```

## Data Flow

1. **Task Creation**: TodoInput → useTodos → TodoContext → LocalStorage
2. **State Update**: TodoItem → useTodos → TodoContext → LocalStorage
3. **Filtering**: TodoFilter → TodoContext → TodoList (display update)
4. **Initialization**: App startup → LocalStorage → TodoContext → Components

## Type Definitions

```typescript
// types/todo.ts
interface Todo {
  id: string;           // UUID
  title: string;        // Task title
  completed: boolean;   // Completion status
  createdAt: Date;      // Creation date
  updatedAt: Date;      // Update date
}

type FilterType = 'all' | 'active' | 'completed';

interface TodoState {
  todos: Todo[];
  filter: FilterType;
}
```

## State Management Design

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

## Local Storage Design

- **Key**: `todo-app-data`
- **Format**: JSON string
- **Save Timing**: On all state changes
- **Error Handling**: Wrapped in try-catch, errors logged to console

## UI/UX Design

### Layout

```
┌─────────────────────────────────────┐
│          TODO App                   │
├─────────────────────────────────────┤
│  [          Input Field           ]  │
│  [Add]                              │
├─────────────────────────────────────┤
│  [All] [Active] [Completed]         │
├─────────────────────────────────────┤
│  □ Task 1               [Edit][Delete] │
│  ☑ Task 2               [Edit][Delete] │
│  □ Task 3               [Edit][Delete] │
└─────────────────────────────────────┘
```

### Styling Policy

- Mobile-first design
- Minimum width: 320px
- Maximum width: 800px (centered)
- Color palette:
  - Primary: #007bff
  - Completed: #6c757d
  - Delete: #dc3545
  - Background: #f8f9fa

## Performance Optimization

- Use React.memo to minimize component re-rendering
- Memoize event handlers with useCallback
- Consider virtual scrolling for large numbers of tasks (over 1000)

## Accessibility

- aria-label for all interactive elements
- Keyboard navigation support
- Focus management
- Screen reader support