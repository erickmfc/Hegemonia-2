# Script simples para commit e push
Set-Location "E:\Hegemonia Global\teste\Hegemonia-2"

Write-Host "Adicionando arquivos..." -ForegroundColor Yellow
git add .

Write-Host "Fazendo commit..." -ForegroundColor Yellow
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Atualização automática - $date"

Write-Host "Verificando remote..." -ForegroundColor Yellow
$remote = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Configurando remote..." -ForegroundColor Yellow
    git remote add origin https://github.com/erickmfc/Hegemonia-2.git
}

Write-Host "Fazendo push..." -ForegroundColor Yellow
git push -u origin main

Write-Host "Concluído!" -ForegroundColor Green

