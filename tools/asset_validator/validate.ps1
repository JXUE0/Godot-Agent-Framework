param(
  [Parameter(Mandatory=$true)][string]$ProjectRoot,
  [Parameter(Mandatory=$true)][string]$FrameworkRoot
)

$excludedDirs = @('.godot', '.import', '.git', 'node_modules', 'bin', 'obj')
$tempExtensions = @('.tmp', '.bak', '.swp', '.old', '.log')
$heavyExtensions = @('.psd', '.blend', '.kra', '.xcf', '.aep')
$allowedTempDirs = @('temp', 'tmp', '_temp', '.temp', (Join-Path $FrameworkRoot 'temp'))

function Test-ExcludedPath([string]$fullPath) {
  foreach ($d in $excludedDirs) {
    if ($fullPath -like "*\\$d\\*") { return $true }
  }
  return $false
}

function Test-InAllowedTempDir([string]$fullPath) {
  foreach ($d in $allowedTempDirs) {
    if ($fullPath -like "*$d\\*") { return $true }
  }
  return $false
}

Get-ChildItem -Path $ProjectRoot -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
  $full = $_.FullName
  if (Test-ExcludedPath $full) { return }

  $name = $_.Name
  $ext = $_.Extension.ToLowerInvariant()

  if ($name -match '\s') {
    Write-Output "ERROR: Espacios en nombre de archivo: $full"
  }

  if ($name -cmatch '[A-Z]') {
    Write-Output "WARN: Mayusculas en nombre de archivo: $full"
  }

  if ($tempExtensions -contains $ext) {
    if (-not (Test-InAllowedTempDir $full)) {
      Write-Output "ERROR: Archivo temporal fuera de carpeta temporal: $full"
    } else {
      Write-Output "WARN: Archivo temporal en carpeta temporal: $full"
    }
  }

  if ($heavyExtensions -contains $ext) {
    Write-Output "WARN: Archivo pesado/fuente detectado (revisar): $full"
  }
}


