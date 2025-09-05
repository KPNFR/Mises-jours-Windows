# Vérifie l'exécution en admin
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Ce script doit être exécuté en tant qu'administrateur."
    Break
}

Write-Host "Début du script de mise à jour Windows..." -ForegroundColor Cyan

# Installer et importer le module
Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
Import-Module PSWindowsUpdate -Force -Verbose

do {
    # Récupérer toutes les mises à jour disponibles
    $updates = Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreUserInput -Category "Updates","OptionalUpdates" -Verbose

    if ($updates.Count -gt 0) {
        # Installer toutes les mises à jour
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot -Category "Updates","OptionalUpdates" -Verbose
        Write-Host "Mises à jour installées. Redémarrage si nécessaire..."
        Restart-Computer -Force
        Start-Sleep -Seconds 60
    }

} while ($updates.Count -gt 0)

Write-Host "Toutes les mises à jour ont été installées." -ForegroundColor Cyan
