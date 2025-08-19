# 🤖 Kiro Agent - Traceable Agentic Development (TAD)

> **Kiro** brings structure, traceability, and consistency to your development workflow by automating the creation of high-quality specification documents and managing the entire feature lifecycle through optimized Gemini CLI interactions.

## What is TAD?

**Traceable Agentic Development (TAD)** is a methodology where every piece of work is semantically linked to clear requirements and deliberate design decisions, creating a complete traceability chain from concept to implementation and completion.

## 🌟 Key Benefits

| Benefit | Description |
|---|---|
| 📝 **Automatic Documentation** | Generate comprehensive specs in seconds with intelligent context awareness |
| 🔄 **Complete Traceability** | Every task links back to design and requirements with semantic connections |
| 🧠 **Context Preservation** | Reload complete feature context at any time with optimized token usage |
| 🔍 **Built-in Verification** | Validate traceability before coding begins with smart checks |
| 📊 **Progress Tracking** | Monitor task status and feature completion with visual dashboards |
| 📈 **Smart Completion** | Validate, measure, and archive completed features with quality metrics |

## 🚀 Getting Started

### Prerequisites

* **Google Gemini CLI**: Kiro tools are designed specifically for the Gemini agent with optimized prompt structures.
* **uv**: The Python installer and virtual environment manager. Install with `pip install uv`.
* **Unix-like Terminal**: Compatible with bash or zsh shells.

### Installation in 3 Simple Steps

1.  **Download the required files**  
    Make sure you have the following files in your project folder:
    * [kiro_tool.py](./kiro_tool.py)
    * [setup_kiro.sh](./setup_kiro.sh)
    * [kiro_template.md](./kiro_template.md)

2.  **Make the setup script executable**
    ```bash
    chmod +x setup_kiro.sh
    ```

3.  **Run the installer in your project directory**
    ```bash
    ./setup_kiro.sh
    ```
    The script will set up a Python virtual environment and create a `kiro_server.py` file for you.

## 💡 How to Use Kiro Tools with Gemini CLI

Kiro operates as a set of tools for the Gemini CLI agent, exposed via an MCP server. You interact with it using natural language in a two-terminal setup, with optimized prompts that leverage Gemini's advanced reasoning capabilities.

### 1. Start the Kiro MCP Server
In your **first terminal**, start the server from your project directory:
```bash
# Activate the environment
source .venv/bin/activate

# Run the server
python kiro_server.py
```
Keep this terminal running.

### 2. Connect Gemini CLI
In a **new terminal**, connect the Gemini CLI to your server:
```bash
# Start the Gemini CLI
gemini

# Inside the CLI, connect to the server
/mcp connect http://127.0.0.1:8080/mcp/
```

### Interacting with Kiro Tools - Advanced Prompting Techniques

Once connected, you can use these optimized prompt structures to achieve better results from the Gemini agent. The agent will discover and call the correct functions from `kiro_tool.py`.

#### 1. Creating a New Feature with Context-Rich Prompts
To generate comprehensive specification documents with detailed context:
```
> Use the Kiro tools to generate specs for a 'User Authentication with Two-Factor Auth' feature. The system should support SMS and authenticator app verification, with fallback options for account recovery. Consider security best practices and potential integration with OAuth providers.
```

#### 2. Resuming Work with Semantic Memory Prompts
To reload the context of an existing feature with enhanced recall:
```
> Resume work on the 'User Authentication with Two-Factor Auth' feature using the Kiro context tool. Focus on the security implementation details and the user experience flow we previously defined.
```

#### 3. Updating Task Status with Specific Task Reasoning
To track progress by updating a task's status with reasoning:
```
> Use the Kiro tool to update the task 'TASK-abc123-001' in the 'User Authentication' feature to 'done'. We've implemented the SMS verification service with retry logic and proper error handling as specified in the requirements.
```
Supported statuses are `done`, `in-progress`, and `blocked`.

#### 4. Completing a Feature with Quality Assessment
When all tasks are done, run the smart completion process with quality verification:
```
> Run the Kiro smart completion process for the 'User Authentication' feature. Please verify that all acceptance criteria have been met and generate detailed metrics on code quality and test coverage.
```
This will validate, generate reports, and archive the feature documentation.

## 📚 Advanced Prompt Patterns for Kiro Tools

### Chain-of-Thought Reasoning for Complex Features
When describing complex features, use this pattern for better results:
```
> Generate Kiro specs for a "Real-time Collaboration System" with the following reasoning:
1. First, let's consider the core user requirements: [describe primary use cases]
2. Next, let's identify the technical challenges: [list major technical hurdles]
3. Now, let's define the necessary components: [outline main system components]
4. Finally, let's consider integration points: [describe how it connects to existing systems]
```

### Few-Shot Examples for Consistent Task Generation
For consistent task breakdowns, provide examples in your prompts:
```
> Generate tasks for the "Payment Processing" feature using this pattern:
Example task 1: "Implement Stripe API integration for payment processing"
- Small scope, clear acceptance criteria
- Single responsibility
- Testable independently

Example task 2: "Create payment confirmation UI with status indicators"
- Frontend-focused
- Clear user experience goal
- Visual acceptance criteria

Now, create tasks for our payment feature that follow this same pattern.
```

### System-Level Thinking for Architecture Design
For architectural decisions, prompt the system to consider broader impacts:
```
> Design the database schema for our "Customer Analytics Dashboard" feature. Consider:
- Current system data models and how they'll be extended
- Performance implications for reporting queries
- Data privacy considerations for different user roles
- Future extensibility for additional analytics metrics
```

## 📋 Command Reference (Advanced Prompt Examples)

| Action | Example Prompt | Tool Called | Optimization Technique |
|---|---|---|---|
| Generate new feature specs | `> Generate Kiro specs for "New Billing Dashboard" with focus on real-time payment processing, historical transaction viewing, and export capabilities. Consider integration with our existing payment providers and accounting system.` | `generate_feature_specs` | Context enrichment |
| Reload context | `> Resume work on the "New Billing Dashboard" feature, particularly focusing on the transaction history visualization component we were designing. Recall that we decided to use a paginated table with sortable columns and downloadable receipts.` | `resume_feature_context` | Memory priming |
| Update task progress | `> Update task TASK-xyz-002 "Implement transaction filter UI" in "New Billing Dashboard" to in-progress. We've started implementing the date range picker and payment status filters as specified in the design document.` | `update_task_status` | Detail amplification |
| Run smart completion | `> Complete the "New Billing Dashboard" feature with comprehensive validation. Verify that all export formats (PDF, CSV, JSON) work correctly and that the dashboard updates in real-time when new transactions occur.` | `complete_feature` | Quality specification |

## 🗂️ Generated Documentation Structure

```
specs/
└── user-authentication-with-two-factor-auth/
    ├── requirements.md  # The WHY and WHAT
    ├── design.md        # The HOW
    └── tasks.md         # The execution plan with progress tracking

specs/done/
└── DONE_20250818_a1b2c3d4_.../  # Archived completed features
    ├── requirements.md
    ├── design.md
    ├── tasks.md
    ├── validation.md
    ├── metrics.md
    └── retrospective.md
```

## 🔧 Optimizing Gemini CLI for Kiro Development

To maximize the effectiveness of Gemini CLI when working with Kiro tools:

### Custom System Instructions

Create a `.gemini/system.md` file in your project root with these specialized instructions:

```markdown
# Kiro TAD Development Assistant

You are an expert software development assistant specializing in:
- Traceable agentic development
- Technical specification creation
- Task breakdown and estimation
- Feature lifecycle management

When working with Kiro tools:
1. Consider the full project context before generating content
2. Create detailed, implementation-ready specifications
3. Break down tasks into independently testable units
4. Trace all design decisions back to specific requirements
5. Provide reasoning for architectural choices
6. Consider cross-cutting concerns like security and performance

Always respond with thoughtful, complete answers optimized for software development workflows.
```

### Effective Command Aliases

Set up these aliases for common Kiro workflows:

```bash
# Add to your .bashrc or .zshrc
alias kiro-new='gemini "Generate Kiro specs for a feature that"'
alias kiro-resume='gemini "Resume work on the feature using Kiro context tool"'
alias kiro-update='gemini "Update task status in Kiro for"'
alias kiro-complete='gemini "Run the Kiro smart completion process for"'
```

### Enhancing Gemini CLI's Context Window

For complex features, increase Gemini CLI's context window:

```bash
export GEMINI_CONTEXT_WINDOW=100000  # Adjust based on your needs
```

This allows Kiro to maintain more comprehensive context during development sessions.