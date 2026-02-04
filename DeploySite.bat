@echo off
REM Launch PowerShell script to deploy RespectDevs site
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0deploy.ps1"
pause