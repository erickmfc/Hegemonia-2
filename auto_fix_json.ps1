# Script Avançado para Correção Automática de JSON
# Monitora e corrige vírgulas extras em arquivos .yy do GameMaker Studio
# Autor: Assistente AI

param(
    [switch]$Watch = $false,
    [switch]$FixAll = $false,
    [string]$TargetFile = ""
)

Write-Host "=== CORRETOR AUTOMÁTICO DE JSON PARA GAMEMAKER STUDIO ===" -ForegroundColor Green
Write-Host "Versão: 2.0 - Sistema Avançado de Correção" -ForegroundColor Yellow

# Função para corrigir um arquivo específico
function Fix-JsonFile {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "❌ Arquivo não encontrado: $FilePath" -ForegroundColor Red
        return $false
    }
    
    Write-Host "🔍 Analisando: $FilePath" -ForegroundColor Cyan
    
    # Ler o conteúdo do arquivo
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $originalContent = $content
    
    # Padrões de correção mais específicos
    $patterns = @(
        # Remover vírgulas antes de fechamentos de objetos
        @{Pattern = ',\s*}\s*$'; Replacement = '}'},
        @{Pattern = ',\s*\]\s*$'; Replacement = ']'},
        # Remover vírgulas extras em objetos dentro de arrays
        @{Pattern = ',\s*}\s*,(\s*\]|\s*})'; Replacement = '}$1'},
        @{Pattern = ',\s*\]\s*,(\s*\]|\s*})'; Replacement = ']$1'},
        # Casos específicos do GameMaker Studio
        @{Pattern = ',\s*}\s*,(\s*\]|\s*})'; Replacement = '}$1'},
        @{Pattern = ',\s*\]\s*,(\s*\]|\s*})'; Replacement = ']$1'}
    )
    
    $changes = 0
    foreach ($pattern in $patterns) {
        $newContent = $content -replace $pattern.Pattern, $pattern.Replacement
        if ($newContent -ne $content) {
            $content = $newContent
            $changes++
        }
    }
    
    # Verificar se houve mudanças
    if ($content -ne $originalContent) {
        # Criar backup com timestamp
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupPath = $FilePath + ".backup_$timestamp"
        Copy-Item $FilePath $backupPath -Force
        Write-Host "  💾 Backup criado: $backupPath" -ForegroundColor Gray
        
        # Salvar o arquivo corrigido
        Set-Content $FilePath $content -Encoding UTF8 -NoNewline
        Write-Host "  ✅ Arquivo corrigido! ($changes correções)" -ForegroundColor Green
        return $true
    } else {
        Write-Host "  ✅ Arquivo já está correto" -ForegroundColor Green
        return $false
    }
}

# Função para monitorar arquivos
function Start-FileWatcher {
    Write-Host "👀 Iniciando monitoramento de arquivos .yy..." -ForegroundColor Yellow
    Write-Host "Pressione Ctrl+C para parar" -ForegroundColor Gray
    
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = Get-Location
    $watcher.Filter = "*.yy"
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true
    
    $action = {
        $path = $Event.SourceEventArgs.FullPath
        $changeType = $Event.SourceEventArgs.ChangeType
        
        if ($changeType -eq "Changed") {
            Write-Host "📝 Arquivo modificado: $path" -ForegroundColor Yellow
            Start-Sleep -Milliseconds 500  # Aguardar o arquivo ser completamente salvo
            Fix-JsonFile $path
        }
    }
    
    Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action
    
    try {
        while ($true) {
            Start-Sleep -Seconds 1
        }
    } finally {
        $watcher.Dispose()
        Get-EventSubscriber | Unregister-Event
    }
}

# Função principal
function Main {
    if ($TargetFile -ne "") {
        # Corrigir arquivo específico
        Fix-JsonFile $TargetFile
    } elseif ($FixAll) {
        # Corrigir todos os arquivos .yy
        Write-Host "🔧 Corrigindo todos os arquivos .yy..." -ForegroundColor Yellow
        $yyFiles = Get-ChildItem -Path "." -Filter "*.yy" -Recurse
        $fixedCount = 0
        
        foreach ($file in $yyFiles) {
            if (Fix-JsonFile $file.FullName) {
                $fixedCount++
            }
        }
        
        Write-Host "`n📊 Resumo:" -ForegroundColor Green
        Write-Host "Arquivos processados: $($yyFiles.Count)" -ForegroundColor White
        Write-Host "Arquivos corrigidos: $fixedCount" -ForegroundColor White
    } elseif ($Watch) {
        # Modo de monitoramento
        Start-FileWatcher
    } else {
        # Mostrar ajuda
        Write-Host "`n📖 Como usar:" -ForegroundColor Cyan
        Write-Host "  .\auto_fix_json.ps1 -FixAll                    # Corrigir todos os arquivos" -ForegroundColor White
        Write-Host "  .\auto_fix_json.ps1 -TargetFile 'arquivo.yy'   # Corrigir arquivo específico" -ForegroundColor White
        Write-Host "  .\auto_fix_json.ps1 -Watch                     # Monitorar arquivos em tempo real" -ForegroundColor White
        Write-Host "`n💡 Dica: Use -Watch para correção automática durante o desenvolvimento!" -ForegroundColor Yellow
    }
}

# Executar função principal
Main
