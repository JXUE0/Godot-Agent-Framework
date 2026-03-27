@echo off
setlocal
set ROOT=%~dp0
set PROJECT=%~1
if "%PROJECT%"=="" (
  echo [GAF][Setup] Uso: setup_project.cmd C:\ruta\a\tu_proyecto
  exit /b 1
)
powershell -ExecutionPolicy Bypass -File "%ROOT%setup_project.ps1" -ProjectRoot "%PROJECT%" -InstallMCP -RunValidation
