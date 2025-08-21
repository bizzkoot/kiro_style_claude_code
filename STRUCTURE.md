# Project Structure

This repository contains the Kiro Style Specification-Driven Development framework for Claude Code.

## 📁 Directory Structure

```
kiro_style_claude_code/
├── README.md                    # Main documentation
├── STRUCTURE.md                 # This file - project structure overview
├── install-global.sh            # Global installation script
├── uninstall-global.sh          # Global uninstaller script
│
├── example-project/             # Template project for per-project setup
│   ├── .claude/
│   │   └── commands/
│   │       ├── kiro.md              # Full TAD workflow command
│   │       ├── kiro-researcher.md   # Requirements specialist
│   │       ├── kiro-architect.md    # Design specialist  
│   │       ├── kiro-implementer.md  # Implementation specialist
│   │       └── debugger.md          # Debugging workflow
│   ├── CLAUDE.md                # Project template with Kiro rules
│   └── specs/                   # Example specifications directory
│       └── example-todo-app/    # Sample feature specifications
│           ├── requirements.md  # Example requirements with TAD
│           ├── design.md       # Example design with ADRs
│           └── tasks.md        # Example tasks with traceability
│
└── global/                      # Files for global installation
    ├── commands/
    │   └── kiro-init.md        # Global initialization command
    └── templates/
        └── kiro-template.md    # CLAUDE.md template for new projects
```

## 🚀 Installation Methods

### Global Installation (Recommended)
Installs Kiro commands globally for use in any project:
- Copies all commands to `~/.claude/commands/`
- Installs CLAUDE.md template to `~/.claude/templates/`
- Provides `/kiro-init` command for easy project setup

### Per-Project Installation  
Sets up Kiro workflow in individual projects:
- Copies `.claude/commands/` to project directory
- Copies `CLAUDE.md` to project root
- Manual initialization required

## 🎯 Key Features

- **Traceable Agentic Development (TAD)** framework
- **Semantic traceability** with UUID-based linking
- **Multi-agent validation** with confidence scoring
- **Dynamic risk assessment** and mitigation
- **Self-improving system** with pattern recognition
- **Resume capability** for seamless continuation
- **Structured debugging** with specification-driven approach

## 📝 Usage After Installation

### Global Installation Users:
```bash
cd any-project/
claude
/kiro-init                    # Auto-setup Kiro workflow
/kiro "create todo app"       # Start development
```

### Per-Project Users:
```bash
cd project-with-kiro/
claude
/init "preserve CLAUDE.md"    # Manual initialization
/kiro "create todo app"       # Start development
```