# Script de Backup dos Arquivos Corretos
# Salva versões corretas dos arquivos .yy para restauração rápida

Write-Host "=== SISTEMA DE BACKUP DE ARQUIVOS CORRETOS ===" -ForegroundColor Green

# Criar diretório de backup
$backupDir = ".\backup_correct_files"
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
    Write-Host "📁 Diretório de backup criado: $backupDir" -ForegroundColor Green
}

# Função para corrigir e fazer backup
function Backup-CorrectFile {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        return $false
    }
    
    # Corrigir o arquivo primeiro
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $originalContent = $content
    
    # Aplicar correções
    $content = $content -replace ',\s*}\s*$', '}'
    $content = $content -replace ',\s*\]\s*$', ']'
    $content = $content -replace ',\s*}\s*,(\s*\]|\s*})', '}$1'
    $content = $content -replace ',\s*\]\s*,(\s*\]|\s*})', ']$1'
    
    if ($content -ne $originalContent) {
        # Salvar versão corrigida
        Set-Content $FilePath $content -Encoding UTF8 -NoNewline
        Write-Host "✅ Corrigido: $FilePath" -ForegroundColor Green
    }
    
    # Fazer backup da versão corrigida
    $relativePath = $FilePath.Replace((Get-Location).Path + "\", "")
    $backupPath = Join-Path $backupDir $relativePath
    $backupDirPath = Split-Path $backupPath -Parent
    
    if (-not (Test-Path $backupDirPath)) {
        New-Item -ItemType Directory -Path $backupDirPath -Force | Out-Null
    }
    
    Copy-Item $FilePath $backupPath -Force
    Write-Host "💾 Backup salvo: $backupPath" -ForegroundColor Gray
    
    return $true
}

# Processar todos os arquivos .yy
Write-Host "🔧 Corrigindo e fazendo backup de todos os arquivos .yy..." -ForegroundColor Yellow

$yyFiles = Get-ChildItem -Path "." -Filter "*.yy" -Recurse
$processedCount = 0

foreach ($file in $yyFiles) {
    if (Backup-CorrectFile $file.FullName) {
        $processedCount++
    }
}

Write-Host "`n📊 Resumo:" -ForegroundColor Green
Write-Host "Arquivos processados: $($yyFiles.Count)" -ForegroundColor White
Write-Host "Arquivos com backup: $processedCount" -ForegroundColor White
Write-Host "Backup salvo em: $backupDir" -ForegroundColor White

Write-Host "`n💡 Para restaurar arquivos corretos, execute:" -ForegroundColor Yellow
Write-Host "  .\restore_correct_files.ps1" -ForegroundColor Cyan