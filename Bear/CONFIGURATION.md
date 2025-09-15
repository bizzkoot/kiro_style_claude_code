# Bear V2 Configuration Guide

## Overview

This guide covers detailed configuration options for Bear V2 agentic agent system, including memory management, performance tuning, integration settings, and advanced customization options.

## Configuration Files Location

### Global Installation
```
~/.claude/
├── state/bear/config.json          # Main Bear configuration
├── state/bear/memory-policy.json   # Memory management policies
├── state/bear/debug-config.json    # Debug and logging settings
└── agents/agent-performance.json   # Agent performance database
```

### Project-Specific Installation
```
./.claude/
├── state/bear/config.json          # Project-specific Bear config
├── state/bear/memory-policy.json   # Project memory policies
├── state/bear/debug-config.json    # Project debug settings
└── agents/agent-performance.json   # Project agent performance
```

## Core Configuration (`config.json`)

### Basic Structure
```json
{
  "bear_version": "2.0.0",
  "installation_date": "2025-01-15T10:30:00Z",
  "installation_path": "/path/to/.claude",
  "memory": { ... },
  "performance": { ... },
  "workflows": { ... },
  "integration": { ... },
  "debug": { ... }
}
```

### Memory System Configuration

```json
{
  "memory": {
    "max_projects": 100,
    "retention_days": 365,
    "auto_cleanup": true,
    "semantic_search": true,
    "compression_enabled": true,
    "index_rebuild_frequency": "weekly",
    "backup_enabled": false,
    "backup_location": "/path/to/backup",
    "search_timeout_ms": 5000,
    "max_search_results": 50
  }
}
```

**Configuration Options:**
- `max_projects`: Maximum number of project memories to retain (default: 100)
- `retention_days`: Days to keep project memories (default: 365)
- `auto_cleanup`: Automatically remove old memories (default: true)
- `semantic_search`: Enable semantic search capabilities (default: true)
- `compression_enabled`: Compress old memory files (default: true)
- `index_rebuild_frequency`: When to rebuild search index ("daily", "weekly", "monthly")
- `backup_enabled`: Create backups of memory system (default: false)
- `search_timeout_ms`: Maximum time for memory searches in milliseconds
- `max_search_results`: Maximum number of search results to return

### Performance Tracking Configuration

```json
{
  "performance": {
    "tracking_enabled": true,
    "min_tasks_for_rating": 5,
    "performance_weight_recent": 0.7,
    "auto_agent_selection": true,
    "success_threshold": 0.8,
    "speed_weight": 0.3,
    "quality_weight": 0.7,
    "learning_rate": 0.1,
    "performance_decay": 0.05
  }
}
```

**Configuration Options:**
- `tracking_enabled`: Enable agent performance tracking (default: true)
- `min_tasks_for_rating`: Minimum tasks before performance rating is reliable
- `performance_weight_recent`: Weight given to recent performance vs. historical
- `auto_agent_selection`: Automatically select best agents based on performance
- `success_threshold`: Minimum success rate to consider agent effective
- `speed_weight`: Importance of task completion speed (0.0-1.0)
- `quality_weight`: Importance of task quality (0.0-1.0)
- `learning_rate`: How quickly performance metrics adapt to new data
- `performance_decay`: Rate at which old performance data becomes less relevant

### Workflow Configuration

```json
{
  "workflows": {
    "complexity_threshold": 3,
    "parallel_execution": true,
    "reflexive_learning": true,
    "ears_compliance": true,
    "max_parallel_tasks": 4,
    "task_timeout_minutes": 30,
    "retry_failed_tasks": true,
    "max_retries": 2,
    "fast_track_criteria": {
      "max_subtasks": 3,
      "estimated_time_minutes": 15,
      "requires_research": false
    },
    "fast_track_confirmation": {
      "enabled": true,
      "timeout_seconds": 60,
      "show_agent_metrics": true,
      "show_risk_assessment": true,
      "show_affected_files": true,
      "allow_plan_modification": true,
      "auto_escalate_on_modify": false,
      "confirmation_prompts": {
        "accept": ["y", "yes", "proceed", "ok", "confirm", "continue"],
        "decline": ["n", "no", "abort", "cancel", "stop"],
        "modify": ["modify", "change", "adjust", "edit", "different"]
      }
    }
  }
}
```

**Configuration Options:**
- `complexity_threshold`: Complexity score threshold for Deep Dive workflow (1-10)
- `parallel_execution`: Enable parallel task execution (default: true)
- `reflexive_learning`: Enable reflexive learning from errors (default: true)
- `ears_compliance`: Maintain EARS compliance in all workflows (default: true)
- `max_parallel_tasks`: Maximum number of tasks to run simultaneously
- `task_timeout_minutes`: Maximum time allowed for individual tasks
- `retry_failed_tasks`: Automatically retry failed tasks (default: true)
- `max_retries`: Maximum number of retry attempts per task

**Fast Track Confirmation Options:**
- `fast_track_confirmation.enabled`: Enable plan confirmation for Fast Track workflow (default: true)
- `fast_track_confirmation.timeout_seconds`: Time to wait for user response before re-prompting (default: 60)
- `fast_track_confirmation.show_agent_metrics`: Display agent performance data in plan (default: true)
- `fast_track_confirmation.show_risk_assessment`: Include risk analysis in plan display (default: true)
- `fast_track_confirmation.show_affected_files`: List all files that will be modified/created (default: true)
- `fast_track_confirmation.allow_plan_modification`: Allow user to request plan changes (default: true)
- `fast_track_confirmation.auto_escalate_on_modify`: Automatically escalate to Deep Dive on modification request (default: false)
- `fast_track_confirmation.confirmation_prompts`: Customizable response keywords for accept/decline/modify actions

### Integration Configuration

```json
{
  "integration": {
    "kiro_framework": true,
    "claude_code_agents": true,
    "existing_commands": true,
    "backward_compatibility": true,
    "command_prefix": "/bear",
    "memory_integration": {
      "kiro_specs": true,
      "implementer_state": true,
      "share_learnings": true
    },
    "agent_coordination": {
      "delegate_to_specialists": true,
      "preserve_context": true,
      "unified_reporting": true
    }
  }
}
```

**Integration Options:**
- `kiro_framework`: Enable Kiro framework integration
- `claude_code_agents`: Work with existing Claude Code agents
- `existing_commands`: Respect existing command structure
- `backward_compatibility`: Maintain compatibility with older versions
- `command_prefix`: Prefix for Bear commands (default: "/bear")

### Debug Configuration

```json
{
  "debug": {
    "enabled": false,
    "log_level": "info",
    "log_file": "/path/to/.claude/state/bear/debug.log",
    "max_log_size_mb": 10,
    "log_rotation": true,
    "verbose_memory": false,
    "trace_performance": false,
    "profile_workflows": false
  }
}
```

**Debug Options:**
- `enabled`: Enable debug logging (default: false)
- `log_level`: Logging level ("error", "warn", "info", "debug", "trace")
- `log_file`: Path to debug log file
- `max_log_size_mb`: Maximum log file size before rotation
- `verbose_memory`: Detailed memory system logging
- `trace_performance`: Trace performance metrics in detail
- `profile_workflows`: Profile workflow execution times

## Agent Performance Database (`agent-performance.json`)

### Structure
```json
{
  "version": "2.0.0",
  "last_updated": "2025-01-15T10:30:00Z",
  "agents": {
    "agent-name": {
      "total_tasks": 0,
      "success_rate": 0.85,
      "avg_completion_time": 120,
      "specializations": ["domain1", "domain2"],
      "performance_by_domain": {
        "web-development": {
          "tasks": 25,
          "success_rate": 0.92,
          "avg_time": 110
        }
      },
      "recent_performance": [
        {
          "date": "2025-01-15",
          "success": true,
          "time_minutes": 8,
          "domain": "api-development"
        }
      ]
    }
  },
  "default_selections": {
    "domain": "preferred-agent"
  },
  "selection_criteria": {
    "prefer_recent_success": true,
    "domain_specialization_weight": 0.8,
    "speed_vs_quality_balance": 0.6
  }
}
```

### Adding Custom Agents
```json
{
  "agents": {
    "your-custom-agent": {
      "total_tasks": 0,
      "success_rate": 0.75,
      "avg_completion_time": 150,
      "specializations": ["custom-domain", "specific-tech"],
      "performance_by_domain": {},
      "recent_performance": [],
      "custom_properties": {
        "preferred_for": ["specific-task-type"],
        "avoid_for": ["incompatible-task-type"],
        "requires_setup": false
      }
    }
  }
}
```

## Memory Policy Configuration (`memory-policy.json`)

### Complete Memory Policy
```json
{
  "retention": {
    "successful_projects": "1_year",
    "failed_projects": "6_months",
    "learning_entries": "permanent",
    "performance_data": "permanent",
    "debug_logs": "30_days",
    "temp_files": "7_days"
  },
  "optimization": {
    "semantic_index_rebuild": "weekly",
    "performance_analysis": "monthly",
    "memory_compression": "quarterly",
    "backup_creation": "monthly"
  },
  "privacy": {
    "anonymize_sensitive_data": true,
    "exclude_patterns": [
      "*.key",
      "*.secret",
      "*.token",
      "*.password",
      "*.env"
    ],
    "encryption_enabled": false,
    "secure_deletion": true
  },
  "limits": {
    "max_memory_size_gb": 5,
    "max_project_memories": 100,
    "max_learning_entries": 1000,
    "warn_at_size_gb": 4
  }
}
```

**Policy Options:**
- **Retention**: How long to keep different types of data
- **Optimization**: When to perform maintenance tasks  
- **Privacy**: Data protection and anonymization settings
- **Limits**: Storage and quantity limits

## Environment-Specific Configuration

### Development Environment
```json
{
  "debug": {
    "enabled": true,
    "log_level": "debug",
    "verbose_memory": true,
    "trace_performance": true
  },
  "workflows": {
    "task_timeout_minutes": 60,
    "max_retries": 3
  },
  "memory": {
    "retention_days": 90,
    "auto_cleanup": false
  }
}
```

### Production Environment
```json
{
  "debug": {
    "enabled": false,
    "log_level": "error"
  },
  "workflows": {
    "task_timeout_minutes": 15,
    "max_retries": 1
  },
  "memory": {
    "retention_days": 365,
    "auto_cleanup": true,
    "compression_enabled": true
  },
  "performance": {
    "performance_weight_recent": 0.8
  }
}
```

### Team Environment
```json
{
  "memory": {
    "backup_enabled": true,
    "backup_location": "/shared/bear-backup"
  },
  "integration": {
    "share_learnings": true,
    "unified_reporting": true
  },
  "privacy": {
    "anonymize_sensitive_data": true,
    "secure_deletion": true
  }
}
```

## Advanced Configuration

### Custom Agent Specialization
```json
{
  "custom_specializations": {
    "machine-learning": {
      "preferred_agents": ["python-expert", "data-scientist"],
      "complexity_boost": 1.5,
      "requires_research": true
    },
    "blockchain-development": {
      "preferred_agents": ["blockchain-developer", "security-auditor"],
      "complexity_boost": 2.0,
      "parallel_discouraged": true
    }
  }
}
```

### Workflow Customization
```json
{
  "custom_workflows": {
    "security-focused": {
      "always_include_agents": ["security-auditor"],
      "additional_validation": true,
      "enhanced_logging": true
    },
    "rapid-prototyping": {
      "prefer_fast_track": true,
      "skip_deep_research": true,
      "reduced_validation": true
    }
  }
}
```

### Memory Enhancement
```json
{
  "memory_enhancements": {
    "semantic_tags": {
      "auto_generate": true,
      "ml_tagging": false,
      "custom_taxonomy": "/path/to/taxonomy.json"
    },
    "cross_project_learning": {
      "enabled": true,
      "similarity_threshold": 0.7,
      "max_similar_projects": 5
    },
    "predictive_suggestions": {
      "enabled": true,
      "confidence_threshold": 0.8,
      "suggest_agents": true,
      "suggest_approaches": true
    }
  }
}
```

## Configuration Validation

### Validation Script
Create a configuration validator:

```bash
#!/bin/bash
# validate-config.sh
python3 -c "
import json
import sys

try:
    with open('$1', 'r') as f:
        config = json.load(f)
    
    # Validate required fields
    required = ['bear_version', 'memory', 'performance', 'workflows']
    for field in required:
        if field not in config:
            print(f'Missing required field: {field}')
            sys.exit(1)
    
    # Validate version
    if config['bear_version'] != '2.0.0':
        print(f'Version mismatch: {config[\"bear_version\"]}')
        sys.exit(1)
    
    print('Configuration valid')
    sys.exit(0)
    
except json.JSONDecodeError as e:
    print(f'JSON syntax error: {e}')
    sys.exit(1)
except Exception as e:
    print(f'Validation error: {e}')
    sys.exit(1)
"
```

### Configuration Backup
```bash
#!/bin/bash
# backup-config.sh
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.claude/backups/config-$DATE"

mkdir -p "$BACKUP_DIR"
cp ~/.claude/state/bear/*.json "$BACKUP_DIR/"
cp ~/.claude/agents/agent-performance.json "$BACKUP_DIR/"

echo "Configuration backed up to: $BACKUP_DIR"
```

## Performance Tuning

### Memory Optimization
- **Large Projects**: Increase `max_projects` and enable compression
- **Limited Storage**: Reduce `retention_days` and enable auto-cleanup
- **Fast Search**: Keep `semantic_search` enabled, tune `search_timeout_ms`

### Agent Selection Optimization
- **Consistent Team**: Increase `performance_weight_recent` to 0.8+
- **Diverse Projects**: Decrease to 0.5-0.6 for more historical weight
- **Quality Focus**: Increase `quality_weight`, decrease `speed_weight`

### Workflow Optimization
- **Simple Projects**: Lower `complexity_threshold` to prefer Fast Track
- **Complex Projects**: Increase `max_parallel_tasks` if resources allow
- **Time-Critical**: Reduce `task_timeout_minutes`

## Troubleshooting Configuration Issues

### Common Problems

1. **JSON Syntax Errors**
   ```bash
   python3 -m json.tool ~/.claude/state/bear/config.json
   ```

2. **Permission Issues**
   ```bash
   chmod 644 ~/.claude/state/bear/*.json
   chmod 755 ~/.claude/state/bear/
   ```

3. **Memory Policy Conflicts**
   - Ensure retention periods are realistic
   - Check disk space limits vs. `max_memory_size_gb`
   - Verify privacy settings don't conflict with functionality

4. **Performance Database Corruption**
   ```bash
   # Reset to defaults
   cp agent-performance-template.json ~/.claude/agents/agent-performance.json
   ```

### Configuration Reset
```bash
#!/bin/bash
# reset-bear-config.sh
echo "Resetting Bear V2 configuration to defaults..."

# Backup current config
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p ~/.claude/backups/reset-$DATE
cp ~/.claude/state/bear/*.json ~/.claude/backups/reset-$DATE/ 2>/dev/null || true

# Recreate default configuration
./install-bear.sh --config-only

echo "Configuration reset complete. Backup saved to ~/.claude/backups/reset-$DATE"
```

## Configuration Best Practices

### Security
- Keep `debug.enabled` false in production
- Enable `privacy.anonymize_sensitive_data` for team environments
- Use secure file permissions (644 for config files, 700 for directories)
- Regularly rotate debug logs

### Performance
- Monitor memory usage with `limits.warn_at_size_gb`
- Tune `performance_weight_recent` based on your team's consistency
- Adjust `complexity_threshold` based on your typical project types
- Enable compression for long-term memory storage

### Maintenance
- Set up automated backups for critical configurations
- Schedule regular performance analysis
- Monitor and clean debug logs
- Update agent performance data periodically

### Team Collaboration
- Standardize configuration across team members
- Share successful agent performance data
- Use consistent memory policies
- Document any custom specializations or workflows

---

This configuration guide provides comprehensive control over Bear V2's behavior. Start with the default settings and gradually customize based on your specific needs and usage patterns.