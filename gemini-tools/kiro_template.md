# Kiro: Traceable Agentic Development (TAD)

*A methodology for specification-driven development using EARS and Stateful Persona Delegation.*

This project adopts Kiro, a methodology for Traceable Agentic Development (TAD). It ensures every feature is precisely specified, traceable, and implemented by a qualified specialist agent using EARS (Easy Approach to Requirements Syntax) for precision and testability.

## The Specification Directory: `specs/`

All Kiro specifications reside in the `specs/` directory, organized by feature. The `/kiro` command generates the following files:

- **`specs/{feature-name}/requirements.md` (The "What & Why")**: Defines user stories and acceptance criteria using EARS syntax. This is the semantic anchor for the feature.
- **`specs/{feature-name}/design.md` (The "How")**: Contains architectural decision records (ADRs) and component designs with EARS behavioral contracts. This is the architectural mirror.
- **`specs/{feature-name}/persona-delegation.json` (The "Who")**: A plan that maps each task ID to a specific specialist persona. This ensures accountability and expertise.
- **`specs/{feature-name}/tasks.md` (The "Execution Plan")**: A checklist of implementation tasks, each with a traceable link to requirements and an EARS-formatted Definition of Done (DoD).

## The Kiro Workflow

The development lifecycle follows a structured, interactive process managed by the `/kiro` command.

1.  **Initiate & Specify**: Begin by running `/kiro "Feature Name"`. The agent generates the full specification suite: `requirements.md`, `design.md`, `persona-delegation.json`, and `tasks.md`.
2.  **Approve**: You must review and approve each generated file (`requirements`, `design`, `tasks`). The agent will not proceed without your explicit approval for each stage, ensuring the plan aligns with your vision.
3.  **Delegate & Implement**: For each task in `tasks.md`, the agent consults `persona-delegation.json`, adopts the assigned specialist persona, and executes the implementation.
4.  **Verify & Complete**: Upon completing all tasks, the agent validates that the implementation meets all EARS criteria, runs tests, and archives the feature into the `specs/done/` directory.

## Driving the Workflow: Commands

The primary way to interact with the Kiro workflow is through the `/kiro` command and natural language follow-ups in the Gemini CLI.

### Core Commands

-   `/kiro "Feature Name"`: Initializes the complete specification suite for a new feature.
-   `/kiro resume "Feature Name"`: Resumes work on an existing feature, loading its full context.

### Command Usage Patterns

**1. Basic Feature Generation**
```
/kiro "User Authentication System"
```

**2. Feature with Rich Context**
```
/kiro "User Profile Management System with GDPR compliance, real-time validation, and mobile support"
```

**3. Complex Feature with Structured Context**
```
/kiro "Payment Processing System with the following considerations:
1. Core functionality: Stripe integration, multiple payment methods, subscription billing
2. User experience: One-click payments, saved payment methods, receipt management  
3. Integration points: Connect to existing user accounts, notification service, accounting system
4. Technical constraints: PCI compliance, fraud detection, international currency support"
```

**4. Task Management (Natural Language Follow-ups)**
After specifications are generated, use simple instructions to manage tasks:
```
"Mark task TASK-abc123-001 as completed"
"Update task TASK-abc123-002 to in-progress" 
"Complete the User Authentication feature"
```

## EARS: The Language of Precision

EARS (Easy Approach to Requirements Syntax) is used to write unambiguous, verifiable requirements. It is mandatory for all acceptance criteria, behavioral contracts, and definitions of done.

### EARS Syntax Format

-   **WHEN** `[a trigger occurs]`, the system **SHALL** `[perform a specific action]`.
-   **WHILE** `[a state is ongoing]`, the system **SHALL** `[maintain a continuous behavior]`.
-   **IF** `[a condition is true]`, the system **SHALL** `[execute a conditional response]`.
-   **WHERE** `[a feature is constrained]`, the system **SHALL** `[adhere to a bounded action]`.

**Examples:**
-   WHEN user submits valid login credentials, the system SHALL authenticate within 200ms.
-   WHILE the user session is active, the system SHALL maintain the authentication state.
-   IF login attempts exceed 3 failures, the system SHALL temporarily lock the account for 15 minutes.
-   WHERE the user lacks required permissions, the system SHALL display an "Access Denied" message.

### Benefits of EARS

-   **Eliminates Ambiguity**: Provides clear, measurable success criteria instead of vague goals like "fast login."
-   **Direct Test Translation**: EARS statements map directly to BDD (Given/When/Then) test scenarios, streamlining QA.
-   **Precise Behavioral Contracts**: Component interfaces can specify exact behavioral expectations (e.g., `// WHEN method1() is called, SHALL return Promise<T> within 200ms`).
-   **Comprehensive Coverage**: Ensures all conditions, triggers, and constraints are explicitly defined and testable.

## Core Principles

1.  **Specification First**: All features must begin with a `/kiro` command to generate the specification files. No implementation should occur before specs are approved.
2.  **Approval is Mandatory**: The agent will stop and wait for your explicit approval after generating requirements, design, and tasks. This is a core control mechanism.
3.  **Sequential Tasking**: Tasks must be implemented in the order they appear in `tasks.md` unless otherwise instructed. Update task status by changing `[ ]` to `[x]` and updating the progress counter.
4.  **EARS is Law**: All acceptance criteria, behavioral contracts, and Definitions of Done (DoD) must be written in valid EARS format.
5.  **Handle Specification Changes Gracefully**: If requirements change mid-stream, state the needed change in natural language. The agent will update the specification files, re-verify EARS compliance, and await your re-approval before continuing.
    ```
    "I need to add social login to the User Authentication feature."
    "Change the database from PostgreSQL to MongoDB for the Data Storage feature."
    ```
