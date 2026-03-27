param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [switch]$Force
)

$addonSrc = Join-Path $PSScriptRoot '..\tools\mcp\addon_template\addons\gaf_sync'
$addonDst = Join-Path $ProjectRoot 'addons\gaf_sync'

if (-not $Force -and (Test-Path $addonDst)) {
  Write-Host "[GAF][MCP] GAF-Sync ya instalado en $addonDst. Use -Force para sobrescribir."
  exit 0
}

Write-Host "[GAF][MCP] Instalando addon..."
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $addonDst) | Out-Null
Copy-Item -Path $addonSrc -Destination $addonDst -Recurse -Force
Write-Host "[GAF][MCP] Instalacion completada"
Write-Host "[GAF][MCP] Activa el plugin en Project > Project Settings > Plugins"
