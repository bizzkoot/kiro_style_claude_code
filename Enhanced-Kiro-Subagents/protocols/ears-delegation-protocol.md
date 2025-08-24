# EARS-Compliant Delegation Protocol

## Purpose
Simple protocol for delegating tasks to subagents while preserving EARS behavioral contracts.

## Delegation Format
When delegating to subagents, use this structure:

```
@<subagent-name>: [Brief task description]

EARS Context:
- REQ-ID: [Requirement identifier]  
- AC-ID: [Acceptance criteria identifier]
- EARS Statement: [Original WHEN/IF/WHILE/WHERE SHALL statement]

[Minimal context about what needs to be done]

Expected Output: [What you expect back from the subagent]
```

## Example Delegation
```
@code-reviewer: Review user authentication implementation

EARS Context:
- REQ-AUTH-001: User login system
- AC-AUTH-001-01: WHEN user enters credentials, system SHALL authenticate within 2 seconds
- AC-AUTH-001-02: IF authentication fails, system SHALL display specific error message

Implementation to review:
[Provide the code/implementation to be reviewed]

Expected Output: Code review feedback with specific EARS compliance assessment
```

## Validation Process
1. **Pre-Delegation**: Ensure EARS context is complete
2. **Post-Output**: Check output addresses original EARS criteria
3. **Fallback**: If delegation fails, implement directly
4. **Integration**: Verify final result meets all requirements

## Context Guidelines
- Provide only essential context to minimize token usage
- Include complete EARS statement for traceability
- Specify expected output format
- Reference original requirement IDs

## Supported EARS Patterns
- **WHEN** [trigger] **SHALL** [action]
- **WHILE** [condition] **SHALL** [behavior]  
- **IF** [condition] **SHALL** [response]
- **WHERE** [constraint] **SHALL** [bounded action]

## Fallback Strategy
If subagent delegation fails or produces inadequate results:
1. Retry once with enhanced context
2. Fall back to direct implementation
3. Document the failure for future optimization

This protocol ensures that all subagent work maintains traceability to original EARS requirements while keeping the process simple and efficient.