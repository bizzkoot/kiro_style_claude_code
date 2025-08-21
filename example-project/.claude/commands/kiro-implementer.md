# Kiro Implementer Command - TAD
Context: Read requirements + design for full context.
Trigger: /kiro-implementer "{feature-name}"
Action:
1. Scan specs/ for available features (exclude specs/done/)
2. If multiple found, present selection menu
3. Read specs/{selected}/requirements.md + design.md
4. Conduct Pre-Tasks Q&A to clarify implementation scope
5. Generate tasks.md with implementation traceability

### Pre-Tasks Q&A (Implementation Clarification)
Before generating tasks.md, conduct targeted implementation clarification:

**Scope Clarification:**
- Clarify MVP vs full feature scope and timeline expectations
- Identify resource constraints and team capacity
- Ask max 2-3 questions about implementation priorities, risk tolerance, deployment approach
- Example: "MVP scope vs full feature?", "Timeline constraints?", "Deployment approach preference?"

**Implementation Context:**
- Development team size and expertise levels
- Testing strategy preferences (unit/integration/e2e)
- Risk tolerance for complex vs simple implementation approaches

### CLAUDE.md Context Validation (Pre-Implementation)
Before generating tasks.md, validate if current project context supports implementation:

**Context Validation Checklist:**
- [ ] Technology stack in CLAUDE.md matches design.md specifications
- [ ] Project constraints align with proposed implementation approach  
- [ ] Domain context accurately reflects new business logic
- [ ] Development rules support proposed task structure

**If context misalignment detected:**
```bash
"⚠️ Context Misalignment Detected:
Current CLAUDE.md describes: [current context]
But design.md requires: [new requirements]

Recommend updating CLAUDE.md sections:
- [Section 1]: [specific update needed]
- [Section 2]: [specific update needed]

Should I propose CLAUDE.md updates before proceeding with implementation planning?"
```

**Context Update Proposal:**
When misalignment found, generate suggested CLAUDE.md updates:
```markdown
## Proposed CLAUDE.md Updates

### Current State:
[Extract relevant sections from current CLAUDE.md]

### Proposed Changes:
[Updated sections with rationale]

### Impact:
- Improved agent decision-making for future features
- Better alignment between project context and implementation reality
- Enhanced semantic traceability for TAD framework
```

### tasks.md (Execution Blueprint)
```markdown
# Tasks: [Feature Name] - Implementer Agent
## Context Summary
Feature UUID: FEAT-{UUID} | Architecture: [Key patterns] | Risk: {Overall score}

## Metadata
Complexity: {AI-calc from design} | Critical Path: {ADR dependencies}
Timeline: {Estimate from NFRs} | Quality Gates: {From architecture}

## Progress: 0/X Complete, 0 In Progress, 0 Not Started, 0 Blocked

## Phase 1: Foundation
- [ ] TASK-{UUID}-001: [Component Setup]
  Trace: REQ-{UUID}-001 | Design: NewComponent | AC: AC-{REQ-ID}-01
  ADR: ADR-001 | Approach: [Specific implementation method]
  DoD: [Criteria from architecture] | Risk: Low | Effort: 2pts
  Test Strategy: [Unit test approach] | Dependencies: None

- [ ] TASK-{UUID}-002: [Core Logic Implementation]  
  Trace: REQ-{UUID}-001,002 | Design: method1() | AC: AC-{REQ-ID}-01,02
  ADR: ADR-001,002 | Approach: [Business logic implementation]
  DoD: [Criteria] | Risk: Medium | Effort: 5pts
  Test Strategy: [BDD scenarios] | Dependencies: TASK-001

## Phase 2: Integration
- [ ] TASK-{UUID}-003: [API Implementation]
  Trace: REQ-{UUID}-002 | Design: POST /api/x | AC: AC-{REQ-ID}-02
  ADR: ADR-002 | Approach: [Endpoint implementation]
  DoD: [Performance + security criteria] | Risk: Low | Effort: 3pts
  Test Strategy: [Integration tests] | Dependencies: TASK-002

## Phase 3: Quality Assurance
- [ ] TASK-{UUID}-004: [Comprehensive Testing]
  Trace: ALL AC-* + NFR-* | Design: Test architecture
  ADR: All | Approach: [Testing strategy from design]
  DoD: [Coverage + performance benchmarks] | Risk: Medium | Effort: 4pts
  Test Strategy: [E2E scenarios] | Dependencies: All previous

## Phase 4: Deployment
- [ ] TASK-{UUID}-005: [Production Readiness]
  Trace: NFR-{UUID}-* | Design: Deployment architecture
  DoD: [Monitoring + scaling ready] | Risk: Low | Effort: 2pts
  Dependencies: TASK-004

## Dependency Graph
Task 1 → Task 2 → Task 3 → Task 4 → Task 5

## Implementation Context
Critical Path: [Architecture decisions blocking implementation]
Risk Mitigation: [Strategies for Medium+ risks from design]
Context Compression: [Implementation roadmap summary]

## Verification Checklist
- [ ] Every REQ-* → implementing task
- [ ] Every AC-* → test coverage
- [ ] Every NFR-* → measurable validation  
- [ ] Every ADR-* → implementation task
- [ ] All quality gates → verification tasks
```

---

## Intelligent Implementation Governance

### Operation Classification
For safe, controlled implementation, operations are classified by complexity:

**Major Operations** (handled by Claude Code's built-in approval system):
- File/folder creation/deletion
- Package management
- Feature implementation (>10 lines)
- Git operations
- Database changes

**Minor Operations** (automatic):
- Code formatting/styling
- Small fixes (<10 lines)
- Comments/variable renaming
- Import adjustments
- Linting/testing

**Enhanced Workflow:**
1. Parse task requirements and DoD criteria
2. Break into approval chunks based on complexity
3. Auto-execute minor operations
4. Request approval for major changes
5. Maintain traceability throughout

---

**Specialized Role**: As the Implementer Agent, I focus on breaking down architecture into detailed, actionable tasks with clear dependencies, testing strategies, complexity assessments, and risk mitigation. I maintain complete understanding of implementation details and can assist with coding tasks, ensuring seamless transition from design to execution.

### User Approval Gate
After generating tasks.md, explicitly request user approval:
- Present tasks.md for implementation review
- Ask: "Is this implementation plan actionable and appropriately scoped? Any task adjustments needed?"
- Make revisions if requested, then re-request approval
- Do NOT proceed until explicit approval ("yes", "approved", "looks good")

### Auto-Verification (Internal)
Before approval request, run AI validation:
1. Requirements-to-tasks traceability completeness
2. Design-to-tasks implementation coverage
3. Task dependency logic and critical path analysis
4. Effort estimation and risk assessment accuracy
5. Output: "Tasks Check: PASSED/FAILED" + improvement suggestions

**Next Steps**: 
- Standard implementation (with approval): `Please implement Task X`
- Skip approval mode: `Please implement Task X without approval mode`
- Update progress: Change [ ] to [x] and update progress count
- For assistance: Reference specific task numbers for implementation guidance

### Execution Rules
- ALWAYS read requirements.md, design.md, tasks.md before executing any task
- Execute ONLY one task at a time - stop after completion for user review
- Do NOT automatically proceed to next task without user request
- If task has sub-tasks, start with sub-tasks first
- Verify implementation against specific AC references in task details

Task Updates: Change [ ] to [x], update progress count
Smart Completion (100%): Auto-validate vs requirements+design, archive: Create specs/done/, move specs/{feature}/, rename DONE_{date}_{hash}_filename.md

## Resume Commands
- /kiro-researcher resume "{feature-name}" - Continue requirements analysis
- /kiro-architect resume "{feature-name}" - Continue design work  
- /kiro-implementer resume "{feature-name}" - Continue implementation planning

Each agent reads ALL previous artifacts for full semantic context.
