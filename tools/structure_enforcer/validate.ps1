param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [Parameter(Mandatory=$true)][string]$FrameworkRoot
)

$projectFile = Join-Path $ProjectRoot 'project.godot'
$frameworkDir = Join-Path $ProjectRoot 'godot-agent-framework'
$templatesDir = Join-Path $FrameworkRoot 'tools\scene_templates'
$expectedDirs = @('scenes', 'scripts', 'assets', 'addons')

if (-not (Test-Path $projectFile)) {
  Write-Output "ERROR: No se encontro project.godot en $ProjectRoot"
}

if (-not (Test-Path $frameworkDir)) {
  Write-Output "ERROR: No se encontro godot-agent-framework/ en $ProjectRoot"
}

foreach ($d in $expectedDirs) {
  $p = Join-Path $ProjectRoot $d
  if (-not (Test-Path $p)) {
    Write-Output "WARN: Carpeta recomendada no encontrada: $p"
  }
}

Get-ChildItem -Path $FrameworkRoot -Recurse -Filter *.tscn -File -ErrorAction SilentlyContinue | ForEach-Object {
  $full = $_.FullName
  if ($full -notlike "$templatesDir*" ) {
    Write-Output "WARN: Escena dentro del framework fuera de scene_templates: $full"
  }
}
