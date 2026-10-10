Write-Host "`n=== Setup AI Coding Environment ===" -ForegroundColor Cyan
Write-Host "Beantwoord de volgende vragen met j (ja) of n (nee).`n" -ForegroundColor White

# 1. VS Code installatie
$hasVSCode = Read-Host "Heb je Visual Studio Code al geinstalleerd? (j/n)"
if ($hasVSCode -match "^[nN]") {
    Write-Host "`nVisual Studio Code wordt geinstalleerd...`n" -ForegroundColor Yellow
    winget install -e --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "`nVS Code wordt overgeslagen (bestaande versie blijft behouden)." -ForegroundColor Green
}
Write-Host ""

# 2. Docker Desktop installatie
$hasDocker = Read-Host "Heb je Docker Desktop al geinstalleerd? (j/n)"
if ($hasDocker -match "^[nN]") {
    Write-Host "`nDocker Desktop wordt geinstalleerd...`n" -ForegroundColor Yellow
    winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "`nDocker Desktop wordt overgeslagen (bestaande versie blijft behouden)." -ForegroundColor Green
}
Write-Host ""

# 3. Preventieve WSL Update
Write-Host "WSL (Windows Subsystem for Linux) controleren en updaten ter preventie van Docker-fouten...`n" -ForegroundColor Yellow
wsl --update
Write-Host "`nWSL is up-to-date en klaar voor gebruik." -ForegroundColor Green
Write-Host ""

# 4. VS Code Extensies
Write-Host "Benodigde VS Code extensies installeren...`n" -ForegroundColor Yellow
# 2>$null verbergt de onschuldige NodeJS Deprecation warning van Microsoft zelf
code --install-extension ms-vscode-remote.remote-containers --force 2>$null

Write-Host "`n=== Setup Voltooid! ===" -ForegroundColor Cyan
Write-Host "Let op: Als Docker net is geinstalleerd of WSL is geupdatet, moet je mogelijk je computer herstarten.`n" -ForegroundColor Red