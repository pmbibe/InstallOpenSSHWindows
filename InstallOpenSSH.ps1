$UriOpenSSH = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.1.0.0p1-Beta/OpenSSH-Win64.zip"
$OutFileOpenSSH = "C:\Users\Administrator\Desktop\OpenSSH-Win64.zip"
$Destination = "C:\Program Files\OpenSSH-Win64"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $UriOpenSSH -OutFile $OutFileOpenSSH
Add-Type -Assembly "System.IO.Compression.Filesystem"
[System.IO.Compression.ZipFile]::ExtractToDirectory($OutFileOpenSSH,$Destination)
cd $Destination
cd .\OpenSSH-Win64
.\install-sshd.ps1
Start-Service sshd
netsh advfirewall firewall add rule name=SSHPort dir=in action=allow protocol=TCP localport=22
Set-Service -Name sshd -StartupType "Automatic"