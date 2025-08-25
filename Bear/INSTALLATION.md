# Bear V2 Agentic Agent - Standalone Installation Guide

## Overview

Bear V2 is an advanced agentic developer protocol that provides adaptive task-oriented planning (ATOP) with persistent memory, reflexive learning, and dynamic agent selection. This guide provides complete standalone installation instructions.

## Prerequisites

### System Requirements
- **Operating System**: macOS, Linux, or Windows with WSL
- **Claude Code CLI**: Latest version installed and configured
- **Disk Space**: Minimum 100MB for memory and agent files
- **Permissions**: Write access to home directory and project directories

### Dependencies
- **Git**: For repository operations (if using git-based memory)
- **Python 3.6+**: For JSON processing (optional but recommended)
- **Bash/Zsh**: For installation scripts

## Installation Types

Choose your installation type based on your needs:

### 1. Global Installation (Recommended for Personal Use)
- **Location**: `~/.claude/`
- **Scope**: Available to all Claude Code projects
- **Best for**: Personal development environments

### 2. Project-Specific Installation
- **Location**: `./project/.claude/`
- **Scope**: Available only to specific project
- **Best for**: Team projects, isolated environments

### 3. Hybrid Installation (Advanced)
- **Location**: Both global and project-specific
- **Scope**: Global defaults with project overrides
- **Best for**: Complex multi-project setups

## Quick Installation (Recommended)

### Step 1: Run the Auto-Installer

```bash
# Navigate to Bear directory
cd /path/to/your/project/Bear

# Run the installation script
chmod +x install-bear.sh
./install-bear.sh
```

### Step 2: Choose Installation Type
The installer will prompt you to select:
1. Global installation (`~/.claude/`)
2. Project-specific installation (`./project/.claude/`)
3. Cancel

### Step 3: Verify Installation
```bash
# Check directory structure
ls -la ~/.claude/  # for global
# or
ls -la ./.claude/  # for project-specific

# Verify Bear command availability
claude --help | grep bear
```

## Manual Installation

If you prefer manual installation or need custom configuration:

### Step 1: Create Directory Structure

#### For Global Installation:
```bash
# Create Bear directories
mkdir -p ~/.claude/{memory,agents,protocols,templates,state}

# Create Bear subdirectories
mkdir -p ~/.claude/memory/{projects,templates,patterns}
mkdir -p ~/.claude/agents/performance
mkdir -p ~/.claude/state/{bear,sessions}
```

#### For Project-Specific Installation:
```bash
# Create project Bear directories
mkdir -p ./.claude/{memory,agents,protocols,templates,state}

# Create Bear subdirectories
mkdir -p ./.claude/memory/{projects,templates,patterns}
mkdir -p ./.claude/agents/performance
mkdir -p ./.claude/state/{bear,sessions}
```

### Step 2: Install Bear Protocol Files

```bash
# Copy Bear protocol
cp bear_protocol.md ~/.claude/protocols/
# or for project-specific:
cp bear_protocol.md ./.claude/protocols/

# Copy Knowledge Synthesizer
cp knowledge_synthesizer_v2.md ~/.claude/agents/
# or for project-specific:
cp knowledge_synthesizer_v2.md ./.claude/agents/
```

### Step 3: Initialize Performance Tracking

```bash
# Create agent performance database
cat > ~/.claude/agents/agent-performance.json << 'EOF'
{
  "version": "2.0.0",
  "last_updated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "agents": {
    "backend-architect": {
      "total_tasks": 0,
      "success_rate": 0.85,
      "avg_completion_time": 120,
      "specializations": ["api", "database", "architecture"],
      "performance_by_domain": {}
    },
    "frontend-developer": {
      "total_tasks": 0,
      "success_rate": 0.80,
      "avg_completion_time": 90,
      "specializations": ["react", "ui", "responsive"],
      "performance_by_domain": {}
    }
  },
  "default_selections": {
    "web-development": "backend-architect",
    "ui-design": "frontend-developer",
    "data-processing": "data-engineer",
    "devops": "devops-expert"
  }
}
EOF
```

### Step 4: Configure Bear Commands

#### Create Bear Command File:
```bash
# For global installation
cat > ~/.claude/commands/bear.md << 'EOF'
---
name: bear
description: "Master agentic developer with BEAR V2 protocol for adaptive task-oriented planning"
category: workflow-orchestration
version: "2.0.0"
---

# BEAR V2 Master Agent

You are BEAR, operating with the BEAR V2 (Reflexive) protocol for adaptive task-oriented planning.

## Core Directive
Achieve user goals with maximum efficiency through adaptive workflow selection, persistent memory, and reflexive learning.

## Protocol Location
Load the full BEAR V2 protocol from: `~/.claude/protocols/bear_protocol.md`

## Memory System
- **Location**: `~/.claude/memory/`
- **Performance Data**: `~/.claude/agents/agent-performance.json` 
- **Session State**: `~/.claude/state/bear/`

## Activation Commands
- `/bear [task-description]` - Full BEAR V2 workflow
- `/bear-fast [simple-task]` - Fast Track workflow only  
- `/bear-deep [complex-task]` - Deep Dive workflow only
- `/bear-memory [search-query]` - Search memory system

## Integration Points
- Compatible with existing Claude Code agents
- Enhances Kiro framework when present
- Works with EARS syntax and specifications

Execute with full BEAR V2 capabilities upon activation.
EOF

# For project-specific installation
cat > ./.claude/commands/bear.md << 'EOF'
[Same content as above, but update paths to ./.claude/]
EOF
```

### Step 5: Install Knowledge Synthesizer Agent

```bash
# Copy the synthesizer agent definition
cp knowledge_synthesizer_v2.md ~/.claude/agents/knowledge-synthesizer-v2.md
# or for project-specific:
cp knowledge_synthesizer_v2.md ./.claude/agents/knowledge-synthesizer-v2.md
```

## Integration with Existing Systems

### Kiro Framework Integration

If you have an existing Kiro framework setup:

```bash
# Create integration bridge
cat > ~/.claude/protocols/bear-kiro-bridge.md << 'EOF'
# Bear-Kiro Integration Bridge

## Memory Integration
- Bear memories integrate with Kiro specifications in `specs/`
- EARS compliance maintained across both systems
- Shared agent performance tracking

## Command Coordination  
- `/bear` can invoke `/kiro-*` agents for specialized tasks
- `/kiro-implementer` enhanced with Bear's memory system
- Unified reflection and learning system

## Workflow Coordination
- Bear's Deep Dive complements Kiro's spec-driven approach
- Shared EARS validation and acceptance criteria
- Combined debugging and learning loops

## Memory Mapping
- Kiro specs → Bear semantic memory
- Bear learnings → Kiro specification updates
- Shared performance analytics
EOF
```

### Claude Code CLI Integration

Update your `CLAUDE.md` file to include Bear commands:

```bash
# Add to existing CLAUDE.md or create new section
cat >> CLAUDE.md << 'EOF'

## Bear V2 Agentic Agent Commands

- `/bear [task-description]` - Full BEAR V2 adaptive workflow with memory and learning
- `/bear-fast [simple-task]` - Quick execution for well-defined tasks
- `/bear-deep [complex-task]` - Comprehensive planning for complex projects
- `/bear-memory [query]` - Search and recall from persistent memory system

### Bear Integration Benefits
- **Persistent Memory**: Learn from every project and interaction
- **Adaptive Workflows**: Automatic complexity triage and workflow selection  
- **Performance Tracking**: Continuous improvement of agent selection
- **Reflexive Learning**: Deep analysis and prevention of repeated errors
- **Parallel Execution**: DAG-based planning for efficient task coordination
EOF
```

## Configuration

### Memory Configuration

Configure Bear's memory system by editing `~/.claude/state/bear/config.json`:

```json
{
  "memory": {
    "max_projects": 100,
    "retention_days": 365,
    "auto_cleanup": true,
    "semantic_search": true
  },
  "performance": {
    "tracking_enabled": true,
    "min_tasks_for_rating": 5,
    "performance_weight_recent": 0.7
  },
  "workflows": {
    "complexity_threshold": 3,
    "parallel_execution": true,
    "auto_agent_selection": true
  },
  "integration": {
    "kiro_framework": true,
    "ears_compliance": true,
    "existing_agents": true
  }
}
```

### Agent Performance Tuning

Customize agent selection in `~/.claude/agents/agent-performance.json`:

```json
{
  "version": "2.0.0",
  "agents": {
    "your-custom-agent": {
      "total_tasks": 0,
      "success_rate": 0.75,
      "avg_completion_time": 150,
      "specializations": ["domain1", "domain2"],
      "performance_by_domain": {}
    }
  },
  "selection_criteria": {
    "prefer_recent_success": true,
    "domain_specialization_weight": 0.8,
    "speed_vs_quality_balance": 0.6
  }
}
```

## Validation and Testing

### Installation Validation

Run the validation script:

```bash
# Create and run validation script
cat > validate-bear-installation.sh << 'EOF'
#!/bin/bash

echo "🐻 Validating Bear V2 Installation..."

# Check directory structure
if [[ -d ~/.claude/memory && -d ~/.claude/agents ]]; then
    echo "✅ Directory structure: OK"
else
    echo "❌ Directory structure: MISSING"
    exit 1
fi

# Check protocol files
if [[ -f ~/.claude/protocols/bear_protocol.md ]]; then
    echo "✅ Bear protocol: INSTALLED"
else
    echo "❌ Bear protocol: MISSING"
fi

# Check command definition
if [[ -f ~/.claude/commands/bear.md ]]; then
    echo "✅ Bear commands: INSTALLED"
else
    echo "❌ Bear commands: MISSING"
fi

# Check performance tracking
if [[ -f ~/.claude/agents/agent-performance.json ]]; then
    echo "✅ Performance tracking: CONFIGURED"
else
    echo "❌ Performance tracking: MISSING"
fi

# Check knowledge synthesizer
if [[ -f ~/.claude/agents/knowledge-synthesizer-v2.md ]]; then
    echo "✅ Knowledge Synthesizer: INSTALLED"
else
    echo "❌ Knowledge Synthesizer: MISSING"
fi

echo "🎉 Bear V2 validation complete!"
EOF

chmod +x validate-bear-installation.sh
./validate-bear-installation.sh
```

### Memory System Test

Test Bear's memory functionality:

```bash
# Create test memory entry
mkdir -p ~/.claude/memory/test-project-$(date +%Y%m%d)
cat > ~/.claude/memory/test-project-$(date +%Y%m%d)/memory-summary.md << 'EOF'
# Test Memory Entry

**Project ID**: `test-bear-installation`
**Date**: `$(date -u +"%Y-%m-%d")` | **Status**: `SUCCESS`

## Test Results
- Directory structure: ✅ Created
- Protocol installation: ✅ Verified  
- Command integration: ✅ Functional
- Performance tracking: ✅ Initialized

## Semantic Tags
`#installation #test #bear-v2 #setup-complete`
EOF

echo "✅ Test memory entry created"
```

## Troubleshooting

### Common Issues

#### 1. Permission Denied Errors
```bash
# Fix permissions
chmod -R 755 ~/.claude/
# or for project-specific:
chmod -R 755 ./.claude/
```

#### 2. Command Not Found
```bash
# Verify Claude Code CLI recognizes commands
claude --list-commands | grep bear

# If not found, check command file location
ls -la ~/.claude/commands/bear.md
```

#### 3. Memory System Errors
```bash
# Clear and reinitialize memory
rm -rf ~/.claude/memory/*
mkdir -p ~/.claude/memory/{projects,templates,patterns}

# Reset performance tracking
cp agent-performance.json ~/.claude/agents/agent-performance.json
```

#### 4. JSON Configuration Errors
```bash
# Validate JSON files
python3 -m json.tool ~/.claude/agents/agent-performance.json
python3 -m json.tool ~/.claude/state/bear/config.json
```

### Debug Mode

Enable debug logging:

```bash
# Add to Bear configuration
echo '{"debug": {"enabled": true, "log_level": "verbose", "log_file": "~/.claude/state/bear/debug.log"}}' > ~/.claude/state/bear/debug-config.json
```

### Reset Installation

Complete reset if needed:

```bash
# WARNING: This removes all Bear data
rm -rf ~/.claude/memory/
rm -rf ~/.claude/agents/agent-performance.json
rm -rf ~/.claude/state/bear/
rm -rf ~/.claude/protocols/bear_protocol.md
rm -rf ~/.claude/commands/bear.md

# Then re-run installation
./install-bear.sh
```

## Advanced Configuration

### Multi-Project Setup

For teams managing multiple projects:

```bash
# Create project templates
mkdir -p ~/.claude/templates/bear-project-template/{memory,agents,state}

# Create project initialization script  
cat > ~/.claude/templates/bear-project-init.sh << 'EOF'
#!/bin/bash
PROJECT_NAME="$1"
if [[ -z "$PROJECT_NAME" ]]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

# Copy Bear template to project
cp -r ~/.claude/templates/bear-project-template ./.claude/
echo "🐻 Bear initialized for project: $PROJECT_NAME"
EOF
```

### Performance Optimization

Optimize Bear for large-scale usage:

```bash
# Configure memory retention
cat > ~/.claude/state/bear/memory-policy.json << 'EOF'
{
  "retention": {
    "successful_projects": "1_year", 
    "failed_projects": "6_months",
    "learning_entries": "permanent",
    "performance_data": "permanent"
  },
  "optimization": {
    "semantic_index_rebuild": "weekly",
    "performance_analysis": "monthly",
    "memory_compression": "quarterly"
  }
}
EOF
```

## Security Considerations

### File Permissions
```bash
# Secure Bear directories
chmod 700 ~/.claude/memory/
chmod 700 ~/.claude/state/bear/
chmod 644 ~/.claude/protocols/bear_protocol.md
```

### Memory Privacy
- Bear memories may contain sensitive project information
- Consider encryption for sensitive projects
- Regular cleanup of old memories recommended

### Agent Security
- Validate agent definitions before installation
- Monitor agent performance for anomalies
- Regular security updates of Bear protocol

## Support and Updates

### Getting Help
- Check the troubleshooting section above
- Review Bear protocol documentation in `bear_protocol.md`
- Search existing memory entries for similar issues

### Updates
- Bear V2 is designed to be backward-compatible
- Performance data is preserved across updates
- Memory format is stable and version-tracked

### Community
- Share successful Bear configurations
- Contribute agent performance improvements
- Report issues and enhancement requests

---

## Quick Reference

### Essential Commands
```bash
# Installation
./install-bear.sh

# Validation  
./validate-bear-installation.sh

# Usage
/bear [task-description]
/bear-memory [search-query]

# Maintenance
python3 -m json.tool ~/.claude/agents/agent-performance.json
```

### Directory Structure
```
~/.claude/
├── memory/           # Persistent project memories
├── agents/           # Agent definitions and performance
├── protocols/        # Bear protocol specification  
├── commands/         # Bear command definitions
├── state/bear/       # Runtime state and configuration
└── templates/        # Project templates
```

🐻 **Bear V2 is now ready for adaptive, intelligent development assistance!**