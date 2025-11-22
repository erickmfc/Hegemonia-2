@echo off
echo ==========================================
echo   LIMPEZA DE CACHE DO GAMEMAKER
echo ==========================================
echo.
echo Feche o GameMaker antes de continuar!
echo.
pause

echo.
echo Limpando cache do projeto...
rmdir /s /q "e:\Hegemonia Global\teste\Hegemonia-2-1\Hegemonia-2-master\cache" 2>nul
rmdir /s /q "%localappdata%\GameMakerStudio2\Cache" 2>nul

echo.
echo ==========================================
echo   CACHE LIMPO COM SUCESSO!
echo ==========================================
echo.
echo Agora abra o projeto no GameMaker e compile novamente (F5).
echo.
pause
