@echo off
setlocal
cls
echo.
echo === Setup AI Coding Environment ===
echo Dit script controleert wat al geinstalleerd is en installeert alleen wat ontbreekt.
echo.

set "WARNINGS=0"
set "NEEDS_ADMIN="
set "NO_ADMIN="
set "ADMIN_CONTINUE="

:: ---- 0. Controles vooraf ----
where winget >nul 2>nul
if errorlevel 1 goto :no_winget

:: ---- 1. Visual Studio Code ----
echo.
set "CODE_CMD="
call :find_code
if defined CODE_CMD goto :vscode_present

echo Visual Studio Code is niet gevonden en wordt geinstalleerd...
echo.
winget install -e --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements
set "RC=%ERRORLEVEL%"
if "%RC%"=="0" goto :vscode_installed
call :winget_is_fatal "%RC%"
if errorlevel 1 goto :vscode_failed
echo [Waarschuwing] winget gaf code %RC% terug, maar meldt dat de software al aanwezig is.
set /a WARNINGS+=1
goto :vscode_installed

:vscode_present
echo Visual Studio Code is al geinstalleerd: %CODE_CMD%
echo VS Code wordt overgeslagen, bestaande versie blijft behouden.
goto :vscode_done

:vscode_installed
echo.
echo Visual Studio Code is klaar voor gebruik.
goto :vscode_done

:vscode_failed
echo [Fout] Installatie van Visual Studio Code is mislukt ^(winget code %RC%^).
goto :fatal

:vscode_done
:: Na een verse installatie staat de code-CLI nog niet in PATH van deze sessie,
:: daarom zoeken we hem hier opnieuw op de standaard installatielocatie.
call :find_code

:: ---- 2. Docker Desktop ----
echo.
set "DOCKER_FOUND="
call :find_docker
if defined DOCKER_FOUND goto :docker_present

echo Docker Desktop is niet gevonden en wordt geinstalleerd...
echo.
call :admin_gate "Docker Desktop installeren"
if errorlevel 1 goto :docker_no_admin

winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
set "RC=%ERRORLEVEL%"
if "%RC%"=="0" goto :docker_installed
call :winget_is_fatal "%RC%"
if errorlevel 1 goto :docker_failed
echo [Waarschuwing] winget gaf code %RC% terug, maar meldt dat de software al aanwezig is.
set /a WARNINGS+=1
goto :docker_installed

:docker_present
echo Docker Desktop is al geinstalleerd: %DOCKER_FOUND%
echo Docker Desktop wordt overgeslagen, bestaande versie blijft behouden.
goto :docker_done

:docker_installed
echo.
echo Docker Desktop is klaar voor gebruik.
goto :docker_done

:docker_failed
echo [Fout] Installatie van Docker Desktop is mislukt ^(winget code %RC%^).
goto :fatal

:docker_no_admin
echo [Waarschuwing] Docker Desktop is niet geinstalleerd; deze stap is overgeslagen.
set /a WARNINGS+=1
set "NEEDS_ADMIN=1"
goto :docker_done

:docker_done

:: ---- 3. Preventieve WSL Update ----
echo.
echo WSL - Windows Subsystem for Linux - controleren en updaten ter preventie van Docker-fouten...
echo.
call :admin_gate "WSL bijwerken met wsl --update"
if errorlevel 1 goto :wsl_no_admin

wsl --update
set "RC=%ERRORLEVEL%"
if not "%RC%"=="0" goto :wsl_failed
echo.
echo WSL is up-to-date en klaar voor gebruik.
goto :wsl_done

:wsl_failed
echo [Waarschuwing] wsl --update gaf code %RC% terug; Docker kan hierdoor fouten geven.
echo               Probeer dit later handmatig opnieuw met: wsl --update
set /a WARNINGS+=1
goto :wsl_done

:wsl_no_admin
echo [Waarschuwing] WSL is niet bijgewerkt; deze stap is overgeslagen.
echo               Docker kan hierdoor fouten geven.
set /a WARNINGS+=1
set "NEEDS_ADMIN=1"

:wsl_done

:: ---- 4. VS Code Extensies ----
echo.
echo Benodigde VS Code extensies installeren...
echo.
call :find_code
if not defined CODE_CMD goto :ext_manual

:: 2>nul onderdrukt de interne NodeJS DeprecationWarning van VS Code
:: call is verplicht: code.cmd is een batchbestand en zou het script anders beeindigen
call "%CODE_CMD%" --install-extension ms-vscode-remote.remote-containers --force 2>nul
set "RC=%ERRORLEVEL%"
if "%RC%"=="0" goto :ext_installed
echo [Waarschuwing] Toevoegen van de Dev Containers extensie is mislukt ^(code %RC%^).
goto :ext_manual

:ext_installed
echo Dev Containers extensie is toegevoegd.
goto :ext_done

:ext_manual
echo [Let op] De Dev Containers extensie kon niet automatisch worden toegevoegd.
echo Installeer deze straks zelf in VS Code. Windows moet hiervoor mogelijk eerst herstarten.
set /a WARNINGS+=1

:ext_done
:: ---- Afronden ----
echo.
if %WARNINGS% EQU 0 goto :finish_ok
echo === Setup voltooid met waarschuwingen ===
goto :finish_note

:finish_ok
echo === Setup Voltooid! ===

:finish_note
echo Let op: Als Docker net is geinstalleerd of WSL is geupdatet, moet je mogelijk je computer herstarten.
if defined NEEDS_ADMIN echo Start dit script opnieuw in "Terminal (Admin)" om de overgeslagen stappen uit te voeren.
echo.
pause
if %WARNINGS% EQU 0 exit /b 0
exit /b 1

:: ---- Foutafhandeling ----
:no_winget
echo [Fout] winget is niet gevonden. Installeer de "App Installer" uit de Microsoft Store
echo        en voer .\setup.cmd opnieuw uit.
goto :fatal

:fatal
echo.
echo === Setup afgebroken ===
if defined NO_ADMIN echo Tip: draai het script in "Terminal (Admin)" en probeer het daarna opnieuw.
echo Los de bovenstaande fout op en voer .\setup.cmd opnieuw uit.
echo.
pause
exit /b 1

:: ---- Subroutines ----

:admin_gate
:: %1 = de stap die beheerdersrechten nodig heeft.
:: errorlevel 0 = stap uitvoeren, errorlevel 1 = stap overslaan.
:: Zonder beheerdersrechten wordt er alleen gewaarschuwd; de gebruiker beslist.
call :is_admin
if not errorlevel 1 exit /b 0
set "NO_ADMIN=1"
if defined ADMIN_CONTINUE goto :admin_gate_choice
echo.
echo [Waarschuwing] Voor deze stap zijn mogelijk beheerdersrechten (admin) nodig: %~1
echo                Zonder beheerdersrechten kan Windows om een UAC-melding vragen of mislukt de stap.
echo                Je kunt het script ook opnieuw starten in "Terminal (Admin)". 
set "ADMIN_CONTINUE=n"
set /p ADMIN_CONTINUE="Toch doorgaan zonder beheerdersrechten? (j/n): "
:admin_gate_choice
if /i "%ADMIN_CONTINUE%"=="j" exit /b 0
exit /b 1

:is_admin
:: errorlevel 0 als het script met beheerdersrechten draait.
net session >nul 2>&1
if not errorlevel 1 exit /b 0
whoami /groups 2>nul | findstr /c:"S-1-16-12288" >nul
if not errorlevel 1 exit /b 0
exit /b 1

:find_code
:: Zet CODE_CMD naar het volledige pad van de VS Code CLI (code.cmd).
:: CODE_CMD blijft leeg als VS Code niet gevonden wordt.
set "CODE_CMD="
if exist "%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd" set "CODE_CMD=%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd"
if not defined CODE_CMD if exist "%ProgramFiles%\Microsoft VS Code\bin\code.cmd" set "CODE_CMD=%ProgramFiles%\Microsoft VS Code\bin\code.cmd"
if defined CODE_CMD exit /b 0
where code.cmd >nul 2>nul
if errorlevel 1 exit /b 1
for /f "delims=" %%I in ('where code.cmd 2^>nul') do if not defined CODE_CMD set "CODE_CMD=%%I"
if not defined CODE_CMD exit /b 1
exit /b 0

:find_docker
:: Zet DOCKER_FOUND als Docker Desktop (of de docker CLI) aanwezig is.
set "DOCKER_FOUND="
if exist "%ProgramFiles%\Docker\Docker\Docker Desktop.exe" set "DOCKER_FOUND=%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
if defined DOCKER_FOUND exit /b 0
where docker.exe >nul 2>nul
if errorlevel 1 exit /b 1
for /f "delims=" %%I in ('where docker.exe 2^>nul') do if not defined DOCKER_FOUND set "DOCKER_FOUND=%%I"
if not defined DOCKER_FOUND exit /b 1
exit /b 0

:winget_is_fatal
:: %1 = exit code van winget; errorlevel 0 betekent een onschuldige melding.
set "WRC=%~1"
if "%WRC%"=="0" exit /b 0
rem 0x8A15002B - pakket is al geinstalleerd
if "%WRC%"=="-1978335189" exit /b 0
if "%WRC%"=="2316632107" exit /b 0
rem 0x8A150061 - geen toepasbare update (al up-to-date)
if "%WRC%"=="-1978335135" exit /b 0
if "%WRC%"=="2316632161" exit /b 0
rem 3010 - geslaagd, maar herstart vereist
if "%WRC%"=="3010" exit /b 0
exit /b 1

