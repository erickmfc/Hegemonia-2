@echo off
chcp 65001 >nul
echo ========================================
echo    HEGEMONIA GLOBAL - COMMIT MINIMAP
echo ========================================
echo.

cd /d "E:\Hegemonia Global\teste\Hegemonia-2-1"

echo [1/4] Verificando repositório Git...
if not exist ".git" (
    echo    Inicializando novo repositório...
    git init
    git branch -M main
)

echo [2/4] Verificando remote...
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo    Adicionando remote...
    git remote add origin https://github.com/erickmfc/Hegemonia-2.git
)

echo [3/4] Adicionando todos os arquivos...
git add -A

echo [4/4] Fazendo commit...
git commit -m "feat: Melhorias no minimap - exibe todos os objetos e ajustes na lancha patrulha

- Minimap agora mostra todos os objetos importantes do mapa
- Navios (azul), veículos (verde), infantaria (amarelo), aviões (branco)
- Estruturas militares (laranja), civis (ciano), centro pesquisa (roxo)
- Ajustes na lógica de movimento da lancha patrulha para curvas mais suaves
- Sistema de velocidade progressiva para manobras mais realistas"

echo.
echo Fazendo push para origin/main...
git push -u origin main

echo.
echo ========================================
echo    COMMIT E PUSH CONCLUÍDOS!
echo ========================================
echo.
pause

