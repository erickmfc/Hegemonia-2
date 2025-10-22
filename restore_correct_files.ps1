# Script de Restauração de Arquivos Corretos
# Restaura versões corretas dos arquivos .yy do backup

Write-Host "=== RESTAURADOR DE ARQUIVOS CORRETOS ===" -ForegroundColor Green

$backupDir = ".\backup_correct_files"

if (-not (Test-Path $backupDir)) {
    Write-Host "❌ Diretório de backup não encontrado: $backupDir" -ForegroundColor Red
    Write-Host "Execute primeiro: .\backup_correct_files.ps1" -ForegroundColor Yellow
    exit 1
}

# Função para restaurar arquivo
function Restore-File {
    param([string]$BackupPath, [string]$TargetPath)
    
    if (-not (Test-Path $BackupPath)) {
        return $false
    }
    
    # Criar diretório de destino se não existir
    $targetDir = Split-Path $TargetPath -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    
    # Fazer backup do arquivo atual antes de restaurar
    if (Test-Path $TargetPath) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $currentBackup = $TargetPath + ".current_backup_$timestamp"
        Copy-Item $TargetPath $currentBackup -Force
        Write-Host "  💾 Backup atual salvo: $currentBackup" -ForegroundColor Gray
    }
    
    # Restaurar arquivo
    Copy-Item $BackupPath $TargetPath -Force
    Write-Host "  ✅ Restaurado: $TargetPath" -ForegroundColor Green
    return $true
}

Write-Host "🔄 Restaurando arquivos corretos..." -ForegroundColor Yellow

$backupFiles = Get-ChildItem -Path $backupDir -Filter "*.yy" -Recurse
$restoredCount = 0

foreach ($backupFile in $backupFiles) {
    $relativePath = $backupFile.FullName.Replace((Join-Path (Get-Location).Path "backup_correct_files") + "\", "")
    $targetPath = Join-Path (Get-Location) $relativePath
    
    if (Restore-File $backupFile.FullName $targetPath) {
        $restoredCount++
    }
}

Write-Host "`n📊 Resumo:" -ForegroundColor Green
Write-Host "Arquivos restaurados: $restoredCount" -ForegroundColor White
Write-Host "Backup usado: $backupDir" -ForegroundColor White

Write-Host "`n✅ Restauração concluída!" -ForegroundColor Green
Write-Host "O projeto agora deve carregar corretamente no GameMaker Studio." -ForegroundColor Yellow
