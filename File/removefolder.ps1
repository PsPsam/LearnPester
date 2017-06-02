function remove-emptyfolders-t1 {
  Param
  (
    # Path to the folder to check for old files
    [Parameter(Mandatory, HelpMessage = 'Will remove empty subfolders',
      ValueFromPipelineByPropertyName,
      Position = 0)]
    [string]$path
  )
  Get-ChildItem -Path $path -Recurse -Force -Directory | 
    Where-Object {$null -eq (Get-ChildItem -Path $_.FullName -File -Recurse -Force)} | Remove-Item -Force -Recurse
}

function remove-emptyfolders-t2 {
  Param
  (
    # Path to the folder to check for old files
    [Parameter(Mandatory, HelpMessage = 'Will remove empty subfolders',
      ValueFromPipelineByPropertyName,
      Position = 0)]
    [string]$path
  )
  do {
    $test = Get-ChildItem -Path $path -Recurse -Directory -Force | 
      Where-Object {$null -eq (Get-ChildItem -Path $_.FullName -Recurse -Force)}
    write-host $test
    $test | Remove-Item -Force -Recurse
  } while ($test.count -ne 0)
}

Describe "Remove-EmptyFolders1" {

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
    
    Remove-EmptyFolders-t1 -path "TestDrive:\env"

    It "removes the folder" {
      Test-Path "TestDrive:\env\empty" | Should Be $false
    }
    It "does not removes the folder notempty" {
      Test-Path "TestDrive:\env\notempty" | Should Be $true
    }
  }
}

Describe "Remove-EmptyFolders2" {

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
    Remove-EmptyFolders-t2 -path "TestDrive:\env"
    It "removes the folder" {
      Test-Path "TestDrive:\env\empty" | Should Be $false
    }
    It "does not removes the folder notempty" {
      Test-Path "TestDrive:\env\notempty" | Should Be $true
    }
  }
}
