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

The primary way to interact with the Kiro agent is through the `kiro` command in your terminal.

- `kiro "<feature name>"`: Initializes the specification-driven workflow for a new feature.
- `kiro resume "<feature name>"`: Resumes an in-progress feature development workflow.

During the workflow, the agent will prompt for approvals at key stages:
- **Approve requirements.md**: To confirm user stories and acceptance criteria.
- **Approve design.md**: To confirm the technical architecture and design.
- **Please implement Task X**: To proceed with individual implementation tasks.

## Development Rules

1. All features start with a requirements definition.
2. Proceed to design only after the requirements are approved.
3. Proceed to implementation only after the design is approved.
4. Tasks should be defined to be independently testable.
5. Mark tasks as completed in `tasks.md` using `[x]`.
6. All tasks must pass verification before the feature is archived.

## Task Completion

When a task is completed:
1. Update `tasks.md` by changing `[ ]` to `[x]` for the completed task.
2. Update the progress counter at the top of `tasks.md`.
3. Ensure the implementation for the current task is working before proceeding to the next one.

## Agent Workflow

The `kiro` command initiates a structured, multi-phase development process. While you interact with a single `kiro` command, the agent intelligently handles the different phases of development (requirements, design, implementation) behind the scenes.

1. **Start**: Run `kiro "<feature name>"` in your terminal.
2. **Requirements**: The agent will first act as a requirements specialist to create `requirements.md`.
3. **Design**: After the requirements are approved, the agent will take on the role of an architect to create `design.md`.
4. **Implementation**: Once the design is approved, the agent will function as an implementer, creating and executing tasks from `tasks.md`.

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