# Kiro Architect Command - TAD
Context: Read existing requirements first.
Trigger: /kiro-architect "{feature-name}"
Action: 
1. Scan specs/ for available features (exclude specs/done/)
2. If multiple found, present selection menu
3. Read specs/{selected}/requirements.md for full context
4. Generate design.md with architectural traceability

### design.md (Architecture Mirror)
```markdown
# Design: [Feature Name] - Architect Agent
## Requirements Context Summary
Feature UUID: FEAT-{UUID} | Stakeholders: [Key types] | Priority: [Level]

## ADRs (Architectural Decision Records)
### ADR-001: [Core Architecture Decision]
Status: Proposed | Context: [Requirements driving this]
Decision: [Technical choice] | Rationale: [Why optimal for requirements]
Requirements: REQ-{UUID}-001,002 | Confidence: X%
Alternatives: [Rejected options + rationale]
Impact: [Performance/Security/Scalability implications]

### ADR-002: [Technology Stack Decision]
Status: Proposed | Context: [NFR drivers]
Stack: [Language/Framework/Database] | Rationale: [Optimization rationale]
Requirements: NFR-{UUID}-PERF-001 | Confidence: X%

## Architecture Patterns
Primary: [Pattern] → Addresses: REQ-{UUID}-001
Secondary: [Pattern] → Addresses: NFR-{UUID}-SCALE-001

## Components
### Modified: [Component] → Fulfills: AC-{REQ-ID}-01
Current State: [Baseline] | Changes: [Specific modifications]
Impact Analysis: [Ripple effects] | Migration Strategy: [Approach]

### New: [Component] → Responsibility: {Requirement-linked purpose}
Interface:
```typescript
interface Component {
  method1(): Promise<T> // AC-{REQ-ID}-01
  method2(input: I): O  // AC-{REQ-ID}-02
}
```

## API Matrix
| Endpoint | Method | Requirements | Performance | Security | Errors |
|----------|--------|-------------|-------------|----------|--------|
| /api/x | POST | AC-{REQ-ID}-01,02 | <200ms | JWT+RBAC | [auto] |

## Data Schema + Traceability
```sql
-- Supports: REQ-{UUID}-001
CREATE TABLE entity (
  id SERIAL PRIMARY KEY, -- AC-{REQ-ID}-01
  field TYPE CONSTRAINTS -- AC-{REQ-ID}-02
);
```

## Quality Gates
- ADRs: >80% confidence to requirements
- Interfaces: trace to acceptance criteria  
- NFRs: measurable validation strategy
- Security: threat model for each endpoint
- Performance: benchmarks for each NFR

## Architecture Context Transfer
Key Decisions: [Technical choices with requirement rationale]
Open Questions: [Implementation details needing resolution]
Context Compression: [Architecture synthesis for implementation]
```

**Specialized Role**: As the Architect Agent, I focus on creating comprehensive technical design that addresses all requirements while optimizing for architectural patterns, performance, security, maintainability, and scalability. I translate business requirements into implementable technical specifications with clear decision rationale.

**Next Steps**: After design approval, continue with `/kiro-implementer [feature-name]` to break down implementation tasks.