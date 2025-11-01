@echo off
git init
git add .
git commit -m "Atualizacao automatica"
git remote remove origin 2>nul
git remote add origin https://github.com/erickmfc/Hegemonia-2.git
git branch -M main
git push -u origin main --force

