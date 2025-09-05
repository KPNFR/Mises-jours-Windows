# Vérifie si le script est exécuté en tant qu'administrateur
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Warning "Ce script doit être exécuté en tant qu'administrateur."
    Break
}

Write-Host "Début du script de mise à jour Windows via PowerShell" -ForegroundColor Cyan

# Étape 1 : Installer le module PSWindowsUpdate
Write-Host "Installation du module PSWindowsUpdate..." -ForegroundColor Yellow
Install-Module -Name PSWindowsUpdate -Force -Confirm:$false

# Étape 2 : Définir la stratégie d'exécution pour ce processus
Write-Host "Définition de la stratégie d'exécution à RemoteSigned (temporaire)..." -ForegroundColor Yellow
Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# Étape 3 : Importer le module
Write-Host "Importation du module PSWindowsUpdate..." -ForegroundColor Yellow
Import-Module PSWindowsUpdate -Force -Verbose

# Étape 4 : Boucle pour installer toutes les mises à jour disponibles
do {
    Write-Host "`nRecherche des mises à jour disponibles..." -ForegroundColor Green
    $updates = Get-WindowsUpdate -MicrosoftUpdate -IgnoreUserInput -AcceptAll

    if ($updates) {
        Write-Host "`nInstallation des mises à jour disponibles..." -ForegroundColor Green
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot -Verbose
        Write-Host "Redémarrage si nécessaire..." -ForegroundColor Yellow
        Restart-Computer -Force
        Start-Sleep -Seconds 60  # Attend le redémarrage et la reprise
    }
} while (Get-WindowsUpdate -MicrosoftUpdate -IgnoreUserInput -AcceptAll)

Write-Host "`nToutes les mises à jour sont installées. Le système peut redémarrer automatiquement si nécessaire." -ForegroundColor Cyan
