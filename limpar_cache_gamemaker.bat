@echo off
echo ========================================
echo LIMPEZA DE CACHE GAMEMAKER STUDIO 2
echo ========================================
echo.

echo Limpando GMS2TEMP...
if exist "%LOCALAPPDATA%\GameMakerStudio2\GMS2TEMP" (
    rd /s /q "%LOCALAPPDATA%\GameMakerStudio2\GMS2TEMP"
    echo ✅ GMS2TEMP limpo!
) else (
    echo ⚠️ Pasta GMS2TEMP nao encontrada
)

echo.
echo Limpando Cache do GameMaker...
if exist "%APPDATA%\GameMakerStudio2\Cache" (
    rd /s /q "%APPDATA%\GameMakerStudio2\Cache"
    echo ✅ Cache limpo!
) else (
    echo ⚠️ Pasta Cache nao encontrada
)

echo.
echo Limpando arquivos temporarios do Windows...
del /q /f /s "%TEMP%\*" >nul 2>&1
echo ✅ Temp limpo!

echo.
echo ========================================
echo Limpeza concluida!
echo ========================================
pause

