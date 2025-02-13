# Setup
$threshold = 5
$firewallRulePrefix = "BruteForceBlock_"
$whiteListFile = Join-Path $PSScriptRoot "whitelist.txt"

# Creating whitelist file
if (-not (Test-Path $whiteListFile)) {
    New-Item -Path $whiteListFile -ItemType File -Force | Out-Null
    Write-Output "Create wl file: $whiteListFile"
}

# Import ip whitelist
$whiteListIPs = Get-Content $whiteListFile -ErrorAction SilentlyContinue | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

# Check bad logon events
$events = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=4625)]]" -ErrorAction SilentlyContinue

$ipAttempts = @{}

foreach ($event in $events) {
    $xml = [xml]$event.ToXml()
    $ip = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "IpAddress" } | Select-Object -ExpandProperty "#text"

    if ($ip -and $ip -ne "::1" -and $ip -ne "127.0.0.1") {
        if ($ipAttempts.ContainsKey($ip)) {
            $ipAttempts[$ip]++
        } else {
            $ipAttempts[$ip] = 1
        }
    }
}

# Define the IPs to be blocked
$ipsToBlock = $ipAttempts.GetEnumerator() | Where-Object { $_.Value -gt $threshold -and $whiteListIPs -notcontains $_.Key } | Select-Object -ExpandProperty Key

# Check existing fw rules
$existingRules = Get-NetFirewallRule -DisplayName "${firewallRulePrefix}*" -ErrorAction SilentlyContinue | ForEach-Object { $_.DisplayName -replace "^$firewallRulePrefix", "" }

foreach ($ip in $ipsToBlock) {
    if ($existingRules -notcontains $ip) {
        Write-Output "Блокую IP: $ip"
        New-NetFirewallRule -DisplayName "${firewallRulePrefix}$ip" -Direction Inbound -RemoteAddress $ip -Action Block -Profile Any
    } else {
        Write-Output "IP вже заблокований: $ip"
    }
}

Write-Output "Обробка завершена."
