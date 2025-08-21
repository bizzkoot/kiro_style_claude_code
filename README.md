# Kiro Style Specification-Driven Development for Claude Code

<div align="center">
    <img src="ICON.png" alt="Alt text" width="200" height="200">
    <p>A simple system that reproduces the Kiro editor workflow in Claude Code with Traceable Agentic Development (TAD) framework.</p>
</div>

## 🎯 Concept

Kiro-style specification-driven development is a methodology that advances development centered around three files with **semantic traceability** and **AI-powered validation**.

1. **requirements.md** - What to build (User Stories with semantic anchoring)
2. **design.md** - How to build it (Technical Design with ADRs)
3. **tasks.md** - Implementation steps (Task Management with bi-directional traceability)

### TAD Framework Benefits

- **Semantic Traceability** - AI understands requirement relationships contextually using UUID-based linking
- **Multi-Agent Validation** - Agents verify each other's work automatically with confidence scoring
- **Dynamic Risk Assessment** - Continuous monitoring and adjustment of risk factors
- **Self-Improving System** - Learning system that optimizes estimates and processes over time
- **Golden Thread Maintenance** - Requirements → Design → Implementation maintained by AI throughout lifecycle
- **Architectural Decision Records** - Captures not just what was decided, but why and what alternatives were considered
- **Resume Capability** - Seamlessly continue work on any feature while preserving full semantic context

## 🚀 How to Use

### Option 1: 🌍 Global Installation (Recommended)

Install Kiro commands globally to use in any project:

```bash
# Clone the repository
git clone https://github.com/bizzkoot/kiro_style_claude_code.git
cd kiro_style_claude_code

# Run global installation script
./install-global.sh

# Clean up
cd .. && rm -rf kiro_style_claude_code
```

**✨ Now use Kiro in any project:**
```bash
cd any-project/
claude
/kiro-init  # Sets up Kiro workflow automatically
```

**🗑️ To uninstall globally:**
```bash
# Download and run uninstaller
curl -sSL https://raw.githubusercontent.com/bizzkoot/kiro_style_claude_code/main/uninstall-global.sh | bash

# Or clone and run locally
git clone https://github.com/bizzkoot/kiro_style_claude_code.git
cd kiro_style_claude_code && ./uninstall-global.sh
cd .. && rm -rf kiro_style_claude_code
```

---

### Option 2: 📁 Per-Project Setup

Choose one of these methods for individual projects:

<details>
<summary><b>Method A:</b> Clone and copy files</summary>

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
<summary><b>Method B:</b> Use as a template for a new project</summary>

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

### 🚀 Initialize Claude Code (Per-Project Only)

```bash
# Start Claude Code
claude

# Initialize with Kiro workflow preservation
/init "Please run initialization while preserving the existing CLAUDE.md content. Add project structure details without overwriting the Kiro workflow information."
```

> **💡 Why this matters:** This creates a knowledge base that all `/kiro` commands will use, avoiding redundant project scanning and preserving your workflow setup.

---

## 🎯 Development Workflows

### Option A: 🚀 Full TAD Workflow (One-Command Complete)

<details>
<summary><b>Quick Start - Single Command</b></summary>

```bash
/kiro "Create TODO app"
```

**✨ Creates instantly:**
```
specs/create-todo-app/
├── requirements.md    # 📋 User stories + semantic anchoring + stakeholder analysis
├── design.md         # 🏗️ Technical architecture + ADRs + quality gates  
└── tasks.md          # ✅ Implementation checklist + bi-directional traceability
```

**Perfect for:** Simple features, prototyping, or when you want everything generated at once.

</details>

---

### Option B: 🎯 Specialized Agent Workflow (Recommended)

<details>
<summary><b>Step-by-Step Expert Analysis</b></summary>

#### 🔍 **Step 1: Requirements Research**
```bash
/kiro-researcher "Create TODO app"
```
**🎯 Focus:** Deep requirements analysis
- 👥 Stakeholder mapping & market research
- 🔗 Semantic anchoring with UUID-based linking  
- ⚠️ Edge case identification & business value scoring
- 📊 Risk factors & validation hooks

#### 🏗️ **Step 2: Technical Architecture**  
```bash
/kiro-architect "create-todo-app"
```
**🎯 Focus:** Optimal technical design
- 📝 Architectural Decision Records (ADRs) with rationale
- 🔧 Component design with explicit requirement mapping
- 🛡️ Security analysis & performance considerations
- 📈 Technical debt prevention strategies

#### ⚡ **Step 3: Implementation Planning**
```bash
/kiro-implementer "create-todo-app"
```
**🎯 Focus:** Detailed execution roadmap  
- 🔄 Bi-directional traceability to requirements & design
- 📊 Dependency mapping & critical path analysis
- 🧪 Testing strategies & complexity assessments
- ⚠️ Risk mitigation & implementation guidance

</details>

**🏆 Benefits of Specialized Agents:**
- 🎯 **Deep Expertise** - Each agent optimized for its domain
- 🧠 **Enhanced Context** - Better preservation of decision rationale  
- 🔗 **Semantic Continuity** - Maintains golden thread across phases
- ✅ **AI Validation** - Multi-agent verification & gap detection

---

## 🔄 Resume Development (Continue Where You Left Off)

<details>
<summary><b>Resume Any Feature Seamlessly</b></summary>

#### 🚀 **Resume Full Workflow**
```bash
/kiro resume "create-todo-app"
```
Reads **all three files** and reconstructs complete context.

#### 🎯 **Resume Specific Agents**
```bash
# Continue requirements work
/kiro-researcher resume "create-todo-app"

# Continue design work  
/kiro-architect resume "create-todo-app"

# Continue implementation planning
/kiro-implementer resume "create-todo-app"
```

**🎯 Resume Benefits:**
- 🧠 **Full Context** - AI knows WHY decisions were made, not just WHAT
- 🔗 **Semantic Continuity** - Preserves requirement relationships & rationale
- ⚠️ **Risk Awareness** - Maintains risk assessments & mitigation strategies  
- 📊 **Progress Tracking** - Continues from exact pause point

</details>

---

## 📋 Development Process

### ✅ **Review & Approve**
```bash
# Review each phase
"Approve requirements.md"    # ✅ Check stakeholder needs & confidence scores
"Approve design.md"         # ✅ Verify ADR rationale & traceability  
"Approve tasks.md"          # ✅ Confirm implementation plan
```

### 🛠️ **Implement Tasks**
```bash
# Start implementation
"Please implement Task 1"

# Follow the roadmap
"Proceed with development according to tasks.md"
```

### 🔄 **Handle Changes**
When requirements evolve, TAD framework automatically maintains traceability:

```bash
"Add user authentication functionality"
"Change database from PostgreSQL to MongoDB"  
"Remove the dark mode feature"
```

**🤖 Claude automatically:**
- ✅ Updates all related specification files
- 🔗 Maintains semantic traceability links  
- 📊 Recalculates confidence scores & risk assessments
- 📝 Preserves architectural decision rationale

---

## 🐛 Debugging & Issue Resolution

### 🔍 **Natural Language Debugging**
Initiate debugging through conversational interface:

```bash
"I'm seeing an error in the login endpoint"
"The application crashes when loading large files" 
"Why is the authentication failing?"
```

**🎯 TAD Debugging Features:**
- 🔍 **Context-Aware Analysis** - Examines related files and components automatically
- 🎯 **Root Cause Identification** - Systematic investigation with pattern recognition
- 🛡️ **Risk Assessment** - Evaluates potential impacts of proposed fixes
- ✅ **Structured Resolution** - Task-based approach with verification planning
- 📝 **Specification Updates** - Maintains traceability when debugging reveals requirement gaps

### 🗂️ **Debug Specifications**
Creates structured debug specs in `specs/debug-{issue-id}/`:
```
specs/debug-login-error/
├── requirements.md    # 📋 Issue definition + expected resolution
├── design.md         # 🔍 Root cause analysis + solution strategy  
└── tasks.md          # ✅ Investigation + resolution steps
```

### 🔄 **Integration with Development Workflow**
- **Researcher**: Escalates when issues reveal requirement gaps
- **Architect**: Consults when fixes require design changes  
- **Implementer**: Collaborates on significant implementation changes

## 📁 Project Structure

Initial setup with TAD framework:
```
your-project-directory/
├── .claude/
│   └── commands/
│       ├── kiro.md              # Full TAD workflow command
│       ├── kiro-researcher.md   # Requirements specialist with TAD
│       ├── kiro-architect.md    # Design specialist with ADRs
│       ├── kiro-implementer.md  # Implementation specialist with traceability
│       └── debugger.md          # Debugging workflow and issue resolution
└── CLAUDE.md                    # Project rules
```

After running `/kiro "Create TODO app"` with TAD:
```
your-project-directory/
├── .claude/
│   └── commands/
│       ├── kiro.md              # Full TAD workflow command
│       ├── kiro-researcher.md   # Requirements specialist with TAD
│       ├── kiro-architect.md    # Design specialist with ADRs
│       ├── kiro-implementer.md  # Implementation specialist with traceability
│       └── debugger.md          # Debugging workflow and issue resolution
├── CLAUDE.md
└── specs/                 # Created automatically
    └── create-todo-app/   # Feature-specific directory
        ├── requirements.md    # With semantic anchoring and UUIDs
        ├── design.md         # With ADRs and traceability matrix
        └── tasks.md          # With bi-directional requirement mapping
```

After feature completion and archiving:
```
your-project-directory/
├── .claude/
│   └── commands/
│       ├── kiro.md              # Full TAD workflow command
│       ├── kiro-researcher.md   # Requirements specialist with TAD
│       ├── kiro-architect.md    # Design specialist with ADRs
│       ├── kiro-implementer.md  # Implementation specialist with traceability
│       └── debugger.md          # Debugging workflow and issue resolution
├── CLAUDE.md
├── specs/
└── specs/done/            # Archive directory
    └── create-todo-app/   # Archived feature with semantic hash
        ├── DONE_2025-08-15_a1b2c3d4_requirements.md
        ├── DONE_2025-08-15_a1b2c3d4_design.md
        └── DONE_2025-08-15_a1b2c3d4_tasks.md
```

## 🔄 TAD Framework Features

### Semantic Traceability
- **UUID-based Linking** - Every requirement, design element, and task has semantic relationships
- **Intent Vectors** - AI-generated summaries that help agents understand contextual relationships
- **Confidence Scoring** - Quantified certainty levels for all decisions and estimates

### Multi-Agent Validation
- **Auto-Verification Loops** - Agents automatically check each other's work for gaps and inconsistencies
- **Gap Detection** - Proactive identification of missing coverage or orphaned elements
- **Quality Gates** - Measurable criteria that must be met before proceeding to next phase

### Dynamic Risk Assessment
- **Continuous Monitoring** - Risk factors are tracked and updated throughout development
- **Impact Analysis** - Understanding how changes affect the entire system
- **Mitigation Strategies** - Specific approaches for handling identified risks

### Self-Improving System
- **Pattern Recognition** - Learn from completed features to improve future estimations
- **Process Optimization** - Suggest improvements based on delivery metrics
- **Retrospective Intelligence** - Generate insights and lessons learned for knowledge base

## 📝 License

MIT License

## 🙏 Acknowledgements

This project is based on the original work by [tomada1114](https://github.com/tomada1114/kiro_style_claude_code). We thank the original author for creating the Kiro Style Specification-Driven Development framework.

The TAD (Traceable Agentic Development) enhancements incorporate cutting-edge agentic coding practices and requirements traceability methodologies to create an intelligent development orchestrator that maintains the "golden thread" between requirements, design, and implementation throughout the entire development lifecycle.
