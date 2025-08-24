# Kiro Implementer Command - Enhanced 3-Phase TAD

## Purpose
Simple 3-phase implementer that combines Kiro TAD rigor with enhanced subagent delegation.

## Command Usage
```
/kiro-implementer [feature-name]
/kiro-implementer resume [feature-name]
```

**Options:**
- `start` - Begin new implementation from Phase 1
- `resume` - Continue an existing implementation. Loads previously discovered subagent capabilities from `.claude/state/implementer-state/[feature-name].json` to ensure context is preserved.

## 3-Phase Execution Strategy

### Phase 1: Dynamic Discovery & State Persistence
**Goal**: Find available subagents quickly and efficiently, with resume capability

**Process**:
1. Check for `~/.claude/agents/subagents-manifest.json`
2. If found, read agent capabilities from manifest
3. If not found, scan `~/.claude/agents/*.md` files
4. Generate capabilities briefing with specialization grouping
5. **State Persistence**: Save discovered capabilities briefing to `.claude/state/implementer-state/[feature-name].json` for resume functionality

**Output**: Brief list of available specialized agents + persistent state file for resume

### Phase 2: Strategic Planning
**Goal**: Break down requirements into tasks with appropriate agent assignments

**Process**:
1. Read `requirements.md` and `design.md` from current specs
2. **Load task template**: Use structure from `~/.claude/templates/tasks-template.md` 
3. **Follow example format**: Use the concrete example format shown below (lines 169-200)
4. Break EARS requirements into concrete tasks
5. Match tasks to appropriate subagents based on specialization
6. Generate `tasks.md` combining template structure with example formatting

**Output**: Complete `tasks.md` with task breakdown, agent assignments, and progress tracking

### Phase 3: EARS-Compliant Implementation
**Goal**: Execute tasks using appropriate subagents with EARS compliance

**Process**:
1. Execute tasks from `tasks.md` in sequence
2. **Follow delegation protocol**: Use patterns from `~/.claude/protocols/ears-delegation-protocol.md`
3. For each task, delegate to assigned subagent using `@agent-name` format
4. Provide EARS context: requirement ID + acceptance criteria
5. Validate output against original requirements

**Output**: Working implementation that meets all EARS acceptance criteria

## EARS-Compliant Delegation Protocol

### Context Injection Pattern
When delegating tasks to subagents, the protocol ensures proper context injection:

```
@code-reviewer: Review implementation against EARS acceptance criteria:

REQ-FEAT-001: WHEN user submits form, system SHALL validate within 200ms
AC-FEAT-001-01: IF validation fails, system SHALL display specific error message

[Provide minimal context about the implementation to review]

Expected: Code review feedback with EARS compliance assessment
```

### Validation Pipeline
Each delegated task follows this validation pipeline:
1. **Context Validation**: Ensure EARS requirements are properly injected
2. **Task Execution**: Subagent processes task with full context
3. **Output Validation**: Verify results meet acceptance criteria
4. **Compliance Check**: Confirm EARS traceability is maintained

## Dynamic Subagent Discovery

### Manifest-Based Discovery
Available subagents are automatically discovered using intelligent manifest-based discovery:

**Primary Discovery Method**:
- Check for `~/.claude/agents/subagents-manifest.json` (fast index-based lookup)
- Load agent capabilities, specializations, and metadata from manifest
- **Use discovery protocol**: Follow guidelines from `~/.claude/protocols/discovery-protocol.md`
- Provides sub-200ms discovery performance for 300+ agents

**Fallback Discovery Method**:
- Global: `~/.claude/agents/` (installed via enhance-kiro-subagents.sh)
- Project: `./.claude/agents/` (project-specific agents)
- File-based scanning when manifest unavailable

Project agents take precedence over global agents.

## Supporting Files

**Templates** (auto-installed to `~/.claude/templates/` or `./.claude/templates/`):
- `tasks-template.md` - Standard format for task breakdown and progress tracking
- `simple-manifest-schema.json` - Reference schema for manifest structure validation

**Protocols** (auto-installed to `~/.claude/protocols/` or `./.claude/protocols/`):
- `ears-delegation-protocol.md` - Standard patterns for subagent delegation with context injection
- `discovery-protocol.md` - Guidelines for agent discovery and capabilities briefing generation

## Integration with Kiro TAD
1. **Researcher** creates `requirements.md` with EARS acceptance criteria
2. **Architect** creates `design.md` with technical specifications
3. **Enhanced Implementer** executes 3-phase process:
   - Discovery: Find available agents
   - Planning: Create `tasks.md` with delegations
   - Implementation: Execute with subagent assistance

## Resume Functionality

### State-Aware Resume Capability
The enhanced implementer supports intelligent resume functionality, allowing seamless continuation of interrupted workflows.

**Resume Command**: `/kiro-implementer resume [feature-name]`

### Resume Workflow

**Starting New Implementation**:
1. `/kiro-implementer user-authentication start`
2. Phase 1 discovers agents and saves state to `.claude/state/implementer-state/user-authentication.json`
3. Phase 2 creates `tasks.md` with agent assignments
4. User works on some tasks, then stops

**Resuming Implementation**:
1. `/kiro-implementer resume user-authentication`
2. **Loads saved state** from `.claude/state/implementer-state/user-authentication.json`
3. **Skips rediscovery** - uses previously identified agents for consistency
4. **Reviews current progress** in `tasks.md`
5. **Continues from incomplete tasks** with same agent assignments

### State File Structure
`.claude/state/implementer-state/[feature-name].json`:
```json
{
  "feature_name": "user-authentication",
  "discovery_timestamp": "2024-01-15T10:30:00Z",
  "capabilities_briefing": "**Code Review**: @code-reviewer, @security-auditor...",
  "total_agents": 295,
  "agent_assignments": {
    "security_tasks": "@security-expert",
    "database_tasks": "@database-expert",
    "api_tasks": "@api-designer"
  }
}
```

## State Management
- **State Persistence**: `.claude/state/implementer-state/[feature-name].json`
- **Progress Tracking**: `tasks.md` with checkbox completion tracking
- **Agent Consistency**: Resume uses same agents identified during initial discovery
- **Automatic Cleanup**: State files removed when feature reaches 100% completion

## Execution Examples

**Phase 1 Discovery Output**:
```
Available Subagents (42 found):
**Code Review**: @code-reviewer, @security-auditor
**Testing**: @test-automator, @performance-tester  
**Frontend**: @react-expert, @css-specialist
**Backend**: @api-designer, @database-expert
```

**Phase 2 Planning Output (tasks.md)** - Example format for AI reference:
```markdown
# Tasks: User Authentication - Enhanced Implementer

## Progress: 0/4 Complete, 0 In Progress, 4 Not Started

## Phase 1: Foundation Tasks
- [ ] **TASK-001: Authentication Schema Design**
  - **Requirement**: REQ-AUTH-001 - User credential validation
  - **EARS AC**: WHEN user submits login, SHALL validate within 200ms
  - **Assigned**: @database-expert
  - **Dependencies**: None

## Phase 2: Implementation Tasks  
- [ ] **TASK-002: API Endpoint Implementation**
  - **Requirement**: REQ-AUTH-002 - Login/logout endpoints
  - **EARS AC**: WHEN endpoint called, SHALL return JWT token
  - **Assigned**: @api-designer
  - **Dependencies**: TASK-001

- [ ] **TASK-003: Frontend Components**
  - **Requirement**: REQ-AUTH-003 - Login/logout UI
  - **EARS AC**: WHEN form submitted, SHALL display validation errors
  - **Assigned**: @react-expert
  - **Dependencies**: TASK-002

## Phase 3: Quality Assurance
- [ ] **TASK-004: Security Testing**
  - **Requirement**: REQ-AUTH-004 - Security validation
  - **EARS AC**: WHEN tests run, SHALL validate all security criteria
  - **Assigned**: @security-expert
  - **Dependencies**: All previous tasks
```

**Phase 3 Implementation**:
Execute each task by delegating to the assigned specialist with proper EARS context. Update task status and progress counter as tasks complete.

## Performance Targets
- Discovery: Complete in under 500ms for 300+ agents
- Planning: Generate tasks.md in under 30 seconds
- Implementation: Maintain EARS traceability throughout

## Execution Rules

### Task Execution
- **Always read** `requirements.md`, `design.md`, and `tasks.md` before executing any task
- **Execute only one task at a time** - stop after completion for user review  
- **Do NOT automatically proceed** to next task without user request
- **Update progress** in `tasks.md`: change `[ ]` to `[x]` and update progress counter

### Progress Tracking Format
Update the progress line in `tasks.md`:
```markdown
## Progress: 2/4 Complete, 1 In Progress, 1 Not Started
```

### Task Status Updates
- `[ ]` - Not Started
- `[x]` - Completed  
- Mark task as completed only when fully validated against EARS criteria

### Resume Behavior
- **On resume**: Load state from `.claude/state/implementer-state/[feature-name].json`
- **Skip Phase 1**: Use saved capabilities briefing (no rediscovery)
- **Review progress**: Check `tasks.md` for completed vs pending tasks
- **Continue execution**: Pick up from next incomplete task
- **Maintain assignments**: Use same agents that were originally assigned

### Completion & Cleanup
- **At 100% completion**: Automatically clean up state file
- **Archive completed**: Move `tasks.md` to `specs/done/[feature-name]-tasks.md`
- **Validate final result**: Ensure all EARS acceptance criteria are met

## Command Examples

```bash
# Start new feature implementation
/kiro-implementer user-authentication start

# Resume interrupted implementation  
/kiro-implementer resume user-authentication

# Continue with next task after completion
/kiro-implementer user-authentication continue
```

This enhanced implementer provides intelligent resume capabilities with state persistence, enabling seamless workflow continuation while maintaining the power of specialized subagents and the rigor of the original Kiro TAD system.