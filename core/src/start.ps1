# Enable MD Core Debug Logging
# New-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan\logger" -Name "loglevel" -Value "debug" -PropertyType "String"
# New-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan\logger" -Name "logfile" -Value "C:\OPSWAT\core_debug.log" -PropertyType "String"
# Set-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan\logger" -Name "wineventlog_level" -Value "debug"

# Enable multi-node deployment
New-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan\global" -Name "address" -Value "0.0.0.0" -PropertyType "String"
New-ItemProperty -Path "HKLM:\SOFTWARE\OPSWAT\Metascan\global" -Name "port" -Value "8007" -PropertyType "String"

# Start MetaDefender Core Service
Write-Host "Starting MetaDefender Core"
stop-service ometascan
start-service ometascan
Write-Host "MetaDefender Core Started"

# Disable MetaDefender Node Service on Core
Write-Host "Disabling MetaDefender Node Service on Core Server"
Set-Service ometascan-node -StartupType Disabled
Stop-Service ometascan-node
Write-Host "MetaDefender MetaDefender Node Disabled"

# Sleep for 30 seconds
Write-Host "Sleeping for 30 seconds while services start"
Start-Sleep -seconds 30

# License the instance
$activation_key = Get-Content -Path C:\OPSWAT\activation.key -TotalCount 1
& C:\\OPSWAT\\activate.ps1 -hostname localhost -user admin -password admin -activation_key $activation_key -activation_node_quantity 1 -activation_comment "Wheeler MD Core Windows Docker"

# Loop to display logs and keep container running
$lastCheck = (Get-Date).AddSeconds(-2) 
while ($true) 
{ 
    Get-EventLog -LogName Application -Source "MetaDefender*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message	 
    $lastCheck = Get-Date 
    Start-Sleep -Seconds 2 
}