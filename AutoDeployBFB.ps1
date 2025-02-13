# variables
$downloadUrl = "https://github.com/edinichka/autodeploy-rdp-custom-port/raw/refs/heads/main/BFGuard.ps1"
$scriptPath = "C:\Scripts\BFGuard.ps1"           # ???? ???????? ??? ??????
$taskName = "AutoBlockBruteForce"

# create dir
if (!(Test-Path "C:\Scripts")) {
    New-Item -ItemType Directory -Path "C:\Scripts"
}

# download script
Invoke-WebRequest -Uri $downloadUrl -OutFile $scriptPath

# create 
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration (New-TimeSpan -Days 3650) -At (Get-Date).Date
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd -AllowHardTerminate -MultipleInstances IgnoreNew

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest -Force

Write-Output "Task $taskName succesfully created, script was downloaded and deployed in $scriptPath"
