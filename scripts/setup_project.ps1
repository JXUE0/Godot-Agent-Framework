param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [switch]$InstallMCP,
  [switch]$ForceMCP,
  [switch]$RunValidation
)

Write-Host "[GAF][Setup] Proyecto detectado: $ProjectRoot"

if (-not (Test-Path (Join-Path $ProjectRoot 'project.godot'))) {
  Write-Host "[GAF][Setup] WARNING: project.godot no encontrado en $ProjectRoot"
}

if ($InstallMCP) {
  Write-Host "[GAF][Setup] Instalando MCP..."
  $mcpArgs = @("-ProjectRoot", $ProjectRoot)
  & (Join-Path $PSScriptRoot 'install_mcp.ps1') @mcpArgs
}

if ($RunValidation) {
  & (Join-Path $PSScriptRoot 'validate_project.ps1')
}

Write-Host "[GAF][Setup] Completado"
