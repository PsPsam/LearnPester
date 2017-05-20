#Define Server
$WindowsFeatureNotInstalled = @(
	@{
		Feature = 'LegacyComponents'
	}
	@{
		Feature = 'DirectPlay'
	}
	@{
		Feature = 'SimpleTCP'
	}
	@{
		Feature = 'SNMP'
	}
	@{
		Feature = 'WMISnmpProvider'
	}
	@{
		Feature = 'Windows-Identity-Foundation'
	}
	@{
		Feature = 'Microsoft-Windows-Subsystem-Linux'
	}
	@{
		Feature = 'IIS-WebServerRole'
	}
	@{
		Feature = 'IIS-WebServer'
	}
	@{
		Feature = 'IIS-CommonHttpFeatures'
	}
	@{
		Feature = 'IIS-HttpErrors'
	}
	@{
		Feature = 'IIS-HttpRedirect'
	}
	@{
		Feature = 'IIS-ApplicationDevelopment'
	}
	@{
		Feature = 'IIS-NetFxExtensibility'
	}
	@{
		Feature = 'IIS-NetFxExtensibility45'
	}
	@{
		Feature = 'IIS-HealthAndDiagnostics'
	}
	@{
		Feature = 'IIS-HttpLogging'
	}
	@{
		Feature = 'IIS-LoggingLibraries'
	}
	@{
		Feature = 'IIS-RequestMonitor'
	}
	@{
		Feature = 'IIS-HttpTracing'
	}
	@{
		Feature = 'IIS-Security'
	}
	@{
		Feature = 'IIS-URLAuthorization'
	}
	@{
		Feature = 'IIS-RequestFiltering'
	}
	@{
		Feature = 'IIS-IPSecurity'
	}
	@{
		Feature = 'IIS-Performance'
	}
	@{
		Feature = 'IIS-HttpCompressionDynamic'
	}
	@{
		Feature = 'IIS-WebServerManagementTools'
	}
	@{
		Feature = 'IIS-ManagementScriptingTools'
	}
	@{
		Feature = 'IIS-IIS6ManagementCompatibility'
	}
	@{
		Feature = 'IIS-Metabase'
	}
	@{
		Feature = 'WAS-WindowsActivationService'
	}
	@{
		Feature = 'WAS-ProcessModel'
	}
	@{
		Feature = 'WAS-NetFxEnvironment'
	}
	@{
		Feature = 'WAS-ConfigurationAPI'
	}
	@{
		Feature = 'IIS-HostableWebCore'
	}
	@{
		Feature = 'WCF-HTTP-Activation'
	}
	@{
		Feature = 'WCF-NonHTTP-Activation'
	}
	@{
		Feature = 'WCF-HTTP-Activation45'
	}
	@{
		Feature = 'WCF-TCP-Activation45'
	}
	@{
		Feature = 'WCF-Pipe-Activation45'
	}
	@{
		Feature = 'WCF-MSMQ-Activation45'
	}
	@{
		Feature = 'IIS-CertProvider'
	}
	@{
		Feature = 'IIS-WindowsAuthentication'
	}
	@{
		Feature = 'IIS-DigestAuthentication'
	}
	@{
		Feature = 'IIS-ClientCertificateMappingAuthentication'
	}
	@{
		Feature = 'IIS-IISCertificateMappingAuthentication'
	}
	@{
		Feature = 'IIS-ODBCLogging'
	}
	@{
		Feature = 'IIS-StaticContent'
	}
	@{
		Feature = 'IIS-DefaultDocument'
	}
	@{
		Feature = 'IIS-DirectoryBrowsing'
	}
	@{
		Feature = 'IIS-WebDAV'
	}
	@{
		Feature = 'IIS-WebSockets'
	}
	@{
		Feature = 'IIS-ApplicationInit'
	}
	@{
		Feature = 'IIS-ASPNET'
	}
	@{
		Feature = 'IIS-ASPNET45'
	}
	@{
		Feature = 'IIS-ASP'
	}
	@{
		Feature = 'IIS-CGI'
	}
	@{
		Feature = 'IIS-ISAPIExtensions'
	}
	@{
		Feature = 'IIS-ISAPIFilter'
	}
	@{
		Feature = 'IIS-ServerSideIncludes'
	}
	@{
		Feature = 'IIS-CustomLogging'
	}
	@{
		Feature = 'IIS-BasicAuthentication'
	}
	@{
		Feature = 'IIS-HttpCompressionStatic'
	}
	@{
		Feature = 'IIS-ManagementConsole'
	}
	@{
		Feature = 'IIS-ManagementService'
	}
	@{
		Feature = 'IIS-WMICompatibility'
	}
	@{
		Feature = 'IIS-LegacyScripts'
	}
	@{
		Feature = 'IIS-LegacySnapIn'
	}
	@{
		Feature = 'IIS-FTPServer'
	}
	@{
		Feature = 'IIS-FTPSvc'
	}
	@{
		Feature = 'IIS-FTPExtensibility'
	}
	@{
		Feature = 'MSMQ-Container'
	}
	@{
		Feature = 'MSMQ-Server'
	}
	@{
		Feature = 'MSMQ-Triggers'
	}
	@{
		Feature = 'MSMQ-ADIntegration'
	}
	@{
		Feature = 'MSMQ-HTTP'
	}
	@{
		Feature = 'MSMQ-Multicast'
	}
	@{
		Feature = 'MSMQ-DCOMProxy'
	}
	@{
		Feature = 'NetFx4Extended-ASPNET45'
	}
	@{
		Feature = 'RasRip'
	}
	@{
		Feature = 'TelnetClient'
	}
	@{
		Feature = 'TFTP'
	}
	@{
		Feature = 'SMB1Protocol'
	}
	@{
		Feature = 'Printing-Foundation-LPRPortMonitor'
	}
	@{
		Feature = 'Printing-Foundation-LPDPrintService'
	}
	@{
		Feature = 'ScanManagementConsole'
	}
	@{
		Feature = 'DirectoryServices-ADAM-Client'
	}
	@{
		Feature = 'ServicesForNFS-ClientOnly'
	}
	@{
		Feature = 'ClientForNFS-Infrastructure'
	}
	@{
		Feature = 'NFS-Administration'
	}
	@{
		Feature = 'RasCMAK'
	}
	@{
		Feature = 'SmbDirect'
	}
	@{
		Feature = 'Containers'
	}
	@{
		Feature = 'Windows-Defender-ApplicationGuard'
	}
	@{
		Feature = 'DataCenterBridging'
	}
	@{
		Feature = 'TIFFIFilter'
	}
	@{
		Feature = 'Client-DeviceLockdown'
	}
	@{
		Feature = 'Client-EmbeddedShellLauncher'
	}
	@{
		Feature = 'Client-EmbeddedBootExp'
	}
	@{
		Feature = 'Client-EmbeddedLogon'
	}
	@{
		Feature = 'Client-KeyboardFilter'
	}
	@{
		Feature = 'Client-UnifiedWriteFilter'
	}
	@{
		Feature = 'MultiPoint-Connector'
	}
	@{
		Feature = 'MultiPoint-Connector-Services'
	}
	@{
		Feature = 'MultiPoint-Tools'
	}
)
$windowsFeaturesInstalled = @(
	@{
		Feature = 'Microsoft-Windows-HyperV-Guest-Package'
	}
	@{
		Feature = 'MicrosoftWindowsPowerShellV2Root'
	}
	@{
		Feature = 'MicrosoftWindowsPowerShellV2'
	}
	@{
		Feature = 'Internet-Explorer-Optional-amd64'
	}
	@{
		Feature = 'NetFx3'
	}
	@{
		Feature = 'WCF-Services45'
	}
	@{
		Feature = 'WCF-TCP-PortSharing45'
	}
	@{
		Feature = 'NetFx4-AdvSrvs'
	}
	@{
		Feature = 'MediaPlayback'
	}
	@{
		Feature = 'WindowsMediaPlayer'
	}
	@{
		Feature = 'Printing-PrintToPDFServices-Features'
	}
	@{
		Feature = 'Printing-XPSServices-Features'
	}
	@{
		Feature = 'MSRDC-Infrastructure'
	}
	@{
		Feature = 'SearchEngine-Client-Package'
	}
	@{
		Feature = 'Xps-Foundation-Xps-Viewer'
	}
	@{
		Feature = 'WorkFolders-Client'
	}
	@{
		Feature = 'Microsoft-Hyper-V-All'
	}
	@{
		Feature = 'Microsoft-Hyper-V-Tools-All'
	}
	@{
		Feature = 'Microsoft-Hyper-V-Management-Clients'
	}
	@{
		Feature = 'Microsoft-Hyper-V-Management-PowerShell'
	}
	@{
		Feature = 'Microsoft-Hyper-V'
	}
	@{
		Feature = 'Microsoft-Hyper-V-Hypervisor'
	}
	@{
		Feature = 'Microsoft-Hyper-V-Services'
	}
	@{
		Feature = 'Printing-Foundation-Features'
	}
	@{
		Feature = 'Printing-Foundation-InternetPrinting-Client'
	}
	@{
		Feature = 'FaxServicesClientPackage'
	}
)
$Programs = @(
	@{
		Name = 'DuckieTV'
	}
	@{
		Name = 'Mozilla Thunderbird 45.6.0'
	}
	@{
		Name = 'Garmin Express'
	}
	@{
		Name = 'Missing program'
	}
)
#End Define Server
$WindowsFeatures = Get-WindowsOptionalFeature -Online | Where-Object -Property state -EQ -Value 'Enabled'
$installedprograms = Get-ItemProperty -Path HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object -Property DisplayName

Describe -Name 'Clientset' -Fixture {
	Context -Name 'Windows Feature that should be installed' -Fixture {
		It -name 'Should have <Feature> installed' -TestCases $windowsFeaturesInstalled -test {
			param($Feature)
			$WindowsFeatures.featurename -contains $Feature | Should Be $True
		}
	}

	Context -Name 'Windows Feature that should Not be installed' -Fixture {
		It -name 'Should NOT have <Feature> installed' -TestCases $WindowsFeatureNotInstalled  -test {
			param($Feature)
			$WindowsFeatures.FeatureName -contains $Feature | Should Be $False
		}
	}

	Context -Name 'Default programs that should be installed' -Fixture {       
		It -name 'Should have <Name> installed' -TestCases $Programs -test {
			param($name)
			$installedprograms.DisplayName -contains $name | Should be $True
		}   
	}
}