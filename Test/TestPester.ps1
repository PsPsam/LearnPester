#requires -Version 1.0
function Test-Pester 
{
	param (
         [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
		[string]$ComputerName,

        [Parameter()]
        [validateSet('2008','2012','2014')]
		[String]$Version = '2014'  
	)
	if ($ComputerName) {
        $output = $ComputerName +' '+ $version
		write-output $output
	}
	#Get-Service -ComputerName $ComputerName -Name $Name
}