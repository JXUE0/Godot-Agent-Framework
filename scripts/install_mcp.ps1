param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [switch]$Force
)

$addonSrc = Join-Path $PSScriptRoot '..\tools\mcp\addon_template\addons\godot_mcp'
$addonDst = Join-Path $ProjectRoot 'addons\godot_mcp'

if (Test-Path $addonDst) {
  Write-Host "[GAF][MCP] MCP ya instalado en $addonDst. No se realizaron cambios."
  exit 0
}

Write-Host "[GAF][MCP] Instalando addon..."
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $addonDst) | Out-Null
Copy-Item -Path $addonSrc -Destination $addonDst -Recurse -Force
Write-Host "[GAF][MCP] Instalacion completada"
Write-Host "[GAF][MCP] Activa el plugin en Project > Project Settings > Plugins"
