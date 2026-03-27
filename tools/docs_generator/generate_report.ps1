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

@"
# GAF Validation Report

- Timestamp: $timestamp
- Errors: $($errors.Count)
- Warnings: $($warnings.Count)

## Errors
$([string]::Join("`n", $errors))

## Warnings
$([string]::Join("`n", $warnings))
"@ | Set-Content -Encoding UTF8 $ReportPath
