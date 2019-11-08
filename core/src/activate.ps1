# define CLI parameters
param (
    [Parameter(Mandatory=$true)] [string]$hostname,
    [Parameter(Mandatory=$true)] [string]$user,
    [Parameter(Mandatory=$true)] [string]$password,
    [Parameter(Mandatory=$true)] [string]$activation_key,
    [Parameter(Mandatory=$true)] [string]$activation_node_quantity,
    [Parameter(Mandatory=$true)] [string]$activation_comment,
    [Parameter(Mandatory=$false)] [bool]$force
)

# build credentials array
$credentials = @{
    user = $user
    password = $password
}

# login
$result = Invoke-RestMethod -Uri ("http://{0}:8008/login" -f $hostname) -Body (ConvertTo-Json $credentials) -Method Post
$session_id = $result.session_id

# get licensing status
$headers = @{apikey = $session_id}
$result = Invoke-RestMethod -Uri ("http://{0}:8008/admin/license" -f $hostname) -Headers $headers -Method Get

# check if we are currently licensed. first check if the properties came back in the JSON response
if ((Get-Member -inputobject $result -name "deployment") -and `
    (Get-Member -InputObject $result -name "days_left") -and `
    (!$force) -and `
    ($result.days_left -gt 0)) {
   
    # it appears that we are licensed
    Write-host "This instance is already activated. No activation necessary. `n Deployment ID: " $result.deployment " `n Days Left: " $result.days_left "`n`n"
} else {
    Write-host "This instance is not currently activated. Attempting online activation."

    # perform activation
    $body = @{
        activationKey = $activation_key
        quantity = $activation_node_quantity
        comment = $activation_comment
    }
    $result = Invoke-RestMethod -uri ("http://{0}:8008/admin/license/activation" -f $hostname) -Headers $headers -method Post -body (ConvertTo-Json $body)
    Write-host "Licensing result is: " $result.success
}

# log out and free up the session
Write-host "Logging out from MD Core instance."
$result = Invoke-RestMethod -uri ("http://{0}:8008/logout" -f $hostname) -Headers $headers -method Post -UseBasicParsing
Write-host "Session logout result is: " $result.response