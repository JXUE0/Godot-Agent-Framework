@echo off
setlocal

if "%~1"=="" (
  echo [GAF][MCP] Missing project path.
  echo Usage: install_mcp.cmd C:\path\to\project
  exit /b 1
)

powershell -ExecutionPolicy Bypass -File "%~dp0install_mcp.ps1" -ProjectRoot "%~1"
