#!/usr/bin/env bash
# LinkedIn Demo Script — run this while screen recording (Win+Alt+R)
# Shows: hatch → card → observe → pet → persistence message
#
# Before running:
#   1. Start screen recording (Win+Alt+R)
#   2. Make your terminal window nice and big
#   3. Run: bash demo/linkedin-demo.sh
#   4. Stop recording when done (Win+Alt+R)

cd "$(dirname "$0")/.."
clear

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
DIM='\033[2m'
NC='\033[0m'

type_slow() {
  local text="$1"
  for ((i=0; i<${#text}; i++)); do
    printf '%s' "${text:$i:1}"
    sleep 0.04
  done
  echo ""
}

pause() {
  sleep "${1:-2}"
}

# Delete old DB for fresh start
rm -f ~/.buddy/buddy.db 2>/dev/null

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  🐾 Buddy — Your Persistent AI Coding Companion${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
pause 2

echo -e "${GREEN}  Step 1: Hatch a buddy${NC}"
echo -e "${DIM}  ─────────────────────${NC}"
echo ""
type_slow "  $ buddy_hatch --name Nuzzlecap --species Mushroom"
echo ""
pause 1

# Run hatch
echo '{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"demo","version":"1.0.0"}}}
{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"buddy_hatch","arguments":{"name":"Nuzzlecap","species":"Mushroom","user_id":"linkedin-demo"}}}' | timeout 15 node dist/server/index.js 2>/dev/null | tail -1 | node -e "process.stdin.resume();let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{try{const r=JSON.parse(d);r.result.content.forEach(c=>console.log(c.text))}catch(e){}})"

pause 3

echo ""
echo -e "${GREEN}  Step 2: Your buddy watches you code${NC}"
echo -e "${DIM}  ────────────────────────────────────${NC}"
echo ""
type_slow "  $ buddy_observe \"wrote a clean CSV parser with error handling\""
echo ""
pause 1

# Run observe
echo '{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"demo","version":"1.0.0"}}}
{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"buddy_observe","arguments":{"summary":"wrote a clean CSV parser with proper error handling","mode":"skillcoach"}}}' | timeout 10 node dist/server/index.js 2>/dev/null | tail -1 | node -e "process.stdin.resume();let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{try{const r=JSON.parse(d);console.log(r.result.content[0].text)}catch(e){}})"

pause 3

echo ""
echo -e "${GREEN}  Step 3: Pet your buddy${NC}"
echo -e "${DIM}  ──────────────────────${NC}"
echo ""
type_slow "  $ buddy_pet"
echo ""
pause 1

# Run pet
echo '{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"demo","version":"1.0.0"}}}
{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"buddy_pet","arguments":{}}}' | timeout 10 node dist/server/index.js 2>/dev/null | tail -1 | node -e "process.stdin.resume();let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{try{const r=JSON.parse(d);r.result.content.forEach(c=>console.log(c.text))}catch(e){}})"

pause 3

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${MAGENTA}  Close the terminal. Restart your computer.${NC}"
echo -e "${MAGENTA}  Update your CLI.${NC}"
echo ""
echo -e "${YELLOW}  Your buddy is still here. 🐾${NC}"
echo ""
echo -e "${DIM}  Works with: Claude Code · Cursor · Windsurf · Codex · Gemini CLI${NC}"
echo ""
echo -e "${GREEN}  Install:${NC}"
echo -e "  curl -fsSL https://raw.githubusercontent.com/fiorastudio/buddy/master/install.sh | bash"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
