# Script de Análise de Performance - Hegemonia Global
# Identifica verificações excessivas e debug messages sem verificação

Write-Host "🔍 Analisando performance do projeto..." -ForegroundColor Cyan

$resultados = @{
    VerificacoesExcessivas = @()
    DebugSemVerificacao = @()
    VerificacoesEmStep = @()
}

# Analisar verificações excessivas
Write-Host "`n📊 Analisando verificações de variáveis..." -ForegroundColor Yellow

$arquivos = Get-ChildItem -Path "objects" -Recurse -Filter "*.gml" | Where-Object { $_.Name -match "Step_0|Draw_0" }

foreach ($arquivo in $arquivos) {
    $conteudo = Get-Content $arquivo.FullName -Raw
    $linhas = Get-Content $arquivo.FullName
    
    # Verificações em Step/Draw events
    $verificacoes = ([regex]::Matches($conteudo, "variable_instance_exists|variable_global_exists|instance_exists")).Count
    
    if ($verificacoes -gt 5) {
        $resultados.VerificacoesExcessivas += [PSCustomObject]@{
            Arquivo = $arquivo.FullName
            Verificacoes = $verificacoes
            Tipo = "Step/Draw"
        }
    }
    
    # Debug messages sem verificação
    $debugMessages = ([regex]::Matches($conteudo, "show_debug_message")).Count
    $debugChecks = ([regex]::Matches($conteudo, "debug_enabled|debug_level")).Count
    
    if ($debugMessages -gt 0 -and $debugChecks -eq 0) {
        $resultados.DebugSemVerificacao += [PSCustomObject]@{
            Arquivo = $arquivo.FullName
            DebugMessages = $debugMessages
        }
    }
}

# Gerar relatório
Write-Host "`n📋 RELATÓRIO DE PERFORMANCE" -ForegroundColor Cyan
Write-Host "=" * 60

Write-Host "`n⚠️  VERIFICAÇÕES EXCESSIVAS (>5 verificações):" -ForegroundColor Yellow
if ($resultados.VerificacoesExcessivas.Count -eq 0) {
    Write-Host "  ✅ Nenhuma verificação excessiva encontrada" -ForegroundColor Green
} else {
    foreach ($item in $resultados.VerificacoesExcessivas | Sort-Object Verificacoes -Descending | Select-Object -First 10) {
        Write-Host "  - $($item.Arquivo): $($item.Verificacoes) verificações" -ForegroundColor Red
    }
}

Write-Host "`n⚠️  DEBUG MESSAGES SEM VERIFICAÇÃO:" -ForegroundColor Yellow
if ($resultados.DebugSemVerificacao.Count -eq 0) {
    Write-Host "  ✅ Todos os debug messages têm verificação" -ForegroundColor Green
} else {
    foreach ($item in $resultados.DebugSemVerificacao | Sort-Object DebugMessages -Descending | Select-Object -First 10) {
        Write-Host "  - $($item.Arquivo): $($item.DebugMessages) mensagens sem verificação" -ForegroundColor Red
    }
}

# Estatísticas
Write-Host "`n📊 ESTATÍSTICAS:" -ForegroundColor Cyan
Write-Host "  - Arquivos analisados: $($arquivos.Count)" -ForegroundColor White
Write-Host "  - Verificações excessivas: $($resultados.VerificacoesExcessivas.Count)" -ForegroundColor White
Write-Host "  - Debug sem verificação: $($resultados.DebugSemVerificacao.Count)" -ForegroundColor White

# Recomendações
Write-Host "`n💡 RECOMENDAÇÕES:" -ForegroundColor Cyan
Write-Host "  1. Substituir show_debug_message por scr_debug_log" -ForegroundColor Yellow
Write-Host "  2. Remover verificações de variáveis próprias" -ForegroundColor Yellow
Write-Host "  3. Cache de verificações que não mudam" -ForegroundColor Yellow
Write-Host "  4. Mover verificações estáticas para Create" -ForegroundColor Yellow

Write-Host "`n✅ Análise concluída!" -ForegroundColor Green
Write-Host "`n📖 Consulte docs/GUIA_OTIMIZACAO_PERFORMANCE.md para mais informações" -ForegroundColor Yellow

