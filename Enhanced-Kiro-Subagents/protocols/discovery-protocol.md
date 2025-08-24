# Simple Subagent Discovery Protocol

## Purpose
Efficient discovery of available subagents from global and project directories.

## Discovery Locations
1. **Global**: `~/.claude/agents/` (from enhance-kiro-subagents.sh installation)
2. **Project**: `./.claude/agents/` (project-specific agents)
3. **Precedence**: Project agents override global agents with same name

## Discovery Process

### Method 1: Manifest-Based (Preferred)
1. Check for `subagents-manifest.json` in agents directory
2. Read agent list with specializations from manifest
3. Generate capabilities briefing from manifest data

### Method 2: File Scan (Fallback)  
1. If no manifest found, scan for `*.md` files in agents directory
2. Read frontmatter from each file to extract:
   - Agent name (from filename)
   - Specialization (from `category:` or `specialization:` field)
   - Purpose (from `description:` or first heading)
3. Group by specialization

## Discovery Output
Generate a simple capabilities briefing:

```
Available Subagents (Total: 42):
**Code Analysis**: @code-reviewer, @security-auditor, @performance-analyzer
**Testing**: @test-automator, @integration-tester, @load-tester
**Frontend**: @react-expert, @vue-specialist, @css-master
**Backend**: @api-designer, @database-expert, @microservice-architect
**Infrastructure**: @docker-specialist, @k8s-expert, @cloud-architect
```

## Manifest Format
Simple JSON structure in `subagents-manifest.json`:

```json
{
  "version": "1.0",
  "agents": [
    {
      "name": "code-reviewer",
      "specialization": "Code Analysis",
      "description": "Reviews code for quality and standards compliance"
    },
    {
      "name": "test-automator", 
      "specialization": "Testing",
      "description": "Creates comprehensive test suites"
    }
  ]
}
```

## Performance Targets
- **Manifest-based**: Complete discovery in <200ms for 300+ agents
- **File scan fallback**: Complete discovery in <500ms for 300+ agents
- **Memory usage**: <10MB during discovery process

## Error Handling
- If both global and project directories are missing: "No subagents found. Run ./enhance-kiro-subagents.sh to install."
- If manifest is corrupted: Fall back to file scan
- If no .md files found: Return empty capabilities list

## State Persistence
Save discovery results to `.claude/state/implementer-state/[feature-name].json` for:
- Resumable operations
- Performance optimization on subsequent runs
- Offline capability reference

This simple protocol ensures fast, reliable subagent discovery while maintaining fallback mechanisms for robustness.