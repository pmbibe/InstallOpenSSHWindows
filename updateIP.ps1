if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}
$IPType = "IPv4"
# $wifiInterface = Get-NetAdapter | ? {$_.Name -match "WiFi *"} 
$lanInterface = Get-NetAdapter | ? {$_.Name -match "Ethernet *"} | Get-NetIPInterface -AddressFamily $IPType 

# if ($wifiInterface.Status -eq "Up") {
#     Disable-NetAdapter $wifiInterface.Name -Confirm:$false 
# }
if ($lanInterface.Dhcp -eq "Disabled") {
    $lanInterface | Set-NetIPInterface -DHCP Enabled
    $lanInterface | Set-DnsClientServerAddress -ResetServerAddresses
}
$InterfaceDescription = Get-NetAdapter | ? {$_.Name -match "Ethernet *"}
$adapter = Get-WmiObject -Class Win32_NetworkAdapterConfiguration  -ComputerName . | Where-Object -FilterScript { $InterfaceDescription.InterfaceDescription -contains $_.Description }
$adapter.RenewDHCPLease()