# write new rdp port
$port = Read-Host "Type new port"
#reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d $port /f
#netsh advfirewall firewall add rule name="RDP Custom Port" dir=in action=allow protocol=TCP localport=$port
#netsh advfirewall firewall add rule name="RDP Custom Port" dir=in action=allow protocol=UDP localport=$port
#net stop TermService /y
#net start TermService
Write-Host "RDP port has been changed. New RDP is $port"
Read-Host "Press Enter for exit."