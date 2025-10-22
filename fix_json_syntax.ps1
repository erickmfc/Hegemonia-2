# Script para corrigir problemas de sintaxe JSON em arquivos .yy do GameMaker Studio
# Autor: Assistente AI
# Data: $(Get-Date)

Write-Host "=== Corretor de Sintaxe JSON para GameMaker Studio ===" -ForegroundColor Green
Write-Host "Procurando arquivos .yy com problemas de vírgulas extras..." -ForegroundColor Yellow

# Função para corrigir vírgulas extras em um arquivo
function Fix-JsonFile {
    param([string]$FilePath)
    
    Write-Host "Corrigindo: $FilePath" -ForegroundColor Cyan
    
    # Ler o conteúdo do arquivo
    $content = Get-Content $FilePath -Raw
    
    # Padrões de correção
    $patterns = @(
        # Remover vírgulas antes de fechamentos de objetos/arrays
        @{Pattern = ',\s*}\s*$'; Replacement = '}'},
        @{Pattern = ',\s*\]\s*$'; Replacement = ']'},
        # Remover vírgulas extras em objetos dentro de arrays
        @{Pattern = ',\s*}\s*,(\s*\]|\s*})'; Replacement = '}$1'},
        @{Pattern = ',\s*\]\s*,(\s*\]|\s*})'; Replacement = ']$1'}
    )
    
    $originalContent = $content
    
    foreach ($pattern in $patterns) {
        $content = $content -replace $pattern.Pattern, $pattern.Replacement
    }
    
    # Verificar se houve mudanças
    if ($content -ne $originalContent) {
        # Fazer backup do arquivo original
        $backupPath = $FilePath + ".backup"
        Copy-Item $FilePath $backupPath -Force
        Write-Host "  Backup criado: $backupPath" -ForegroundColor Gray
        
        # Salvar o arquivo corrigido
        Set-Content $FilePath $content -Encoding UTF8
        Write-Host "  ✓ Arquivo corrigido!" -ForegroundColor Green
        return $true
    } else {
        Write-Host "  ✓ Arquivo já está correto" -ForegroundColor Green
        return $false
    }
}

# Procurar todos os arquivos .yy
$yyFiles = Get-ChildItem -Path "." -Filter "*.yy" -Recurse

$fixedCount = 0
$totalFiles = $yyFiles.Count

Write-Host "Encontrados $totalFiles arquivos .yy" -ForegroundColor Yellow

foreach ($file in $yyFiles) {
    if (Fix-JsonFile $file.FullName) {
        $fixedCount++
    }
}

Write-Host "`n=== Resumo ===" -ForegroundColor Green
Write-Host "Arquivos processados: $totalFiles" -ForegroundColor White
Write-Host "Arquivos corrigidos: $fixedCount" -ForegroundColor White

if ($fixedCount -gt 0) {
    Write-Host "`n✓ Correções aplicadas com sucesso!" -ForegroundColor Green
    Write-Host "Os backups dos arquivos originais foram salvos com extensão .backup" -ForegroundColor Yellow
} else {
    Write-Host "`n✓ Nenhum problema encontrado!" -ForegroundColor Green
}

Write-Host "`nPressione qualquer tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
