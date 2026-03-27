param(
  [Parameter(Mandatory=$true)][string]$FrameworkRoot,
  [Parameter(Mandatory=$true)][string]$ReportPath,
  [Parameter(Mandatory=$true)][string[]]$Findings
)

$dir = Split-Path -Parent $ReportPath
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$errors = $Findings | Where-Object { $_ -like 'ERROR:*' }
$warnings = $Findings | Where-Object { $_ -like 'WARN:*' }

if ($null -eq $errors) { $errors = @() }
if ($null -eq $warnings) { $warnings = @() }

$errorsText = if ($errors.Count -gt 0) { [string]::Join("`n", $errors) } else { "None" }
$warningsText = if ($warnings.Count -gt 0) { [string]::Join("`n", $warnings) } else { "None" }

@"
# GAF Validation Report

- Timestamp: $timestamp
- Errors: $($errors.Count)
- Warnings: $($warnings.Count)

## Errors
$errorsText

## Warnings
$warningsText
"@ | Set-Content -Encoding UTF8 $ReportPath
