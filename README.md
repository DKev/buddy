# Buddy 🤖🐱

Your context-aware terminal companion for Claude Code, Cursor, Windsurf, and more. Buddy lives in your MCP server and grows as you code.

## Quick Start

```bash
# Install Buddy via MCP (Alpha)
npx buddy-mcp install
```

## Features

- **Hatching**: Your Buddy is uniquely determined by your user ID (or random if you prefer).
- **Evolution**: Earn XP for commits, bug fixes, and active coding sessions. Watch your Buddy grow from an egg to a hatchling to an adult.
- **Dreaming**: Buddy consolidates memories during "Light" and "Deep" sleep, surfacing insights and evolving their personality.
- **Context-Aware**: Buddy reacts to your code context—celebrating commits and offering comfort during debugging.

## Distribution & Setup

Buddy can be added to any MCP-compatible environment.

### Claude Code
Add to your `claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "buddy": {
      "command": "npx",
      "args": ["-y", "buddy-mcp"]
    }
  }
}
```

### Cursor / Windsurf
Add a new MCP server with:
- **Name**: Buddy
- **Type**: stdio
- **Command**: `npx -y buddy-mcp`

## Alpha Testing

We are currently in **Alpha**. Please report bugs and feedback on the repository.

---
*Powered by OpenClaw*
