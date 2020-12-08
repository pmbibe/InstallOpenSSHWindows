$UriOpenSSH = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.1.0.0p1-Beta/OpenSSH-Win64.zip"
$OutFileOpenSSH = "C:\Users\Administrator\Desktop\OpenSSH-Win64.zip"
# Decleare Jenkins's key in jenkinsPK
$jenkinsPK = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkTXXG6bnAo7VuKcWTGz3AzMMjlfFfpXiojBDGYv9rHJsCM6Yeyrad+mj9QfNRAan9aYB6tPcCiSmS74m1nWjaHWB/iHch0szNbTRbzb+gHterFrzPMnyh2P055my+TxRYCqG8B/pT8kpf3BO38ZtQiNr3i9hUL9933zJp62bUIprbaxCdRXoKtuWLAT2rz3DCCIiYVyrfX0TgEEdDBq0Pl9jbLpFsPNAiBmX85PbS8yuw1we5nPekWLJBLEctqSM8UAg0pySfhra7i287eOkiaACxjuFZi7xuDHOE3Mi5VtB9sggatEJ3u2gAqavtZ/WoFYPWgVC/K8vpnZOePFXL jenkins@Jenkins"
$sshUser = 'C:\Users\Administrator\.ssh'
$Destination = "C:\Program Files\OpenSSH-Win64"
$sshConfigFile = 'C:\ProgramData\ssh\sshd_config'
$sshConfig = "AuthorizedKeysFile .ssh/authorized_keys`r`nPasswordAuthentication no"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $UriOpenSSH -OutFile $OutFileOpenSSH
Add-Type -Assembly "System.IO.Compression.Filesystem"
[System.IO.Compression.ZipFile]::ExtractToDirectory($OutFileOpenSSH,$Destination)
cd $Destination\OpenSSH-Win64
.\install-sshd.ps1
Start-Service sshd
[system.io.directory]::CreateDirectory($sshUser)
New-Item $sshUser\authorized_keys -ItemType "file" -Value $jenkinsPK    
netsh advfirewall firewall add rule name=SSHPort dir=in action=allow protocol=TCP localport=22
$sshConfig | Set-Content $sshConfigFile
Restart-Service sshd
Set-Service -Name sshd -StartupType "Automatic"
