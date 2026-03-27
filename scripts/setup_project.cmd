@echo off
setlocal

if "%~1"=="" (
  echo [GAF][Setup] Missing project path.
  echo Usage: setup_project.cmd C:\path\to\project
  exit /b 1
)

powershell -ExecutionPolicy Bypass -File "%~dp0setup_project.ps1" -ProjectRoot "%~1" -InstallMCP -RunValidation
