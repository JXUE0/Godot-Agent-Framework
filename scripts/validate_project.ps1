param()

$frameworkRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$projectRoot = Split-Path -Parent $frameworkRoot

if (-not (Test-Path (Join-Path $projectRoot 'project.godot'))) {
  Write-Host "[GAF] project.godot no encontrado en $projectRoot. Usando frameworkRoot como proyecto."
  $projectRoot = $frameworkRoot
}

$findings = @()
$findings += & (Join-Path $frameworkRoot 'tools\structure_enforcer\validate.ps1') -ProjectRoot $projectRoot -FrameworkRoot $frameworkRoot
$findings += & (Join-Path $frameworkRoot 'tools\\asset_validator\\validate.ps1') -ProjectRoot $projectRoot -FrameworkRoot $frameworkRoot
$findings += & (Join-Path $frameworkRoot 'tools\\structure_enforcer\\deprecated_apis.ps1') -ProjectRoot $projectRoot

$reportPath = Join-Path $frameworkRoot 'docs\generated\validation-report.md'
& (Join-Path $frameworkRoot 'tools\docs_generator\generate_report.ps1') -FrameworkRoot $frameworkRoot -ReportPath $reportPath -Findings $findings

$errors = $findings | Where-Object { $_ -like 'ERROR:*' }
$warnings = $findings | Where-Object { $_ -like 'WARN:*' }

Write-Host "[GAF] Validacion completada. Errors: $($errors.Count) | Warnings: $($warnings.Count)"
Write-Host "[GAF] Reporte: $reportPath"

if ($errors.Count -gt 0) { exit 1 }


