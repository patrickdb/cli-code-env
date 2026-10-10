@echo off
setlocal
cls
echo.
echo === Setup AI Coding Environment ===
echo Beantwoord de volgende vragen met j (ja) of n (nee).
echo.

:: 1. VS Code installatie
set "hasVSCode="
set /p hasVSCode="Heb je Visual Studio Code al geinstalleerd? (j/n): "
if /i "%hasVSCode%"=="n" (
    echo.
    echo Visual Studio Code wordt geinstalleerd...
    echo.
    winget install -e --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements
) else (
    echo.
    echo VS Code wordt overgeslagen, bestaande versie blijft behouden.
)
echo.

:: 2. Docker Desktop installatie
set "hasDocker="
set /p hasDocker="Heb je Docker Desktop al geinstalleerd? (j/n): "
if /i "%hasDocker%"=="n" (
    echo.
    echo Docker Desktop wordt geinstalleerd...
    echo.
    winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
) else (
    echo.
    echo Docker Desktop wordt overgeslagen, bestaande versie blijft behouden.
)
echo.

:: 3. Preventieve WSL Update
echo WSL - Windows Subsystem for Linux - controleren en updaten ter preventie van Docker-fouten...
echo.
wsl --update
echo.
echo WSL is up-to-date en klaar voor gebruik.
echo.

:: 4. VS Code Extensies
echo Benodigde VS Code extensies installeren...
echo.
where code >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    :: 2>nul onderdrukt de interne NodeJS DeprecationWarning van VS Code
    code --install-extension ms-vscode-remote.remote-containers --force 2>nul
) else (
    echo [Let op] VS Code is zojuist geinstalleerd. Windows moet eerst even herstarten
    echo voordat we de extensie automatisch kunnen toevoegen.
    echo Installeer straks zelf de extensie "Dev Containers" in VS Code.
)

echo.
echo === Setup Voltooid! ===
echo Let op: Als Docker net is geinstalleerd of WSL is geupdatet, moet je mogelijk je computer herstarten.
echo.
pause
