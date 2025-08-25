# 🐻 Bear V2 Agentic Agent

**Advanced Adaptive Task-Oriented Planning (ATOP) for Claude Code**

Bear V2 is a sophisticated agentic developer protocol that brings adaptive workflows, persistent memory, reflexive learning, and dynamic agent selection to Claude Code CLI environments.

## 🌟 Key Features

- **🧠 Adaptive Workflows**: Automatic complexity triage between Fast Track and Deep Dive approaches
- **💾 Persistent Memory System**: Semantic search across all project histories and learnings
- **🔄 Reflexive Learning**: Deep analysis and prevention of repeated errors
- **⚡ Dynamic Agent Selection**: Performance-based agent selection with continuous optimization
- **🎯 EARS Integration**: Full specification compliance and validation
- **🤝 Kiro Compatible**: Seamless integration with existing Kiro framework

## 🚀 Quick Start

### 1. Install Bear V2
```bash
cd Bear/
chmod +x install-bear.sh
./install-bear.sh
```

### 2. Validate Installation
```bash
./validate-bear.sh
```

### 3. Start Using Bear
```bash
# Full adaptive workflow
/bear "help me implement user authentication"

# Search memory system
/bear-memory "authentication patterns"

# Fast track for simple tasks
/bear-fast "add logging to this function"

# Deep dive for complex projects
/bear-deep "design a scalable microservices architecture"
```

## 📁 Repository Structure

```
Bear/
├── 📋 INSTALLATION.md          # Complete installation guide
├── ⚙️  CONFIGURATION.md         # Detailed configuration options
├── 🔧 TROUBLESHOOTING.md       # Comprehensive troubleshooting
├── 🐻 bear_protocol.md         # Core Bear V2 protocol specification
├── 🧠 knowledge_synthesizer_v2.md # Memory curation agent
├── 🛠️  install-bear.sh          # Automated installation script
├── ✅ validate-bear.sh          # Installation validation tool
└── 📖 README.md                # This file
```

## 📖 Documentation Overview

### [INSTALLATION.md](./INSTALLATION.md)
Complete standalone installation guide covering:
- System requirements and dependencies
- Global vs project-specific installation
- Manual installation steps
- Integration with existing systems
- Validation and testing procedures

### [CONFIGURATION.md](./CONFIGURATION.md) 
Detailed configuration reference including:
- Core configuration options
- Memory system settings
- Performance tracking tuning
- Workflow customization
- Environment-specific configurations

### [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
Comprehensive troubleshooting guide covering:
- Common installation issues
- Command and integration problems
- Memory system diagnostics
- Performance optimization
- Emergency recovery procedures

### [bear_protocol.md](./bear_protocol.md)
The complete Bear V2 protocol specification:
- Core architecture and principles
- Workflow definitions (Fast Track vs Deep Dive)
- Memory system architecture
- Agent selection algorithms
- EARS compliance integration

### [knowledge_synthesizer_v2.md](./knowledge_synthesizer_v2.md)
Knowledge Synthesizer agent specification:
- Memory curation protocols
- Performance analytics synthesis
- Semantic tagging systems
- Quality assurance processes

## 🛠️ Installation Options

### 🌍 Global Installation (Recommended for Personal Use)
- **Location**: `~/.claude/`
- **Scope**: Available to all Claude Code projects
- **Best for**: Personal development environments

### 📁 Project-Specific Installation
- **Location**: `./.claude/` (current project)
- **Scope**: Available only to this project
- **Best for**: Team projects, isolated environments

### ⚡ One-Command Installation
```bash
# Global installation
./install-bear.sh
# Select option 1 when prompted

# Project-specific installation
./install-bear.sh
# Select option 2 when prompted
```

## 🧠 Bear V2 Architecture

### Adaptive Workflow Engine
```
User Request → Assess & Recall → Triage Complexity
                                      ↙        ↘
                            Fast Track        Deep Dive
                               ↓                ↓
                        Quick Execution    Research → Plan → Execute
                               ↓                ↓
                        Learn & Update ← Learn & Synthesize
```

### Memory System
```
~/.claude/memory/
├── projects/           # Individual project memories
├── templates/          # Reusable patterns and templates
└── patterns/          # Architectural and code patterns

Memory Entry Structure:
├── memory-summary.md   # Searchable project summary
├── reflection-log.md   # Learning entries and insights
└── technical-artifacts/ # Reusable code and configs
```

### Agent Performance Tracking
```json
{
  "agents": {
    "backend-architect": {
      "success_rate": 0.92,
      "avg_completion_time": 110,
      "specializations": ["api", "database", "architecture"]
    }
  }
}
```

## 🎯 Usage Patterns

### Basic Workflow
```bash
# 1. Start with Bear for adaptive planning
/bear "I need to add real-time notifications to my app"

# 2. Bear assesses complexity and suggests approach
# 3. For complex tasks, Bear creates detailed plan
# 4. Bear executes using optimal agent combinations
# 5. Bear learns from results and updates performance data
```

### Memory-Driven Development
```bash
# Search for relevant past solutions
/bear-memory "websocket implementation"

# Apply learnings to current project
/bear "implement websockets using the patterns from project-2024-auth"

# Bear automatically incorporates past learnings
```

### Integration with Kiro Framework
```bash
# Bear enhances Kiro's specification-driven approach
/bear "create user authentication feature"
# → Bear plans, then delegates to /kiro-implementer for execution

# Kiro specifications feed into Bear's memory system
# Bear's learnings improve future Kiro specifications
```

## 🔧 Configuration Highlights

### Memory Configuration
```json
{
  "memory": {
    "max_projects": 100,
    "retention_days": 365,
    "semantic_search": true,
    "auto_cleanup": true
  }
}
```

### Performance Tuning
```json
{
  "performance": {
    "auto_agent_selection": true,
    "performance_weight_recent": 0.7,
    "success_threshold": 0.8
  }
}
```

### Workflow Customization
```json
{
  "workflows": {
    "complexity_threshold": 3,
    "parallel_execution": true,
    "reflexive_learning": true,
    "ears_compliance": true
  }
}
```

## 🤖 Available Commands

| Command | Description | Use Case |
|---------|-------------|----------|
| `/bear [task]` | Full adaptive workflow with complexity triage | General development tasks |
| `/bear-fast [task]` | Fast Track workflow for simple, well-defined tasks | Quick fixes, simple implementations |
| `/bear-deep [task]` | Deep Dive workflow for complex, multi-faceted projects | Architecture design, complex features |
| `/bear-memory [query]` | Search and recall from persistent memory system | Find past solutions, patterns, learnings |

## 🔍 Validation & Testing

### Quick Validation
```bash
# Run comprehensive validation
./validate-bear.sh

# Expected output:
# ✅ Directory structure: OK
# ✅ Bear protocol: INSTALLED  
# ✅ Bear commands: INSTALLED
# ✅ Performance tracking: CONFIGURED
# ✅ Knowledge Synthesizer: INSTALLED
```

### Health Check
```bash
# Check memory system
ls ~/.claude/memory/projects/

# Test command availability
claude --help | grep bear

# Validate configuration
python3 -m json.tool ~/.claude/state/bear/config.json
```

## 🚨 Emergency Procedures

### Quick Reset
```bash
# If Bear seems broken, quick diagnostic:
./validate-bear.sh

# If validation fails, reinstall:
./install-bear.sh
```

### Complete Reset
```bash
# WARNING: Removes all Bear data and memories
rm -rf ~/.claude/memory ~/.claude/agents/agent-performance.json
./install-bear.sh
```

## 🔗 Integration Points

### With Kiro Framework
- Bear's adaptive planning + Kiro's structured specifications
- Shared EARS compliance and validation
- Memory system enhances specification quality
- Performance tracking across both systems

### With Claude Code CLI
- Native command integration
- Existing agent compatibility
- Preserved workflow patterns
- Enhanced with persistent learning

### With Development Tools
- Git integration for project tracking
- IDE compatibility through Claude Code
- CI/CD enhancement through memory-driven insights
- Team collaboration through shared learnings

## 📊 Performance Metrics

Bear V2 tracks and optimizes:
- **Agent Success Rates**: Which agents perform best for which tasks
- **Task Completion Times**: Speed optimization without quality loss
- **Complexity Assessment Accuracy**: How well Bear predicts task complexity
- **Memory System Usage**: Search effectiveness and relevance
- **Learning Loop Effectiveness**: How well Bear prevents repeated mistakes

## 🛡️ Security & Privacy

- **Memory Privacy**: Configurable anonymization of sensitive data
- **Secure Storage**: Appropriate file permissions for memory and config
- **Debug Logging**: Controlled debug output with rotation
- **Team Safety**: Options for shared vs. private memory systems

## 🔄 Continuous Improvement

Bear V2 continuously improves through:
- **Reflexive Learning**: Deep analysis of errors and successes
- **Performance Tracking**: Continuous optimization of agent selection
- **Memory Synthesis**: Automatic knowledge curation and pattern recognition
- **User Feedback Integration**: Adaptation based on user preferences and outcomes

## 🆘 Getting Help

1. **Check Documentation**: Start with INSTALLATION.md, CONFIGURATION.md, or TROUBLESHOOTING.md
2. **Run Diagnostics**: Use `./validate-bear.sh` for immediate health check
3. **Enable Debug Logging**: Set `"debug": {"enabled": true}` in config.json
4. **Collect Information**: Use diagnostic scripts in TROUBLESHOOTING.md
5. **Reset if Needed**: Emergency procedures are documented

## 🎯 Best Practices

- **Start Simple**: Use default configurations initially, customize gradually
- **Monitor Performance**: Check agent success rates and adjust selection criteria
- **Regular Maintenance**: Clean old memories, update performance data
- **Team Coordination**: Share successful configurations and learnings
- **Security First**: Use appropriate privacy settings for team environments

---

## 🚀 Ready to Transform Your Development Workflow?

Bear V2 represents the future of AI-assisted development: adaptive, learning, and continuously improving. It's not just a tool—it's your development partner that gets smarter with every project.

**Install now and experience the power of truly intelligent development assistance!**

```bash
./install-bear.sh
# Choose your installation type
# Start developing with /bear [your-task]
```

🐻 **Welcome to the Bear V2 ecosystem—where every project makes you smarter for the next one!**