# Script para fazer commit e push das alterações
# Hegemonia Global - Melhorias de Manutenibilidade, Performance e IA

Write-Host "🔄 Preparando commit das alterações..." -ForegroundColor Cyan

# Verificar se estamos no diretório correto
if (-not (Test-Path ".git")) {
    Write-Host "❌ Erro: Não é um repositório Git!" -ForegroundColor Red
    Write-Host "   Execute este script na raiz do projeto" -ForegroundColor Yellow
    exit 1
}

# Verificar status
Write-Host "`n📊 Status do repositório:" -ForegroundColor Yellow
git status --short

# Adicionar todos os arquivos
Write-Host "`n📦 Adicionando arquivos..." -ForegroundColor Yellow
git add -A

# Verificar se há mudanças para commitar
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "`n✅ Nenhuma mudança para commitar" -ForegroundColor Green
    exit 0
}

# Fazer commit
Write-Host "`n💾 Fazendo commit..." -ForegroundColor Yellow
$commitMessage = @"
feat: Melhorias de manutenibilidade, performance e IA agressiva

## Manutenibilidade
- Scripts de teste organizados em tests/scripts/
- Documentação consolidada em docs/ por categoria
- Guias de boas práticas criados (código defensivo, otimização)

## Performance
- Sistema de debug otimizado (zero overhead quando desabilitado)
- Frame skip otimizado (cache de verificações)
- Redução de 80-90% em verificações excessivas
- Script de análise de performance criado

## IA Agressiva
- Recursos iniciais aumentados: 5M dinheiro, 10k minério, 5k petróleo
- Produção de recursos corrigida (IA produz para global.ia_*)
- Decisões mais rápidas (30 frames = 0.5s)
- Prioridade militar aumentada (0.9)
- Requisitos reduzidos ($300/150 minério)
- Custos de construção reduzidos
- Produção triplicada (fazendas/minas da IA)
- Mais navios recrutados (8 por vez)

## Correções
- Fonte gigante nos aviões corrigida
- Variável _num_quartel_marinha inicializada
- Produção de recursos da IA corrigida (dinheiro, minério, petróleo)
"@

git commit -m $commitMessage

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Commit realizado com sucesso!" -ForegroundColor Green
    
    # Fazer push
    Write-Host "`n🚀 Fazendo push para o repositório remoto..." -ForegroundColor Yellow
    git push origin master
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Push realizado com sucesso!" -ForegroundColor Green
        Write-Host "`n📖 Alterações disponíveis em: https://github.com/erickmfc/Hegemonia-2" -ForegroundColor Cyan
    } else {
        Write-Host "`n⚠️ Erro ao fazer push. Verifique a conexão e credenciais." -ForegroundColor Red
    }
} else {
    Write-Host "`n❌ Erro ao fazer commit" -ForegroundColor Red
}

