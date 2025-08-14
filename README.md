# Kiro Style Specification-Driven Development for Claude Code

A simple system that reproduces the Kiro editor workflow in Claude Code.

## 🎯 Concept

Kiro-style specification-driven development is a methodology that advances development centered around three files.

1. **requirements.md** - What to build (User Stories)
2. **design.md** - How to build it (Technical Design)
3. **tasks.md** - Implementation steps (Task Management)

### Benefits

- **Clear Development Process** - Always clear what to do next
- **Efficient Collaboration with AI** - AI can easily understand structured specifications
- **Easy Change Tracking** - Clear specification change history
- **Suitable for Team Development** - Clear specifications make it easy to align understanding

## 🚀 How to Use

### 1. Project Initialization

Choose one of these methods to set up your project:

<details>
<summary><b>Method 1:</b> Copy example project (quickest)</summary>

```bash
cp -r example-project/ my-project/
cd my-project/
```
</details>

<details>
<summary><b>Method 2:</b> Add to an existing project</summary>

```bash
cd your-existing-project/
cp -r path/to/example-project/.claude .
cp -r path/to/example-project/specs .
cp path/to/example-project/CLAUDE.md .
```
</details>

<details>
<summary><b>Method 3:</b> Download directly from GitHub</summary>

```bash
# Using curl
curl -LO https://github.com/bizzkoot/kiro_style_claude_code/archive/refs/heads/main.zip
unzip main.zip

# Copy required files to your project directory
cp -r kiro_style_claude_code-main/example-project/.claude ./
cp -r kiro_style_claude_code-main/example-project/specs ./
cp kiro_style_claude_code-main/example-project/CLAUDE.md ./

# Clean up
rm -rf kiro_style_claude_code-main main.zip
```
</details>

### 2. Start Claude Code

```bash
claude
```

### 3. Development Workflow

#### Step 1: Create Feature Specifications

```
/kiro Create TODO app
```

This creates a new directory for the feature specifications:
- `specs/create-todo-app/requirements.md` - User stories and acceptance criteria
- `specs/create-todo-app/design.md` - Technical architecture and components
- `specs/create-todo-app/tasks.md` - Implementation checklist

#### Step 2: Review and Refine Specifications

```
# Review requirements first
Approve requirements.md

# Then review design
Approve design.md
```

#### Step 3: Implement Tasks

```
# Either implement a specific task
Please implement Task 1

# Or proceed with the development plan
Proceed with development according to the tasks.md
```

#### Step 4: Handle Specification Changes

When requirements change, clearly communicate the changes to Claude Code:

```
"I want to add user authentication functionality"
"I want to change the database from PostgreSQL to MongoDB"
"The dark mode feature is no longer needed, please remove it"
```

Claude will update all related specification files while maintaining consistency.

## 📁 Project Structure

```
your-project-directory/
├── .claude/
│   └── commands/
│       └── kiro.md        # Specification initialization command
├── CLAUDE.md              # Project rules
├── specs/
│   └── create-todo-app/   # Each feature gets its own directory
│       ├── requirements.md
│       ├── design.md
│       └── tasks.md
└── specs-todoapp-example  # Reference example (can be deleted)
```

## 📝 License

MIT License

## 🙏 Acknowledgements

This project is based on the original work by [tomada1114](https://github.com/tomada1114/kiro_style_claude_code). We thank the original author for creating the Kiro Style Specification-Driven Development framework.
