Set-Location "E:\Hegemonia Global\teste\Hegemonia-2"
if (-not (Test-Path .git)) { git init }
git add .
git commit -m "Atualizacao automatica $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git remote remove origin 2>$null
git remote add origin https://github.com/erickmfc/Hegemonia-2.git
git push -u origin master --force
Write-Host "Concluido!" -ForegroundColor Green

