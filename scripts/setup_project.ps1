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

# PowerShell logic for .cursorrules
# PowerShell logic for AI rules
$gafRoot = $PSScriptRoot
$rulesToCopy = @('.cursorrules', '.clinerules')
foreach ($rule in $rulesToCopy) {
  $source = Join-Path $gafRoot ('..\' + $rule)
  $dest = Join-Path $ProjectRoot $rule
  if (Test-Path $source) {
    Write-Host "[GAF][Setup] Copiando reglas de IA ($rule) a $ProjectRoot"
    Copy-Item -Path $source -Destination $dest -Force
  }
}

# Copy GitHub Copilot instructions
$copilotSource = Join-Path $gafRoot '..\.github\copilot-instructions.md'
$githubDest = Join-Path $ProjectRoot '.github'
if (Test-Path $copilotSource) {
  if (-not (Test-Path $githubDest)) { New-Item -ItemType Directory -Path $githubDest | Out-Null }
  Write-Host "[GAF][Setup] Copiando instrucciones de GitHub Copilot a $githubDest"
  Copy-Item -Path $copilotSource -Destination (Join-Path $githubDest 'copilot-instructions.md') -Force
}

if ($InstallMCP) {
  Write-Host "[GAF][Setup] Instalando MCP..."
  $mcpArgs = @{
    ProjectRoot = $ProjectRoot
    Force = $ForceMCP
  }
  & (Join-Path $PSScriptRoot 'install_mcp.ps1') @mcpArgs
}

if ($RunValidation) {
  & (Join-Path $PSScriptRoot 'validate_project.ps1')
}

Write-Host "[GAF][Setup] Completado"
