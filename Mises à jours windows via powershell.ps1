# Vérifie si le script est exécuté en tant qu'administrateur
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Warning "Ce script doit être exécuté en tant qu'administrateur."
    Break
}

Write-Host "Début du script de mise à jour Windows via PowerShell" -ForegroundColor Cyan

# Installer et importer le module PSWindowsUpdate
Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
Import-Module PSWindowsUpdate -Force -Verbose

# Boucle pour installer toutes les mises à jour importantes et facultatives
do {
    Write-Host "`nRecherche des mises à jour disponibles..." -ForegroundColor Green
    # Inclut les mises à jour facultatives
    $updates = Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreUserInput -Category "Updates","OptionalUpdates"

    if ($updates) {
        Write-Host "`nInstallation des mises à jour disponibles..." -ForegroundColor Green
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot -Verbose -Category "Updates","OptionalUpdates"
        Write-Host "Redémarrage si nécessaire..." -ForegroundColor Yellow
        Restart-Computer -Force
        Start-Sleep -Seconds 60
    }
} while (Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreUserInput -Category "Updates","OptionalUpdates")

Write-Host "`nToutes les mises à jour, y compris facultatives, sont installées. Le système peut redémarrer automatiquement si nécessaire." -ForegroundColor Cyan
