# Buddy MCP Server — Windows PowerShell Installer
#
# Usage:
#   irm https://raw.githubusercontent.com/fiorastudio/buddy/master/install.ps1 | iex
#   OR
#   .\install.ps1

$ErrorActionPreference = "Stop"
$REPO = "https://github.com/fiorastudio/buddy.git"
$INSTALL_DIR = "$env:USERPROFILE\.buddy\server"

Write-Host ""
Write-Host "  Buddy MCP Server Installer" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
try { $null = Get-Command node -ErrorAction Stop }
catch {
  Write-Host "Node.js is required. Install from https://nodejs.org" -ForegroundColor Yellow
  exit 1
}

$nodeVersion = (node -v) -replace 'v(\d+)\..*', '$1'
if ([int]$nodeVersion -lt 18) {
  Write-Host "Node.js 18+ required. You have $(node -v)." -ForegroundColor Yellow
  exit 1
}

try { $null = Get-Command git -ErrorAction Stop }
catch {
  Write-Host "Git is required." -ForegroundColor Yellow
  exit 1
}

# Clone or update
if (Test-Path $INSTALL_DIR) {
  Write-Host "Updating existing installation..."
  Push-Location $INSTALL_DIR
  git pull origin master --quiet
  Pop-Location
} else {
  Write-Host "Installing Buddy MCP Server..."
  git clone --depth 1 $REPO $INSTALL_DIR --quiet
}

Push-Location $INSTALL_DIR

Write-Host "Installing dependencies..."
npm install --quiet 2>$null
Write-Host "Building..."
npm run build --quiet 2>$null

$SERVER_PATH = "$INSTALL_DIR\dist\server\index.js"

Pop-Location

Write-Host ""
Write-Host "  Buddy installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "  Server: $SERVER_PATH" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Add to Claude Code (~/.claude/settings.json):" -ForegroundColor Yellow
Write-Host '  {'
Write-Host '    "mcpServers": {'
Write-Host '      "buddy": {'
Write-Host "        `"command`": `"node`","
Write-Host "        `"args`": [`"$($SERVER_PATH -replace '\\', '/')`"]"
Write-Host '      }'
Write-Host '    }'
Write-Host '  }'
Write-Host ""
Write-Host "  Then tell your AI: `"hatch a buddy`"" -ForegroundColor Green
Write-Host ""
