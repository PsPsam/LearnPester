[string]$FirstName = 'Joe'
[string]$LastName = 'Blow'
[string]$Department = 'HR'
[string]$Title = 'VP'
[string]$DefaultPassword = 'p@$$w0rd12345' ## Don't do this...really    
$Username = "$($FirstName.SubString(0, 1))$LastName"
#region Create the new user
$NewUserParams = @{
    'UserPrincipalName' = $Username
    'Name' = $Username
    'GivenName' = $FirstName
    'Surname' = $LastName
    'Department' = $Department
    'SamAccountName' = $Username
    'AccountPassword' = (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force)
    'Enabled' = $true
}
New-AdUser @NewUserParams
#endregion