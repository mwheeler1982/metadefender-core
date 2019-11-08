# Enable MD Core Node Debug Logging
# New-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan Node\logger" -Name "loglevel" -Value "debug" -PropertyType "String"
# New-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan Node\logger" -Name "logfile" -Value "C:\OPSWAT\node_debug.log" -PropertyType "String"
# Set-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan Node\logger" -Name "wineventlog_level" -Value "debug"

# Enable multi-node deployment
# Lookup the IP address of the Core instance
$mdcore_ip = (Resolve-DnsName core -type a).IPAddress

# Create Registry Entries
# New-Item -Path "HKLM:\SOFTWARE\OPSWAT\Metascan Node" -name "global"
Set-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan Node\global" -Name "serveraddress" -Value $mdcore_ip
# New-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan Node\global" -Name "serverport" -Value "8007" -PropertyType "String"

# Start MetaDefender Core Node Service
Write-Host "Starting MetaDefender Core Node"
stop-service ometascan-node
start-service ometascan-node
Write-Host "MetaDefender Core Node Started"

# Sleep for 30 seconds
Write-Host "Sleeping for 30 seconds while services start"
Start-Sleep -seconds 30

# Loop to display logs and keep container running
$lastCheck = (Get-Date).AddSeconds(-2) 
while ($true) 
{ 
    Get-EventLog -LogName Application -Source "MetaDefender*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message	 
    $lastCheck = Get-Date 
    Start-Sleep -Seconds 2 
}