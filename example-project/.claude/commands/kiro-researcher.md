# Kiro Researcher Command

**Context**: Review CLAUDE.md for project context first.
As a requirements specialist, analyze project needs and create comprehensive requirements.

Create `specs/{kebab-case-feature-name}/` directory for "$ARGUMENTS" and generate:

**`requirements.md`**
```markdown
# Requirements Document - Created by Researcher Agent
## Project Overview
[Comprehensive feature description and detailed business value analysis]

## Stakeholder Analysis
[Identification of all stakeholders and their specific needs]

## Requirements
### Requirement 1: [Name]
**As a** [User] **I want** [Goal] **So that** [Benefit]
**Acceptance Criteria:**
1.1. WHEN [condition] THEN [system] SHALL [response]
1.2. WHEN [condition] THEN [system] SHALL [response]
**Edge Cases:**
- [Edge case 1]
- [Edge case 2]

### Requirement 2: [Name]
**As a** [User] **I want** [Goal] **So that** [Benefit]
**Acceptance Criteria:**
2.1. WHEN [condition] THEN [system] SHALL [response]
2.2. WHEN [condition] THEN [system] SHALL [response]
**Edge Cases:**
- [Edge case 1]
- [Edge case 2]

## Non-functional Requirements
- **Performance**: [Detailed requirements with metrics]
- **Security**: [Comprehensive security considerations]
- **Usability**: [User experience requirements]
- **Maintainability**: [Long-term maintenance considerations]
- **Scalability**: [Growth and scaling requirements]

## Market Research
[Competitive analysis and market positioning]

## Context Transfer
- **Key Decisions**: [Important decisions that influenced requirements]
- **Open Questions**: [Issues that need resolution in design phase]
- **Context Compression**: [Summary of research that informed these requirements]
```

**Specialized Role**: As the Researcher Agent, my focus is on creating comprehensive requirements with thorough stakeholder analysis, detailed acceptance criteria, and careful consideration of edge cases. After approval, suggest continuing with `/kiro-architect` to create the technical design based on these requirements.

**Next Steps**:
After requirements are approved:
1. Continue with the architect agent: `/kiro-architect [feature-name]`