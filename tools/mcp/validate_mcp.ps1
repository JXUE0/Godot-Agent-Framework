param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot
)

$addonRoot = Join-Path $ProjectRoot 'addons\godot_mcp'
$pluginCfg = Join-Path $addonRoot 'plugin.cfg'
$pluginGd = Join-Path $addonRoot 'plugin.gd'
$mcpServer = Join-Path $addonRoot 'mcp_server.gd'

if (-not (Test-Path $addonRoot)) {
  Write-Output "WARN: MCP no instalado (addons/godot_mcp no existe)"
  return
}

if (-not (Test-Path $pluginCfg)) { Write-Output "ERROR: MCP sin plugin.cfg" }
if (-not (Test-Path $pluginGd)) { Write-Output "ERROR: MCP sin plugin.gd" }
if (-not (Test-Path $mcpServer)) { Write-Output "WARN: MCP sin mcp_server.gd (modo servidor no disponible)" }

if (Test-Path $pluginCfg) {
  $cfg = Get-Content -Raw $pluginCfg
  if ($cfg -notmatch 'name=') { Write-Output "ERROR: plugin.cfg sin name" }
  if ($cfg -notmatch 'script=') { Write-Output "ERROR: plugin.cfg sin script" }
}

if (Test-Path $mcpServer) {
  $server = Get-Content -Raw $mcpServer
  if ($server -match 'allow_remote_connections\s*:=\s*true') {
    Write-Output "WARN: allow_remote_connections=true (riesgo de seguridad)"
  }
  if ($server -match 'allow_unsafe_commands\s*:=\s*true') {
    Write-Output "WARN: allow_unsafe_commands=true (riesgo de seguridad)"
  }
}
