@echo off
echo Starting KASSIA Local Server at http://localhost:8000 ...
powershell -ExecutionPolicy Bypass -File "%~dp0server.ps1" -Port 8000
pause
