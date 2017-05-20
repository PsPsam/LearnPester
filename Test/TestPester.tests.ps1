Describe 'Test-Pester' {
    $Versions = @(
        @{  Version  = '2008'
            TestName = '2008'
        }
         @{  Version  = '2012'
            TestName = '2012'
        }
         @{  Version  = '2014'
            TestName = '2014'
        }
        @{  Version  = '2016'
            TestName = '2016'
        }
    )

	Context 'Input' {

	}
	Context 'Execution' {
        It 'Runs with just Computername' {
            Test-Pester -ComputerName 'Test' | Should be 'Test 2014'
        }
        It 'Runs with Computername and Version <TestName>' -testcase $Versions {
            param($Version)
            Test-Pester -ComputerName 'Test' -Ver $version | Should be "Test $version"
        }
	}
	Context 'Output' {

	}
}