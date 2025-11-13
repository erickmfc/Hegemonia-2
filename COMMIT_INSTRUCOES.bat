@echo off
echo ========================================
echo COMMIT: Botao Voltar ao Menu - Instrucoes
echo ========================================
echo.

cd /d "E:\Hegemonia Global\teste\Hegemonia-2-1"

echo Verificando status do repositorio...
git status

echo.
echo Adicionando arquivos modificados...
git add objects/obj_instrucao/Draw_0.gml
git add objects/obj_instrucao/Mouse_4.gml
git add objects/obj_instrucao/Create_0.gml

echo.
echo Fazendo commit...
git commit -m "feat: Adicionar botao 'Voltar ao Menu' na room de instrucoes

- Adicionado botao 'VOLTAR AO MENU' na parte inferior da tela
- Implementado efeito hover no botao
- Adicionada deteccao de clique para voltar ao menu principal
- Instrucoes organizadas em secoes claras e legiveis
- Sistema completo de navegacao entre menu e instrucoes"

echo.
echo Verificando remote...
git remote -v

echo.
echo Fazendo push para o repositorio...
git push -u origin master

if errorlevel 1 (
    echo.
    echo Tentando push para branch main...
    git push -u origin main
)

echo.
echo ========================================
echo Processo concluido!
echo ========================================
pause

