@echo off
echo ========================================
echo    HEGEMONIA GLOBAL v1.2 - COMMIT MAJOR
echo ========================================
echo.

cd /d "E:\Hegemonia Global\teste\Hegemonia-2"

echo Executando PowerShell script...
powershell.exe -ExecutionPolicy Bypass -File "git_commit_major.ps1"

pause

