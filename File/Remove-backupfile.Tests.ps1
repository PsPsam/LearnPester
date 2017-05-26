#Dot source the ps1 file
. .\Remove-backupfile.ps1

Describe "Check with Scriptanalyser" {
  It 'must pass PSScriptAnalyzer rules' {
    Invoke-ScriptAnalyzer -Path ".\Remove-backupfile.ps1" | should beNullOrEmpty
  }
}

Describe "Remove-files" {

  Context "folder has old and new files" {
    #Setup -Dir "env"
    #Setup -Dir "env\server"
    Setup -Dir "env\server\Full"
    Setup -Dir "env\server\Diff"
    Setup -Dir "env\server\Log"
    Setup -File "env\server\old.txt"
    Setup -File "env\server\full\old.bak"
    Setup -File "env\server\diff\old.bak"
    Setup -File "env\server\log\old.bak"
    # change the file creation date
    $oldFile = Get-Item "TestDrive:\env\server\old.txt"
    $oldFile.CreationTime = (Get-Date).AddDays(-3)
    Setup -File "env\server1\new.txt"

    It "new file exists" {
      Test-Path "TestDrive:\env\server1\new.txt" | Should Be $true
    }
    It "old file exists" {
      Test-Path "TestDrive:\env\server\old.txt" | Should Be $true
    }
    It "removes the old files" {
      Remove-file -path "TestDrive:env" -date (Get-Date).AddDays(-2)
      Test-Path "TestDrive:\env\server\old.txt" | Should Be $false
    }
 
    It "leaves the new files" {
      Remove-file -path "TestDrive:env" -date (Get-Date).AddDays(-2)
      Test-Path "TestDrive:\env\server1\new.txt" | Should Be $true
    }
  }
 
  Context "folders doesn't have old files" {
    Setup -File "env\server\new1.txt" 
    Setup -File "env\server\new2.txt" 
 
    It "does nothing" {
      Remove-file -path "TestDrive:" -date (Get-Date).AddDays(-2)
      Test-Path "TestDrive:\env\server\new1.txt" | Should Be $true
      Test-Path "TestDrive:\env\server\new2.txt" | Should Be $true
    }
  }
}

Describe "Remove-EmptyFolders" { 
  Context "path has empty folders" {
    Setup -Dir "env\empty"
    It "removes the folder" {
      Remove-EmptyFolder -path "TestDrive:\env"
      Test-Path "TestDrive:\empty" | Should Be $false
    }
  }
  Context "path does not have empty folders" {
    Setup -Dir "env\notempty"
    Setup -file "env\notempty\file.txt" 
    It "does not removes the folder" {
      Remove-EmptyFolder -path "TestDrive:notempty"
      Test-Path "TestDrive:\env" | Should Be $true
    }
  }
}

Describe "Remove-OldFiles" {
  Setup -Dir "env\folder"
  #New-item "TestDrive:\new.txt" -Type file
  # change the file creation date
  #$oldFile = Get-Item "TestDrive:\old.txt"
  #$oldFile.CreationTime = (Get-Date).AddDays(-3)
  #New-item "TestDrive:\new.txt" -Type file

  $today = get-date
  mock Get-Date { $today }
  mock Remove-File {}
  mock Remove-EmptyFolder {}


  Context "Input" {
    It -name "When path doesn't exists, it will throw an exception" -test {
      {Remove-OldFile -path 'TestDrive:\wrongfolder' -olderThan 3} | Should throw
    }
    
    It "given folder should exist" {
      {Remove-OldFile -path 'TestDrive:\env\folder' -olderThan 3} | Should be $true
    }
  }
  
  Context "Execution" {
    #    $result = {Remove-OldFile -path 'TestDrive:\folder' -olderThan 3}

    It "should get a date time" {
      setup -Dir "env"
      $null = Remove-OldFile -Path 'TestDrive:\env' -olderThan 3
      
      $assMParams = @{
        CommandName = 'Get-Date'
        Times       = 1
        Exactly     = $true
        Scope       = 'It'
      }
      Assert-MockCalled @assMParams
    }
    It "Should call Remove-File" {
      $null = Remove-OldFile -Path 'TestDrive:\env' -olderThan 3
      
      $assMParams = @{
        CommandName     = 'Remove-File'
        Times           = 1
        Exactly         = $true
        Scope           = 'It'
        ParameterFilter = {
          $path -eq 'TestDrive:\env' -and 
          $date -eq ($today).adddays(-3)
        }
      }
      Assert-MockCalled @assMParams
    }
   
    It "Should call Remove-EmptyFolder when empyfolder is true" {
      $null = Remove-OldFile -Path 'TestDrive:\env' -olderThan 3 -emptyfolder $true
      $assMParams = @{
        CommandName     = 'Remove-EmptyFolder'
        Times           = 1
        Exactly         = $true
        Scope           = 'It'
        ParameterFilter = {
          $path -eq 'TestDrive:\env'
        }
      }
      Assert-MockCalled @assMParams
    }
  }

  Context "Output" {

  }
}
