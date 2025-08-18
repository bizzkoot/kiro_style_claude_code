#!/bin/bash

# ANSI color codes for better UI
C_GREEN="\033[32m"
C_YELLOW="\033[33m"
C_CYAN="\033[36m"
C_RED="\033[31m"
C_RESET="\033[0m"

# --- Introduction ---
echo -e "${C_CYAN} Kiro Agent Setup Utility ✨${C_RESET}"
echo "This script will install the 'kiro' command for easy use in your terminal."
echo "It will:"
echo "  1. Move 'kiro_tool.py' to a permanent directory (~/gemini-tools/)."
echo "  2. Add a 'kiro' function to your shell configuration file."
echo ""

# --- Pre-flight Checks ---
# 1. Ensure kiro_tool.py exists
if [ ! -f "kiro_tool.py" ]; then
  echo -e "${C_RED}❌ Error: 'kiro_tool.py' not found.${C_RESET}"
  echo "Please make sure this setup script is in the same directory as kiro_tool.py."
  exit 1
fi

# 2. Ask for user confirmation
read -p "$(echo -e ${C_YELLOW}'Do you want to proceed? (y/n) '${C_RESET})" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Setup cancelled."
  exit 1
fi

# --- Installation Steps ---
echo -e "\n${C_CYAN}🚀 Starting installation...${C_RESET}"

# 1. Create directory and move the tool
TOOL_DIR="$HOME/gemini-tools"
mkdir -p "$TOOL_DIR"
mv "kiro_tool.py" "$TOOL_DIR/"
echo -e "${C_GREEN}✓ Copied tool to ${TOOL_DIR}/kiro_tool.py${C_RESET}"

# 2. Detect shell and config file
SHELL_NAME=$(basename "$SHELL")
CONFIG_FILE=""
if [ "$SHELL_NAME" = "zsh" ]; then
  CONFIG_FILE="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
  if [ -f "$HOME/.bash_profile" ]; then
    CONFIG_FILE="$HOME/.bash_profile"
  else
    CONFIG_FILE="$HOME/.bashrc"
  fi
else
  echo -e "${C_RED}❌ Unsupported shell: $SHELL_NAME. Please configure manually.${C_RESET}"
  exit 1
fi
echo -e "${C_GREEN}✓ Detected shell '$SHELL_NAME' and config file '${CONFIG_FILE}'${C_RESET}"

# 3. Check if already installed
if grep -q "# Custom Gemini Agent: Kiro" "$CONFIG_FILE"; then
  echo -e "${C_YELLOW}✓ 'kiro' command already seems to be installed. Skipping modification.${C_RESET}"
else
  # Append the function to the config file
  echo -e "\n# Custom Gemini Agent: Kiro for Traceable Agentic Development (installed by setup_kiro.sh)" >> "$CONFIG_FILE"
  cat <<'EOF' >> "$CONFIG_FILE"
kiro() {
  local tool_path="$HOME/gemini-tools/kiro_tool.py"
  if [ "$1" = "resume" ]; then
    if [ -z "$2" ]; then
      echo "Usage: kiro resume \"<feature name>\""
      return 1
    fi
    gemini --tools "$tool_path" "run kiro(command='resume', feature_name='$2')"
  else
    if [ -z "$1" ]; then
      echo "Usage: kiro \"<feature name>\""
      echo "   or: kiro resume \"<feature name>\""
      return 1
    fi
    gemini --tools "$tool_path" "run kiro(command='call', feature_name='$1')"
  fi
}
EOF
  echo -e "${C_GREEN}✓ Added 'kiro' function to your shell configuration.${C_RESET}"
fi

# --- Final Instructions ---
echo -e "\n${C_GREEN}🎉 Success! The 'kiro' agent is installed.${C_RESET}"
echo -e "To start using it, you must first reload your shell configuration."
echo -e "Run this command:"
echo -e "${C_CYAN}  source ${CONFIG_FILE}${C_RESET}"
echo -e "Or simply open a new terminal window.\n"
echo -e "After that, you can use it like this:"
echo -e "  ${C_YELLOW}kiro \"My New Awesome Feature\"${C_RESET}"
echo -e "  ${C_YELLOW}kiro resume \"My New Awesome Feature\"${C_RESET}"