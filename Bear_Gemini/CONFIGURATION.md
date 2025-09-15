# BEAR V2 Configuration Guide (Gemini Edition)

This guide covers the necessary configuration for the BEAR V2 agent within the Gemini CLI environment.

**Note:** The installation script `install-bear.sh` handles all setup automatically. This guide is for reference only.

## 1. Directory Structure

The installer script creates the following directory structure within your home folder to store the command, personas, and performance data:

```
~/.gemini/
├── commands/
│   └── bear.toml               # The core BEAR V2 command and protocol
└── personas/
    ├── agent-performance.json  # The Agent Performance Database
    ├── subagents-manifest.json # Manifest of all installed personas
    └── *.toml                  # Individual persona files
```

## 2. Agent Performance Database

The core of BEAR V2's "Enhanced Agent Selection" is the `agent-performance.json` file. 

**This file is created automatically** by the `install-bear.sh` script. You do not need to create it manually.

### Bootstrap Schema (`agent-performance.json`)

The installer initializes the file with the following content, which is defined in the `bear.toml` protocol. BEAR V2 will update this file over time to track agent performance.

```json
{
  "version": "2.0.0",
  "last_updated": "2025-01-01T00:00:00Z",
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
```

### Key Fields:

*   **`version`**: The schema version.
*   **`last_updated`**: The timestamp of the last update.
*   **`agents`**: An object where each key is a persona name.
    *   `total_tasks`: Total tasks completed.
    *   `success_rate`: A value from 0.0 to 1.0.
    *   `avg_completion_time`: Average time in minutes.
    *   `specializations`: Keywords for domain matching.
*   **`default_selections`**: A fallback map to select a persona for a domain when performance data is insufficient.