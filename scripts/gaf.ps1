param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [switch]$ForceMCP
)

$frameworkRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$addonDir = Join-Path $ProjectRoot 'addons\godot_mcp'

if (Test-Path $addonDir) {
  Write-Host "[GAF] MCP ya instalado en $addonDir"
} else {
  $args = @("-ProjectRoot", $ProjectRoot)
  & (Join-Path $frameworkRoot 'scripts\install_mcp.ps1') @args
}

& (Join-Path $frameworkRoot 'scripts\validate_project.ps1')
