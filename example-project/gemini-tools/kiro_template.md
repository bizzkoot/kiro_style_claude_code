# Kiro Style Specification-Driven Development Template

This project adopts Kiro-style specification-driven development, using a set of tools optimized for the Gemini agent with advanced prompt engineering techniques.

## Specification Files

- **specs/{feature-name}/requirements.md**: User stories and acceptance criteria (the WHY and WHAT)
- **specs/{feature-name}/design.md**: Technical architecture and components (the HOW)
- **specs/{feature-name}/tasks.md**: Implementation tasks and progress tracking (the EXECUTION PLAN)

## Development Flow

1.  **Requirements Definition** → Document in `requirements.md`
2.  **Design** → Document in `design.md`
3.  **Task Division** → Document in `tasks.md`
4.  **Implementation** → Implement each task sequentially
5.  **Verification** → Test build and resolve any errors
6.  **Archival** → Move completed features to `specs/done/`

## Interacting with Kiro Tools Using Advanced Prompts

The primary way to interact with the Kiro workflow is by giving **semantically rich natural language commands** to the Gemini agent. The agent will automatically select and run the appropriate Kiro tool to perform the action.

### Optimized Prompt Patterns

Use these structured prompt patterns for better results:

#### 1. Feature Generation Prompts

**Basic Structure:**
```
Generate Kiro specs for a '[Feature Name]' that [detailed description of purpose and functionality].
```

**Enhanced Structure:**
```
Generate Kiro specs for a '[Feature Name]' with these considerations:
1. Core functionality: [describe primary capabilities]
2. User experience: [describe key user interactions]
3. Integration points: [describe connections to other systems]
4. Technical constraints: [describe any limitations or requirements]
```

**Example:**
```
Generate Kiro specs for a 'User Profile Management System' with these considerations:
1. Core functionality: Store and retrieve user profile data including contact information, preferences, and account settings
2. User experience: Allow users to view and edit their profile through an intuitive interface with real-time validation
3. Integration points: Connect to authentication system, notification service, and storage backends
4. Technical constraints: Must comply with GDPR data protection requirements and support both web and mobile interfaces
```

#### 2. Context Resume Prompts

**Basic Structure:**
```
Resume work on the '[Feature Name]' feature.
```

**Enhanced Structure:**
```
Resume work on the '[Feature Name]' feature with focus on:
- Current implementation status
- [Specific aspect] considerations
- Next development priorities
```

**Example:**
```
Resume work on the 'User Profile Management System' feature with focus on:
- Current implementation status of the edit profile functionality
- Security considerations for personal data protection
- Next development priorities for admin management capabilities
```

#### 3. Task Update Prompts

**Basic Structure:**
```
Update task [TASK-ID] to '[status]'.
```

**Enhanced Structure:**
```
Update task [TASK-ID] to '[status]' because [reasoning]:
- [Implementation details or blockers]
- [Quality considerations]
- [Next steps]
```

**Example:**
```
Update task TASK-abc123-002 to 'in-progress' because we've started implementation:
- Database schema has been defined and migrations created
- Validation rules have been established following security review
- Next steps include implementing the data access layer and REST endpoints
```

#### 4. Feature Completion Prompts

**Basic Structure:**
```
Complete the '[Feature Name]' feature.
```

**Enhanced Structure:**
```
Complete the '[Feature Name]' feature with quality focus on:
- [Primary quality concern]
- [Secondary quality concern]
- [Specific verification requirements]
```

**Example:**
```
Complete the 'User Profile Management System' feature with quality focus on:
- Security and data protection compliance
- Performance under high-load conditions
- Comprehensive validation of all acceptance criteria defined in requirements
```

## Agent Workflow

The Gemini agent uses the Kiro tools to manage the development lifecycle with enhanced reasoning capabilities. The agent intelligently handles the different phases (requirements, design, implementation) based on your natural language requests.

1.  **Start**: Ask the agent to generate specs for a new feature using the enhanced prompt patterns.
2.  **Requirements**: The agent will use the `generate_feature_specs` tool to create `requirements.md` with semantic traceability.
3.  **Design**: The agent will continue the plan to create `design.md` with explicit reasoning for architectural decisions.
4.  **Implementation**: Finally, the agent will create `tasks.md`, providing a clear plan for development with dependency tracking.

### Advanced Workflow Capabilities

The enhanced Kiro tools now support:

- **Feature Roadmapping**: Generate multi-feature roadmaps with dependencies and timeline visualizations
- **Implementation Options Analysis**: Evaluate different approaches with weighted decision matrices
- **Integration Test Planning**: Create comprehensive test plans derived from requirements
- **Cross-Feature Dependencies**: Track and manage dependencies between features

### Benefits of this Approach

- **Explicit Reasoning**: All decisions include clear rationales that trace to requirements
- **Semantic Traceability**: Every element connects meaningfully to other documentation
- **Context Preservation**: Long-term memory of feature details across development sessions
- **Quality Enforcement**: Built-in quality checks and validation at every phase
- **Token Efficiency**: Optimized prompts that balance detail with token usage

## Development Rules

1.  All features start with a comprehensive requirements definition.
2.  Proceed to design only after the requirements are approved.
3.  Proceed to implementation only after the design is approved.
4.  Tasks should be defined to be independently testable.
5.  Use structured natural language to ask the agent to update task statuses (e.g., 'done', 'in-progress').
6.  All tasks must be complete before asking the agent to run the completion process.

## Responding to Specification Changes

When specifications change, update all related specification files (`requirements.md`, `design.md`, `tasks.md`) while maintaining semantic consistency.

### Change Request Prompt Pattern

```
I need to change the '[Feature Name]' feature to [description of change]. Please:
1. Analyze the impact across requirements, design, and tasks
2. Update all affected documentation with traceability
3. Provide a summary of changes and rationale
```

**Examples:**
```
I need to change the 'User Authentication' feature to add social login options. Please:
1. Analyze the impact across requirements, design, and tasks
2. Update all affected documentation with traceability
3. Provide a summary of changes and rationale
```

```
I need to change the database from PostgreSQL to MongoDB in the 'Data Storage' feature. Please:
1. Analyze the impact across requirements, design, and tasks
2. Update all affected documentation with traceability
3. Provide a summary of changes and rationale
```

When changes occur, the agent will take the following actions:

1.  Add/modify/delete requirements in `requirements.md`
2.  Update `design.md` to match the requirements with explicit reasoning for changes
3.  Adjust `tasks.md` based on the design, updating status and dependencies
4.  Verify semantic consistency between all files
5.  Provide a complete change impact analysis

## Advanced Gemini CLI Integration

For optimal results with the Gemini CLI, consider these additional configurations:

### Custom System Instructions

Create a `.gemini/system.md` file in your project with specialized Kiro instructions:

```markdown
# Kiro Development Assistant

You are an expert in Traceable Agentic Development (TAD) using the Kiro methodology.

When working with specifications:
- Maintain complete traceability between requirements, design, and tasks
- Provide explicit reasoning for all design decisions
- Structure tasks for independent testing and verification
- Consider security, performance, and maintainability in all designs
- Generate comprehensive documentation with semantic connections

Use chain-of-thought reasoning in all responses to produce higher quality results.
```

### Enhanced Workflow Commands

Create command aliases for advanced Kiro operations:

```bash
# Add to your .bashrc or .zshrc
alias kiro-roadmap='gemini "Generate a feature roadmap using Kiro tools for the following features:"'
alias kiro-options='gemini "Analyze implementation options using Kiro tools for the feature:"'
alias kiro-test-plan='gemini "Generate an integration test plan using Kiro tools for the feature:"'
```

These configurations will help you get the most out of the Gemini agent's capabilities when working with Kiro tools.