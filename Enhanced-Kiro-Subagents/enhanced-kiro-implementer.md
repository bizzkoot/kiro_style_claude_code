# Kiro Implementer Command - Enhanced with Dynamic Subagent Integration

## Overview
Enhanced implementer combines Kiro TAD's specification-driven rigor with dynamic subagent discovery and EARS-compliant delegation through 3-phase execution.

**Enhanced Capabilities:**
- **Dynamic Discovery**: Auto-discovers subagents from global (`~/.claude/agents/`) and project (`./.claude/agents/`) manifests. Project-specific agents override global ones.
- **EARS Delegation**: Preserves behavioral contracts during task routing
- **3-Phase Execution**: Discovery → Planning → Implementation with autonomous decision-making
- **Performance Optimized**: Sub-200ms agent discovery through manifest caching

## Command Usage
```
/kiro-implementer [feature-name] [options]
/kiro-implementer resume [feature-name]
```

**Options:**
- `start` - Begin new implementation from Phase 1
- `resume` - Continue an existing implementation. Loads the previously discovered subagent capabilities from `.claude/implementer-state/[feature-name].json` to ensure context is preserved.
- `without-approval` - Skip user approval for experienced teams

## 3-Phase Execution Strategy

### Phase 1: Dynamic Discovery & State Persistence
**EARS Context**: WHEN Phase 1 Discovery starts, SHALL scan global and project-local agent directories (~/.claude/agents/, ./.claude/agents/), create a unified "Capabilities Briefing", and persist it to a state file.

**Auto-Discovery Process:**
1. **Environment Survey**: Scans global (`~/.claude/agents/`) and project-local (`./.claude/agents/`) directories for available subagents.
2. **Capability Mapping**: Extracts purpose/specialization from the manifest.
3. **Performance Loading**: Uses the cached manifest for sub-200ms discovery.
4. **State Persistence**: Saves the discovered "Capabilities Briefing" to `.claude/implementer-state/[feature-name].json`. This file acts as a state record for the `resume` command.
5. **Strategic Assessment**: Analyzes requirements against the available capabilities.

**Discovery Output**: A persisted capabilities briefing located at `.claude/implementer-state/[feature-name].json`.

### Phase 2: Strategic Planning
**EARS Context**: WHEN Phase 2 Planning executes, SHALL decompose EARS DoD requirements and map appropriate subagents with delegation rationale

**Planning Intelligence:**
1. **Requirement Decomposition**: Breaks EARS Definition of Done into discrete tasks
2. **Agent Mapping**: Matches task complexity/type to suitable specialist agents
3. **Delegation Strategy**: Plans which tasks to delegate vs handle directly
4. **Context Optimization**: Prepares minimal necessary EARS context for each delegation

**Planning Output**: Detailed delegation roadmap with rationale for each assignment.

### Phase 3: EARS-Compliant Implementation
**EARS Context**: WHILE Phase 3 Implementation runs, SHALL invoke subagents with @<subagent-name> format providing EARS context and acceptance criteria

**Implementation Execution:**
1. **Smart Delegation**: Invokes appropriate subagents with `@<subagent-name>` format
2. **Context Injection**: Provides specific EARS acceptance criteria and minimal context
3. **Output Validation**: Validates subagent outputs against original behavioral contracts
4. **Fallback Handling**: Retries with enhanced context or falls back to direct implementation

## Dynamic Subagent Discovery

### Manifest-Based Discovery
**Performance**: Sub-200ms discovery for 100+ agents through intelligent manifest caching
**Architecture**: JSON manifest with lazy-loaded capabilities briefing

### Currently Available Subagents
*Auto-discovered from global and project-local manifests (`~/.claude/agents/subagents-manifest.json`, `./.claude/agents/subagents-manifest.json`):*

```javascript
// Phase 1: Discovery Engine (Optimized)
const discoveryEngine = {
    async scanAgents() {
        const globalManifestPath = '~/.claude/agents/subagents-manifest.json';
        const localManifestPath = './.claude/agents/subagents-manifest.json';
        
        try {
            const globalAgents = await this.loadAgentsFromManifest(globalManifestPath);
            const localAgents = await this.loadAgentsFromManifest(localManifestPath);
            
            // Merge agents, with local agents overriding global ones
            const allAgents = this.mergeAgents(globalAgents, localAgents);
            
            return this.generateCapabilitiesBriefing(allAgents);
        } catch (error) {
            // Fallback to file system scan if manifests are unavailable
            return this.fallbackFileSystemScan(); 
        }
    },

    async fallbackFileSystemScan() {
        const globalPath = '~/.claude/agents/';
        const localPath = './.claude/agents/';
        
        try {
            // Scan for *.md files in both directories as fallback
            const globalAgents = await this.scanDirectoryForAgents(globalPath);
            const localAgents = await this.scanDirectoryForAgents(localPath);
            
            const allAgents = this.mergeAgents(globalAgents, localAgents);
            return this.generateCapabilitiesBriefing(allAgents);
        } catch (fallbackError) {
            return "No subagents discovered. Run ./enhance-kiro-subagents.sh to initialize.";
        }
    },

    async scanDirectoryForAgents(dirPath) {
        // Fallback: scan for *.md files and extract frontmatter
        // This is slower but ensures discovery if manifest is missing
        return []; // Implementation would scan .md files directly
    },

    async loadAgentsFromManifest(manifestPath) {
        try {
            const manifest = await this.loadManifest(manifestPath);
            return manifest.agents || [];
        } catch (error) {
            return []; // Return empty array if a manifest is not found
        }
    },

    mergeAgents(globalAgents, localAgents) {
        const agentMap = new Map();
        globalAgents.forEach(agent => agentMap.set(agent.name, agent));
        localAgents.forEach(agent => agentMap.set(agent.name, agent)); // Overwrites global with local
        return Array.from(agentMap.values());
    },
    
    generateCapabilitiesBriefing(agents) {
        const grouped = this.groupBySpecialization(agents);
        return Object.entries(grouped).map(([spec, agentList]) => 
            `**${spec}**: ${agentList.map(a => `@${a.name}`).join(', ')}`
        ).join('\n');
    }
};

```

**Discovery Metrics** (Current Installation):
- Total Available: 288 specialized agents
- Performance: Sub-200ms manifest loading (cached)
- Specializations: 27 categories (Security, Testing, Performance, etc.)

## EARS-Compliant Delegation Protocol

### Context Injection Pattern
When delegating to subagents:
```
EARS Context Package:
- Requirement ID: REQ-{UUID}-XXX
- Acceptance Criteria: Specific EARS statements (WHEN/WHILE/IF/WHERE + SHALL)
- Behavioral Contracts: Expected component behavior specifications
- Minimal Context: Feature summary, constraints, dependencies only
```

### Validation Pipeline
1. **Pre-Delegation**: Validate EARS context completeness
2. **Post-Output**: Check outputs against original behavioral contracts
3. **Retry Logic**: Enhanced context or fallback if validation fails
4. **Integration**: Validate final integration against all EARS criteria

### Example Delegation
```
@code-reviewer: Review implementation against EARS acceptance criteria:

AC-FEAT-123-001: WHEN user submits form, system SHALL validate within 200ms
AC-FEAT-123-002: IF validation fails, system SHALL display specific error messages

[Minimal implementation context provided]

Expected: Review feedback with specific EARS compliance assessment
```

## Pre-Tasks Q&A (Implementation Clarification)
Before generating tasks.md, conduct targeted implementation clarification:

**Scope Clarification (EARS-Driven):**
- Parse EARS acceptance criteria and NFRs from requirements.md and design.md
- Clarify MVP vs full feature scope based on EARS priority levels
- Identify resource constraints and team capacity for EARS compliance
- Ask max 2-3 questions about implementation priorities, EARS validation approach, deployment approach

**Implementation Context (EARS-Aware):**
- Development team size and expertise levels with BDD/EARS experience
- Testing strategy preferences (unit/integration/e2e) with EARS-to-BDD translation capabilities
- Risk tolerance for complex vs simple implementation approaches
- EARS compliance validation tools and frameworks available

## Pre-Implementation User Approval Gate
After the Pre-Tasks Q&A, I will summarize my understanding and ask for approval before proceeding.

**Summary Example:**
"Based on our Q&A, my understanding is:
- **Scope:** We will focus on the MVP scope, covering EARS priorities [P1, P2].
- **Approach:** We will use a [BDD Test Framework] for validation.
- **Deployment:** The initial deployment will be to [Staging Environment].

Is this understanding correct? Shall I proceed with context validation and implementation planning?"

**Action:** Do NOT proceed to the next step until the user gives explicit approval (e.g., "yes", "correct", "proceed").

## CLAUDE.md Context Validation (Pre-Implementation)
Before generating tasks.md, validate if current project context supports implementation:

**Context Validation Checklist:**
- [ ] Technology stack in CLAUDE.md matches design.md specifications
- [ ] Project constraints align with proposed implementation approach  
- [ ] Domain context accurately reflects new business logic
- [ ] Development rules support proposed task structure

**If context misalignment detected:**
Recommend updating CLAUDE.md sections with specific updates needed before proceeding.

## tasks.md (Execution Blueprint)
```markdown
# Tasks: [Feature Name] - Enhanced Implementer Agent
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
  DoD (EARS Format): WHEN component initialized, SHALL satisfy AC-{REQ-ID}-01 with 100% test coverage
  Risk: Low | Effort: 2pts | Delegation: @component-architect
  Test Strategy: [EARS-to-BDD unit tests] | Dependencies: None

## Phase 2: Integration  
- [ ] TASK-{UUID}-002: [API Implementation]
  Trace: REQ-{UUID}-002 | Design: POST /api/x | AC: AC-{REQ-ID}-02
  DoD (EARS Format): WHEN endpoint deployed, SHALL handle requests per EARS contract
  Risk: Low | Effort: 3pts | Delegation: @api-designer
  Dependencies: TASK-001

## Phase 3: Quality Assurance
- [ ] TASK-{UUID}-003: [Comprehensive Testing]
  Trace: ALL AC-* + NFR-* | Design: Test architecture
  DoD (EARS Format): WHEN tests execute, SHALL validate every EARS acceptance criterion
  Risk: Medium | Effort: 4pts | Delegation: @test-automator
  Dependencies: All previous

## Verification Checklist (EARS Compliance)
- [ ] Every REQ-* → implementing task with EARS DoD
- [ ] Every EARS AC → BDD test coverage (Given/When/Then)
- [ ] Every EARS NFR → measurable validation with specific triggers
- [ ] All design EARS contracts → implementation tasks with subagent delegation
```

## Implementation Commands

### Standard Workflow
```bash
# 1. Initialize enhanced capabilities (if not done)
./enhance-kiro-subagents.sh

# 2. Start implementation with 3-phase execution
/kiro-implementer [feature-name] start

# 3. Resume an interrupted implementation
/kiro-implementer resume [feature-name]
```

### Quality Assurance Integration
All implementations maintain:
- ✅ **Requirement Traceability**: Every task maps to specific EARS acceptance criteria
- ✅ **Behavioral Contract Compliance**: All outputs validated against original specifications
- ✅ **Delegation Transparency**: Clear rationale for each specialist assignment with @subagent format
- ✅ **Performance Standards**: Sub-3-second discovery, automated validation pipelines

## Advanced Features

### Intelligent Fallback
If subagent delegation fails or produces non-compliant output:
1. **Enhanced Context Retry**: Provide additional context and retry once
2. **Direct Implementation**: Fall back to standard kiro-implementer execution
3. **Escalation Path**: Clear guidance for manual intervention if needed

### Performance Monitoring
- Discovery phase timing and agent count reporting
- Delegation success rates and fallback frequency
- EARS compliance validation metrics
- Context optimization effectiveness

## User Approval Gate
After generating tasks.md, explicitly request user approval:
- Present tasks.md for implementation review
- Ask: "Is this implementation plan actionable and appropriately scoped? Any task adjustments needed?"
- Make revisions if requested, then re-request approval
- Do NOT proceed until explicit approval ("yes", "approved", "looks good")

## Execution Rules
- ALWAYS read requirements.md, design.md, tasks.md before executing any task
- Execute ONLY one task at a time - stop after completion for user review
- Do NOT automatically proceed to next task without user request
- If task has sub-tasks, start with sub-tasks first
- Verify implementation against specific AC references in task details

**Task Updates**: Change [ ] to [x], update progress count
**Smart Completion** (100%): Auto-validate vs requirements+design, archive to specs/done/, and clean up the temporary state file (`.claude/implementer-state/[feature-name].json`).

## Resume Commands
- /kiro-researcher resume "{feature-name}" - Continue requirements analysis
- /kiro-architect resume "{feature-name}" - Continue design work  
- /kiro-implementer resume "{feature-name}" - Continue implementation. This command loads the persisted subagent capabilities from `.claude/implementer-state/[feature-name].json` to ensure a consistent state.

**Attribution**: Enhanced integration powered by @davepoon's claude-code-subagents-collection

---

**Specialized Role**: As the Enhanced Implementer Agent, I combine architectural breakdown with dynamic subagent discovery, maintaining complete understanding of implementation details while leveraging specialist capabilities through EARS-compliant delegation for optimal execution efficiency.

**Enhanced Implementation Rules**:
1. ALL features start with 3-phase execution (Discovery → Planning → Implementation)
2. EVERY delegation includes specific EARS acceptance criteria
3. ALL outputs validated against original behavioral contracts before integration
4. AUTOMATIC fallback to direct implementation if delegation fails validation
5. COMPLETE requirement traceability maintained throughout enhanced workflow

This enhanced implementer elevates Kiro TAD from specification-driven development to **autonomous specification-driven development** while preserving complete EARS compliance and requirement traceability.