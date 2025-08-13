# Kiro Style Specification-Driven Development Template

This project adopts Kiro-style specification-driven development.

## Specification Files

- **specs/requirements.md**: User stories and requirements
- **specs/design.md**: Technical architecture
- **specs/tasks.md**: Implementation tasks and progress

## Development Flow

1. Requirements Definition → Document in requirements.md
2. Design → Document in design.md
3. Task Division → Document in tasks.md
4. Implementation → Implement each task sequentially

## Commands

- `/kiro`: Initialize specifications for a new feature

## Development Rules

1. All features start with requirements definition
2. Proceed to design after approving requirements
3. Proceed to implementation after approving design
4. Tasks should be independently testable

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