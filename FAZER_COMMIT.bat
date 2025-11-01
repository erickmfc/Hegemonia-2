@echo off
chcp 65001 >nul
echo ========================================
echo    HEGEMONIA GLOBAL - COMMIT E PUSH
echo ========================================
echo.

cd /d "E:\Hegemonia Global\teste\Hegemonia-2"

echo [1/5] Verificando repositório Git...
if not exist ".git" (
    echo    Inicializando novo repositório...
    git init
    git branch -M main
)

echo [2/5] Verificando remote...
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo    Adicionando remote...
    git remote add origin https://github.com/erickmfc/Hegemonia-2.git
)

echo [3/5] Adicionando todos os arquivos...
git add .

echo [4/5] Fazendo commit...
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a:%%b)
set timestamp=%mydate% %mytime%
git commit -m "Atualização automática - %timestamp%"

echo [5/5] Fazendo push para origin/main...
git push -u origin main

echo.
echo ========================================
echo    COMMIT E PUSH CONCLUÍDOS!
echo ========================================
echo.
pause

