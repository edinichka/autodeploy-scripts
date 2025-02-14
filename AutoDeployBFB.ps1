# variables
$downloadScript = "https://github.com/edinichka/autodeploy-scripts/raw/refs/heads/main/BFGuard.ps1"
$downloadTask = "https://github.com/edinichka/autodeploy-scripts/raw/refs/heads/main/BFGuardTask.xml"
$scriptPath = "C:\BFGuard\BFGuard.ps1"
$taskPath = "C:\BFGuard\BFGuardTask.xml"

# create dir
if (!(Test-Path "C:\Scripts")) {
    New-Item -ItemType Directory -Path "C:\BFGuard"
}

# download script
Invoke-WebRequest -Uri $downloadScript -OutFile $scriptPath
Invoke-WebRequest -Uri $downloadTask -OutFile $taskPath

#deploy task and run it
#additionally clear security events in case of random blocks
Clear-EventLog -LogName Security
schtasks /create /tn "BFGuardTask" /xml $taskPath /f
Start-Sleep -Seconds 5
Start-ScheduledTask -TaskName "BFGuardTask"
