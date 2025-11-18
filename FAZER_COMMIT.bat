@echo off
echo ========================================
echo COMMIT E PUSH - HEGEMONIA GLOBAL
echo ========================================
echo.

REM Verificar se estamos em um repositório Git
if not exist ".git" (
    echo ERRO: Nao e um repositorio Git!
    echo Execute este script na raiz do projeto
    pause
    exit /b 1
)

echo [1/4] Verificando status...
git status --short
echo.

echo [2/4] Adicionando arquivos...
git add -A
if %errorlevel% neq 0 (
    echo ERRO ao adicionar arquivos
    pause
    exit /b 1
)
echo OK
echo.

echo [3/4] Fazendo commit...
git commit -m "feat: Melhorias de manutenibilidade, performance e IA agressiva" -m "- Organizacao: Scripts de teste e documentacao reorganizados" -m "- Performance: Sistema de debug otimizado, frame skip melhorado" -m "- IA: Recursos aumentados (5M dinheiro, 10k minerio), producao corrigida" -m "- Correcoes: Fonte gigante nos avioes, producao de recursos da IA"
if %errorlevel% neq 0 (
    echo ERRO ao fazer commit
    pause
    exit /b 1
)
echo OK
echo.

echo [4/4] Fazendo push para GitHub...
git push origin master
if %errorlevel% neq 0 (
    echo ERRO ao fazer push
    echo Verifique a conexao e credenciais do GitHub
    pause
    exit /b 1
)
echo OK
echo.

echo ========================================
echo COMMIT E PUSH CONCLUIDOS COM SUCESSO!
echo ========================================
echo.
echo Alteracoes disponiveis em:
echo https://github.com/erickmfc/Hegemonia-2
echo.
pause
