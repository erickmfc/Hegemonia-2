# Script para fazer commit das mudanças no objeto de instruções
# Autor: Auto-generated
# Data: 2025-01-XX

Write-Host "=== COMMIT: Botão Voltar ao Menu nas Instruções ===" -ForegroundColor Cyan

# Navegar para o diretório do projeto
$projectPath = "E:\Hegemonia Global\teste\Hegemonia-2-1"
Set-Location $projectPath

# Verificar se é um repositório git
if (-not (Test-Path ".git")) {
    Write-Host "❌ Erro: Não é um repositório Git!" -ForegroundColor Red
    Write-Host "Inicializando repositório..." -ForegroundColor Yellow
    git init
    git remote add origin https://github.com/erickmfc/Hegemonia-2.git
}

# Verificar status
Write-Host "`n📊 Verificando status do repositório..." -ForegroundColor Yellow
git status

# Adicionar arquivos modificados
Write-Host "`n➕ Adicionando arquivos modificados..." -ForegroundColor Yellow
git add objects/obj_instrucao/Draw_0.gml
git add objects/obj_instrucao/Mouse_4.gml
git add objects/obj_instrucao/Create_0.gml

# Fazer commit
Write-Host "`n💾 Fazendo commit..." -ForegroundColor Yellow
$commitMessage = "feat: Adicionar botão 'Voltar ao Menu' na room de instruções

- Adicionado botão '🏠 VOLTAR AO MENU' na parte inferior da tela
- Implementado efeito hover no botão
- Adicionada detecção de clique para voltar ao menu principal
- Instruções organizadas em seções claras e legíveis
- Sistema completo de navegação entre menu e instruções"

git commit -m $commitMessage

# Verificar se há remote configurado
Write-Host "`n🔗 Verificando remote..." -ForegroundColor Yellow
$remote = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️ Remote não configurado. Adicionando..." -ForegroundColor Yellow
    git remote add origin https://github.com/erickmfc/Hegemonia-2.git
}

# Fazer push
Write-Host "`n🚀 Fazendo push para o repositório..." -ForegroundColor Yellow
git push -u origin master

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Commit e push realizados com sucesso!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️ Tentando push para branch main..." -ForegroundColor Yellow
    git push -u origin main
}

Write-Host "`n✨ Processo concluído!" -ForegroundColor Cyan

