## 1. Kiro Researcher Agent

```markdown
# Kiro Researcher Command - TAD
Context: Review CLAUDE.md for project context first.
Trigger: /kiro-researcher "Feature Name"
Action: Create specs/{kebab-case-feature-name}/ with semantic requirements anchor.

### requirements.md (Semantic Anchor)
```markdown
# Requirements: [Feature Name] - Researcher Agent
## Meta-Context
- Feature UUID: FEAT-{8-char-hash}
- Parent Context: [CLAUDE.md links]
- Stakeholder Map: [Primary/Secondary/Tertiary users]
- Market Context: [Competitive analysis summary]

## Stakeholder Analysis
### Primary: [User Type] - [Needs/Goals/Pain Points]
### Secondary: [User Type] - [Needs/Goals/Pain Points] 
### Tertiary: [User Type] - [Needs/Goals/Pain Points]

## Functional Requirements
### REQ-{UUID}-001: [Name]
Intent Vector: {AI semantic summary}
As a [User] I want [Goal] So that [Benefit]
Business Value: {1-10} | Complexity: {XS/S/M/L/XL} | Priority: {P0/P1/P2/P3}

Acceptance Criteria:
- AC-{REQ-ID}-01: GIVEN [context] WHEN [action] THEN [outcome] {confidence: X%}
- AC-{REQ-ID}-02: GIVEN [context] WHEN [action] THEN [outcome] {confidence: X%}

Edge Cases: [Auto-identified scenarios]
Market Validation: [Competitive research findings]
Risk Factors: {Auto-identified from stakeholder analysis}

## Non-functional Requirements
- NFR-{UUID}-PERF-001: {Measurable performance target}
- NFR-{UUID}-SEC-001: {Security constraint + compliance}
- NFR-{UUID}-UX-001: {Usability metric + accessibility}
- NFR-{UUID}-SCALE-001: {Scalability requirement}
- NFR-{UUID}-MAINT-001: {Maintainability standard}

## Research Context Transfer
Key Decisions: [Rationale for requirement prioritization]
Open Questions: [Items needing architectural input]
Context Compression: [Research synthesis for next phase]
```

**Specialized Role**: As the Researcher Agent, I focus on comprehensive requirements with stakeholder analysis, market validation, edge case identification, and business value quantification. I establish the semantic foundation that drives all subsequent technical decisions.

**Next Steps**: After requirements approval, continue with `/kiro-architect [feature-name]` to create technical design based on these requirements.