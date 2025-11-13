# Script para commit das melhorias do minimap
Set-Location "E:\Hegemonia Global\teste\Hegemonia-2-1"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   HEGEMONIA GLOBAL - COMMIT MINIMAP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se é um repositório Git
if (-not (Test-Path ".git")) {
    Write-Host "Inicializando repositório Git..." -ForegroundColor Yellow
    git init
    git branch -M main
}

# Verificar remote
Write-Host "[1/4] Verificando remote..." -ForegroundColor Yellow
$remote = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "   Adicionando remote..." -ForegroundColor Yellow
    git remote add origin https://github.com/erickmfc/Hegemonia-2.git
}

# Adicionar arquivos
Write-Host "[2/4] Adicionando arquivos modificados..." -ForegroundColor Yellow
git add -A

# Fazer commit
Write-Host "[3/4] Fazendo commit..." -ForegroundColor Yellow
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$commitMessage = "feat: Melhorias no minimap - exibe todos os objetos (navios, quarteis, estruturas) e ajustes na lancha patrulha

- Minimap agora mostra todos os objetos importantes do mapa
- Navios (azul), veículos (verde), infantaria (amarelo), aviões (branco)
- Estruturas militares (laranja), civis (ciano), centro pesquisa (roxo)
- Ajustes na lógica de movimento da lancha patrulha para curvas mais suaves
- Sistema de velocidade progressiva para manobras mais realistas
- $date"

git commit -m $commitMessage

# Push
Write-Host "[4/4] Fazendo push para origin/main..." -ForegroundColor Yellow
git push -u origin main

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   COMMIT E PUSH CONCLUÍDOS!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

