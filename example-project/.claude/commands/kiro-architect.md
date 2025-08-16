# Kiro Architect Command

As a design specialist, analyze requirements and create optimal technical architecture.

**Process:**
1. Check if `specs/{kebab-case-feature-name}/` exists for "$ARGUMENTS"
2. If target folder doesn't exist, scan `specs/` for available feature folders (exclude `specs/done/`)
3. If multiple folders found, present selection:
   ```
   Multiple feature folders found. Please select:
   1. {folder-name-1}
   2. {folder-name-2}
   3. {folder-name-3}
   > 
   ```
4. After confirmation/selection, read `specs/{selected-feature}/requirements.md`
5. Generate design.md in the selected folder

**`design.md`**
```markdown
# Design Document - Created by Architect Agent
## Architecture Overview
[Detailed description of how feature integrates with existing system]

## Technology Stack Analysis
- **Language**: [e.g., TypeScript] - [Justification]
- **Framework**: [e.g., React] - [Justification]
- **Database**: [e.g., PostgreSQL] - [Justification]
- **Alternative Options Considered**: [Alternatives and why they were rejected]

## Architecture Patterns
[Description of architectural patterns being applied]

## Components and Interfaces
### Modified: [ExistingComponent] - [Detailed changes needed]
- **Current State**: [Description of current implementation]
- **Proposed Changes**: [Specific modifications]
- **Impact Analysis**: [How changes affect other components]

### New: [NewComponent] - [Purpose]
- **Responsibility**: [Component's primary responsibility]
- **Interfaces**: [Public interfaces and methods]
- **Dependencies**: [Other components this depends on]

```typescript
// Key implementation structure with detailed comments
```

## Data Flow
1. [Detailed Step 1]
2. [Detailed Step 2] 
3. [Detailed Step 3]

## API Design
- `GET /api/[resource]` - [Comprehensive description with request/response format]
- `POST /api/[resource]` - [Comprehensive description with request/response format]

## Database Schema
| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| id | INTEGER | Primary Key | NOT NULL, AUTO INCREMENT |
| [field] | [type] | [description] | [constraints] |

## Performance Considerations
[Analysis of performance impact and optimization strategies]

## Security Considerations
[Detailed security analysis and mitigation strategies]

## Technical Debt Prevention
[Strategies to prevent accumulation of technical debt]

## Context Transfer
- **Key Decisions**: [Important architectural decisions]
- **Open Questions**: [Technical issues that need resolution in implementation]
- **Context Compression**: [Summary of technical research that informed this design]
```

**Specialized Role**: As the Architect Agent, my focus is on creating a comprehensive technical design that addresses all requirements while considering architectural patterns, performance, security, and maintainability. After approval, suggest continuing with `/kiro-implementer` to break down the implementation tasks.

**Next Steps**:
After design is approved:
1. Continue with the implementer agent: `/kiro-implementer [feature-name]`