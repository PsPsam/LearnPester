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


  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
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
    Write-Verbose -Message "Starting to check the given path $path for old files"
    Get-ChildItem -Path $path -Recurse -Force |
      Where-Object -FilterScript {
      !$_.PSIsContainer -and $_.CreationTime -lt $date 
    } |
      Remove-Item -Force
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


  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
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
    Write-Verbose -Message "Starting to check the given path $path for empty folders"
    # Delete any empty directories left behind after deleting the old files.
    Get-ChildItem -Path $path -Recurse -Force |
      Where-Object {
      $_.PSIsContainer -and $null -eq (Get-ChildItem -Path $_.FullName -Recurse -Force |
          Where-Object {-not $_.PSIsContainer})
    } |
      Remove-Item -Force -Recurse
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


  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
  param(
    # Path to the folder to check for old files
    [Parameter(Mandatory,
      ValueFromPipelineByPropertyName,
      Position = 0)]
    [ValidateScript( {
        if (-not (Test-Path -LiteralPath $_)) {
          throw "Path '${_}' does not exist. Please provide the path to a file or folder on your local computer and try again."
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
    Remove-File -path $path -date $checkdate
    Write-Output -InputObject 'Remove old files done'
    # Call the function to remove empty folders if $emptyfolder -eq $true
    if ($emptyfolder) {
      Remove-EmptyFolder -path $path
      Write-Output -InputObject 'Removed empty folders done'
    }
  }
  End {
    Write-Output -InputObject 'Done'
  }
}

#remove-file -path x:\path -age 70 -emptyfolder $true