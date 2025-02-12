# write new rdp port
$port = Read-Host "Type new port"
# deploing new port into Registry
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d $port /f
# add firewall accepting TCP rule
netsh advfirewall firewall add rule name="RDP Custom Port" dir=in action=allow protocol=TCP localport=$port
# add firewall accepting UDP rule
netsh advfirewall firewall add rule name="RDP Custom Port" dir=in action=allow protocol=UDP localport=$port
# reload Terminal Service
net stop TermService /y
net start TermService
# Well Done.
Write-Host "RDP port has been changed. New RDP is $port"
Read-Host "Press Enter for exit."