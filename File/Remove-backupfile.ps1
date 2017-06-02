# This script contains three functions. The main function is Remove-Oldfile but you can call the other two directly also.
# To run this a schedual task edit the last line to suite your need.

function Remove-File {
  <#
    .SYNOPSIS
    Removes files based on the given path and given date

    .DESCRIPTION
    The function will remove files from the given path that are older then the given date

    .PARAMETER path
    The path to remove old files from

    .PARAMETER date
    Files older the date will be removed

    .EXAMPLE
    Remove-File -path Value -date Value
    Will remove the file that has an older date the given

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Remove-File

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param
  (
    # Path to the folder to check for old files
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName,
      Position = 0)]
    [string]$path,

    # Age in days of file to delete
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName,
      Position = 1)]
    [datetime]$date
  )

  Begin {
  }
  Process {
    # Delete files older than the $limit.
    Write-Verbose -Message ('Starting to check the given path {0} for old files' -f $path)
    $files = Get-ChildItem -Path $path -Recurse -Force -File |
      Where-Object -FilterScript {$_.CreationTime -lt $date}
    $files | Remove-Item -Force
    return $files
  }
  End {
  }
}

function Remove-EmptyFolder {
  <#
    .SYNOPSIS
    Removes folders that are empty

    .DESCRIPTION
    Removes folders that are empty

    .PARAMETER path
    Base path to start looking for empty folders

    .EXAMPLE
    Remove-EmptyFolder -path Value
    Removes empty folders from the path given.

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Remove-EmptyFolder

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param
  (
    # Path to the folder to check for old files
    [Parameter(Mandatory, HelpMessage = 'Will remove empty subfolders',
      ValueFromPipelineByPropertyName,
      Position = 0)]
    [string]$path
  )

  Begin {
  }

  Process {

    # Delete files older than the $limit.
    Write-Verbose -Message ('Starting to check the given path {0} for empty folders' -f $path)
    # Delete any empty directories left behind after deleting the old files.
    $removed = $null
    do {
      $test = Get-ChildItem -Path $path -Recurse -Directory -Force | 
        Where-Object {$null -eq (Get-ChildItem -Path $_.FullName -Recurse -Force)}
      $test | Remove-Item -Force -Recurse
      $removed += $test
    } while ($test.count -ne 0)
    return $removed
    #Get-ChildItem -Path $path -Recurse -Force -Directory | Where-Object {$null -eq (Get-ChildItem -Path $_.FullName -File -Recurse -Force)} | Remove-Item -Force -Recurse
  }
  End {
    
  }
}

function Remove-OldFile {
  <#
    .SYNOPSIS
    The function will check the singel given path for files that are older then the given number of days.

    .DESCRIPTION
    The function will check the given path for files that are older then the given number of days.

    .PARAMETER path
    Sets the base path to start the search for old files and empty folders

    .PARAMETER olderThan
    How old in days the files should be to be removed.

    .PARAMETER empyfolder
    If it should remove empty folders or not.'

    .EXAMPLE
    Remove-OldFiles -path d:\test -olderThan 7 
    Will remove files from d:\test that are older then seven days, will not remove empty folders

    .EXAMPLE
    Remove-OldFiles -path d:\test -olderThan 7 -empyfolder $true
    Will remove files from d:\test that are older then seven days, will remove empty folders

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Remove-OldFiles

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  param(
    # Path to the folder to check for old files
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName,
      Position = 0)]
    [ValidateScript( {
        if (-not (Test-Path -LiteralPath $_)) {
          throw ("Path '{0}' does not exist. Please provide the path to a file or folder on your local computer and try again." -f ${_})
        }
        $true
      })]
    [string]$path,

    # Older than days to delete
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName,
      Position = 1)]
    [int]$Age,

    # remove empty folders
    [Parameter(ValueFromPipelineByPropertyName,
      Position = 2)]
    # [Validateset($True, $False)]
    $emptyfolder = $False
  )

  Begin {
    $checkdate = (get-date).AddDays( - $age)
    
  }
  Process {
    # Call the function to remove files
    write-eventlog -logname Application -source SQLBackup -eventID 0 -entrytype Information -message "Remove of old files on $path starting!"
    $files = Remove-File -path $path -date $checkdate
    $output = "Remove old files done `n$files"
    $count = $files.count
    write-eventlog -logname Application -source SQLBackup -eventID 1 -entrytype Information -message "Remove of old files on $path done!"
    if ($count -gt 0) {
        write-eventlog -logname Application -source SQLBackup -eventID 1 -entrytype Information -message "Removed $count files `n $output"
    }
    #Write-Output -InputObject $output
    # Call the function to remove empty folders if $emptyfolder -eq $true
    if ($emptyfolder) {
      write-eventlog -logname Application -source SQLBackup -eventID 2 -entrytype Information -message "Remove of empty folders on $path starting!"
      $folders = Remove-EmptyFolder -path $path
      $count = $folders.count
      $output = "Removed empty folders done, removed folders `n $folders"
      write-eventlog -logname Application -source SQLBackup -eventID 3 -entrytype Information -message "Remove of empty folders on $path done!"
      if ($count -gt 0) {
        write-eventlog -logname Application -source SQLBackup -eventID 3 -entrytype Information -message "Removed $count folders `n $output"
      }
    }
  }
  End {
    Write-Output -InputObject 'Done'
  }
}

Remove-OldFile -path \\sodra.com\sql-backup\test -age 35 -emptyfolder $true
Remove-OldFile -path \\sodra.com\sql-backup\acceptans -age 35 -emptyfolder $true
Remove-OldFile -path \\sodra.com\sql-backup\produktion -age 65 -emptyfolder $true