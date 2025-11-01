@echo off
chcp 65001 >nul
cd /d "E:\Hegemonia Global\teste\Hegemonia-2"

echo Inicializando Git se necessario...
if not exist .git git init

echo Adicionando arquivos...
git add .

echo Fazendo commit...
git commit -m "Atualizacao - %date% %time%"

echo Configurando remote...
git remote remove origin 2>nul
git remote add origin https://github.com/erickmfc/Hegemonia-2.git

echo Fazendo push...
git push -u origin master --force

echo Concluido!
pause

