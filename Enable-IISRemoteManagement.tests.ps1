#Pester Script
#. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')

Describe 'Enable-IISRemoteManagement' {
     context 'Input' {
         it 'when the computer is offline, it will throw an exception' {
 
             mock 'Test-Connection' {
                 $false
             }
 
             { Enable-IISRemoteManagement -ComputerName 'IAMOFFLINE' } | should throw 'could not be reached'
         }
     }

    context 'Execution' {
        mock 'Test-Connection' {
            $true
        }
    
        mock 'Test-WindowsFeature' {
            $true
        }
    
        mock 'Set-RemoteRegistryValue'
    
        mock 'Set-Service'
    
        mock 'Start-Service'
    
        mock 'Get-Service'{
            New-MockObject -Type 'System.ServiceProcess.ServiceController'
        }
        
        it 'when the Web-Mgmt-Service feature is already installed, it attempts to change the EnableRemoteManagement reg value to 1' {

            $null = Enable-IISRemoteManagement -ComputerName 'SOMETHING'

            $assMParams = @{
                CommandName = 'Set-RemoteRegistryValue'
                Times = 1
                Scope = 'It'
                Exactly = $true
                ParameterFilter = { $ComputerName -eq 'SOMETHING' }
            }
            Assert-MockCalled @assMParams
        }

        it 'When the web-Mgmt-Service feature is installed, it changes the WMSvc services starup type to Automatic' {
            $null = Enable-IISRemoteManagement -ComputerName 'SOMETHING'
            $assertMockParameters =  @{
                CommandName = 'Set-Service'
                Times = 1
                Scope = 'It'
                Exactly = $True
                ParameterFilter = { $ComputerName -eq 'SOMETHING'}
            }
            Assert-MockCalled @assertMockParameters
        }
        it 'When the web-Mgmt-Service feature is already installed, it starts the WMSvc service' {
            $null = Enable-IISRemoteManagement -ComputerName 'SOMETHING'
            $assertMockParameters =  @{
                CommandName = 'Get-Service'
                Times = 1
                Scope = 'It'
                Exactly = $True
            }
            Assert-MockCalled @assertMockParameters -ParameterFilter {$ComputerName -eq 'SOMETHING'}
            $assertMockParameters.CommandName = 'Start-Service'
            Assert-MockCalled @assertMockParameters

        }
    }

    context 'Output' {
         it 'when the computer already has the Web-Mgmt-Service featureb installed , it will throw an exception' {
 
             mock 'Test-Connection' {
                 $true
             }
 
             mock 'Test-WindowsFeature' {
                 $false
             }
 
             { Enable-IISRemoteManagement -ComputerName 'IAMONLINE' } | should throw 'Windows feature is not installed'
         }
     }
}