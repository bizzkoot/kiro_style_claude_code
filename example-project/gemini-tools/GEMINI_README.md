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

### Installation in 2 Simple Steps

1.  **Download the kiro.toml file**  
    Make sure you have the [kiro.toml](./kiro.toml) file from this repository.

2.  **Install the command**  
    Choose one of the following installation methods:

    **Global Installation (recommended):**
    ```bash
    # Copy to global Gemini commands directory
    cp kiro.toml ~/.gemini/commands/
    ```

    **Project-specific Installation:**
    ```bash
    # Create project commands directory
    mkdir -p .gemini/commands/
    
    # Copy to project directory
    cp kiro.toml .gemini/commands/
    ```

## 💡 How to Use Kiro with Gemini CLI

Kiro operates as a simple command for the Gemini CLI using a TOML-based system prompt. No complex setup or servers required!

### Using the /kiro Command

Start the Gemini CLI and use the `/kiro` command:
```bash
# Start the Gemini CLI
gemini

# Use the kiro command with your feature description
/kiro "User Authentication System with two-factor authentication"
```

### Command Examples

#### 1. Creating a New Feature
Generate comprehensive specification documents with EARS syntax:
```
/kiro "User Authentication with Two-Factor Auth supporting SMS and authenticator apps"
```

#### 2. Resuming Work on a Feature
Continue work on an existing feature:
```
/kiro resume "User Authentication" 
```

#### 3. Complex Feature with Context
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

## 📖 Additional Resources

- [kiro_template.md](./kiro_template.md) - Detailed template and examples
- [kiro.toml](./kiro.toml) - The command specification file

## 🤝 Contributing

To modify or extend the kiro command:
1. Edit the `kiro.toml` file
2. Update the prompt section with your improvements
3. Reinstall using the installation steps above