@echo off
setlocal
set ROOT=%~dp0
set PROJECT=%~1
if "%PROJECT%"=="" (
  echo [GAF] Uso: gaf.cmd C:\ruta\a\tu_proyecto
  exit /b 1
)
powershell -ExecutionPolicy Bypass -File "%ROOT%gaf.ps1" -ProjectRoot "%PROJECT%"
