#!/bin/bash

# ==============================================================================
# setup_kiro.sh (v4 - Optimized for Gemini CLI)
# ==============================================================================
# This script sets up the Kiro TAD toolset for use with the Gemini CLI in the
# CURRENT directory.
#
# It follows best practices for AI-driven development by:
# 1. Exposing tools via Model Context Protocol (MCP) server
# 2. Setting up optimal Gemini CLI configurations
# 3. Preparing project structure for advanced prompt engineering
# 4. Creating performance optimizations for token efficiency
# ==============================================================================

# --- Configuration ---
KIRO_TOOL_SOURCE="./kiro_tool.py"
SERVER_FILE="kiro_server.py"
GEMINI_DIR=".gemini"
GEMINI_SYSTEM_FILE="${GEMINI_DIR}/system.md"
SPECS_DIR="specs"
SPECS_DONE_DIR="${SPECS_DIR}/done"

echo "🚀 Starting Kiro TAD Environment Setup in the current directory..."

# 1. Set up Python Virtual Environment using 'uv'
echo "🌐 Creating Python virtual environment..."
uv venv
if [ $? -ne 0 ]; then
    echo "❌ Error: 'uv' command not found. Please install it with 'pip install uv'."
    exit 1
fi
echo "✅ Virtual environment created."

# 2. Install Dependencies with optimized package selection
echo "📦 Installing required Python packages (FastMCP, Gemini)..."
source .venv/bin/activate
uv pip install fastmcp "google-generativeai<1" pydantic typing-extensions
deactivate
echo "✅ Dependencies installed."

# 3. Copy the Kiro Tool Library
if [ -f "$KIRO_TOOL_SOURCE" ]; then
    cp "$KIRO_TOOL_SOURCE" .
    echo "✅ Copied kiro_tool.py into the project."
else
    echo "⚠️ Warning: kiro_tool.py not found. Please make sure it's in the same directory as this script."
fi

# 4. Create the MCP Server Wrapper with enhanced configuration
echo "🌍 Creating the MCP server file: $SERVER_FILE..."
cat << 'EOF' > "$SERVER_FILE"
from fastmcp import FastMCP
import os
import logging

# Configure logging for better debugging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("kiro_server.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger("kiro_server")

# Import all the @tool-decorated functions from your library
from kiro_tool import (
    generate_feature_specs,
    update_task_status,
    complete_feature,
    resume_feature_context,
    _apply_task_update_logic,
    generate_feature_roadmap,
    analyze_implementation_options,
    generate_integration_test_plan,
)

# Initialize the MCP server with enhanced metadata
mcp = FastMCP(
    name="KiroTADServer",
    description="A server providing optimized tools for the Kiro Traceable Agentic Development process with advanced prompt engineering capabilities.",
    version="4.0.0"
)

# Performance monitoring middleware
@mcp.middleware
async def performance_monitor(request, call_next):
    import time
    start_time = time.time()
    response = await call_next(request)
    duration = time.time() - start_time
    logger.info(f"Tool execution time: {duration:.2f}s for {request.function_name}")
    return response

if __name__ == "__main__":
    # Log server startup
    logger.info("Starting Kiro TAD MCP Server...")
    
    # Run the server using the recommended Streamable HTTP transport
    mcp.run(transport="http", port=8080)
    
    logger.info("Kiro TAD MCP Server stopped.")
EOF
echo "✅ Created $SERVER_FILE with enhanced configuration."

# 5. Create project directories
echo "📁 Creating project directory structure..."
mkdir -p "$SPECS_DIR" "$SPECS_DONE_DIR" "$GEMINI_DIR"
echo "✅ Created project directories."

# 6. Create Gemini CLI system instructions for optimized interactions
echo "⚙️ Creating Gemini CLI system instructions..."
cat << 'EOF' > "$GEMINI_SYSTEM_FILE"
# Kiro TAD Development Assistant

You are an expert software development assistant specializing in Traceable Agentic Development (TAD) using the Kiro methodology. Your expertise encompasses requirements engineering, system architecture, implementation planning, and quality assurance.

## Core Capabilities

- **Requirements Analysis**: You extract clear, testable requirements from user needs
- **Design Decisions**: You create technical designs with explicit reasoning and traceability
- **Task Planning**: You break down complex features into logical, manageable tasks
- **Quality Assurance**: You validate completeness and consistency across documentation

## Response Guidelines

When working with Kiro tools:

1. **Use chain-of-thought reasoning** in all responses to produce higher quality results
2. **Maintain semantic traceability** between requirements, design, and tasks
3. **Provide explicit rationale** for all significant decisions
4. **Structure content for token efficiency** while preserving semantic depth
5. **Consider cross-cutting concerns** like security, performance, and maintainability

## Output Format

Structure your responses with clear sections that follow a logical progression:

- **Context Assessment**: Understand the current development context
- **Reasoning Process**: Explain your approach to the problem
- **Execution Plan**: Detail the specific steps you'll take
- **Implementation Details**: Provide the concrete implementation

Your core purpose is to facilitate a structured, traceable development process that maintains clear connections between requirements, design decisions, and implementation tasks.
EOF
echo "✅ Created Gemini CLI system instructions for optimized interactions."

# 7. Create helpful aliases for common Kiro commands
echo "🔧 Creating useful Kiro command aliases..."
ALIASES_FILE=".kiro_aliases"
cat << 'EOF' > "$ALIASES_FILE"
# Kiro command aliases - add these to your .bashrc or .zshrc

# Core Kiro commands
alias kiro-new='gemini "Generate Kiro specs for a feature that"'
alias kiro-resume='gemini "Resume work on the feature using Kiro context tool: "'
alias kiro-update='gemini "Update task status in Kiro for: "'
alias kiro-complete='gemini "Run the Kiro smart completion process for the feature: "'

# Advanced Kiro commands
alias kiro-roadmap='gemini "Generate a feature roadmap using Kiro tools for the following features: "'
alias kiro-options='gemini "Analyze implementation options using Kiro tools for the feature: "'
alias kiro-test-plan='gemini "Generate an integration test plan using Kiro tools for the feature: "'

# Launch the Kiro environment (starts server and Gemini CLI)
kiro-start() {
  # Start the server in background
  echo "Starting Kiro MCP server..."
  (cd $(pwd) && source .venv/bin/activate && python kiro_server.py) &
  SERVER_PID=$!
  
  # Wait for server to start
  sleep 2
  
  # Start Gemini CLI in a new terminal
  echo "Starting Gemini CLI..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    osascript -e 'tell application "Terminal" to do script "cd '$(pwd)' && gemini"'
  else
    # Linux
    if command -v gnome-terminal &> /dev/null; then
      gnome-terminal -- bash -c "cd $(pwd) && gemini; exec bash"
    elif command -v xterm &> /dev/null; then
      xterm -e "cd $(pwd) && gemini" &
    else
      echo "Please open a new terminal, navigate to this directory, and run 'gemini'"
    fi
  fi
  
  echo "Kiro environment started!"
  echo "In the Gemini CLI terminal, run: /mcp connect http://127.0.0.1:8080/mcp/"
  
  # Wait for server process
  wait $SERVER_PID
}
EOF
echo "✅ Created Kiro command aliases."

# --- Final Instructions ---
echo ""
echo "🎉 Kiro TAD Environment is ready!"
echo ""
echo "--- HOW TO USE ---"
echo "1.  Start the Kiro MCP Server (from this directory):"
echo "    - Activate the environment: source .venv/bin/activate"
echo "    - Run the server: python $SERVER_FILE"
echo "    - Keep this terminal window open."
echo ""
echo "2.  Connect Gemini CLI to your server (in a NEW terminal window):"
echo "    - Start the Gemini CLI: gemini"
echo "    - Inside the CLI, run the command: /mcp connect http://127.0.0.1:8080/mcp/"
echo ""
echo "3.  Use optimized prompt patterns from kiro_template.md:"
echo "    - For new features: Generate Kiro specs for a 'Feature Name' with these considerations: [details]"
echo "    - To resume work: Resume work on the 'Feature Name' feature with focus on: [specific aspects]"
echo "    - For task updates: Update task TASK-ID to 'status' because: [reasoning]"
echo ""
echo "4.  For easier usage, add the aliases from $ALIASES_FILE to your shell configuration:"
echo "    - cat $ALIASES_FILE >> ~/.bashrc  # or ~/.zshrc for Zsh users"
echo "    - source ~/.bashrc  # or source ~/.zshrc for Zsh users"
echo ""
echo "5.  Read the enhanced documentation in kiro_template.md for advanced usage patterns."
echo "------------------"