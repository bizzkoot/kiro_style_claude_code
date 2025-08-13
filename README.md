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

```bash
# Method 1: Copy example-project
cp -r example-project/ my-project/
cd my-project/

# Method 2: Add to existing project
cd your-existing-project/
cp -r path/to/example-project/.claude .
cp -r path/to/example-project/specs .
cp path/to/example-project/CLAUDE.md .

# Method 3: Direct download from GitHub
mkdir my-project
cd my-project/
# Using curl (more common on macOS and many Linux distributions)
curl -LO https://github.com/bizzkoot/kiro_style_claude_code/archive/refs/heads/main.zip
# Extract using unzip (common on most systems)
unzip main.zip
# Alternative extraction using tar (if unzip is not available)
# tar -xf main.zip
mv kiro_style_claude_code-main/.claude .
mv kiro_style_claude_code-main/specs .
mv kiro_style_claude_code-main/CLAUDE.md .
rm -rf kiro_style_claude_code-main main.zip

# Alternative using wget (if curl is not available)
# wget https://github.com/bizzkoot/kiro_style_claude_code/archive/refs/heads/main.zip
```

### 2. Start Development with Claude Code

```bash
claude
```

### 3. Feature Development Flow

#### Create Specifications for New Features

```
/kiro Create TODO app
```

This will generate (update) the following files.

- `specs/requirements.md` - Requirements definition in user story format
- `specs/design.md` - System architecture and technical design
- `specs/tasks.md` - Implementation tasks and checklist

#### How to Proceed with Development

```
# 1. Review and approve requirements
Approve requirements.md

# 2. Review and approve design
Approve design.md

# 3. Implement tasks sequentially
Please implement Task 1
  or
Proceed with development according to specs/tasks.md
```

#### Responding to Specification Changes

When there are changes to specifications, please communicate the changes to Claude Code.
Update all related specification files (requirements.md, design.md, tasks.md) while maintaining consistency.

Examples:

```
"I want to add user authentication functionality"
"I want to change the database from PostgreSQL to MongoDB"
"The dark mode feature is no longer needed, please remove it"
```

## 📁 Project Structure

```
my-project/
├── .claude/
│   └── commands/
│       └── kiro.md        # Specification initialization command
├── CLAUDE.md              # Project rules
├── specs/
│   ├── requirements.md    # Requirements definition
│   ├── design.md          # Design document
│   └── tasks.md           # Task list
└── specs-todoapp-example  # Specification file example (reference only, can be deleted)
```

## 📝 License

MIT License

## 🙏 Acknowledgements

This project is based on the original work by [tomada1114](https://github.com/tomada1114/kiro_style_claude_code). We thank the original author for creating the Kiro Style Specification-Driven Development framework.