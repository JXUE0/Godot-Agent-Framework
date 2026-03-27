param(
  [string]$ProjectRoot = "",
  [switch]$InstallMCP,
  [switch]$ForceMCP,
  [switch]$RunValidation
)

$frameworkRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
  $ProjectRoot = (Resolve-Path (Join-Path $frameworkRoot '..')).Path
}

$projectFile = Join-Path $ProjectRoot 'project.godot'
if (-not (Test-Path $projectFile)) {
  Write-Host "[GAF][Setup] project.godot no encontrado en $ProjectRoot."
  Write-Host "[GAF][Setup] Usa -ProjectRoot para indicar un proyecto Godot valido."
  exit 1
}

Write-Host "[GAF][Setup] Proyecto detectado: $ProjectRoot"

if ($InstallMCP) {
  $args = @("-ProjectRoot", $ProjectRoot)
  if ($ForceMCP) { $args += "-Force" }
  Write-Host "[GAF][Setup] Instalando MCP..."
  & (Join-Path $frameworkRoot 'scripts\install_mcp.ps1') @args
}

if ($RunValidation) {
  Write-Host "[GAF][Setup] Ejecutando validacion..."
  & (Join-Path $frameworkRoot 'scripts\validate_project.ps1')
}

Write-Host "[GAF][Setup] Completado"
