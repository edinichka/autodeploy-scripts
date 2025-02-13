# змінні
$downloadUrl = "https://github.com/edinichka/autodeploy-rdp-custom-port/raw/refs/heads/main/BFGuard.ps1"
$scriptPath = "C:\Scripts\BFGuard.ps1"           # Шлях до скрипта
$taskName = "AutoBlockBruteForce"

# створити директорію
if (!(Test-Path "C:\Scripts")) {
    New-Item -ItemType Directory -Path "C:\Scripts"
}

# завантажити скрипт
Invoke-WebRequest -Uri $downloadUrl -OutFile $scriptPath

# створити дію
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

# створити тригер для запуску кожні 10 хвилин, починаючи з поточного часу
$trigger = New-ScheduledTaskTrigger -At (Get-Date).AddMinutes(1)
$trigger.RepetitionInterval = New-TimeSpan -Minutes 10
$trigger.RepetitionDuration = New-TimeSpan -Days 3650

# налаштування (без AllowHardTerminate)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd -MultipleInstances IgnoreNew

# зареєструвати заплановану задачу
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest -Force

Write-Output "Задача $taskName успішно створена, скрипт був завантажений і розгорнутий за адресою $scriptPath"
