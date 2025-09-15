# Bear V2 Troubleshooting Guide

## Quick Diagnostics

If you're experiencing issues with Bear V2, start here:

```bash
# Run the comprehensive validation script
./validate-bear.sh

# Check basic installation
ls -la ~/.claude/protocols/bear_protocol.md

# Test command availability  
claude --help | grep bear

# Check memory system
ls -la ~/.claude/memory/

# Validate configuration
python3 -m json.tool ~/.claude/state/bear/config.json
```

## Common Issues & Solutions

### 1. Installation Issues

#### Problem: "No Bear V2 installation detected"
**Symptoms:**
- `validate-bear.sh` reports no installation found
- Bear commands not available
- Missing protocol files

**Solution:**
```bash
# Verify installation location
ls -la ~/.claude/
ls -la ./.claude/

# Re-run installation
cd Bear/
./install-bear.sh

# If installation fails, check permissions
sudo chown -R $USER ~/.claude/
chmod -R 755 ~/.claude/
```

#### Problem: "Permission denied" during installation
**Symptoms:**
- Installation script fails with permission errors
- Cannot create directories
- Cannot write configuration files

**Solution:**
```bash
# Fix home directory permissions
chmod 755 $HOME
chmod -R 755 ~/.claude/

# For project-specific installation
chmod -R 755 ./.claude/

# If still failing, check disk space
df -h
```

#### Problem: "Directory already exists" warnings
**Symptoms:**
- Installation shows directory exists warnings
- Some files not overwritten
- Configuration seems incomplete

**Solution:**
```bash
# Clean installation (WARNING: removes all Bear data)
rm -rf ~/.claude/memory ~/.claude/agents ~/.claude/protocols
./install-bear.sh

# Or selective cleanup
rm ~/.claude/state/bear/config.json
./install-bear.sh --config-only
```

### 2. Command Issues

#### Problem: Bear commands not recognized
**Symptoms:**
- `/bear` command shows "command not found"
- Claude doesn't recognize Bear agents
- Commands exist in files but not working

**Diagnostics:**
```bash
# Check command files exist
ls -la ~/.claude/commands/bear*.md

# Verify Claude recognizes commands
claude --list-commands | grep bear

# Check frontmatter format
head -10 ~/.claude/commands/bear.md
```

**Solutions:**
```bash
# Recreate command files
cd Bear/
./install-bear.sh --commands-only

# Check Claude configuration
claude config show

# Restart Claude daemon if running
claude daemon restart
```

#### Problem: Commands exist but don't load protocol
**Symptoms:**
- Bear command loads but shows basic behavior
- No access to memory system
- Missing Bear-specific features

**Solution:**
```bash
# Verify protocol file location and path
ls -la ~/.claude/protocols/bear_protocol.md

# Check command file references correct path
grep "bear_protocol.md" ~/.claude/commands/bear.md

# Update path in command file if needed
sed -i 's|/old/path/bear_protocol.md|~/.claude/protocols/bear_protocol.md|g' ~/.claude/commands/bear.md
```

#### Problem: Fast Track plan confirmation not working
**Symptoms:**
- `/bear-fast` executes immediately without showing plan
- No user confirmation prompt appears
- Configuration settings seem ignored

**Diagnostics:**
```bash
# Check Fast Track confirmation configuration
grep -A 10 "fast_track_confirmation" ~/.claude/state/bear/config.json

# Verify FAST_TRACK_EXAMPLES.md is installed
ls -la ~/.claude/protocols/FAST_TRACK_EXAMPLES.md

# Test configuration JSON validity
python3 -m json.tool ~/.claude/state/bear/config.json
```

**Solutions:**
```bash
# Enable Fast Track confirmation in config
cat > ~/.claude/state/bear/config-patch.json << 'EOF'
{
  "workflows": {
    "fast_track_confirmation": {
      "enabled": true,
      "timeout_seconds": 60,
      "show_agent_metrics": true,
      "show_affected_files": true
    }
  }
}
EOF

# Merge configuration (requires jq)
jq -s '.[0] * .[1]' ~/.claude/state/bear/config.json ~/.claude/state/bear/config-patch.json > ~/.claude/state/bear/config.json.tmp
mv ~/.claude/state/bear/config.json.tmp ~/.claude/state/bear/config.json

# Or reinstall with latest configuration
cd Bear/
./install-bear.sh --config-only
```

### 3. Memory System Issues

#### Problem: Memory searches return no results
**Symptoms:**
- `/bear-memory` queries return empty
- No memory entries found
- Search appears to work but finds nothing

**Diagnostics:**
```bash
# Check memory directory structure
find ~/.claude/memory -type f -name "*.md" | head -10

# Check memory permissions
ls -la ~/.claude/memory/

# Test memory creation
mkdir -p ~/.claude/memory/test-$$
echo "# Test" > ~/.claude/memory/test-$$/memory-summary.md
```

**Solutions:**
```bash
# Fix memory permissions
chmod -R 755 ~/.claude/memory/
chmod -R 644 ~/.claude/memory/**/*.md

# Recreate sample memory
cd Bear/
./install-bear.sh --sample-memory

# Check memory policy configuration
cat ~/.claude/state/bear/memory-policy.json
```

#### Problem: Memory system slow or unresponsive  
**Symptoms:**
- Memory searches timeout
- Long delays accessing memories
- High CPU usage during memory operations

**Solutions:**
```bash
# Check memory system size
du -sh ~/.claude/memory/

# Clean old memories
find ~/.claude/memory -name "*.md" -mtime +365 -delete

# Rebuild memory index
rm ~/.claude/memory/.index 2>/dev/null || true

# Tune performance settings
# Edit ~/.claude/state/bear/config.json:
# "search_timeout_ms": 10000,
# "max_search_results": 25
```

### 4. Performance Issues

#### Problem: Agent selection seems wrong
**Symptoms:**
- Bear selects inappropriate agents for tasks
- Performance ratings seem incorrect
- Agents with poor track records still selected

**Diagnostics:**
```bash
# Check performance database
cat ~/.claude/agents/agent-performance.json | python3 -m json.tool

# Look for agents with unrealistic ratings
python3 -c "
import json
with open('~/.claude/agents/agent-performance.json') as f:
    data = json.load(f)
    for agent, perf in data.get('agents', {}).items():
        if perf.get('success_rate', 0) > 1.0 or perf.get('success_rate', 0) < 0:
            print(f'Invalid rating for {agent}: {perf.get(\"success_rate\")}')
"
```

**Solutions:**
```bash
# Reset performance database
cp Bear/agent-performance-template.json ~/.claude/agents/agent-performance.json

# Adjust selection criteria in config.json:
# "prefer_recent_success": true,
# "domain_specialization_weight": 0.8

# Force performance recalculation
rm ~/.claude/agents/.performance-cache 2>/dev/null || true
```

#### Problem: Tasks timeout frequently
**Symptoms:**
- Bear reports task timeouts
- Workflows incomplete
- Repeated timeout messages

**Solution:**
```bash
# Edit ~/.claude/state/bear/config.json
# Increase timeout values:
# "task_timeout_minutes": 45,
# "max_retries": 3

# For complex projects, disable parallel execution temporarily:
# "parallel_execution": false
```

### 5. Integration Issues

#### Problem: Kiro integration not working
**Symptoms:**
- Bear doesn't recognize Kiro commands
- CLAUDE.md not updated with Bear commands
- No Kiro-Bear bridge functionality

**Diagnostics:**
```bash
# Check for Kiro framework
ls -la CLAUDE/CLAUDE.md
ls -la ./.claude/commands/kiro*.md

# Check for integration bridge
ls -la ~/.claude/protocols/bear-kiro-bridge.md
```

**Solutions:**
```bash
# Recreate integration
cd Bear/
./install-bear.sh --integration-only

# Manually add to CLAUDE.md if needed
cat >> CLAUDE.md << 'EOF'

## Bear V2 Commands
- `/bear [task]` - Full adaptive workflow
- `/bear-memory [query]` - Search memory system
EOF

# Check Kiro command accessibility
grep -r "kiro" ~/.claude/commands/
```

#### Problem: Memory integration conflicts with existing state
**Symptoms:**
- Bear memory conflicts with implementer-state
- Duplicate or conflicting state files
- Existing project state not recognized

**Solution:**
```bash
# Check state directory conflicts
ls -la ./.claude/state/
ls -la ./.claude/implementer-state/

# Migrate existing state if needed
mkdir -p ./.claude/state/legacy/
mv ./.claude/implementer-state/* ./.claude/state/legacy/ 2>/dev/null || true

# Update Bear to recognize legacy state
# Edit ~/.claude/state/bear/config.json:
# "integration": {
#   "legacy_state_path": "./.claude/state/legacy",
#   "migrate_legacy": true
# }
```

### 6. Configuration Issues

#### Problem: JSON syntax errors in configuration
**Symptoms:**
- Bear fails to load
- Configuration validation errors
- Python JSON parsing errors

**Diagnostics:**
```bash
# Validate all JSON files
python3 -m json.tool ~/.claude/state/bear/config.json
python3 -m json.tool ~/.claude/agents/agent-performance.json
python3 -m json.tool ~/.claude/state/bear/memory-policy.json
```

**Solutions:**
```bash
# Fix common JSON issues
# Remove trailing commas
sed -i 's/,\([[:space:]]*[}\]])/\1/g' ~/.claude/state/bear/config.json

# Fix quotes
sed -i 's/"/"/g; s/"/"/g' ~/.claude/state/bear/config.json

# Reset to default if corrupted
cd Bear/
cp config-templates/default-config.json ~/.claude/state/bear/config.json
```

#### Problem: Configuration values seem ignored
**Symptoms:**
- Changes to config.json don't take effect
- Bear uses default behavior despite custom config
- Settings revert after restart

**Solutions:**
```bash
# Check config file is in correct location
ls -la ~/.claude/state/bear/config.json

# Verify no duplicate config files
find ~/.claude -name "config.json" -type f

# Check for file permission issues
chmod 644 ~/.claude/state/bear/config.json

# Clear any cached configuration
rm ~/.claude/state/bear/.config-cache 2>/dev/null || true
```

### 7. Debug and Logging Issues

#### Problem: No debug logs generated
**Symptoms:**
- Debug logging enabled but no log files
- Cannot diagnose Bear behavior
- Log file missing or empty

**Solution:**
```bash
# Check debug configuration
grep -A5 '"debug"' ~/.claude/state/bear/config.json

# Ensure debug directory exists
mkdir -p ~/.claude/state/bear/logs/

# Enable debug mode
# Edit ~/.claude/state/bear/config.json:
# "debug": {
#   "enabled": true,
#   "log_level": "debug",
#   "log_file": "~/.claude/state/bear/debug.log"
# }

# Test logging
echo "Test log entry" >> ~/.claude/state/bear/debug.log
```

#### Problem: Log files too large
**Symptoms:**
- Debug logs consuming disk space
- Performance degradation
- Disk space warnings

**Solution:**
```bash
# Enable log rotation
# Edit ~/.claude/state/bear/config.json:
# "debug": {
#   "log_rotation": true,
#   "max_log_size_mb": 10
# }

# Manual cleanup
find ~/.claude/state/bear -name "*.log*" -size +10M -delete

# Compress old logs
gzip ~/.claude/state/bear/*.log.1 2>/dev/null || true
```

## Emergency Recovery Procedures

### Complete Bear Reset
```bash
#!/bin/bash
# emergency-reset.sh
echo "🚨 EMERGENCY BEAR RESET - This will remove ALL Bear data!"
read -p "Are you sure? (type 'RESET' to confirm): " confirm

if [[ "$confirm" == "RESET" ]]; then
    # Backup current installation
    DATE=$(date +%Y%m%d_%H%M%S)
    mkdir -p ~/bear-emergency-backup-$DATE
    cp -r ~/.claude ~/bear-emergency-backup-$DATE/ 2>/dev/null || true
    
    # Remove Bear files
    rm -rf ~/.claude/memory
    rm -rf ~/.claude/agents/agent-performance.json
    rm -rf ~/.claude/agents/knowledge-synthesizer-v2.md
    rm -rf ~/.claude/protocols/bear_protocol.md
    rm -rf ~/.claude/commands/bear*.md
    rm -rf ~/.claude/state/bear
    
    echo "✅ Bear reset complete. Backup saved to ~/bear-emergency-backup-$DATE"
    echo "Run './install-bear.sh' to reinstall"
else
    echo "Reset cancelled"
fi
```

### Selective Recovery
```bash
# Recover just configuration
cd Bear/
./install-bear.sh --config-only

# Recover just commands  
./install-bear.sh --commands-only

# Recover just memory system
mkdir -p ~/.claude/memory/{projects,templates,patterns}
./install-bear.sh --sample-memory
```

## Performance Diagnostics

### Memory Usage Check
```bash
#!/bin/bash
# memory-diagnostics.sh
echo "🧠 Bear Memory System Diagnostics"
echo

# Memory directory size
echo "Memory Usage:"
du -sh ~/.claude/memory/ 2>/dev/null || echo "Memory directory not found"
echo

# Count of memory entries
echo "Memory Counts:"
echo "Projects: $(find ~/.claude/memory/projects -name "memory-summary.md" 2>/dev/null | wc -l)"
echo "Templates: $(find ~/.claude/memory/templates -name "*.md" 2>/dev/null | wc -l)"
echo "Patterns: $(find ~/.claude/memory/patterns -name "*.md" 2>/dev/null | wc -l)"
echo

# Performance metrics
echo "Performance Database:"
if [[ -f ~/.claude/agents/agent-performance.json ]]; then
    python3 -c "
import json
with open('$HOME/.claude/agents/agent-performance.json') as f:
    data = json.load(f)
    agents = data.get('agents', {})
    print(f'Tracked agents: {len(agents)}')
    total_tasks = sum(agent.get('total_tasks', 0) for agent in agents.values())
    print(f'Total tasks tracked: {total_tasks}')
    avg_success = sum(agent.get('success_rate', 0) for agent in agents.values()) / len(agents) if agents else 0
    print(f'Average success rate: {avg_success:.2%}')
"
else
    echo "Performance database not found"
fi
```

### System Resource Check
```bash
#!/bin/bash
# resource-check.sh
echo "💻 System Resource Check for Bear V2"
echo

# Disk space
echo "Disk Space:"
df -h ~ | grep -E "(Filesystem|$(dirname "$HOME"))"
echo

# Memory usage
echo "Memory Usage:"
ps aux | grep -E "(python|claude)" | head -5

# File descriptors
echo "Open Files:"
lsof | grep -c "$HOME/.claude" || echo "0"
```

## Getting Help

### Diagnostic Information Collection
When seeking help, collect this diagnostic information:

```bash
#!/bin/bash
# collect-diagnostics.sh
DATE=$(date +%Y%m%d_%H%M%S)
DIAG_DIR="bear-diagnostics-$DATE"
mkdir -p "$DIAG_DIR"

echo "📋 Collecting Bear V2 diagnostic information..."

# System information
uname -a > "$DIAG_DIR/system-info.txt"
echo "Claude Code version:" >> "$DIAG_DIR/system-info.txt"
claude --version >> "$DIAG_DIR/system-info.txt" 2>&1

# Directory structure
find ~/.claude -type d 2>/dev/null > "$DIAG_DIR/directory-structure.txt"
find ~/.claude -name "*.json" -o -name "*.md" 2>/dev/null > "$DIAG_DIR/files-present.txt"

# Configuration files (sanitized)
cp ~/.claude/state/bear/config.json "$DIAG_DIR/" 2>/dev/null || echo "config.json missing" > "$DIAG_DIR/config-missing.txt"

# Error logs
tail -100 ~/.claude/state/bear/debug.log 2>/dev/null > "$DIAG_DIR/recent-logs.txt" || echo "No debug logs" > "$DIAG_DIR/no-logs.txt"

# Validation results
./validate-bear.sh > "$DIAG_DIR/validation-results.txt" 2>&1 || echo "Validation failed" >> "$DIAG_DIR/validation-results.txt"

echo "✅ Diagnostics collected in: $DIAG_DIR"
echo "📧 Share this directory when requesting support"
```

### Support Channels
1. **Check existing documentation** in Bear/ directory
2. **Run diagnostics** using the scripts above
3. **Search for similar issues** in troubleshooting guide
4. **Collect diagnostic information** before reporting issues

### Self-Help Checklist
Before seeking help:
- [ ] Ran `./validate-bear.sh`
- [ ] Checked file permissions (644 for files, 755 for directories)
- [ ] Verified disk space availability
- [ ] Tested with debug logging enabled
- [ ] Attempted configuration reset
- [ ] Collected diagnostic information

## Prevention Tips

### Regular Maintenance
```bash
# Weekly maintenance script
#!/bin/bash
# bear-maintenance.sh

# Clean old debug logs
find ~/.claude/state/bear -name "*.log" -mtime +7 -delete

# Compress old memories
find ~/.claude/memory -name "*.md" -mtime +90 -exec gzip {} \;

# Validate configuration
python3 -m json.tool ~/.claude/state/bear/config.json >/dev/null

# Check memory usage
USAGE=$(du -s ~/.claude/memory | cut -f1)
if [[ $USAGE -gt 1000000 ]]; then  # 1GB in KB
    echo "⚠️ Memory directory approaching size limits"
fi

echo "✅ Bear maintenance complete"
```

### Best Practices
- **Regular backups** of configuration and performance data
- **Monitor disk usage** in memory directories  
- **Update configurations** gradually, not all at once
- **Test changes** in development before production
- **Keep debug logs** at appropriate level for environment
- **Document customizations** for team members

---

This troubleshooting guide covers the most common issues with Bear V2. For complex problems, use the diagnostic tools provided and follow the systematic approach outlined above.