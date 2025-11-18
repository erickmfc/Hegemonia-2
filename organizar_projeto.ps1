# Script de Organização do Projeto Hegemonia Global
# Move scripts de teste e documentação para estrutura organizada

Write-Host "🔄 Organizando projeto Hegemonia Global..." -ForegroundColor Cyan

# Criar estrutura de pastas
Write-Host "`n📁 Criando estrutura de pastas..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "tests\scripts" | Out-Null
New-Item -ItemType Directory -Force -Path "docs\correcoes" | Out-Null
New-Item -ItemType Directory -Force -Path "docs\implementacoes" | Out-Null
New-Item -ItemType Directory -Force -Path "docs\guias" | Out-Null
New-Item -ItemType Directory -Force -Path "docs\relatorios" | Out-Null
New-Item -ItemType Directory -Force -Path "docs\changelogs" | Out-Null

Write-Host "✅ Estrutura de pastas criada" -ForegroundColor Green

# Mover scripts de teste
Write-Host "`n📦 Movendo scripts de teste..." -ForegroundColor Yellow
$testScripts = Get-ChildItem -Path "scripts" -Directory -Filter "scr_teste_*" -ErrorAction SilentlyContinue
$movedTests = 0

foreach ($script in $testScripts) {
    $destPath = Join-Path "tests\scripts" $script.Name
    if (-not (Test-Path $destPath)) {
        Move-Item -Path $script.FullName -Destination $destPath -Force
        $movedTests++
        Write-Host "  ✅ Movido: $($script.Name)" -ForegroundColor Gray
    }
}

Write-Host "✅ $movedTests scripts de teste movidos" -ForegroundColor Green

# Mover documentação
Write-Host "`n📚 Organizando documentação..." -ForegroundColor Yellow

# Correções
$correcoes = Get-ChildItem -Path "." -File -Filter "CORRECAO_*.md" -ErrorAction SilentlyContinue
$correcoes += Get-ChildItem -Path "." -File -Filter "CORRECOES_*.md" -ErrorAction SilentlyContinue
$movedDocs = 0

foreach ($doc in $correcoes) {
    $destPath = Join-Path "docs\correcoes" $doc.Name
    if (-not (Test-Path $destPath)) {
        Move-Item -Path $doc.FullName -Destination $destPath -Force
        $movedDocs++
    }
}

# Implementações
$implementacoes = Get-ChildItem -Path "." -File -Filter "IMPLEMENTACAO_*.md" -ErrorAction SilentlyContinue
$implementacoes += Get-ChildItem -Path "." -File -Filter "SISTEMA_*.md" -ErrorAction SilentlyContinue

foreach ($doc in $implementacoes) {
    $destPath = Join-Path "docs\implementacoes" $doc.Name
    if (-not (Test-Path $destPath)) {
        Move-Item -Path $doc.FullName -Destination $destPath -Force
        $movedDocs++
    }
}

# Guias
$guias = Get-ChildItem -Path "." -File -Filter "GUIA_*.md" -ErrorAction SilentlyContinue
$guias += Get-ChildItem -Path "." -File -Filter "COMO_*.md" -ErrorAction SilentlyContinue
$guias += Get-ChildItem -Path "." -File -Filter "INSTRUCOES_*.md" -ErrorAction SilentlyContinue

foreach ($doc in $guias) {
    $destPath = Join-Path "docs\guias" $doc.Name
    if (-not (Test-Path $destPath)) {
        Move-Item -Path $doc.FullName -Destination $destPath -Force
        $movedDocs++
    }
}

# Relatórios
$relatorios = Get-ChildItem -Path "." -File -Filter "RELATORIO_*.md" -ErrorAction SilentlyContinue
$relatorios += Get-ChildItem -Path "." -File -Filter "ANALISE_*.md" -ErrorAction SilentlyContinue
$relatorios += Get-ChildItem -Path "." -File -Filter "REVISAO_*.md" -ErrorAction SilentlyContinue

foreach ($doc in $relatorios) {
    $destPath = Join-Path "docs\relatorios" $doc.Name
    if (-not (Test-Path $destPath)) {
        Move-Item -Path $doc.FullName -Destination $destPath -Force
        $movedDocs++
    }
}

# Changelogs
$changelogs = Get-ChildItem -Path "." -File -Filter "CHANGELOG_*.md" -ErrorAction SilentlyContinue

foreach ($doc in $changelogs) {
    $destPath = Join-Path "docs\changelogs" $doc.Name
    if (-not (Test-Path $destPath)) {
        Move-Item -Path $doc.FullName -Destination $destPath -Force
        $movedDocs++
    }
}

Write-Host "✅ $movedDocs arquivos de documentação organizados" -ForegroundColor Green

# Resumo
Write-Host "`n📊 Resumo da organização:" -ForegroundColor Cyan
Write-Host "  - Scripts de teste movidos: $movedTests" -ForegroundColor White
Write-Host "  - Documentação organizada: $movedDocs" -ForegroundColor White
Write-Host "`n✅ Organização concluída!" -ForegroundColor Green
Write-Host "`n📖 Consulte docs/GUIA_MANUTENIBILIDADE.md para mais informações" -ForegroundColor Yellow

