# Enhanced Kiro: Subagent Integration System

<div align="center">
    <img src="../ICON.png" alt="Kiro Style TAD Framework Icon" width="150" height="150">
    <br><br>
    <h3>🤖 Enhanced Specification-Driven Development</h3>
    <p><em>A powerful system that enhances the <code>/kiro-implementer</code> with access to 295+ specialized subagents from the community, enabling intelligent task delegation while maintaining strict EARS compliance and preventing over-engineering.</em></p>
    
![Subagent Integration](https://img.shields.io/badge/Subagent-Integration-blueviolet)
![Dynamic Discovery](https://img.shields.io/badge/Dynamic-Discovery-informational)
![EARS Delegation](https://img.shields.io/badge/EARS-Delegation-brightgreen)
![Community Powered](https://img.shields.io/badge/Community-Powered-orange)
![MVP First](https://img.shields.io/badge/MVP-First-critical)

</div>

## 🙏 Special Thanks to @davepoon

This powerful enhancement is made possible by the incredible work of community hero **@davepoon**. Their brilliant `claude-code-subagents-collection` provides the vast library of specialized agents that power this system.

**Please support their invaluable contribution:**
- 🌟 **Star the repository**: [davepoon/claude-code-subagents-collection](https://github.com/davepoon/claude-code-subagents-collection)
- 🙏 Show appreciation for making enhanced AI development possible

---

## 🚀 Quick Start

Get up and running with enhanced subagent capabilities in under 5 minutes:

### 1. Clone the Repository
```bash
git clone https://github.com/your-repo/Enhanced-Kiro-Subagents.git
cd Enhanced-Kiro-Subagents
```

### 2. Run the Installation Script
```bash
./enhance-kiro-subagents.sh
```

### 3. Choose Installation Type
- **Option 1**: Global installation (`~/.claude/agents/`) - Available to all projects
- **Option 2**: Project installation (`./.claude/agents/`) - Current project only

### 4. Start Using Enhanced Features
```bash
/kiro-implementer feature-name
```

That's it! You now have access to 295+ specialized subagents with intelligent discovery, EARS-compliant delegation, and built-in optimization.

---

## 📋 Prerequisites

Before installation, ensure you have:

- **Claude Code**: The system requires Claude Code to be installed and configured
- **Bash**: Unix shell (macOS/Linux built-in, Windows WSL)
- **Git**: For repository cloning and subagent downloads
- **Network Access**: To download the subagent collection from GitHub
- **100MB+ Free Space**: For the subagent files and supporting assets

---

## 🎯 How It Works: 3.5-Phase Execution & Core Features

This installation transforms your `/kiro-implementer` with a powerful 3.5-phase workflow and new capabilities, all designed for performance, traceability, and efficiency.

### The 3.5-Phase Process

The enhanced implementer follows a structured process for robust, traceable, and optimized development.

<div align="center">

```mermaid
graph TD
    A["/kiro-implementer feature-name"] --> B{Phase 1: Dynamic Discovery}
    B --> C[Load 295+ agent capabilities from manifest]
    C --> E[Generate capabilities briefing & save state]
    
    E --> F{Phase 2: Strategic Planning}
    F --> G[Parse EARS requirements & assess optimization]
    G --> I[Match tasks to specialist agents with token budgets]
    I --> J[Generate tasks.md with assignments & metadata]
    
    J --> J2{Phase 2.5: Optimization Review}
    J2 --> J3[Validate MVP approach & complexity]
    J3 --> J4[User approval gate]

    J4 --> K{Phase 3: EARS-Compliant Implementation}
    K --> L[Delegate to @specialist-agent with EARS & optimization context]
    L --> N[Validate against behavioral contracts]
    N --> O[Integrate compliant code]
    
    style B fill:#e3f2fd,stroke:#1976d2,stroke-width:2px,color:#000000
    style F fill:#e8f5e8,stroke:#388e3c,stroke-width:2px,color:#000000
    style J2 fill:#fce4ec,stroke:#ad1457,stroke-width:2px,color:#000000
    style K fill:#fff3e0,stroke:#f57c00,stroke-width:2px,color:#000000
```

</div>

*   **Phase 1: Discovery**: Scans the `subagents-manifest.json` to identify all available subagents and their specializations (<200ms). This result is saved to a state file for quick resume.
*   **Phase 2: Planning**: Analyzes EARS requirements, performs an optimization assessment, estimates token budgets, and assigns the best agent for each job in `tasks.md`.
*   **Phase 2.5: Optimization Review (New)**: Validates that the proposed plan is not over-engineered and represents a Minimum Viable Product (MVP) approach. Requires user approval before proceeding.
*   **Phase 3: Implementation**: Executes tasks sequentially, delegating to the assigned subagents with full EARS and optimization context to ensure compliance and efficiency.

### Core Features

*   **295+ Specialized Subagents**: Access to the entire @davepoon subagent collection for any task.
*   **Built-in Optimization**: Includes rules and processes to prevent over-engineering, prioritize MVP solutions, and manage complexity with token budgets.
*   **EARS-Compliant Delegation**: Injects requirement traceability into every subagent action.
*   **Stateful Resume**: Seamlessly stop and continue your work. The system loads state from `.claude/state/implementer-state/[feature-name].json` to preserve context and agent assignments, skipping the discovery phase on resume.
*   **Enhanced Developer Experience**: Progress indicators, automatic configuration backups, and comprehensive error handling.

---

## 🎮 Usage & Command Workflow

The enhanced implementer introduces commands for managing the implementation lifecycle.

### Command Workflow

```bash
# 1. Start a new feature (discovers agents, creates tasks.md)
/kiro-implementer user-authentication start

# Work on a few tasks, then stop for the day...

# 2. Resume your work (loads state, continues from where you left off)
/kiro-implementer resume user-authentication

# 3. Continue to the next task after one is complete
/kiro-implementer user-authentication continue
```

### Generated `tasks.md` Example

The system analyzes your `requirements.md` and `design.md` to generate a `tasks.md` file like this:

```markdown
# Tasks: User Authentication - Enhanced Implementer

## Progress: 2/4 Complete, 1 In Progress, 1 Not Started

## Phase 1: Foundation Tasks
- [x] **TASK-001: Authentication Schema Design**
  - **Requirement**: REQ-AUTH-001 - User credential validation
  - **EARS AC**: WHEN user submits login, SHALL validate within 200ms
  - **Assigned**: @database-expert
  - **Complexity**: Simple (use existing user table + password hash)
  - **Token Budget**: ~200 tokens
  - **Dependencies**: None

## Phase 2: Implementation Tasks  
- [x] **TASK-002: API Endpoint Implementation**
  - **Requirement**: REQ-AUTH-002 - Login/logout endpoints
  - **EARS AC**: WHEN endpoint called, SHALL return JWT token
  - **Assigned**: @api-designer
  - **Complexity**: Simple
  - **Token Budget**: ~300 tokens
  - **Dependencies**: TASK-001

...
```

---

## 🔧 Installation Details

### What Gets Installed

Running `./enhance-kiro-subagents.sh` performs the following:

*   **Subagent Collection**: Downloads 295+ specialized `.md` subagent files to `~/.claude/agents/` or `./.claude/agents/`.
*   **Optimized Manifest**: Creates `subagents-manifest.json` for fast discovery.
*   **Enhanced Kiro Implementer**: Replaces the standard implementer with the enhanced 3.5-phase version.
*   **Support Files**: Installs required protocols and templates for delegation and discovery.
*   **Safety Backups**: Automatically backs up your existing `kiro-implementer.md` to your Desktop.

### Global vs Project Installation

*   **Global (`~/.claude/agents/`)**: Recommended for individual developers. Agents are available to all projects.
*   **Project (`./.claude/agents/`)**: Recommended for teams. Agents are isolated to the current project and can be version-controlled.

---

## 🔍 Verification & Troubleshooting

### Confirm Installation Success

1.  **Check Agents**: `ls ~/.claude/agents/ | wc -l` (should show 295+ files).
2.  **Verify Manifest**: `cat ~/.claude/agents/subagents-manifest.json | head -5`.
3.  **Test Implementer**: `/kiro-implementer --help` (should show 3.5-phase execution strategy).

### Common Issues

*   **"Permission denied"**: Make the script executable with `chmod +x enhance-kiro-subagents.sh`.
*   **"Git not found"**: Install git (`brew install git` or `apt-get install git`).
*   **"Network connection failed"**: Check your internet connection and firewall settings.
*   **Recovery**: Your original `kiro-implementer.md` is backed up to your Desktop if you need to restore it.

---

## 🚀 Next Steps & Community

1.  **Explore Available Agents**: Review the manifest or browse `~/.claude/agents/` to see all 295+ specialists.
2.  **Try the Enhanced Implementer**: Start with a simple feature to see the 3.5-phase process in action.
3.  **Join the Community**: This system is powered by @davepoon's subagent collection. Please support their work!
    -   ⭐ **Star the original repo**: [claude-code-subagents-collection](https://github.com/davepoon/claude-code-subagents-collection)
    -   🐛 Report issues and suggest improvements.