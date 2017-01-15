Function Test-WindowsFeature
{
    param (
        $ComputerName,
        $ServiceName
    )
    $getFeatureParams = @{
        ComputerName = $ComputerName
        Name = $ServiceName
        ErrorAction = 'Ignore'
    }
    if ($feature = Get-Windowsfeature @getFeatureParams)
    {
        if ($feature.Installed) {
            $true
        } Else {
            $false
        }

    }
}

#function Test-WindowsFeature {
#    param(
#        $ComputerName,
#        $Name
#    )
#    if ($feature = Get-WindowsFeature -ComputerName $ComputerName -Name $Name -ErrorAction Ignore) {
#        if ($feature.Installed) {
#            $true
#        } else {
#            $false
#        }
#    } else {
#        $false
#    }
#}

Function Set-RemoteRegistryValue {
    Params (
        $ComputerName,
        $Path,
        $RegName,
        $RegValue
    )
    $null = Invoke-Command -ComputerName $ComputerName -Scriptblock {Set-ItemProperty -path $useing:Path -Name $using:Name -Value $using:Value}
}


Function Enable-IISRemoteManagement
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateScript({
             if (-not (Test-Connection -ComputerName $_ -Quiet -Count 1)) {
                 throw "The computer [$_] could not be reached."
             } else {
                 $true
             }
        })]
        [ValidateLength(1,15)]
        [string]$ComputerName
    )

    # Verify the IIS Management Service Windows feature is installed.
    if (Test-WindowsFeature -ComputerName $ComputerName -Name 'Web-Mgmt-Service')
    {
        # Enable Remote Management via a registry key.
        $remoteKeyParams = @{
            ComputerName = $ComputerName
            Path = 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server'
            Name = 'EnableRemoteManagement'
            Value = '1'
        }
        Set-RemoteRegistryValue @remoteKeyParams

        # Set the IIS Remote Management service to automatically start.
        $setParams = @{
            ComputerName = $ComputerName
            Name = 'WMSvc'
            StartupType = 'Automatic'
        }
        Set-Service @setParams

        # Start the IIS Remote Management service.
        Get-Service -ComputerName $ComputerName -Name 'WMSvc' | Start-Service
    }
    else
    {
        throw 'IIS Management Service Windows feature is not installed.'
    }

}