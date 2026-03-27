param(
  [string]$ProjectRoot = "",
  [switch]$Force
)

$frameworkRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
  $ProjectRoot = (Resolve-Path (Join-Path $frameworkRoot '..')).Path
}

$projectFile = Join-Path $ProjectRoot 'project.godot'
if (-not (Test-Path $projectFile)) {
  Write-Host "[GAF][MCP] project.godot no encontrado en $ProjectRoot."
  Write-Host "[GAF][MCP] Usa -ProjectRoot para indicar un proyecto Godot valido."
  exit 1
}

$templateRoot = Join-Path $frameworkRoot 'tools\mcp\addon_template\addons\godot_mcp'
if (-not (Test-Path $templateRoot)) {
  Write-Host "[GAF][MCP] No se encontro el template en $templateRoot"
  exit 1
}

$destRoot = Join-Path $ProjectRoot 'addons\godot_mcp'
if (Test-Path $destRoot) {
  if (-not $Force) {
    Write-Host "[GAF][MCP] Ya existe addons/godot_mcp en el proyecto."
    Write-Host "[GAF][MCP] Reintenta con -Force para sobrescribir (se crea backup)."
    exit 1
  }
  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $backup = Join-Path $ProjectRoot ("addons\\godot_mcp.backup-" + $stamp)
  Write-Host "[GAF][MCP] Creando backup en $backup"
  Copy-Item -Recurse -Force $destRoot $backup
  Remove-Item -Recurse -Force $destRoot
}

Write-Host "[GAF][MCP] Instalando addon..."
Copy-Item -Recurse -Force $templateRoot $destRoot

Write-Host "[GAF][MCP] Instalacion completada"
Write-Host "[GAF][MCP] Activa el plugin en Project > Project Settings > Plugins"
