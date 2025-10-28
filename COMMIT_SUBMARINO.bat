@echo off
echo ========================================
echo COMMIT DAS ALTERAÇÕES DO SUBMARINO
echo ========================================
echo.

cd "E:\Hegemonia Global\teste\Hegemonia-2"

echo [1/6] Verificando status do git...
git status

echo.
echo [2/6] Inicializando repositório (se necessário)...
if not exist .git (
    git init
)

echo.
echo [3/6] Adicionando todos os arquivos...
git add .

echo.
echo [4/6] Criando commit...
git commit -m "Correções no sistema de submarino e patrulha

- Removidos arquivos duplicados (Clean_Up_0.gml, obj_wwhendrick/Mouse_0.gml)
- Corrigido Draw_64.gml para exibir interface de submarino
- Atualizado Draw_0.gml com controles corretos [K] Subm/Emerge
- Corrigido sistema de patrulha para submarinos
- Tecla K funciona diferentemente para submarinos e outras unidades
- Sistema de desseleção funcionando corretamente
- Patrulha funcionando com mínimo de 2 pontos"

echo.
echo [5/6] Configurando repositório remoto...
git remote remove origin 2>nul
git remote add origin https://github.com/erickmfc/Hegemonia-2.git

echo.
echo [6/6] Fazendo push para GitHub...
git push -u origin master --force

echo.
echo ========================================
echo COMMIT CONCLUÍDO COM SUCESSO!
echo ========================================
pause

