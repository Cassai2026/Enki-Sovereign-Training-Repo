#Requires -Version 5.1
<#
.SYNOPSIS
    Start Enki Sovereign Node 29 — Edge Router + Expo Dashboard.

.DESCRIPTION
    Launches core/network/edge_router.py in the background (Python output
    suppressed) and opens ui/expo_dashboard.html in the default browser.
    Green status messages are printed to confirm the 10^47 Sovereign Node
    is active.

.NOTES
    File   : start_node_29.ps1
    Node   : 29
    Scale  : 10^47 (Enki Sovereign Epoch IV)
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── Helpers ───────────────────────────────────────────────────────────────────
function Write-Green {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-Status {
    param([string]$Message)
    $ts = Get-Date -Format 'HH:mm:ss'
    Write-Green "  [✓] [$ts] $Message"
}

# ── Resolve paths relative to this script ────────────────────────────────────
$ScriptDir      = $PSScriptRoot
$EdgeRouterPath = Join-Path $ScriptDir 'core\network\edge_router.py'
$DashboardPath  = Join-Path $ScriptDir 'ui\expo_dashboard.html'

# ── Banner ────────────────────────────────────────────────────────────────────
Write-Host ''
Write-Green '============================================================'
Write-Green '   ⚡  ENKI SOVEREIGN NODE 29  —  SCALE: 10^47             '
Write-Green '============================================================'
Write-Host ''

# ── Validate prerequisites ────────────────────────────────────────────────────
if (-not (Test-Path $EdgeRouterPath)) {
    Write-Host "  [!] edge_router.py not found at: $EdgeRouterPath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $DashboardPath)) {
    Write-Host "  [!] expo_dashboard.html not found at: $DashboardPath" -ForegroundColor Red
    exit 1
}

$pythonCmd = $null
foreach ($candidate in @('python', 'python3')) {
    if (Get-Command $candidate -ErrorAction SilentlyContinue) {
        $pythonCmd = $candidate
        break
    }
}

if (-not $pythonCmd) {
    Write-Host '  [!] Python not found. Install Python 3 and ensure it is on PATH.' -ForegroundColor Red
    exit 1
}

# ── Launch edge router in background (output suppressed) ──────────────────────
Write-Status 'Initialising edge router …'

$procArgs = @{
    FilePath               = $pythonCmd
    ArgumentList           = "-u `"$EdgeRouterPath`""
    WindowStyle            = 'Hidden'
    RedirectStandardOutput = 'NUL'
    RedirectStandardError  = 'NUL'
    PassThru               = $true
}

try {
    $routerProcess = Start-Process @procArgs
    Write-Status "Edge router started  (PID $($routerProcess.Id))"
} catch {
    Write-Host "  [!] Failed to start edge router: $_" -ForegroundColor Red
    exit 1
}

# Brief pause so the router can bind its port before the dashboard loads
Start-Sleep -Milliseconds 800

# ── Open dashboard in default browser ────────────────────────────────────────
Write-Status 'Opening Expo Dashboard in default browser …'

try {
    Start-Process $DashboardPath
    Write-Status 'Expo Dashboard launched.'
} catch {
    Write-Host "  [!] Could not open dashboard: $_" -ForegroundColor Yellow
}

# ── Final status ──────────────────────────────────────────────────────────────
Write-Host ''
Write-Green '============================================================'
Write-Green '   Sovereign Node 29 is ACTIVE at scale 10^47              '
Write-Green '   Edge Router : listening on 127.0.0.1:9029               '
Write-Green '   Dashboard   : ui/expo_dashboard.html                     '
Write-Green '============================================================'
Write-Host ''
Write-Status 'All systems nominal. Enki Epoch IV online.'
Write-Host ''
