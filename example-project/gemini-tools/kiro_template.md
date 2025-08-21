# Kiro Style Specification-Driven Development Template

This project adopts Kiro-style specification-driven development with EARS (Easy Approach to Requirements Syntax) hybrid implementation for enhanced precision and testability.

## Specification Files

- **specs/{feature-name}/requirements.md**: User stories with EARS acceptance criteria (WHEN/WHILE/IF/WHERE + SHALL)
- **specs/{feature-name}/design.md**: Technical architecture with EARS behavioral contracts
- **specs/{feature-name}/tasks.md**: Implementation tasks with EARS Definition of Done (DoD)

## Development Flow

1. **Requirements Definition** → Document in requirements.md with EARS syntax
2. **Design** → Document in design.md with EARS behavioral contracts
3. **Task Division** → Document in tasks.md with EARS DoD
4. **Implementation** → Implement each task sequentially
5. **Verification** → Test build and resolve any errors
6. **Archival** → Move completed features to specs/done/

## Commands

- `/kiro "Feature Name"`: Initialize specifications for a new feature with EARS syntax
- `/kiro resume "Feature Name"`: Resume work on existing feature with full context
- Natural language follow-ups: Task updates, completion, etc.

## Interacting with Kiro Using Simple Commands

The primary way to interact with the Kiro workflow is through the `/kiro` command in Gemini CLI. The command uses embedded EARS methodology for precise requirements.

### Command Usage Patterns

#### 1. Basic Feature Generation
```
/kiro "User Authentication System"
```

#### 2. Feature with Context
```
/kiro "User Profile Management System with GDPR compliance, real-time validation, and mobile support"
```

#### 3. Complex Feature with Structured Context
```
/kiro "Payment Processing System with the following considerations:
1. Core functionality: Stripe integration, multiple payment methods, subscription billing
2. User experience: One-click payments, saved payment methods, receipt management  
3. Integration points: Connect to existing user accounts, notification service, accounting system
4. Technical constraints: PCI compliance, fraud detection, international currency support"
```

#### 4. Resume Feature Work
```
/kiro resume "User Authentication System"
```

#### 5. Task Management (Natural Language Follow-ups)
After generating specifications, use natural language:
```
"Mark task TASK-abc123-001 as completed"
"Update task TASK-abc123-002 to in-progress" 
"Complete the User Authentication feature"
```

### EARS Syntax Integration

The kiro command automatically generates specifications using EARS (Easy Approach to Requirements Syntax):

- **WHEN** [trigger condition], the system **SHALL** [specific action]
- **WHILE** [ongoing state], the system **SHALL** [continuous behavior]
- **IF** [conditional state], the system **SHALL** [conditional response] 
- **WHERE** [constraint boundary], the system **SHALL** [bounded action]

**EARS Examples:**
- WHEN user submits valid login credentials, the system SHALL authenticate within 200ms
- WHILE user session is active, the system SHALL maintain authentication state
- IF login attempts exceed 3 failures, the system SHALL temporarily lock the account for 15 minutes
- WHERE user lacks required permissions, the system SHALL display "Access Denied" message

## Kiro Workflow with EARS

The kiro command manages the complete development lifecycle using EARS methodology:

1. **Specification Generation**: `/kiro "Feature Name"` creates requirements.md, design.md, and tasks.md with EARS syntax
2. **User Approval Gates**: Review and approve each document before proceeding
3. **Implementation**: Follow tasks sequentially with EARS Definition of Done
4. **Progress Tracking**: Update task status using natural language
5. **Completion**: Validate against EARS acceptance criteria and archive

### EARS Integration Benefits

- **Eliminates Ambiguity**: "WHEN user clicks login, system SHALL authenticate within 200ms" vs "fast login"
- **Direct Test Translation**: EARS → BDD (Given/When/Then) mapping for automated testing
- **Behavioral Contracts**: Component interfaces specify exact behavioral expectations
- **Measurable Success**: Every requirement has specific triggers and measurable outcomes
- **Comprehensive Coverage**: Every acceptance criterion maps to testable conditions

### Generated Documentation Structure

```
specs/
└── user-authentication-system/
    ├── requirements.md  # EARS acceptance criteria (WHEN/WHILE/IF/WHERE + SHALL)
    ├── design.md        # EARS behavioral contracts for components
    └── tasks.md         # EARS Definition of Done for each task

specs/done/
└── DONE_20250818_a1b2c3d4_.../  # Archived completed features
    ├── requirements.md
    ├── design.md
    ├── tasks.md
    ├── validation.md
    ├── metrics.md
    └── retrospective.md
```

## Development Rules

1. All features start with requirements definition using EARS syntax
2. Proceed to design after approving requirements  
3. Proceed to implementation after approving design
4. Tasks should be independently testable with EARS DoD
5. Mark tasks as completed using natural language
6. All tasks must pass EARS validation before archiving

## Task Completion

When a task is completed:
1. Update tasks.md by changing `[ ]` to `[x]`
2. Update the progress counter at the top of tasks.md
3. Proceed to the next task only after confirming current task works

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

## Responding to Specification Changes

When specifications change, use natural language to request updates while maintaining EARS consistency:

**Examples:**
```
"I need to add social login to the User Authentication feature"
"Change the database from PostgreSQL to MongoDB in the Data Storage feature"  
"Remove the dark mode feature as it's no longer needed"
```

When changes occur, the kiro workflow will:
1. Update requirements.md with EARS syntax
2. Modify design.md to reflect new EARS behavioral contracts  
3. Adjust tasks.md with updated EARS DoD
4. Verify EARS compliance across all files