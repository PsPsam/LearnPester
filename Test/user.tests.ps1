describe 'New AD User Script' {
    $expectedValues = @{
        'FirstName' = 'Joe'
        'LastName' = 'Blow'
        'Username' = 'jblow'
        'Department' = 'Accounting'
        'Enabled' = $true
    }
    
    $actualUser = Get-AdUser -Filter "samAccountName -eq '$($expectedValues.Username)'"
    
}
 
Notice that I'm not even in an It block yet. I'm just gathering everything to test first. But now that I have the actual object, I'll then create tests for each of the attributes that I'd like to ensure are set.
 
describe 'New AD User Script' {
    $expectedValues = @{
        'FirstName' = 'Joe'
        'LastName' = 'Blow'
        'Username' = 'jblow'
        'Department' = 'HE'
    }
    
    $actualUser = Get-AdUser -Filter "samAccountName -eq '$($expectedValues.Username)'" -Properties Department
    it 'creates an AD user with the right username' {
        $actualUser.samAccountName | should be $expectedValues.Username
    }
    it 'creates an AD user with the right first name' {
        $actualUser.givenName | should be $expectedValues.FirstName
    }
    it 'creates an AD user with the right last name' {
        $actualUser.surName | should be $expectedValues.LastName
    }
    it 'creates an AD user with the right department' {
        $actualUser.Department | should be $expectedValues.Department
    }
    it 'creates an AD user that is enabled' {
        $actualUser.Enabled | should be $true
    }
}