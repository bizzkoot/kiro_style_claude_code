# Kiro Style Specification-Driven Development Template

This project adopts Kiro-style specification-driven development.

## Specification Files

- **specs/{feature-name}/requirements.md**: User stories and acceptance criteria
- **specs/{feature-name}/design.md**: Technical architecture and components
- **specs/{feature-name}/tasks.md**: Implementation tasks and progress tracking

## Development Flow

1. Requirements Definition → Document in requirements.md
2. Design → Document in design.md
3. Task Division → Document in tasks.md
4. Implementation → Implement each task sequentially
5. Verification → Test build and resolve any errors
6. Archival → Move completed features to specs/done/

## Commands

- `/kiro`: Initialize specifications for a new feature
- Ask "Approve requirements.md" to confirm requirements
- Ask "Approve design.md" to confirm design
- Ask "Please implement Task X" for implementation

## Development Rules

1. All features start with requirements definition
2. Proceed to design after approving requirements
3. Proceed to implementation after approving design
4. Tasks should be independently testable
5. Mark tasks as completed using `[x]` notation
6. All tasks must pass verification before archiving

## Task Completion

When a task is completed:
1. Update tasks.md by changing `[ ]` to `[x]`
2. Update the progress counter at the top of tasks.md
3. Proceed to the next task only after confirming current task works

## Agent Specialization

This project supports specialized agent roles for different phases of development:

### Agent Commands
- `/kiro [feature-name]` - Full workflow (all phases)
- `/kiro-researcher [feature-name]` - Requirements specialist
- `/kiro-architect [feature-name]` - Design specialist
- `/kiro-implementer [feature-name]` - Implementation specialist

### Agent Workflow
1. Start with `/kiro-researcher [feature-name]` to create requirements.md
2. After approval, continue with `/kiro-architect [feature-name]` to create design.md
3. After approval, finish with `/kiro-implementer [feature-name]` to create tasks.md and implement

### Benefits
- More thorough analysis at each phase
- Optimized context utilization
- Better preservation of implementation details
- Enhanced specialization for complex features

## Responding to Specification Changes

When specifications change, update all related specification files (requirements.md, design.md, tasks.md) while maintaining consistency.

Examples:
- "I want to add user authentication functionality"
- "I want to change the database from PostgreSQL to MongoDB"
- "The dark mode feature is no longer needed, please remove it"

When changes occur, take the following actions:

1. Add/modify/delete requirements in requirements.md
2. Update design.md to match the requirements
3. Adjust tasks.md based on the design
4. Verify consistency between all files
