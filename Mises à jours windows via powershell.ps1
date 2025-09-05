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

# Étape 4 : Vérifier les mises à jour disponibles
Write-Host "`nRecherche des mises à jour disponibles..." -ForegroundColor Green
Get-WindowsUpdate

# Étape 5 : Installer toutes les mises à jour disponibles et redémarrer si nécessaire
Write-Host "`nInstallation des mises à jour disponibles (avec redémarrage automatique si nécessaire)..." -ForegroundColor Green
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

Write-Host "`nScript terminé. Le système peut redémarrer automatiquement si nécessaire." -ForegroundColor Cyan
