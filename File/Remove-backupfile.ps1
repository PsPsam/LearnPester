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
    [Parameter(Mandatory, HelpMessage = 'Add help message for user',
      ValueFromPipelineByPropertyName,
      Position = 0)]
    [string]$path,

    # Older than days to delete
    [Parameter(Mandatory, HelpMessage = 'Add help message for user',
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
    Describe purpose of "Remove-EmptyFolder" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER path
    Describe parameter -path.

    .EXAMPLE
    Remove-EmptyFolder -path Value
    Describe what this call does

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
    The function will check the given path for files that are older then the given number of days.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER path
    Describe parameter -path.

    .PARAMETER olderThan
    Describe parameter -olderThan.

    .PARAMETER empyfolder
    Describe parameter -empyfolder.

    .EXAMPLE
    Remove-OldFiles -path Value -olderThan Value -empyfolder Value
    Describe what this call does

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
  Param
  (
    # Path to the folder to check for old files
    [Parameter(Mandatory, HelpMessage = 'Path to folder to check for old files',
      ValueFromPipelineByPropertyName,
      Position = 0)]
    [ValidateScript( {Test-Path -Path $_})]
    [string]$path,

    # Older than days to delete
    [Parameter(Mandatory, HelpMessage = 'Age of the files to remove in days',
      ValueFromPipelineByPropertyName,
      Position = 1)]
    [int]$olderThan,

    # remove empty folders
    [Parameter(ValueFromPipelineByPropertyName,
      Position = 2)]
    [Validateset($true, $false)]
    [bool]$emptyfolder = $false
  )

  Begin {
    #$checkdate = get-date
    $checkdate = (get-date).AddDays( - $olderThan)
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
