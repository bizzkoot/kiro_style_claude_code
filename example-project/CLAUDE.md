# Kiro Style Specification-Driven Development Template

This project adopts Kiro-style specification-driven development with EARS (Easy Approach to Requirements Syntax) hybrid implementation for enhanced precision and testability.

## Specification Files

- **specs/{feature-name}/requirements.md**: User stories with EARS acceptance criteria (WHEN/WHILE/IF/WHERE + SHALL)
- **specs/{feature-name}/design.md**: Technical architecture with EARS behavioral contracts
- **specs/{feature-name}/tasks.md**: Implementation tasks with EARS Definition of Done (DoD)
- **specs/debug-{issue-id}/requirements.md**: Issue definition with EARS expected resolution criteria
- **specs/debug-{issue-id}/design.md**: Debug strategy with EARS-compliant solution specifications
- **specs/debug-{issue-id}/tasks.md**: Investigation steps with EARS validation checkpoints

## Development Flow

1. Requirements Definition → Document in requirements.md
2. Design → Document in design.md
3. Task Division → Document in tasks.md
4. Implementation → Implement each task sequentially
5. Verification → Test build and resolve any errors
6. Archival → Move completed features to specs/done/

## Debugging Flow

1. Issue Detection → Document problem in requirements.md
2. Investigation → Analyze root causes and document in design.md
3. Solution Design → Create resolution strategy in design.md
4. Implementation → Apply fixes following tasks.md
5. Validation → Verify resolution without introducing new issues
6. Documentation → Update relevant specifications with insights gained

## Commands

- `/kiro`: Initialize specifications for a new feature
- Ask "Approve requirements.md" to confirm requirements
- Ask "Approve design.md" to confirm design
- Ask "Please implement Task X" for implementation
- Natural language debugging queries like "Investigate why [issue] is occurring"

## Development Rules

1. All features start with requirements definition
2. Proceed to design after approving requirements
3. Proceed to implementation after approving design
4. Tasks should be independently testable
5. Mark tasks as completed using `[x]` notation
6. All tasks must pass verification before archiving
7. Debugging follows the same spec-driven approach as feature development

## Task Completion

When a task is completed:
1. Update tasks.md by changing `[ ]` to `[x]`
2. Update the progress counter at the top of tasks.md
3. Proceed to the next task only after confirming current task works

## Agent Specialization with EARS Hybrid Implementation

This project supports specialized agent roles with EARS (Easy Approach to Requirements Syntax) integration:

### Agent Commands
- `/kiro [feature-name]` - Full TAD workflow with EARS integration
- `/kiro-researcher [feature-name]` - Requirements specialist with EARS acceptance criteria
- `/kiro-architect [feature-name]` - Design specialist with EARS behavioral contracts
- `/kiro-implementer [feature-name]` - Implementation specialist with EARS DoD
- Natural language debugging queries - Debugging specialist with EARS validation

### EARS-Enhanced Agent Workflow
1. **Researcher**: Create requirements.md with EARS syntax (WHEN/WHILE/IF/WHERE + SHALL)
2. **Architect**: Create design.md with EARS behavioral contracts for components
3. **Implementer**: Create tasks.md with EARS Definition of Done for each task
4. **Debugger**: Use EARS validation for systematic issue resolution

### EARS Hybrid Benefits
- **Eliminates Ambiguity**: "WHEN user clicks login, system SHALL authenticate within 200ms" vs "fast login"
- **Direct Test Translation**: EARS → BDD (Given/When/Then) mapping for automated testing
- **Behavioral Contracts**: Component interfaces specify exact behavioral expectations
- **Measurable Success**: Every requirement has specific triggers and measurable outcomes
- **Token Efficiency**: Dense, precise EARS statements reduce verbose explanations
- **Comprehensive Coverage**: Every acceptance criterion maps to testable conditions

## EARS-Enhanced Debugging Capabilities

The debugging system provides:
1. **Context-aware analysis** with EARS behavioral expectation validation
2. **Root cause identification** using EARS acceptance criteria mapping
3. **Solution design** with EARS-compliant resolution specifications
4. **Structured implementation** with EARS Definition of Done for debug tasks
5. **Comprehensive validation** using EARS success criteria measurement

Debugging with EARS precision:
- "WHEN user submits login, system SHALL respond within 200ms but currently takes 5s"
- "WHERE file size exceeds 10MB, system SHALL handle gracefully but currently crashes"
- "IF authentication token is invalid, system SHALL return 401 but returns 500"

EARS debugging creates measurable resolution criteria:
- **Issue Definition**: EARS format for exact problem specification
- **Expected Resolution**: EARS acceptance criteria for successful fix
- **Validation Steps**: EARS-to-BDD test scenarios for verification

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

## Integration Between Development and Debugging

When debugging reveals issues that require specification changes:
1. Complete the debugging process to resolve immediate issues
2. Document findings that impact specifications
3. Update original feature specifications to reflect new understanding
4. Create regression tests to prevent issue recurrence
5. Consider architectural implications of recurring issues

For detailed debugging information with EARS implementation, refer to the debugger.md documentation.

## EARS Hybrid Implementation Details

### EARS Syntax Format
- **WHEN** [trigger condition], the system **SHALL** [specific action]
- **WHILE** [ongoing state], the system **SHALL** [continuous behavior]
- **IF** [conditional state], the system **SHALL** [conditional response]
- **WHERE** [constraint boundary], the system **SHALL** [bounded action]

### EARS-to-BDD Translation
EARS requirements automatically translate to BDD scenarios:
- **EARS**: WHEN user submits valid form, system SHALL save data within 1 second
- **BDD**: GIVEN valid form data, WHEN user submits form, THEN system saves within 1 second

### Quality Assurance with EARS
- Every acceptance criterion includes confidence scoring
- All behavioral contracts specify measurable outcomes
- Component interfaces use EARS format for precise expectations
- Test coverage maps directly from EARS statements to automated tests

### Implementation Verification
- Definition of Done (DoD) written in EARS format
- Task completion verified against EARS acceptance criteria
- Progress tracking includes EARS compliance validation
- Archival process preserves EARS traceability relationships