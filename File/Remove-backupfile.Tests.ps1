# To run this pester test you need to install the latest pester version from Powershell Gallery. 
# Start powershell as admin. 
# If you havent installed Pester from the PSGallery do so by
# install-module Pester -force -verbose
# If you have it installed you can update to the lastest version by 
# Update-module Pester -Verbose

# To run the test
# invoke-pester -path .\remove-backupfile.test.ps1
# To run the test and see that you covered all the code
# invoke-pester -Path .\Remove-backupfile.Tests.ps1 -CodeCoverage .\Remove-backupfile.ps1

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
    Setup -File "env\server\full\new.bak"
    Setup -File "env\server\diff\old.bak"
    Setup -File "env\server\diff\new.bak"
    Setup -File "env\server\log\old.bak"
    Setup -File "env\server\log\new.bak"
    # change the file creation date
    $oldFile = Get-Item "TestDrive:\env\server\old.txt"
    $oldFile.CreationTime = (Get-Date).AddDays(-3)
    $oldFile = Get-Item "TestDrive:\env\server\full\old.bak"
    $oldFile.CreationTime = (Get-Date).AddDays(-3)
    $oldFile = Get-Item "TestDrive:\env\server\diff\old.bak"
    $oldFile.CreationTime = (Get-Date).AddDays(-3)
    $oldFile = Get-Item "TestDrive:\env\server\log\old.bak"
    $oldFile.CreationTime = (Get-Date).AddDays(-3)
    it "should be seven files in server folder" {
      (get-childitem 'testdrive:\env\server' -Recurse -File).count | should be 7
    }

    Setup -File "env\server1\new.txt"
    it "should be one files in server1 folder" {
      (get-childitem 'testdrive:\env\server1' -Recurse -File).count | should be 1
    }

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
    it "should be three files in server folder after removing old files" {
      (get-childitem 'testdrive:\env\server' -Recurse -File).count | should be 3
    }
    it "should be one files in server1 folder after removing old files" {
      (get-childitem 'testdrive:\env\server1' -Recurse -File).count | should be 1
    }
    it "should be four files in env folder after removing old files" {
      (get-childitem 'testdrive:\env' -Recurse -File).count | should be 4
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
 
  Context "path has empty folders and non empty folders" {
    Setup -Dir "env\empty\full"
    Setup -Dir "env\empty\diff"
    Setup -Dir "env\empty\log"
    Setup -Dir "env\notempty\full"
    Setup -Dir "env\notempty\diff"
    Setup -Dir "env\notempty\log"
    Setup -file "env\notempty\full\file.bak"
    Setup -file "env\notempty\diff\file.bak"  
    Setup -file "env\notempty\log\file.bak"
    Setup -Dir "env\half\full"
    Setup -Dir "env\half\diff"
    Setup -Dir "env\half\log"
    Setup -file "env\half\full\file.bak" 
    
    Remove-EmptyFolder -path "TestDrive:\env"
    
    It "removes the folder" {
      Test-Path "TestDrive:\env\empty" | Should Be $false
    }
    It "does not removes the folder notempty" {
      Test-Path "TestDrive:\env\notempty" | Should Be $true
    }
    It "does not removes the folder half" {
      Test-Path "TestDrive:\env\half" | Should Be $true
    }
    It "does not removes the folder half\full" {
      Test-Path "TestDrive:\env\half\full" | Should Be $true
    }
    It "removes the folder half\diff" {
      Test-Path "TestDrive:\env\half\diff" | Should Be $false
    }
    It "removes the folder half\log" {
      Test-Path "TestDrive:\env\half\log" | Should Be $false
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
  mock write-eventlog {}


  Context "Input" {
    It -name "When path doesn't exists, it will throw an exception" -test {
      {Remove-OldFile -path 'TestDrive:\wrongfolder' -Age 3} | Should throw
    }
    
    It "given folder should exist" {
      {Remove-OldFile -path 'TestDrive:\env\folder' -Age 3} | Should be $true
    }
  }
  
  Context "Execution" {
    #    $result = {Remove-OldFile -path 'TestDrive:\folder' -Age 3}

    It "should get a date time one time" {
      setup -Dir "env"
      $null = Remove-OldFile -Path 'TestDrive:\env' -Age 3
      
      $assMParams = @{
        CommandName = 'Get-Date'
        Times       = 1
        Exactly     = $true
        Scope       = 'It'
      }
      Assert-MockCalled @assMParams
    }
    It "Should call Remove-File one time" {
      $null = Remove-OldFile -Path 'TestDrive:\env' -Age 3
      
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

    It 'should call remove-emptyfolder zero times when -emptyfolder is $false or not defined' {
      $null = Remove-OldFile -Path 'TestDrive:\env' -Age 3
      
      $assMParams = @{
        CommandName     = 'Remove-EmptyFolder'
        Times           = 0
        Exactly         = $true
        Scope           = 'It'
        ParameterFilter = {
          $path -eq 'TestDrive:\env'
        }
      }
      Assert-MockCalled @assMParams
    }
      
    It "when empyfolder is true - Should call Remove-EmptyFolder one time" {
      $null = Remove-OldFile -Path 'TestDrive:\env' -Age 3 -emptyfolder $true
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