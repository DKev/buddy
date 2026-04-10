#!/usr/bin/env bash
# Buddy MCP Server — Cross-platform installer
# Works on macOS, Linux, and Windows (Git Bash / WSL)
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/fiorastudio/buddy/master/install.sh | bash
#   OR
#   bash install.sh

set -e

REPO="https://github.com/fiorastudio/buddy.git"
INSTALL_DIR="$HOME/.buddy/server"
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}"
echo '  🥚 Buddy MCP Server Installer'
echo '  ─────────────────────────────'
echo -e "${NC}"

# Check prerequisites
if ! command -v node &> /dev/null; then
  echo -e "${YELLOW}Node.js is required but not found. Install it from https://nodejs.org${NC}"
  exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
  echo -e "${YELLOW}Node.js 18+ required. You have $(node -v). Please upgrade.${NC}"
  exit 1
fi

if ! command -v git &> /dev/null; then
  echo -e "${YELLOW}Git is required but not found.${NC}"
  exit 1
fi

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
  echo "Updating existing installation..."
  cd "$INSTALL_DIR"
  git pull origin master --quiet
else
  echo "Installing Buddy MCP Server..."
  git clone --depth 1 "$REPO" "$INSTALL_DIR" --quiet
fi

cd "$INSTALL_DIR"

# Install and build
echo "Installing dependencies..."
npm install --quiet 2>/dev/null
echo "Building..."
npm run build --quiet 2>/dev/null

SERVER_PATH="$INSTALL_DIR/dist/server/index.js"

echo ""
echo -e "${GREEN}✅ Buddy installed successfully!${NC}"
echo ""
echo -e "Server location: ${BLUE}$SERVER_PATH${NC}"
echo ""
echo "Add to your CLI's MCP config:"
echo ""
echo -e "${YELLOW}Claude Code${NC} (~/.claude/settings.json):"
echo '  {'
echo '    "mcpServers": {'
echo '      "buddy": {'
echo "        \"command\": \"node\","
echo "        \"args\": [\"$SERVER_PATH\"]"
echo '      }'
echo '    }'
echo '  }'
echo ""
echo -e "${YELLOW}Cursor / Windsurf / Other MCP clients:${NC}"
echo "  Same pattern — point command to: node"
echo "  With args: [\"$SERVER_PATH\"]"
echo ""
echo -e "Then tell your AI: ${GREEN}\"hatch a buddy\"${NC} 🥚"
echo ""
