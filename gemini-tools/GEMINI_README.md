# 🤖 Kiro Agent - Traceable Agentic Development (TAD)

> **Kiro** brings structure, traceability, and consistency to your development workflow by automating the creation of high-quality specification documents with EARS syntax through a simple Gemini CLI command.

## What is TAD?

**Traceable Agentic Development (TAD)** is a methodology where every piece of work is semantically linked to clear requirements and deliberate design decisions, creating a complete traceability chain from concept to implementation and completion using EARS (Easy Approach to Requirements Syntax).

## 🌟 Key Benefits

| Benefit | Description |
|---|---|
| 📝 **Automatic Documentation** | Generate comprehensive specs in seconds with EARS syntax and intelligent context awareness |
| 🔄 **Complete Traceability** | Every task links back to design and requirements with semantic connections |
| 🧠 **Context Preservation** | Reload complete feature context at any time with optimized token usage |
| 🔍 **Built-in Verification** | Validate traceability before coding begins with smart checks |
| 📊 **Progress Tracking** | Monitor task status and feature completion with EARS compliance |
| 📈 **Smart Completion** | Validate, measure, and archive completed features with quality metrics |

## 🚀 Getting Started

### Prerequisites

* **Google Gemini CLI**: Install and configure the Gemini CLI on your system
* **Unix-like Terminal**: Compatible with bash or zsh shells

### Option 1: 🌍 Global Installation (Recommended)

Install Kiro commands globally to use in any project with Gemini CLI:

```bash
# Clone the repository
git clone https://github.com/bizzkoot/kiro_style_claude_code.git
cd kiro_style_claude_code/gemini-tools

# Run global installation script
./gemini-install-global.sh

# Clean up
cd .. && rm -rf kiro_style_claude_code
```

**✨ Now use Kiro in any project with Gemini CLI:**
```bash
cd any-project/
gemini
/kiro-init  # Sets up Kiro workflow automatically
```

**🗑️ To uninstall globally:**
```bash
# Download and run uninstaller
curl -sSL https://raw.githubusercontent.com/bizzkoot/kiro_style_claude_code/main/gemini-tools/gemini-uninstall-global.sh | bash

# Or clone and run locally
git clone https://github.com/bizzkoot/kiro_style_claude_code.git
cd kiro_style_claude_code/gemini-tools
./gemini-uninstall-global.sh
cd .. && rm -rf kiro_style_claude_code
```

---

### Option 2: 📁 Per-Project Installation

Choose one of these methods for individual projects:

**Method A: Manual Installation**
```bash
# Create project commands directory
mkdir -p .gemini/commands/
mkdir -p .gemini/templates/

# Copy files to project directory (assuming you're in the gemini-tools directory)
cp kiro.toml .gemini/commands/
cp kiro-init.toml .gemini/commands/
cp kiro_template.md .gemini/templates/
```

**Method B: Clone and Copy**
```bash
# Clone the repository
git clone https://github.com/bizzkoot/kiro_style_claude_code.git

# Copy required files to your project directory
mkdir -p .gemini/commands .gemini/templates
cp kiro_style_claude_code/gemini-tools/kiro.toml .gemini/commands/
cp kiro_style_claude_code/gemini-tools/kiro-init.toml .gemini/commands/
cp kiro_style_claude_code/gemini-tools/kiro_template.md .gemini/templates/

# Clean up
rm -rf kiro_style_claude_code
```

## 💡 How to Use Kiro with Gemini CLI

Kiro operates as a simple command for the Gemini CLI using a TOML-based system prompt. No complex setup or servers required!

### 🚀 Initialize Gemini CLI (Per-Project Only)

For per-project installations, start with project setup:
```bash
# Start the Gemini CLI
gemini

# Initialize new project with Kiro workflow
/kiro-init
```

> **💡 Why this matters:** This copies the Kiro template to your project and sets up the directory structure for specification-driven development.

### Using the /kiro Command

After initialization, use the main `/kiro` command:
```bash
# Start the Gemini CLI (if not already running)
gemini

# Use the kiro command with your feature description
/kiro "User Authentication System with two-factor authentication"
```

### Command Examples

#### 1. Project Initialization (For New Projects)
Set up Kiro workflow in your project:
```
/kiro-init
```

#### 2. Creating a New Feature
Generate comprehensive specification documents with EARS syntax:
```
/kiro "User Authentication with Two-Factor Auth supporting SMS and authenticator apps"
```

#### 3. Resuming Work on a Feature
Continue work on an existing feature:
```
/kiro resume "User Authentication" 
```

#### 4. Complex Feature with Context
Provide detailed context for better specifications:
```
/kiro "Real-time Collaboration System with document editing, user presence, and conflict resolution"
```

## 📚 Advanced Usage Patterns

### Chain-of-Thought Reasoning for Complex Features
When describing complex features, provide structured context:
```
/kiro "Payment Processing System with the following considerations:
1. Core functionality: Stripe integration, multiple payment methods, subscription billing
2. User experience: One-click payments, saved payment methods, receipt management
3. Integration points: Connect to existing user accounts, notification service, accounting system
4. Technical constraints: PCI compliance, fraud detection, international currency support"
```

### EARS-Enhanced Specifications
The kiro command automatically generates specifications with EARS syntax:
- **WHEN** [trigger condition], the system **SHALL** [specific action]
- **WHILE** [ongoing state], the system **SHALL** [continuous behavior]  
- **IF** [conditional state], the system **SHALL** [conditional response]
- **WHERE** [constraint boundary], the system **SHALL** [bounded action]

### Resume Feature Context
To continue work on an existing feature:
```
/kiro resume "Feature Name"
```

## 📋 Command Reference

| Command | Purpose | Example |
|---|---|---|
| `/kiro-init` | Initialize new project with Kiro template | `/kiro-init` |
| `/kiro "Feature Name"` | Generate new feature specifications | `/kiro "User Dashboard"` |
| `/kiro resume "Feature Name"` | Resume work on existing feature | `/kiro resume "Payment System"` |
| Natural language follow-ups | Task updates, completion, etc. | "Mark task TASK-001 as completed" |

## 🗂️ Generated Documentation Structure

```
specs/
└── user-authentication-with-two-factor-auth/
    ├── requirements.md  # The WHY and WHAT with EARS syntax
    ├── design.md        # The HOW with EARS behavioral contracts
    └── tasks.md         # The execution plan with EARS DoD

specs/done/
└── DONE_20250818_a1b2c3d4_.../  # Archived completed features
    ├── requirements.md
    ├── design.md
    ├── tasks.md
    ├── validation.md
    ├── metrics.md
    └── retrospective.md
```

## 🔧 Development Workflow

### Phase 1: Specification Generation
1. Use `/kiro "Feature Name"` to generate all three specification documents
2. Review and approve requirements.md
3. Review and approve design.md  
4. Review and approve tasks.md

### Phase 2: Implementation
1. Follow the tasks in sequence from tasks.md
2. Update task status using natural language ("Mark TASK-001 as completed")
3. Verify implementation against EARS acceptance criteria

### Phase 3: Completion
1. Ensure all tasks are marked complete
2. Run quality validation against EARS requirements
3. Archive completed feature documentation

## 🎯 EARS Integration Benefits

- **Eliminates Ambiguity**: "WHEN user clicks login, system SHALL authenticate within 200ms" vs "fast login"
- **Direct Test Translation**: EARS → BDD (Given/When/Then) mapping for automated testing  
- **Behavioral Contracts**: Component interfaces specify exact behavioral expectations
- **Measurable Success**: Every requirement has specific triggers and measurable outcomes
- **Comprehensive Coverage**: Every acceptance criterion maps to testable conditions

## 🌟 Global Installation Benefits

**✨ Advantages of Global Installation:**
- 🚀 **Instant Access** - Use Kiro commands in any project without setup
- 🔄 **Consistent Experience** - Same workflow across all your projects  
- 🛠️ **Easy Management** - Single install/uninstall for all projects
- 💾 **No Duplication** - Saves disk space by avoiding file copies
- 🔧 **Easy Updates** - Update once, affects all projects
- 📋 **Template Reuse** - Shared templates across projects

**🎯 Perfect for:**
- Developers working on multiple projects
- Teams standardizing on Kiro methodology
- Quick prototyping and experimentation
- Maintaining consistency across codebases

## 📖 Additional Resources

- [kiro_template.md](./kiro_template.md) - Detailed template and examples for Gemini CLI
- [kiro.toml](./kiro.toml) - The main Kiro command specification file
- [kiro-init.toml](./kiro-init.toml) - Project initialization command file
- [gemini-install-global.sh](./gemini-install-global.sh) - Global installation script
- [gemini-uninstall-global.sh](./gemini-uninstall-global.sh) - Global uninstallation script

## 🤝 Contributing

To modify or extend the Gemini Kiro commands:
1. Edit the relevant `.toml` files (`kiro.toml`, `kiro-init.toml`)
2. Update the prompt sections with your improvements
3. Test your changes with per-project installation first
4. For global changes, update the installation scripts:
   - Modify `gemini-install-global.sh` for installation updates
   - Modify `gemini-uninstall-global.sh` for uninstallation updates
5. Reinstall using the appropriate method (global or per-project)