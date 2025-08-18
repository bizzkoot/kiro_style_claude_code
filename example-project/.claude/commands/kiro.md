# Kiro Command - Traceable Agentic Development (TAD)

Context: Review CLAUDE.md for project context first.
Trigger: /kiro "Feature Name"
Action: Create specs/{kebab-case-feature-name}/ with semantic traceability chain.

## Phase 1: Generation Sequence

### 1. requirements.md (Semantic Anchor)
```markdown
# Requirements: [Feature Name]
## Meta-Context
- Feature UUID: FEAT-{8-char-hash}
- Parent Context: [CLAUDE.md links]
- Dependency Graph: [Auto-detected]

## Functional Requirements
### REQ-{UUID}-001: [Name]
Intent Vector: {AI semantic summary}
As a [User] I want [Goal] So that [Benefit]
Business Value: {1-10} | Complexity: {XS/S/M/L/XL}

Acceptance Criteria:
- AC-{REQ-ID}-01: GIVEN [context] WHEN [action] THEN [outcome] {confidence: X%}
- AC-{REQ-ID}-02: GIVEN [context] WHEN [action] THEN [outcome] {confidence: X%}

Validation Hooks: {testable assertions}
Risk Factors: {auto-identified}

## Non-functional Requirements
- NFR-{UUID}-PERF-001: {measurable target}
- NFR-{UUID}-SEC-001: {security constraint + test}
- NFR-{UUID}-UX-001: {usability metric}

## Traceability Manifest
Upstream: [dependencies] | Downstream: [impact] | Coverage: [AI-calculated]
```

### 2. design.md (Architecture Mirror)
```markdown
# Design: [Feature Name]
## ADRs (Architectural Decision Records)
### ADR-001: [Decision]
Status: Proposed | Context: [background] | Decision: [what] | Rationale: [why]
Requirements: REQ-{UUID}-001,002 | Confidence: X% | Alternatives: [rejected options]

## Components
### Modified: [Component] → Fulfills: AC-{REQ-ID}-01
Changes: [specific modifications]

### New: [Component] → Responsibility: {requirement-linked purpose}
Interface:
```typescript
interface Component {
  method1(): Promise<T> // AC-{REQ-ID}-01
  method2(input: I): O  // AC-{REQ-ID}-02
}
```

## API Matrix
| Endpoint | Method | Requirements | Test Strategy | Errors |
|----------|--------|-------------|---------------|--------|
| /api/x | POST | AC-{REQ-ID}-01,02 | Unit+Integration | [auto] |

## Data Flow + Traceability
1. Input Validation → NFR-{UUID}-SEC-001
2. Business Logic → REQ-{UUID}-001  
3. Output → AC-{REQ-ID}-01

## Quality Gates
- ADRs: >80% confidence to requirements
- Interfaces: trace to acceptance criteria
- NFRs: measurable test plans
```

### 3. tasks.md (Execution Blueprint)
```markdown
# Tasks: [Feature Name]
## Metadata
Complexity: {AI-calc} | Critical Path: {sequence} | Risk: {score} | Timeline: {estimate}

## Progress: 0/X Complete, 0 In Progress, 0 Not Started, 0 Blocked

## Phase 1: Foundation
- [ ] TASK-{UUID}-001: [Name]
  Trace: REQ-{UUID}-001 | Design: NewComponent | AC: AC-{REQ-ID}-01
  DoD: [criteria] | Risk: Low | Deps: None | Effort: 2pts

- [ ] TASK-{UUID}-002: [Name]  
  Trace: REQ-{UUID}-001,002 | Design: method1() | AC: AC-{REQ-ID}-01,02
  DoD: [criteria] | Risk: Medium | Deps: TASK-001 | Effort: 5pts

## Phase 2: Integration
- [ ] TASK-{UUID}-003: API Implementation
  Trace: REQ-{UUID}-002 | Design: POST /api/x | AC: AC-{REQ-ID}-02
  DoD: [criteria] | Risk: Low | Deps: TASK-002 | Effort: 3pts

## Phase 3: QA
- [ ] TASK-{UUID}-004: Test Suite
  Trace: ALL AC-* | Design: Test impl | AC: 100% coverage + NFR validation
  DoD: [criteria] | Risk: Medium | Deps: All prev | Effort: 4pts

## Verification Checklist
- [ ] Every REQ-* → implementing task
- [ ] Every AC-* → test coverage  
- [ ] Every NFR-* → measurable validation
- [ ] All design elements → specific tasks
- [ ] Risk mitigation for Medium+ risks
```

### 4. Auto-Verification (Internal)
Before completion, run AI validation:
1. Forward/Backward/Bi-directional traceability check
2. Gap analysis (missing coverage, orphaned elements)
3. Confidence scoring (requirements: X%, design: X%, tasks: X%)
4. Risk assessment and recommendations
5. Output: "Traceability Check: PASSED/FAILED" + improvement suggestions

### 5. CLAUDE.md Update Assessment (Post-Generation)
After generating all three files, analyze if major architectural changes require CLAUDE.md updates:

**Triggers for CLAUDE.md Update:**
- New technology stack (framework, database, architecture pattern)
- Major architectural decisions that change project direction
- New domain concepts or business logic that affects project context
- Significant changes to development approach or constraints

**Assessment Process:**
1. Compare generated design.md ADRs against current CLAUDE.md project context
2. Identify semantic gaps between new requirements and existing project description
3. Check if new NFRs introduce constraints not reflected in CLAUDE.md

**If update needed:**
```bash
"The generated specifications introduce significant architectural changes. 
Should I update CLAUDE.md to reflect:
- [Specific change 1]
- [Specific change 2] 
- [Specific change 3]

This will improve future agent decisions and maintain project context accuracy."
```

**If no update needed:**
```bash
"CLAUDE.md context remains accurate for this feature. No updates required."
```

---

## Phase 2: Lifecycle Management

**Task Updates**: Change [ ] to [x], update progress count, AI monitors for scope drift/timeline deviation

**Smart Completion** (100% progress):
1. Auto-validate acceptance criteria vs implementation
2. Execute full test suite against original requirements  
3. Generate requirement satisfaction + quality metrics report
4. Archive: Create specs/done/, move specs/{feature}/, rename DONE_{date}_{hash}_filename.md
5. Generate retrospective + update semantic knowledge base

**Learning Loop**: Pattern recognition for estimates, risk prediction, process optimization

---

## Resume Command
/kiro resume "{feature-name}"
Action: 
1. Read specs/{feature-name}/requirements.md for full requirement context
2. Read specs/{feature-name}/design.md for architectural decisions + rationale  
3. Read specs/{feature-name}/tasks.md for current progress state
4. Reconstruct semantic traceability graph from all three documents
5. Continue with full TAD framework context maintained

This ensures AI agents understand WHY decisions were made, not just WHAT needs to be done.