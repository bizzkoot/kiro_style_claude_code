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
<summary><b>Method 1:</b> Clone from GitHub (recommended)</summary>

```bash
# Clone the repository
git clone https://github.com/bizzkoot/kiro_style_claude_code.git

# Copy required files to your project directory
cp -r kiro_style_claude_code/example-project/.claude ./
cp kiro_style_claude_code/example-project/CLAUDE.md ./

# Optional: Copy example specifications for reference
# cp -r kiro_style_claude_code/example-project/specs/* ./specs/

# Clean up
rm -rf kiro_style_claude_code
```
</details>

<details>
<summary><b>Method 2:</b> Use as a template for a new project</summary>

```bash
# Clone the repository
git clone https://github.com/bizzkoot/kiro_style_claude_code.git

# Copy the entire example project as your starting point
cp -r kiro_style_claude_code/example-project/ my-new-project/
cd my-new-project/

# Clean up
rm -rf ../kiro_style_claude_code
```
</details>

### 2. Initialize Claude Code

```bash
# Start Claude Code
claude

# Initialize while preserving the existing CLAUDE.md content
/init "Please run initialization while preserving the existing CLAUDE.md content. Add project structure details without overwriting the Kiro workflow information."
```

This initialization step is important as it:
- Analyzes your project structure
- Enhances the provided CLAUDE.md with project-specific details without overwriting existing Kiro workflow instructions
- Creates a knowledge base that all future `/kiro` commands will use
- Avoids redundant project scanning on each command

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

Initial setup:
```
your-project-directory/
├── .claude/
│   └── commands/
│       └── kiro.md        # Specification initialization command with templates
└── CLAUDE.md              # Project rules
```

After running `/kiro Create TODO app`:
```
your-project-directory/
├── .claude/
│   └── commands/
│       └── kiro.md
├── CLAUDE.md
└── specs/                 # Created automatically
    └── create-todo-app/   # Feature-specific directory
        ├── requirements.md
        ├── design.md
        └── tasks.md
```

After feature completion and archiving:
```
your-project-directory/
├── .claude/
│   └── commands/
│       └── kiro.md
├── CLAUDE.md
├── specs/
└── specs/done/            # Archive directory
    └── create-todo-app/   # Archived feature
        ├── DONE_2025-08-15_requirements.md
        ├── DONE_2025-08-15_design.md
        └── DONE_2025-08-15_tasks.md
```

## 📝 License

MIT License

## 🙏 Acknowledgements

This project is based on the original work by [tomada1114](https://github.com/tomada1114/kiro_style_claude_code). We thank the original author for creating the Kiro Style Specification-Driven Development framework.
